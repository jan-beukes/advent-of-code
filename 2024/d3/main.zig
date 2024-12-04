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

fn doMuls(curr: []const u8, next_do: usize) u32 {
    var total: u32 = 0;
    var pos: usize = 0;
    while (mem.indexOf(u8, curr[pos..], "mul")) |i| {
        pos += i;
        if (pos > next_do) break;

        pos += 3;
        const add = parseMul(curr[pos..]) orelse 0;
        total += add;
    }
    return total;
}

pub fn main() !void {
    const do_str = "do()";
    const dont_str = "don't()";

    var curr: []const u8 = input;
    var total = @as(u32, 0);
    var do = true;

    const first = mem.indexOf(u8, curr, "do") orelse curr.len; // no more do to check
    total += doMuls(curr, first);
    while (mem.indexOf(u8, curr, "do")) |do_index| {
        curr = curr[do_index..];
        if (mem.startsWith(u8, curr, do_str)) {
            do = true;
            curr = curr[do_str.len..];
        } else if (mem.startsWith(u8, curr, dont_str)) {
            do = false;
            curr = curr[dont_str.len..];
            continue;
        } else {
            curr = curr[2..];
            if (!do) continue;
        }
        const next_do = mem.indexOf(u8, curr, "do") orelse curr.len; // no more do to check
        total += doMuls(curr, next_do);
    }

    print("result: {}\n", .{total});
}
