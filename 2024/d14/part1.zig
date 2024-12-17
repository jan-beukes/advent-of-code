const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");
const width = 101;
const height = 103;

const Vec2 = struct {
    x: i32,
    y: i32,
};

const Robot = struct {
    pos: Vec2,
    vel: Vec2,

    fn move(self: *Robot) void {
        self.pos.x = @rem(self.pos.x + self.vel.x, width);
        if (self.pos.x < 0) self.pos.x += width;
        self.pos.y = @rem(self.pos.y + self.vel.y, height);
        if (self.pos.y < 0) self.pos.y += height;
    }
};

fn parseRobots(alloc: mem.Allocator) ![]Robot {
    var line_iter = mem.splitSequence(u8, input, "\n");
    var robots = std.ArrayList(Robot).init(alloc);
    while (line_iter.next()) |line| {
        const pos_start = mem.indexOfScalar(u8, line, '=').? + 1;
        const sep1 = mem.indexOfScalar(u8, line, ',').?;
        const space = mem.indexOfScalar(u8, line, ' ').?;
        const vel_start = mem.lastIndexOfScalar(u8, line, '=').? + 1;
        const sep2 = mem.lastIndexOfScalar(u8, line, ',').?;

        const pos = Vec2{
            .x = try std.fmt.parseInt(i32, line[pos_start..sep1], 10),
            .y = try std.fmt.parseInt(i32, line[sep1 + 1 .. space], 10),
        };
        const vel = Vec2{
            .x = try std.fmt.parseInt(i32, line[vel_start..sep2], 10),
            .y = try std.fmt.parseInt(i32, line[sep2 + 1 ..], 10),
        };
        try robots.append(.{ .pos = pos, .vel = vel });
    }

    return try robots.toOwnedSlice();
}

pub fn main() !void {
    const writer = std.io.getStdOut().writer();
    var buffer = std.io.bufferedWriter(writer);
    var out = buffer.writer();
    const alloc = std.heap.page_allocator;

    const robots = try parseRobots(alloc);
    defer alloc.free(robots);

    for (0..100) |_| {
        for (robots) |*r| {
            r.move();
        }
    }

    for (0..height) |y| {
        for (0..width) |x| {
            var count: u8 = 0;
            for (robots) |r| {
                if (r.pos.x == x and r.pos.y == y) count += 1;
            }
            if (count == 0) try out.print(".", .{}) else try out.print("{}", .{count});
        }
        try out.print("\n", .{});
    }

    var quads: [4]u32 = .{ 0, 0, 0, 0 };
    for (robots) |r| {
        const x = r.pos.x + 1;
        const y = r.pos.y + 1;
        if (x < width / 2 + 1) {
            if (y < height / 2 + 1) {
                quads[0] += 1;
            } else if (y > height / 2 + 1) {
                quads[1] += 1;
            }
        } else if (x > width / 2 + 1) {
            if (y < height / 2 + 1) {
                quads[2] += 1;
            } else if (y > height / 2 + 1) {
                quads[3] += 1;
            }
        }
    }
    const result = quads[0] * quads[1] * quads[2] * quads[3];
    try out.print("Result: {} * {} * {} * {} = {}\n", .{ quads[0], quads[1], quads[2], quads[3], result });

    try buffer.flush();
}
