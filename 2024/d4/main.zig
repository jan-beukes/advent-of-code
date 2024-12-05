const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const String = []const u8;

fn xMas(grid: []String, x: usize, y: usize) bool {
    if (@as(isize, @intCast(x)) - 1 < 0 or (x + 1 >= grid[0].len)) return false;
    if (@as(isize, @intCast(y)) - 1 < 0 or (y + 1 >= grid.len)) return false;

    const one = (grid[y - 1][x - 1] == 'M' and grid[y + 1][x + 1] == 'S' or grid[y - 1][x - 1] == 'S' and grid[y + 1][x + 1] == 'M');
    const two = (grid[y + 1][x - 1] == 'M' and grid[y - 1][x + 1] == 'S' or grid[y + 1][x - 1] == 'S' and grid[y - 1][x + 1] == 'M');

    return one and two;
}

pub fn main() !void {
    var grid_list = std.ArrayList([]const u8).init(std.heap.page_allocator);
    defer grid_list.deinit();
    var lines = mem.split(u8, input, "\n");
    while (lines.next()) |line| {
        try grid_list.append(line);
    }
    const grid = grid_list.items;

    var count: u32 = 0;
    for (grid, 0..) |row, y| {
        for (row, 0..) |c, x| {
            if (c == 'A' and xMas(grid, x, y)) count += 1;
        }
    }

    print("Result: {}", .{count});
}
