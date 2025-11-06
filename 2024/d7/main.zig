const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    _ = alloc;
    var line_iter = mem.splitSequence(u8, input, "\n");

    var result: usize = 0;
    while (line_iter.next()) |line| {
        var toks = mem.tokenizeAny(u8, line, ": ");
        const value = try std.fmt.parseUnsigned(usize, toks.next().?, 10);
        var num_buff: [32]usize = undefined;
        var count: usize = 0;
        while (toks.next()) |tok| {
            num_buff[count] = try std.fmt.parseUnsigned(usize, tok, 10);
            count += 1;
        }

        const nums = num_buff[0..count];
        for (0..std.math.pow(usize, 3, count)) |i| {
            var total: usize = nums[0];
            for (nums[1..], 1..) |num, j| {
                const digit = std.math.pow(usize, 3, j);
                const rem = (i / digit) % 3;
                switch (rem) {
                    0 => total = std.math.add(usize, total, num) catch break,
                    1 => total = std.math.mul(usize, total, num) catch break,
                    2 => {
                        const digits = std.math.log10(num) + 1;
                        total = std.math.mul(usize, total, std.math.pow(usize, 10, digits)) catch break;
                        total = std.math.add(usize, total, num) catch break;
                    },
                    else => unreachable,
                }
                if (total > value) break;
            }
            if (total == value) {
                result += total;
                break;
            }
        }
    }

    print("Result: {}\n", .{result});
}
