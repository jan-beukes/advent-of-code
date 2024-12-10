const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

fn trailHeadScore(grid: [][]const u8, row: isize, col: isize, alloc: mem.Allocator) !u32 {
    const TrailPos = struct {
        x: isize,
        y: isize,
        prev: u8,

        fn isIn(self: @This(), list: []@This()) bool {
            for (list) |pos| {
                if (pos.x == self.x and pos.y == self.y) return true;
            }
            return false;
        }
    };

    var stack = std.ArrayList(TrailPos).init(alloc);
    defer stack.deinit();

    try stack.append(.{ .x = col, .y = row, .prev = '0' - 1 });
    var total: u32 = 0;
    while (stack.items.len != 0) {
        const pos = stack.pop();
        if ((pos.x < 0 or pos.x >= grid[0].len) or (pos.y < 0 or pos.y >= grid.len)) continue;

        const c = grid[@as(usize, @intCast(pos.y))][@as(usize, @intCast(pos.x))];
        if (c != pos.prev + 1) continue;
        if (c == '9') total += 1;

        // add next
        try stack.append(.{ .x = pos.x - 1, .y = pos.y, .prev = c });
        try stack.append(.{ .x = pos.x + 1, .y = pos.y, .prev = c });
        try stack.append(.{ .x = pos.x, .y = pos.y - 1, .prev = c });
        try stack.append(.{ .x = pos.x, .y = pos.y + 1, .prev = c });
    }
    return total;
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    // store grid
    var line_iter = mem.splitSequence(u8, input, "\n");
    var grid_list = std.ArrayList([]const u8).init(alloc);
    while (line_iter.next()) |line| try grid_list.append(line);
    const grid = try grid_list.toOwnedSlice();
    defer alloc.free(grid);

    var total_score: u32 = 0;
    for (grid, 0..) |line, row| {
        for (line, 0..) |c, col| {
            if (c != '0') continue;
            const y: isize = @intCast(row);
            const x: isize = @intCast(col);
            const score = try trailHeadScore(grid, y, x, alloc);
            print("Head: ({}, {}) | Score: {}\n", .{ row, col, score });
            total_score += score;
        }
    }
    print("Result: {}\n", .{total_score});
}
