const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

var visited: [][]bool = undefined;
fn perimeter(grid: [][]const u8, char: u8, row: i64, col: i64, area: *u64) u64 {
    if (col < 0 or col >= grid[0].len) return 1;
    if (row < 0 or row >= grid.len) return 1;
    const y: usize = @intCast(row);
    const x: usize = @intCast(col);
    const c = grid[y][x];
    if (c != char) return 1;
    if (visited[y][x]) return 0;

    area.* += 1;
    visited[y][x] = true;
    return perimeter(grid, c, row - 1, col, area) + perimeter(grid, c, row + 1, col, area) + perimeter(grid, c, row, col - 1, area) + perimeter(grid, c, row, col + 1, area);
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var line_iter = mem.splitSequence(u8, input, "\n");
    var grid_list = std.ArrayList([]const u8).init(alloc);
    while (line_iter.next()) |line| try grid_list.append(line);
    const grid = try grid_list.toOwnedSlice();
    defer alloc.free(grid);

    // visited grid
    visited = try alloc.alloc([]bool, grid.len);
    defer alloc.free(visited);
    for (0..visited.len) |i| {
        visited[i] = try alloc.alloc(bool, grid[0].len);
        @memset(visited[i], false);
    }
    defer for (visited) |row| alloc.free(row);

    var total: u64 = 0;
    for (grid, 0..) |line, row| {
        for (line, 0..) |c, col| {
            if (visited[row][col]) continue;
            var area: u64 = 0;
            const perim = perimeter(grid, c, @intCast(row), @intCast(col), &area);
            total += area * perim;
            print("{c}: {} * {} = {}\n", .{ c, area, perim, area * perim });
        }
    }
    print("Result: {}\n", .{total});
}
