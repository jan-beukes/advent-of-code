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
    moves: usize = 0,

    pub fn init(pos: Vec2) Guard {
        return .{
            .pos = pos,
            .dir = .{ .x = 0, .y = -1 },
        };
    }
    fn rotate(self: *Guard) void {
        self.dir = Vec2{ .x = -self.dir.y, .y = self.dir.x };
    }

    pub fn move(self: *Guard, grid: [][]u8) bool {
        if (self.pos.x + self.dir.x >= grid[0].len or self.pos.x + self.dir.x < 0) return true;
        if (self.pos.y + self.dir.y >= grid.len or self.pos.y + self.dir.y < 0) return true;

        const x: usize = @intCast(self.pos.x + self.dir.x);
        const y: usize = @intCast(self.pos.y + self.dir.y);
        if (grid[y][x] == '#' or grid[y][x] == 'O') {
            self.rotate();
            return false;
        }
        self.pos.x += self.dir.x;
        self.pos.y += self.dir.y;
        return false;
    }
};

fn isInLoop(guard: Guard, grid: [][]u8, alloc: mem.Allocator) bool {
    var g = guard;
    var move_map = std.AutoHashMap(Vec2, Vec2).init(alloc);
    defer move_map.deinit();

    while (!g.move(grid)) {
        if (move_map.get(g.pos)) |dir| {
            if (dir.x == g.dir.x and dir.y == g.dir.y) {
                return true;
            }
        } else {
            move_map.put(g.pos, g.dir) catch @panic("HUH");
        }
    }
    return false;
}

pub fn main() !void {
    const alloc = std.heap.c_allocator;
    var line_iter = mem.splitSequence(u8, input, "\n");
    var grid_lines = std.ArrayList([]const u8).init(alloc);
    while (line_iter.next()) |line| {
        try grid_lines.append(line);
    }
    const grid = try grid_lines.toOwnedSlice();
    const guard_start: Vec2 = blk: {
        for (grid, 0..) |line, row| {
            for (line, 0..) |c, col| {
                if (c == '^') break :blk Vec2{ .x = @intCast(col), .y = @intCast(row) };
            }
        }
        std.debug.panic("couldn't find ^\n", .{});
    };
    const guard = Guard.init(guard_start);

    // allocate mutable copy of grid
    var mut_grid: [][]u8 = try alloc.alloc([]u8, grid.len);
    defer alloc.free(mut_grid);
    for (grid, 0..) |line, row| {
        const l = try alloc.alloc(u8, line.len);
        @memcpy(l, line);
        mut_grid[row] = l;
    }
    defer for (mut_grid) |line| alloc.free(line);

    // mark path guard takes
    var g = guard;
    while (!g.move(mut_grid)) mut_grid[@intCast(g.pos.y)][@intCast(g.pos.x)] = 'X';

    var loop_positions: usize = 0;
    for (0..mut_grid.len) |row| {
        for (0..mut_grid[0].len) |col| {
            if (mut_grid[row][col] != 'X') continue;
            mut_grid[row][col] = 'O';
            defer mut_grid[row][col] = 'X';

            if (isInLoop(guard, mut_grid, alloc)) {
                loop_positions += 1;
            }
        }
    }

    print("result: {}\n", .{loop_positions});
}
