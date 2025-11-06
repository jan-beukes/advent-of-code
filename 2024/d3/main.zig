const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

const file = "input.txt";
const input = @embedFile(file);

fn parseMul(str: []const u8) ?u32 {
    var curr = str;

    if (!mem.startsWith(u8, curr, "(")) return null;
    curr = curr[1..];
    const num1_size = for (1..4) |i| {
        if (curr[i] == ',') break i;
    } else return null;
    const num1 = std.fmt.parseUnsigned(u32, curr[0..num1_size], 10) catch return null;

    curr = curr[num1_size + 1 ..];
    const num2_size = for (1..4) |i| {
        if (curr[i] == ')') break i;
    } else return null;
    const num2 = std.fmt.parseUnsigned(u32, curr[0..num2_size], 10) catch return null;

    return num1 * num2;
}

fn getNext(curr: []const u8) ?[]const u8 {
    const idx1 = mem.indexOf(u8, curr, "do") orelse std.math.maxInt(usize);
    const idx2 = mem.indexOf(u8, curr, "mul") orelse std.math.maxInt(usize);
    if (idx1 == idx2 and idx1 == std.math.maxInt(usize)) return null;
    return curr[@min(idx1, idx2)..];
}

pub fn main() !void {
    const do_str = "do()";
    const dont_str = "don't()";

    var curr: []const u8 = input;
    var total = @as(u32, 0);
    var do = true;

    while (getNext(curr)) |slice| {
        curr = slice;
        if (mem.startsWith(u8, curr, do_str)) {
            do = true;
            curr = curr[1..];
        } else if (mem.startsWith(u8, curr, dont_str)) {
            do = false;
            curr = curr[1..];
        } else if (mem.startsWith(u8, curr, "mul") and do) {
            curr = curr[3..];
            total += parseMul(curr) orelse 0;
        } else {
            curr = curr[1..];
        }
    }

    print("result: {}\n", .{total});
}
