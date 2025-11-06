const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

var visited: [][]bool = undefined;

fn inArea(grid: [][]const u8, char: u8, row: i64, col: i64) bool {
    if ((col < 0 or col >= grid[0].len) or (row < 0 or row >= grid.len)) return false;
    const y: usize = @intCast(row);
    const x: usize = @intCast(col);
    if (grid[y][x] != char) return false;

    return true;
}

fn sides(grid: [][]const u8, char: u8, row: i64, col: i64, area: *u64) u64 {
    if (!inArea(grid, char, row, col)) return 0;
    const y: usize = @intCast(row);
    const x: usize = @intCast(col);
    if (visited[y][x]) return 0;

    // vertex
    var side_count: u8 = 0;
    if (!inArea(grid, char, row, col - 1) and !inArea(grid, char, row - 1, col)) side_count += 1;
    if (!inArea(grid, char, row, col + 1) and !inArea(grid, char, row - 1, col)) side_count += 1;
    if (!inArea(grid, char, row, col - 1) and !inArea(grid, char, row + 1, col)) side_count += 1;
    if (!inArea(grid, char, row, col + 1) and !inArea(grid, char, row + 1, col)) side_count += 1;
    if (inArea(grid, char, row, col - 1) and inArea(grid, char, row - 1, col) and !inArea(grid, char, row - 1, col - 1)) side_count += 1;
    if (inArea(grid, char, row, col + 1) and inArea(grid, char, row - 1, col) and !inArea(grid, char, row - 1, col + 1)) side_count += 1;
    if (inArea(grid, char, row, col - 1) and inArea(grid, char, row + 1, col) and !inArea(grid, char, row + 1, col - 1)) side_count += 1;
    if (inArea(grid, char, row, col + 1) and inArea(grid, char, row + 1, col) and !inArea(grid, char, row + 1, col + 1)) side_count += 1;

    area.* += 1;
    visited[y][x] = true;
    return side_count + sides(grid, char, row - 1, col, area) + sides(grid, char, row + 1, col, area) + sides(grid, char, row, col - 1, area) + sides(grid, char, row, col + 1, area);
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
            const side_count = sides(grid, c, @intCast(row), @intCast(col), &area);
            total += area * side_count;
            print("{c}: {} * {} = {}\n", .{ c, area, side_count, area * side_count });
        }
    }
    print("Result: {}\n", .{total});
}
