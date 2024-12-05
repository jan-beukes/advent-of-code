const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = @embedFile(file);
const line_len = 1 + (mem.indexOfScalar(u8, input, '\n') orelse unreachable);

const WORD = "XMAS";
const Point = struct { x: i32, y: i32 };

fn validPoints(grid: []const [line_len]u8, pos: Point, alloc: std.mem.Allocator) []Point {
    const points = alloc.alloc(Point, 8) catch unreachable;
    var count: u32 = 0;
    if (pos.x - 1 > 0) {
        points[count] = .{ .x = pos.x - 1, .y = pos.y };
        count += 1;
    }
    if (pos.y - 1 > 0) {
        points[count] = .{ .x = pos.x, .y = pos.y - 1 };
        points[count + 1] = .{ .x = pos.x - 1, .y = pos.y - 1 };
        count += 2;
    }
    if (pos.x + 1 < grid[0].len) {
        points[count] = .{ .x = pos.x + 1, .y = pos.y };
        points[count + 1] = .{ .x = pos.x + 1, .y = pos.y - 1 };
        count += 2;
    }
    if (pos.y + 1 < grid.len) {
        points[count] = .{ .x = pos.x, .y = pos.y + 1 };
        points[count + 1] = .{ .x = pos.x + 1, .y = pos.y + 1 };
        points[count + 2] = .{ .x = pos.x - 1, .y = pos.y + 1 };
        count += 3;
    }
    return points[0..count];
}

fn isXMas(grid: []const [line_len]u8, res_matrix: [][line_len]bool, letter: u8, prev: Point, pos: Point) bool {
    const row: usize = @intCast(@abs(pos.y));
    const col: usize = @intCast(@abs(pos.x));
    if (grid[row][col] != letter) return false;
    if (letter == 'S') {
        res_matrix[row][col] = true;
        return true;
    }
    // bounds
    const dir: Point = .{ .x = pos.x - prev.x, .y = pos.y - prev.y };
    if (pos.x + dir.x >= grid[0].len or pos.x + dir.x < 0) return false;
    if (pos.y + dir.y >= grid.len or pos.y + dir.y < 0) return false;

    const idx = mem.indexOfScalar(u8, WORD, letter) orelse return false;
    const next_letter = WORD[idx + 1];
    const nex_pos = Point{ .x = pos.x + dir.x, .y = pos.y + dir.y };
    if (isXMas(grid, res_matrix, next_letter, pos, nex_pos)) {
        res_matrix[row][col] = true;
        return true;
    } else return false;
}

pub fn main() void {
    // lol
    const alloc = std.heap.page_allocator;
    comptime var grid: []const [line_len]u8 = undefined;
    grid.ptr = @ptrCast(input[0..line_len]);
    grid.len = input.len / line_len;

    var total = @as(u32, 0);
    var res_matrix: [grid.len][line_len]bool = undefined;
    for (grid, 0..) |line, row| {
        for (line[0..line_len], 0..) |c, col| {
            if (c != 'X') {
                if (!res_matrix[row][col]) res_matrix[row][col] = false;
                continue;
            }

            const point = Point{ .y = @intCast(row), .x = @intCast(col) };
            const points = validPoints(grid, point, alloc);
            defer alloc.free(points);
            for (points) |p| {
                if (isXMas(grid, &res_matrix, 'M', point, p)) {
                    res_matrix[row][col] = true;
                    total += 1;
                }
            }
        }
    }
    for (grid, 0..) |l, r| {
        for (l, 0..) |c, cl| {
            if (res_matrix[r][cl]) {
                print("\x1b[1;31m{c}", .{c});
                print("\x1b[39;49m", .{});
            } else print("{c}", .{c});
        }
    }

    print("\nResult Among us {}\n", .{total});
}
