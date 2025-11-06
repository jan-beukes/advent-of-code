const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const Vec2 = struct {
    x: i32,
    y: i32,
};

const Guard = struct {
    pos: Vec2,
    dir: Vec2,
    total_moves: usize = 0,

    pub fn init(pos: Vec2) Guard {
        return .{
            .pos = pos,
            .dir = .{ .x = 0, .y = -1 },
        };
    }
    pub fn rotate(self: *Guard) void {
        self.dir = Vec2{ .x = -self.dir.y, .y = self.dir.x };
    }
    // return true if no longer on map
    pub fn move(self: *Guard, grid: [][]u8) bool {
        if (self.pos.x + self.dir.x >= grid[0].len or self.pos.x + self.dir.x < 0) return true;
        if (self.pos.y + self.dir.y >= grid.len or self.pos.y + self.dir.y < 0) return true;

        var x: usize = @intCast(self.pos.x + self.dir.x);
        var y: usize = @intCast(self.pos.y + self.dir.y);
        if (grid[y][x] == '#') self.rotate();
        self.pos.x += self.dir.x;
        self.pos.y += self.dir.y;

        x = @intCast(self.pos.x);
        y = @intCast(self.pos.y);
        if (grid[y][x] != 'X') {
            grid[y][x] = 'X';
            self.total_moves += 1;
        }
        return false;
    }
};

fn isInLoop(guard: Guard, grid: [][]u8) bool {
    const start_pos = guard.pos;
    const start_dir = guard.dir;

    while (true) {
        const res = guard.move(grid);
        if (res) return false;
        if (guard.pos.x == start_pos.x and guard.pos.x == start_pos.x and guard.dir.x == start_dir.x and guard.dir.y == start_dir.y) return true;
    }
}

pub fn main() !void {
    const alloc = std.heap.c_allocator;
    var line_iter = mem.splitSequence(u8, input, "\n");
    var grid_lines = std.ArrayList([]u8).init(alloc);
    while (line_iter.next()) |line| {
        const mut_line = try alloc.alloc(u8, line.len);
        @memcpy(mut_line, line);
        try grid_lines.append(mut_line);
    }
    const grid = try grid_lines.toOwnedSlice();
    defer {
        for (grid) |l| alloc.free(l);
        alloc.free(grid);
    }
    const guard_start: Vec2 = blk: {
        for (grid, 0..) |line, row| {
            for (line, 0..) |c, col| {
                if (c == '^') break :blk Vec2{ .x = @intCast(col), .y = @intCast(row) };
            }
        }
        std.debug.panic("couldn't find ^\n", .{});
    };
    print("Guard at: {}\n", .{guard_start});
    var guard = Guard.init(guard_start);
    while (true) {
        const res = guard.move(grid);
        if (res) break;
    }
    print("result: {}\n", .{guard.total_moves});
}
