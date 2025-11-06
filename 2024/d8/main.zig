const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const Pos = struct {
    row: i32,
    col: i32,
};

fn contains(list: []Pos, item: Pos) bool {
    for (list) |pos| {
        if (pos.row == item.row and pos.col == item.col) return true;
    }
    return false;
}

fn addAntinodes(grid: [][]const u8, antinodes: *std.ArrayList(Pos), char: u8, row: usize, col: usize) !void {
    const rowi: i32 = @intCast(row);
    const coli: i32 = @intCast(col);
    var add_self = false;

    for (grid[row..], row..) |line, r| {
        for (line, 0..) |char2, c| {
            if (r == row and c <= col) continue;
            if (char2 != char) continue;
            add_self = true;
            const y_diff: i32 = @as(i32, @intCast(r)) - rowi;
            const x_diff: i32 = @as(i32, @intCast(c)) - coli;
            var pos1: Pos = .{ .col = coli + x_diff, .row = rowi + y_diff };
            var pos2: Pos = .{ .col = coli - x_diff, .row = rowi - y_diff };

            var x_in_map = x_diff < 0 and pos1.col >= 0 or x_diff > 0 and pos1.col < grid[0].len;
            var y_in_map = y_diff < 0 and pos1.row >= 0 or y_diff > 0 and pos1.row < grid.len;
            while (x_in_map and y_in_map) {
                if (!contains(antinodes.items, pos1)) {
                    try antinodes.append(pos1);
                }
                pos1.col += x_diff;
                pos1.row += y_diff;
                x_in_map = x_diff < 0 and pos1.col >= 0 or x_diff > 0 and pos1.col < grid[0].len;
                y_in_map = y_diff < 0 and pos1.row >= 0 or y_diff > 0 and pos1.row < grid.len;
            }

            x_in_map = x_diff < 0 and pos2.col < grid[0].len or x_diff > 0 and pos2.col >= 0;
            y_in_map = y_diff < 0 and pos2.row < grid.len or y_diff > 0 and pos2.row >= 0;
            while (x_in_map and y_in_map) {
                if (!contains(antinodes.items, pos2)) {
                    try antinodes.append(pos2);
                }
                pos2.col -= x_diff;
                pos2.row -= y_diff;
                x_in_map = x_diff < 0 and pos2.col < grid[0].len or x_diff > 0 and pos2.col >= 0;
                y_in_map = y_diff < 0 and pos2.row < grid.len or y_diff > 0 and pos2.row >= 0;
            }
        }
    }
    const pos = Pos{ .col = coli, .row = rowi };
    if (add_self and !contains(antinodes.items, pos)) {
        try antinodes.append(pos);
    }
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var line_iter = mem.splitSequence(u8, input, "\n");
    var grid_list = std.ArrayList([]const u8).init(alloc);
    while (line_iter.next()) |line| try grid_list.append(line);

    const grid = try grid_list.toOwnedSlice();
    defer alloc.free(grid);

    var antinodes = std.ArrayList(Pos).init(alloc);
    defer antinodes.deinit();

    for (grid, 0..) |line, row| {
        for (line, 0..) |char, col| {
            if (char == '.') continue;
            try addAntinodes(grid, &antinodes, grid[row][col], row, col);
        }
    }
    print("Result: {}\n", .{antinodes.items.len});
}
