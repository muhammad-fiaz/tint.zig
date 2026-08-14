const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const RgbColor = color.RgbColor;

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

pub const ansi16_names = [16][]const u8{
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
    "bright_black",
    "bright_red",
    "bright_green",
    "bright_yellow",
    "bright_blue",
    "bright_magenta",
    "bright_cyan",
    "bright_white",
};

pub const ansi256 = generateAnsi256();

fn generateAnsi256() [256]AnsiRgb {
    var palette_arr: [256]AnsiRgb = undefined;
    palette_arr[0] = .{ .r = 0, .g = 0, .b = 0 };
    palette_arr[1] = .{ .r = 0, .g = 0, .b = 0 };
    palette_arr[2] = .{ .r = 0, .g = 170, .b = 0 };
    palette_arr[3] = .{ .r = 170, .g = 170, .b = 0 };
    palette_arr[4] = .{ .r = 0, .g = 0, .b = 170 };
    palette_arr[5] = .{ .r = 170, .g = 0, .b = 170 };
    palette_arr[6] = .{ .r = 0, .g = 170, .b = 170 };
    palette_arr[7] = .{ .r = 170, .g = 170, .b = 170 };
    palette_arr[8] = .{ .r = 85, .g = 85, .b = 85 };
    palette_arr[9] = .{ .r = 255, .g = 85, .b = 85 };
    palette_arr[10] = .{ .r = 85, .g = 255, .b = 85 };
    palette_arr[11] = .{ .r = 255, .g = 255, .b = 85 };
    palette_arr[12] = .{ .r = 85, .g = 85, .b = 255 };
    palette_arr[13] = .{ .r = 255, .g = 85, .b = 255 };
    palette_arr[14] = .{ .r = 85, .g = 255, .b = 255 };
    palette_arr[15] = .{ .r = 255, .g = 255, .b = 255 };
    comptime var i: u16 = 16;
    inline while (i < 232) : (i += 1) {
        const idx = i - 16;
        const b_val: u8 = @intCast(idx % 6);
        const g_val: u8 = @intCast((idx / 6) % 6);
        const r_val: u8 = @intCast(idx / 36);
        palette_arr[i] = .{
            .r = if (r_val == 0) 0 else 55 + r_val * 40,
            .g = if (g_val == 0) 0 else 55 + g_val * 40,
            .b = if (b_val == 0) 0 else 55 + b_val * 40,
        };
    }
    comptime var j: u16 = 232;
    inline while (j < 256) : (j += 1) {
        const gray_val: u8 = @intCast(8 + (j - 232) * 10);
        palette_arr[j] = .{ .r = gray_val, .g = gray_val, .b = gray_val };
    }
    return palette_arr;
}

pub fn rgb6(r: u8, g: u8, b: u8) struct { index: u8 } {
    return .{ .index = 16 + 36 * r + 6 * g + b };
}

pub fn gray(level: u8) struct { index: u8 } {
    return .{ .index = 232 + level };
}

pub fn ramp(start: RgbColor, end: RgbColor, steps: u8) [256]RgbColor {
    var result: [256]RgbColor = undefined;
    const n = @min(steps, @as(u8, 255));
    var i: u16 = 0;
    while (i <= n) : (i += 1) {
        const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(n));
        result[i] = .{
            .r = @intFromFloat(@as(f64, @floatFromInt(start.r)) * (1.0 - t) + @as(f64, @floatFromInt(end.r)) * t),
            .g = @intFromFloat(@as(f64, @floatFromInt(start.g)) * (1.0 - t) + @as(f64, @floatFromInt(end.g)) * t),
            .b = @intFromFloat(@as(f64, @floatFromInt(start.b)) * (1.0 - t) + @as(f64, @floatFromInt(end.b)) * t),
        };
    }
    return result;
}

pub fn gradient(c1: RgbColor, c2: RgbColor, c3: RgbColor, steps: u8) [256]RgbColor {
    var result: [256]RgbColor = undefined;
    const half = steps / 2;
    var i: u16 = 0;
    while (i <= half) : (i += 1) {
        const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(half));
        result[i] = .{
            .r = @intFromFloat(@as(f64, @floatFromInt(c1.r)) * (1.0 - t) + @as(f64, @floatFromInt(c2.r)) * t),
            .g = @intFromFloat(@as(f64, @floatFromInt(c1.g)) * (1.0 - t) + @as(f64, @floatFromInt(c2.g)) * t),
            .b = @intFromFloat(@as(f64, @floatFromInt(c1.b)) * (1.0 - t) + @as(f64, @floatFromInt(c2.b)) * t),
        };
    }
    var j: u16 = 0;
    while (j <= half) : (j += 1) {
        const t = @as(f64, @floatFromInt(j)) / @as(f64, @floatFromInt(half));
        result[half + j] = .{
            .r = @intFromFloat(@as(f64, @floatFromInt(c2.r)) * (1.0 - t) + @as(f64, @floatFromInt(c3.r)) * t),
            .g = @intFromFloat(@as(f64, @floatFromInt(c2.g)) * (1.0 - t) + @as(f64, @floatFromInt(c3.g)) * t),
            .b = @intFromFloat(@as(f64, @floatFromInt(c2.b)) * (1.0 - t) + @as(f64, @floatFromInt(c3.b)) * t),
        };
    }
    return result;
}

pub fn colorWheel(steps: u8) [256]RgbColor {
    var result: [256]RgbColor = undefined;
    var i: u16 = 0;
    while (i <= steps) : (i += 1) {
        const hue = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(steps)) * 360.0;
        const h_f = hue;
        const s_f = 1.0;
        const l_f = 0.5;
        const c = (1.0 - @abs(2.0 * l_f - 1.0)) * s_f;
        const x = c * (1.0 - @abs(@rem(h_f / 60.0, 2.0) - 1.0));
        const m = l_f - c / 2.0;
        var r: f64 = 0;
        var g: f64 = 0;
        var b: f64 = 0;
        if (h_f < 60) {
            r = c;
            g = x;
            b = 0;
        } else if (h_f < 120) {
            r = x;
            g = c;
            b = 0;
        } else if (h_f < 180) {
            r = 0;
            g = c;
            b = x;
        } else if (h_f < 240) {
            r = 0;
            g = x;
            b = c;
        } else if (h_f < 300) {
            r = x;
            g = 0;
            b = c;
        } else {
            r = c;
            g = 0;
            b = x;
        }
        result[i] = .{
            .r = @intFromFloat((r + m) * 255.0),
            .g = @intFromFloat((g + m) * 255.0),
            .b = @intFromFloat((b + m) * 255.0),
        };
    }
    return result;
}

pub fn multiGradient(stops: []const RgbColor, steps: u8) [256]RgbColor {
    var result: [256]RgbColor = undefined;
    if (stops.len == 0) return result;
    if (stops.len == 1) {
        var i: u16 = 0;
        while (i <= steps) : (i += 1) {
            result[i] = stops[0];
        }
        return result;
    }
    const n = @min(steps, @as(u8, 255));
    var i: u16 = 0;
    while (i <= n) : (i += 1) {
        const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(n));
        const segment = t * @as(f64, @floatFromInt(stops.len - 1));
        const idx: usize = @intFromFloat(@min(@floor(segment), @as(f64, @floatFromInt(stops.len - 2))));
        const local_t = segment - @as(f64, @floatFromInt(idx));
        const c1 = stops[idx];
        const c2 = stops[@min(idx + 1, stops.len - 1)];
        result[i] = .{
            .r = @intFromFloat(@as(f64, @floatFromInt(c1.r)) * (1.0 - local_t) + @as(f64, @floatFromInt(c2.r)) * local_t),
            .g = @intFromFloat(@as(f64, @floatFromInt(c1.g)) * (1.0 - local_t) + @as(f64, @floatFromInt(c2.g)) * local_t),
            .b = @intFromFloat(@as(f64, @floatFromInt(c1.b)) * (1.0 - local_t) + @as(f64, @floatFromInt(c2.b)) * local_t),
        };
    }
    return result;
}

pub fn hueGradient(steps: u8) [256]RgbColor {
    var result: [256]RgbColor = undefined;
    const n = @min(steps, @as(u8, 255));
    var i: u16 = 0;
    while (i <= n) : (i += 1) {
        const hue = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(n)) * 360.0;
        const h_f = hue;
        const s_f = 1.0;
        const l_f = 0.5;
        const c = (1.0 - @abs(2.0 * l_f - 1.0)) * s_f;
        const x = c * (1.0 - @abs(@rem(h_f / 60.0, 2.0) - 1.0));
        const m = l_f - c / 2.0;
        var r: f64 = 0;
        var g: f64 = 0;
        var b: f64 = 0;
        if (h_f < 60) {
            r = c;
            g = x;
            b = 0;
        } else if (h_f < 120) {
            r = x;
            g = c;
            b = 0;
        } else if (h_f < 180) {
            r = 0;
            g = c;
            b = x;
        } else if (h_f < 240) {
            r = 0;
            g = x;
            b = c;
        } else if (h_f < 300) {
            r = x;
            g = 0;
            b = c;
        } else {
            r = c;
            g = 0;
            b = x;
        }
        result[i] = .{
            .r = @intFromFloat((r + m) * 255.0),
            .g = @intFromFloat((g + m) * 255.0),
            .b = @intFromFloat((b + m) * 255.0),
        };
    }
    return result;
}

pub const warm_palette = [8]RgbColor{
    .{ .r = 255, .g = 0, .b = 0 },
    .{ .r = 255, .g = 69, .b = 0 },
    .{ .r = 255, .g = 140, .b = 0 },
    .{ .r = 255, .g = 165, .b = 0 },
    .{ .r = 255, .g = 215, .b = 0 },
    .{ .r = 218, .g = 165, .b = 32 },
    .{ .r = 210, .g = 105, .b = 30 },
    .{ .r = 178, .g = 34, .b = 34 },
};

pub const cool_palette = [8]RgbColor{
    .{ .r = 0, .g = 0, .b = 255 },
    .{ .r = 0, .g = 191, .b = 255 },
    .{ .r = 0, .g = 255, .b = 255 },
    .{ .r = 0, .g = 255, .b = 127 },
    .{ .r = 0, .g = 128, .b = 128 },
    .{ .r = 64, .g = 224, .b = 208 },
    .{ .r = 70, .g = 130, .b = 180 },
    .{ .r = 100, .g = 149, .b = 237 },
};

pub const earth_palette = [8]RgbColor{
    .{ .r = 139, .g = 69, .b = 19 },
    .{ .r = 160, .g = 82, .b = 45 },
    .{ .r = 210, .g = 180, .b = 140 },
    .{ .r = 244, .g = 164, .b = 96 },
    .{ .r = 222, .g = 184, .b = 135 },
    .{ .r = 245, .g = 222, .b = 179 },
    .{ .r = 210, .g = 105, .b = 30 },
    .{ .r = 184, .g = 134, .b = 11 },
};

pub const pastel_palette = [8]RgbColor{
    .{ .r = 255, .g = 182, .b = 193 },
    .{ .r = 255, .g = 218, .b = 185 },
    .{ .r = 255, .g = 255, .b = 224 },
    .{ .r = 144, .g = 238, .b = 144 },
    .{ .r = 173, .g = 216, .b = 230 },
    .{ .r = 216, .g = 191, .b = 216 },
    .{ .r = 255, .g = 228, .b = 225 },
    .{ .r = 230, .g = 230, .b = 250 },
};

pub const neon_palette = [8]RgbColor{
    .{ .r = 255, .g = 0, .b = 255 },
    .{ .r = 0, .g = 255, .b = 255 },
    .{ .r = 255, .g = 255, .b = 0 },
    .{ .r = 0, .g = 255, .b = 0 },
    .{ .r = 255, .g = 0, .b = 0 },
    .{ .r = 255, .g = 165, .b = 0 },
    .{ .r = 127, .g = 0, .b = 255 },
    .{ .r = 255, .g = 20, .b = 147 },
};

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

test "palette subsets" {
    try testing.expectEqual(@as(usize, 8), warm_palette.len);
    try testing.expectEqual(@as(usize, 8), cool_palette.len);
    try testing.expectEqual(@as(usize, 8), earth_palette.len);
    try testing.expectEqual(@as(usize, 8), pastel_palette.len);
    try testing.expectEqual(@as(usize, 8), neon_palette.len);
}

test "ramp generates colors" {
    const r = ramp(.{ .r = 0, .g = 0, .b = 0 }, .{ .r = 255, .g = 255, .b = 255 }, 10);
    try testing.expectEqual(@as(u8, 0), r[0].r);
    try testing.expect(r[5].r > 0);
}

test "gradient generates colors" {
    const g = gradient(
        .{ .r = 255, .g = 0, .b = 0 },
        .{ .r = 0, .g = 255, .b = 0 },
        .{ .r = 0, .g = 0, .b = 255 },
        10,
    );
    try testing.expectEqual(@as(u8, 255), g[0].r);
}

test "colorWheel generates rainbow" {
    const w = colorWheel(12);
    try testing.expect(w[0].r > 0);
    try testing.expect(w[6].g > 0);
}

test "multiGradient generates colors" {
    const stops = [_]RgbColor{
        .{ .r = 255, .g = 0, .b = 0 },
        .{ .r = 0, .g = 255, .b = 0 },
        .{ .r = 0, .g = 0, .b = 255 },
    };
    const g = multiGradient(&stops, 10);
    try testing.expectEqual(@as(u8, 255), g[0].r);
    try testing.expect(g[5].g > 0);
}

test "hueGradient generates rainbow" {
    const h = hueGradient(12);
    try testing.expect(h[0].r > 0);
    try testing.expect(h[6].g > 0);
}
