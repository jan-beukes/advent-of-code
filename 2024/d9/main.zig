const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    // count required buffer
    var buffer_size: usize = 0;
    for (input) |char| {
        buffer_size += char - '0';
    }
    var buffer = try alloc.alloc(i64, buffer_size);

    // fill buffer with ids
    var id: isize = 0;
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
                buffer[buffer_pos + j] = -@as(i64, num);
            }
            buffer_pos += num;
        }
    }
    var i: usize = 0;
    while (i < buffer.len) : (i += 1) {
        const digit = buffer[i];
        if (digit < 0) {
            var pos: usize = buffer.len - 1;
            while (pos > i) : (pos -= 1) {
                if (buffer[pos] < 0) continue;
                if (pos <= i) break;

                id = buffer[pos];
                const len1: u64 = @abs(digit);
                var len2: u32 = 0;
                while (buffer[pos - len2] == id) len2 += 1;
                if (len2 <= len1) {
                    for (0..len2) |j| buffer[pos - j] = -@as(i64, len2);
                    for (0..len2) |j| buffer[i + j] = id;
                    if (len2 < len1) {
                        for (0..len1 - len2) |k| buffer[i + len2 + k] = -@as(i64, @intCast(len1 - len2));
                    }
                    break;
                } else {
                    pos -= (len2 - 1);
                }
            }
        }
    }
    var result: usize = 0;
    for (buffer, 0..) |digit, pos| {
        if (digit < 0) continue;
        result += @as(usize, @intCast(digit)) * pos;
    }
    print("Result: {}\n", .{result});
}
