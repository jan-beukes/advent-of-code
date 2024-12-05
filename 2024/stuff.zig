const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

pub fn main() !void {
    const a = std.heap.page_allocator;
    var line_iter = mem.splitSequence(u8, input, "\n");
    var list = std.ArrayList([]const u8).init(a);
}
