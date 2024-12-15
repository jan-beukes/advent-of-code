const std = @import("std");
const mem = std.mem;
const print = std.debug.print;

const file = "input.txt";
const input = mem.trimRight(u8, @embedFile(file), "\n");

const Vec2 = struct { x: u64, y: u64 };

const ClawMachine = struct {
    const Self = @This();

    button_a: Vec2,
    button_b: Vec2,
    prize: Vec2,

    fn init(a: []const u8, b: []const u8, prize: []const u8) !Self {
        var x_start = mem.indexOfScalar(u8, a, '+').? + 1;
        var x_end = mem.indexOfScalar(u8, a, ',').?;
        var y_start = mem.lastIndexOfScalar(u8, a, '+').? + 1;
        const button_a = Vec2{
            .x = try std.fmt.parseUnsigned(u64, a[x_start..x_end], 10),
            .y = try std.fmt.parseUnsigned(u64, a[y_start..], 10),
        };
        x_start = mem.indexOfScalar(u8, b, '+').? + 1;
        x_end = mem.indexOfScalar(u8, b, ',').?;
        y_start = mem.lastIndexOfScalar(u8, b, '+').? + 1;
        const button_b = Vec2{
            .x = try std.fmt.parseUnsigned(u64, b[x_start..x_end], 10),
            .y = try std.fmt.parseUnsigned(u64, b[y_start..], 10),
        };

        const prize_x = mem.indexOfScalar(u8, prize, '=').? + 1;
        x_end = mem.indexOfScalar(u8, prize, ',').?;
        const prize_y = mem.lastIndexOfScalar(u8, prize, '=').? + 1;
        const prize_vec = Vec2{
            .x = try std.fmt.parseUnsigned(u64, prize[prize_x..x_end], 10) + 10000000000000,
            .y = try std.fmt.parseUnsigned(u64, prize[prize_y..], 10) + 10000000000000,
        };

        return .{
            .button_a = button_a,
            .button_b = button_b,
            .prize = prize_vec,
        };
    }

    fn solve(self: Self) ?u64 {
        const button_a = self.button_a;
        const button_b = self.button_b;
        const prize = self.prize;

        const det = @as(f64, @floatFromInt(button_a.x * button_b.y)) - @as(f64, @floatFromInt(button_a.y * button_b.x));
        if (det == 0) return null;

        const a: f64 = @floatFromInt(button_a.x);
        const b: f64 = @floatFromInt(button_b.x);
        const c: f64 = @floatFromInt(button_a.y);
        const d: f64 = @floatFromInt(button_b.y);

        // mat inverse
        const p_x: f64 = @floatFromInt(prize.x);
        const p_y: f64 = @floatFromInt(prize.y);
        const result_a = (p_x * d - p_y * b) / det;
        const result_b = (p_y * a - p_x * c) / det;

        if (@trunc(result_a) != result_a or @trunc(result_b) != result_b) return null;

        return @as(u64, @intFromFloat(result_a)) * 3 + @as(u64, @intFromFloat(result_b));
    }
};

pub fn main() !void {
    var line_iter = mem.splitSequence(u8, input, "\n");

    var total: u64 = 0;
    var num: usize = 0;
    while (line_iter.next()) |line| {
        if (line.len == 0 or line[0] != 'B') continue;
        num += 1;
        const a = line;
        const b = line_iter.next().?;
        const prize = line_iter.next().?;

        const claw_machine = try ClawMachine.init(a, b, prize);
        const min = claw_machine.solve();
        if (min) |m| {
            total += m;
            print("EPIC: {}\n", .{num});
        }
    }

    print("Result: {}\n", .{total});
}
