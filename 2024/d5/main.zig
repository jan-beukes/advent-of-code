const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const ArrayList = std.ArrayList(i32);

fn compare(map: std.AutoHashMap(i32, ArrayList), lhs: i32, rhs: i32) bool {
    if (!(map.contains(lhs) or map.contains(rhs))) return false;

    const lhs_list = map.get(lhs);
    const rhs_list = map.get(rhs);
    if (lhs_list) |list| {
        for (list.items) |item| {
            if (item == rhs) return true;
        }
    }
    if (rhs_list) |list| {
        for (list.items) |item| {
            if (item == lhs) return false;
        }
    }
    return false;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const a = arena.allocator();
    defer arena.deinit();

    var line_iter = mem.splitSequence(u8, input, "\n");
    var map = std.AutoHashMap(i32, ArrayList).init(a);
    defer map.deinit();

    while (line_iter.next()) |line| {
        if (mem.eql(u8, line, "")) break;

        var it = mem.tokenizeSequence(u8, line, "|");
        const n1 = try std.fmt.parseInt(i32, it.next().?, 10);
        const n2 = try std.fmt.parseInt(i32, it.next().?, 10);

        if (map.getPtr(n1)) |list| {
            try list.*.append(n2);
        } else {
            var list = ArrayList.init(a);
            try list.append(n2);
            try map.put(n1, list);
        }
    }

    var total: i32 = 0;
    outer: while (line_iter.next()) |line| {
        var tok_it = mem.tokenizeSequence(u8, line, ",");
        var numbers = ArrayList.init(a);
        while (tok_it.next()) |tok| {
            try numbers.append(try std.fmt.parseInt(i32, tok, 10));
        }
        for (numbers.items, 0..) |num, i| {
            if (!map.contains(num)) continue;
            const list = map.get(num) orelse unreachable;
            for (list.items) |item| {
                if (mem.indexOfScalar(i32, numbers.items, item) == null) continue;
                // He is broken
                if (mem.indexOfScalar(i32, numbers.items, item).? < i) {
                    mem.sort(i32, numbers.items, map, compare);
                    total += numbers.items[numbers.items.len / 2];
                    continue :outer;
                }
            }
        }
    }

    print("result: {}", .{total});
}
