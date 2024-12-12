const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const HashMap = std.AutoHashMap([2]u64, u64);

fn blink(n: u64, b: []u64) ![]u64 {
    std.debug.assert(b.len == 2);
    if (n == 0) {
        b[0] = 1;
        return b[0..1];
    }
    var buff: [32]u8 = undefined;
    const str = try std.fmt.bufPrint(&buff, "{d}", .{n});
    if (str.len % 2 == 0) {
        const l = str.len / 2;
        b[0] = try std.fmt.parseUnsigned(u64, str[0..l], 10);
        b[1] = try std.fmt.parseUnsigned(u64, str[l..], 10);
        return b[0..2];
    }

    b[0] = n * 2024;
    return b[0..1];
}

fn solveDepth(n: u64, depth: u32, cache: *HashMap) !u64 {
    if (cache.get([2]u64{ n, depth })) |v| {
        return v;
    }

    var buff: [2]u64 = undefined;
    const stones = try blink(n, &buff);
    if (depth == 1) return stones.len;

    var num: u64 = 0;
    for (stones) |stone| {
        num += try solveDepth(stone, depth - 1, cache);
    }

    try cache.put([2]u64{ n, depth }, num);
    return num;
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var list = std.ArrayList(u64).init(alloc);
    var it = mem.split(u8, input, " ");

    while (it.next()) |num| {
        try list.append(try std.fmt.parseUnsigned(u64, num, 10));
    }
    const nums = try list.toOwnedSlice();
    defer alloc.free(nums);

    var cache = HashMap.init(alloc);

    var result: u64 = 0;
    for (nums) |num| {
        result += try solveDepth(num, 75, &cache);
    }

    print("Result: {}\n", .{result});
}
