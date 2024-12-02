const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const print = std.debug.print;

fn isSafe(line: []i32, skipIndex: i32) bool {
    var desc = false;
    var descIsSet = false;

    const start: u8 = if (skipIndex == 0) 2 else 1;
    const first = line[start - 1];
    var prev = first;

    var i: u32 = start;
    for (line[start..]) |val| {
        defer i += 1;
        if (i == skipIndex) continue;
        if (!descIsSet) {
            desc = val < first;
            descIsSet = true;
        }

        if (desc and val > prev) {
            return false;
        } else if (!desc and val < prev) {
            return false;
        }
        const diff = @abs(val - prev);
        if (!(1 <= diff and diff <= 3)) {
            return false;
        }
        prev = val;
    }
    return true;
}

fn parseNums(line: []u8, buff: []i32) ![]i32 {
    var tokens = mem.splitSequence(u8, line, " ");
    var count: u32 = 0;
    while (tokens.next()) |tok| : (count += 1) {
        buff[count] = try fmt.parseInt(i32, tok, 10);
    }
    return buff[0..count];
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){}; // gpa is of type GeneralPurposeAllocator()
    const alloc = gpa.allocator();

    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(alloc, 100_000);
    defer alloc.free(contents);

    var lines = mem.splitSequence(u8, contents, "\n");
    var safeCount: i32 = 0;
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) continue;

        var safe = false;
        var buff: [128]i32 = undefined;
        const slice = try parseNums(@constCast(line), buff[0..]);
        // check if safe
        if (isSafe(slice, -1)) {
            safe = true;
        } else {
            // brute force remove numbers
            for (0..slice.len) |i| {
                if (isSafe(slice, @intCast(i))) {
                    safe = true;
                    break;
                }
            }
        }
        if (safe) {
            safeCount += 1;
            print("safe\n", .{});
        } else {
            print("unsafe\n", .{});
        }
    }

    print("result: {}\n", .{safeCount});
}
