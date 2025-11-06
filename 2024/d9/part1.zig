const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const EMPTY: i64 = -1;

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    // count required buffer
    var buffer_size: usize = 0;
    for (input) |char| {
        buffer_size += char - '0';
    }
    var buffer = try alloc.alloc(i64, buffer_size);

    // fill buffer with ids
    var id: usize = 0;
    var buffer_pos: usize = 0;
    for (input, 0..) |char, i| {
        const num = char - '0';
        // file
        if (i % 2 == 0) {
            for (0..num) |j| {
                buffer[buffer_pos + j] = @intCast(id);
            }
            buffer_pos += num;
            id += 1;
        } else {
            for (0..num) |j| {
                buffer[buffer_pos + j] = EMPTY;
            }
            buffer_pos += num;
        }
    }
    var last_pos: usize = buffer.len; // removes a lot of uneeded looping
    for (buffer, 0..) |digit, i| {
        if (digit == EMPTY) {
            for (1..last_pos) |j| {
                const pos = last_pos - j;
                if (buffer[pos] == EMPTY) continue;
                if (pos < i) break;
                buffer[i] = buffer[pos];
                buffer[pos] = EMPTY;
                last_pos = pos;
                break;
            }
        }
    }
    var result: usize = 0;
    for (buffer, 0..) |digit, pos| {
        if (digit == EMPTY) break;
        result += @as(usize, @intCast(digit)) * pos;
    }
    print("Result: {}\n", .{result});
}
