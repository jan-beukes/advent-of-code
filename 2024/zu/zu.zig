const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const KB = 1024.0;
const MB = 1024.0 * KB;
const GB = 1024.0 * MB;

const out = std.io.getStdOut().writer();

const DirWalkerError = Allocator.Error || std.fs.Dir.StatFileError || std.fs.Dir.OpenError;
fn getDirSize(dir: std.fs.Dir, alloc: Allocator) DirWalkerError!usize {
    var walk = try dir.walk(alloc);
    defer walk.deinit();
    var size: usize = 0;
    while (true) {
        const iter = walk.next() catch |e| {
            if (e == error.AccessDenied) {
                print("Permission Denied\n", .{});
                continue;
            }
            return e; // Propagate other errors
        };

        if (iter == null) break;
        const entry = iter.?;

        if (entry.kind == .file) {
            const stat = try entry.dir.statFile(entry.basename);
            size += stat.size;
        }
    }
    return size;
}

pub fn main() !void {
    const alloc = std.heap.c_allocator;
    const argv = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, argv);

    if (argv.len != 2) {
        print("Please enter a single directory", .{});
        std.process.exit(1);
    }

    const path = argv[1];
    var dir: std.fs.Dir = undefined;
    if (std.fs.path.isAbsolute(path)) {
        dir = std.fs.openDirAbsolute(path, .{ .iterate = true }) catch |e| {
            print("Could not open dir {}", .{e});
            std.process.exit(1);
        };
    } else {
        dir = std.fs.cwd().openDir(path, .{ .iterate = true }) catch |e| {
            print("Could not open dir {}", .{e});
            std.process.exit(1);
        };
    }
    defer dir.close();

    const total_size: usize = getDirSize(dir, alloc) catch |e| switch (e) {
        else => {
            std.debug.panic("Error walking them dirs\n", .{});
        },
    };
    const fmt =
        \\Directory {s}:
        \\size: {d:.2}MB
    ;
    const f_total_size: f32 = @floatFromInt(total_size);
    print(fmt, .{ path, f_total_size / MB });
}
