const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const LinkedList = std.DoublyLinkedList(u64);

pub fn main() !void {
    const alloc = std.heap.c_allocator;

    var split_iter = mem.split(u8, input, " ");
    var initial_stones_list = std.ArrayList(u64).init(alloc);
    while (split_iter.next()) |str| {
        const num = try std.fmt.parseUnsigned(u64, str, 10);
        try initial_stones_list.append(num);
    }
    const initial_stones = try initial_stones_list.toOwnedSlice();
    defer alloc.free(initial_stones);

    var total: u64 = 0;
    for (initial_stones) |initial_stone| {
        var stones: LinkedList = .{};
        var first = try alloc.create(LinkedList.Node);
        first.data = initial_stone;
        stones.append(first);

        for (0..75) |_| {
            var stone = stones.first;
            while (stone) |node| {
                const num = node.data;

                if (num == 0) {
                    node.data = 1;
                    stone = node.next;
                    continue;
                }
                const digits = std.math.log10(num) + 1;
                if (digits % 2 == 0) {
                    const new_node = try alloc.create(LinkedList.Node);
                    const order = std.math.pow(u64, 10, digits / 2);
                    node.data = num / order;
                    new_node.data = num - node.data * order;

                    stones.insertAfter(node, new_node);
                    stone = new_node.next;
                    continue;
                } else {
                    node.data = num * 2024;
                }

                stone = node.next;
            }
            print("Total: {d}\n", .{total + stones.len});
        }

        // clean up
        var tmp = stones.first;
        while (tmp) |node| {
            tmp = node.next;
            alloc.destroy(node);
        }

        total += stones.len;
    }
}
