const std = @import("std");
const testing = std.testing;

pub const AnsiRgb = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const ansi16 = [16]AnsiRgb{
    .{ .r = 0, .g = 0, .b = 0 },
    .{ .r = 170, .g = 0, .b = 0 },
    .{ .r = 0, .g = 170, .b = 0 },
    .{ .r = 170, .g = 170, .b = 0 },
    .{ .r = 0, .g = 0, .b = 170 },
    .{ .r = 170, .g = 0, .b = 170 },
    .{ .r = 0, .g = 170, .b = 170 },
    .{ .r = 170, .g = 170, .b = 170 },
    .{ .r = 85, .g = 85, .b = 85 },
    .{ .r = 255, .g = 85, .b = 85 },
    .{ .r = 85, .g = 255, .b = 85 },
    .{ .r = 255, .g = 255, .b = 85 },
    .{ .r = 85, .g = 85, .b = 255 },
    .{ .r = 255, .g = 85, .b = 255 },
    .{ .r = 85, .g = 255, .b = 255 },
    .{ .r = 255, .g = 255, .b = 255 },
};

pub const ansi256 = generateAnsi256();

fn generateAnsi256() [256]AnsiRgb {
    var palette: [256]AnsiRgb = undefined;
    palette[0] = .{ .r = 0, .g = 0, .b = 0 };
    palette[1] = .{ .r = 0, .g = 0, .b = 0 };
    palette[2] = .{ .r = 0, .g = 170, .b = 0 };
    palette[3] = .{ .r = 170, .g = 170, .b = 0 };
    palette[4] = .{ .r = 0, .g = 0, .b = 170 };
    palette[5] = .{ .r = 170, .g = 0, .b = 170 };
    palette[6] = .{ .r = 0, .g = 170, .b = 170 };
    palette[7] = .{ .r = 170, .g = 170, .b = 170 };
    palette[8] = .{ .r = 85, .g = 85, .b = 85 };
    palette[9] = .{ .r = 255, .g = 85, .b = 85 };
    palette[10] = .{ .r = 85, .g = 255, .b = 85 };
    palette[11] = .{ .r = 255, .g = 255, .b = 85 };
    palette[12] = .{ .r = 85, .g = 85, .b = 255 };
    palette[13] = .{ .r = 255, .g = 85, .b = 255 };
    palette[14] = .{ .r = 85, .g = 255, .b = 255 };
    palette[15] = .{ .r = 255, .g = 255, .b = 255 };
    comptime var i: u16 = 16;
    inline while (i < 232) : (i += 1) {
        const idx = i - 16;
        const b_val: u8 = @intCast(idx % 6);
        const g_val: u8 = @intCast((idx / 6) % 6);
        const r_val: u8 = @intCast(idx / 36);
        palette[i] = .{
            .r = if (r_val == 0) 0 else 55 + r_val * 40,
            .g = if (g_val == 0) 0 else 55 + g_val * 40,
            .b = if (b_val == 0) 0 else 55 + b_val * 40,
        };
    }
    comptime var j: u16 = 232;
    inline while (j < 256) : (j += 1) {
        const gray_val: u8 = @intCast(8 + (j - 232) * 10);
        palette[j] = .{ .r = gray_val, .g = gray_val, .b = gray_val };
    }
    return palette;
}

pub fn rgb6(r: u8, g: u8, b: u8) struct { index: u8 } {
    return .{ .index = 16 + 36 * r + 6 * g + b };
}

pub fn gray(level: u8) struct { index: u8 } {
    return .{ .index = 232 + level };
}

test "ansi16 has 16 entries" {
    try testing.expectEqual(@as(usize, 16), ansi16.len);
}

test "ansi256 has 256 entries" {
    try testing.expectEqual(@as(usize, 256), ansi256.len);
}

test "rgb6 formula" {
    try testing.expectEqual(@as(u8, 16), rgb6(0, 0, 0).index);
    try testing.expectEqual(@as(u8, 52), rgb6(1, 0, 0).index);
}

test "gray formula" {
    try testing.expectEqual(@as(u8, 232), gray(0).index);
    try testing.expectEqual(@as(u8, 255), gray(23).index);
}
