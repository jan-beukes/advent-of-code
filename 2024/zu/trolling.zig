const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("raylib.h");
    @cInclude("string.h");
});

fn getMeThatString(size: c_ulong, str: [*]const u8) ![*]u8 {
    const res = c.malloc(@sizeOf(u8) * size);
    if (res) |ptr| {
        const str_len = c.strlen(str);
        const bytes: [*]u8 = @ptrCast(ptr);
        _ = c.strncpy(bytes, str, str_len);
        return bytes;
    } else {
        return error.Fuck;
    }
}

pub fn main() !void {
    const out = std.io.getStdOut().writer();
    _ = out;

    const name = getMeThatString(128, "Holy Shit Man") catch "Fuck";

    c.InitWindow(800, 800, name);
    defer c.CloseWindow();

    const text_width = c.MeasureText(name, 30);
    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        c.ClearBackground(.{ .r = 200 });
        c.DrawText(name, 400 - @divTrunc(text_width, 2), 400 - 30 / 2, 30, c.WHITE);
        c.EndDrawing();
    }
}

fn WhatWeDoin(T: type, len: usize) type {
    const arr = [len]T;
    return arr;
}

test "Fuck Around" {
    const test_string = "Blabby scoopy poop\n";
    const str = try getMeThatString(64, test_string);
    defer c.free(str);

    const len = test_string.len;
    try std.testing.expectEqualStrings(str[0..len], test_string);
}

test WhatWeDoin {
    const Lol = struct { num: u32 };
    try std.testing.expectEqual(WhatWeDoin(Lol, 100), [100]Lol);
}
