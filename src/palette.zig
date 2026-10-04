//! Terminal palettes, ramp generators and palette checks.
//!
//! Everything writes into caller owned buffers: tint.zig never allocates.

const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const util = @import("util.zig");

const Rgb = color.Rgb;
const Color = color.Color;

/// The 16 base colours every terminal must support.
pub const ansi16 = color.ansi16;
/// Names of `ansi16`, indexed the same way.
pub const ansi16Names = color.ansi16Names;

/// xterm's 88-colour palette: the 16 base colours, a 4x4x4 cube on the levels
/// `0, 139, 205, 255` at `16...79`, and an 8 step grayscale ramp at `80...87`
/// that deliberately omits black and white.
pub const ansi88 = generateAnsi88();

/// Names of `ansi88`, indexed the same way.
pub const ansi88Names = generateAnsi88Names();

/// xterm's 256-colour palette.
pub const ansi256 = generateAnsi256();

fn generateAnsi256() [256]Rgb {
    @setEvalBranchQuota(10000);
    var table: [256]Rgb = undefined;
    for (&table, 0..) |*slot, i| slot.* = color.ansi256ToRgb(@intCast(i));
    return table;
}

fn generateAnsi88() [88]Rgb {
    var table: [88]Rgb = undefined;
    for (0..16) |i| table[i] = ansi16[i];

    const levels = [4]u8{ 0, 139, 205, 255 };
    for (0..64) |i| {
        table[16 + i] = .{ .r = levels[i / 16], .g = levels[(i / 4) % 4], .b = levels[i % 4] };
    }

    const grays = [8]u8{ 46, 92, 115, 139, 162, 185, 208, 231 };
    for (grays, 0..) |level, i| table[80 + i] = .{ .r = level, .g = level, .b = level };
    return table;
}

fn generateAnsi88Names() [88][]const u8 {
    @setEvalBranchQuota(100000);
    var names: [88][]const u8 = undefined;
    for (ansi16Names, 0..) |name, i| names[i] = name;
    comptime var i: usize = 0;
    inline while (i < 64) : (i += 1) {
        names[16 + i] = comptime std.fmt.comptimePrint("cube_{d}_{d}_{d}", .{ i / 16, (i / 4) % 4, i % 4 });
    }
    comptime var j: usize = 0;
    inline while (j < 8) : (j += 1) {
        names[80 + j] = comptime std.fmt.comptimePrint("gray_{d}", .{j});
    }
    return names;
}

/// Fills `out` with a linear interpolation from `start` to `end`. Both ends
/// are exact. Empty slices are a no-op.
pub fn ramp(out: []Rgb, start: Rgb, end: Rgb) void {
    const stops = [2]Rgb{ start, end };
    gradient(out, &stops);
}

/// Fills `out` by interpolating through `stops`, which must not be empty. The
/// first and last elements are exactly the first and last stop.
pub fn gradient(out: []Rgb, stops: []const Rgb) void {
    std.debug.assert(stops.len > 0);
    if (out.len == 0) return;
    if (stops.len == 1) {
        for (out) |*slot| slot.* = stops[0];
        return;
    }

    const last = stops.len - 1;
    const divisor: f64 = @floatFromInt(out.len - 1);
    for (out, 0..) |*slot, i| {
        const t: f64 = if (out.len == 1) 0 else @as(f64, @floatFromInt(i)) / divisor;
        const position = t * @as(f64, @floatFromInt(last));
        const index: usize = @min(@as(usize, @intFromFloat(@floor(position))), last - 1);
        slot.* = interpolate(stops[index], stops[index + 1], position - @as(f64, @floatFromInt(index)));
    }
}

/// Fills `out` with a fully saturated sweep around the hue circle, starting
/// and ending at red.
pub fn hue(out: []Rgb) void {
    if (out.len == 0) return;
    if (out.len == 1) {
        out[0] = color.Hsl.init(0, 100, 50).toRgb();
        return;
    }
    const divisor: f64 = @floatFromInt(out.len - 1);
    for (out, 0..) |*slot, i| {
        const angle: f64 = @as(f64, @floatFromInt(i)) / divisor * 360.0;
        slot.* = color.Hsl.init(@intFromFloat(angle), 100, 50).toRgb();
    }
}

/// Fills `out` with a single-hue sequential ramp from almost white to almost
/// black, at fixed 80% saturation.
pub fn sequential(out: []Rgb, baseHue: u16) void {
    if (out.len == 0) return;
    const divisor: f64 = @floatFromInt(out.len - 1);
    for (out, 0..) |*slot, i| {
        const t: f64 = if (out.len == 1) 0 else @as(f64, @floatFromInt(i)) / divisor;
        slot.* = color.Hsl.init(baseHue, 80, @intFromFloat(92 - t * 80)).toRgb();
    }
}

/// Fills `out` with a diverging ramp: `hues[0]` dark through a light centre to
/// `hues[1]` dark. Both ends are fully saturated.
pub fn diverging(out: []Rgb, hues: [2]u16) void {
    if (out.len == 0) return;
    const half = (out.len + 1) / 2;
    for (out, 0..) |*slot, i| {
        if (i < half) {
            const t: f64 = if (half == 1) 1 else @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(half - 1));
            slot.* = color.Hsl.init(hues[0], @intFromFloat(20 + t * 60), @intFromFloat(20 + t * 72)).toRgb();
        } else {
            const second = out.len - half;
            const t: f64 = if (second == 1) 1 else @as(f64, @floatFromInt(i - half)) / @as(f64, @floatFromInt(second - 1));
            slot.* = color.Hsl.init(hues[1], @intFromFloat(80 - t * 60), @intFromFloat(92 - t * 72)).toRgb();
        }
    }
}

/// Fills `out` with evenly spaced, maximally distinct hues at 75% saturation
/// and 60% lightness.
pub fn categorical(out: []Rgb) void {
    if (out.len == 0) return;
    const step: f64 = 360.0 / @as(f64, @floatFromInt(out.len));
    for (out, 0..) |*slot, i| {
        slot.* = color.Hsl.init(@intFromFloat(@as(f64, @floatFromInt(i)) * step), 75, 60).toRgb();
    }
}

fn interpolate(from: Rgb, to: Rgb, t: f64) Rgb {
    return .{ .r = util.mixInt(from.r, to.r, t), .g = util.mixInt(from.g, to.g, t), .b = util.mixInt(from.b, to.b, t) };
}

/// Writes up to `out.len` scheme colours and returns what was written.
pub fn complementary(out: []Color, base: Color) []Color {
    const scheme = [_]Color{base.complementary()};
    return copyScheme(out, &scheme);
}

/// Writes up to `out.len` scheme colours and returns what was written.
pub fn analogous(out: []Color, base: Color) []Color {
    const scheme = [_]Color{ base.analogous()[0], base, base.analogous()[1] };
    return copyScheme(out, &scheme);
}

/// Writes up to `out.len` scheme colours and returns what was written.
pub fn triadic(out: []Color, base: Color) []Color {
    const scheme = [_]Color{ base, base.triadic()[0], base.triadic()[1] };
    return copyScheme(out, &scheme);
}

/// Writes up to `out.len` scheme colours and returns what was written.
pub fn tetradic(out: []Color, base: Color) []Color {
    const t = base.tetradic();
    const scheme = [_]Color{ base, t[0], t[1], t[2] };
    return copyScheme(out, &scheme);
}

/// Writes up to `out.len` scheme colours and returns what was written.
pub fn splitComplementary(out: []Color, base: Color) []Color {
    const s = base.splitComplementary();
    const scheme = [_]Color{ base, s[0], s[1] };
    return copyScheme(out, &scheme);
}

fn copyScheme(out: []Color, scheme: []const Color) []Color {
    const n = @min(out.len, scheme.len);
    @memcpy(out[0..n], scheme[0..n]);
    return out[0..n];
}

/// How readable `fg` is on `bg`, by WCAG ratio.
pub const Readability = enum {
    /// Below 3:1, unreadable body text.
    fail,
    /// At least 3:1, large text only.
    large,
    /// At least 4.5:1, normal text.
    aa,
    /// At least 7:1.
    aaa,
};

pub fn readability(fg: Color, bg: Color) Readability {
    const ratio = fg.contrastRatio(bg);
    if (ratio >= 7) return .aaa;
    if (ratio >= 4.5) return .aa;
    if (ratio >= 3) return .large;
    return .fail;
}

/// The lowest contrast ratio of any pair. Requires at least two colours.
pub fn minContrastRatio(colors: []const Color) f64 {
    std.debug.assert(colors.len >= 2);
    var min = std.math.floatMax(f64);
    for (colors, 0..) |a, i| {
        for (colors[i + 1 ..]) |b| min = @min(min, a.contrastRatio(b));
    }
    return min;
}

/// The highest contrast ratio of any pair. Requires at least two colours.
pub fn maxContrastRatio(colors: []const Color) f64 {
    std.debug.assert(colors.len >= 2);
    var max: f64 = 0;
    for (colors, 0..) |a, i| {
        for (colors[i + 1 ..]) |b| max = @max(max, a.contrastRatio(b));
    }
    return max;
}

/// True when two entries convert to the same RGB.
pub fn hasDuplicates(colors: []const Color) bool {
    for (colors, 0..) |a, i| {
        for (colors[i + 1 ..]) |b| {
            if (std.meta.eql(a.toRgb(), b.toRgb())) return true;
        }
    }
    return false;
}

/// The smallest CIEDE2000 distance of any pair. Requires at least two colours.
pub fn closestPair(colors: []const Color) f64 {
    std.debug.assert(colors.len >= 2);
    var min = std.math.floatMax(f64);
    for (colors, 0..) |a, i| {
        for (colors[i + 1 ..]) |b| min = @min(min, a.deltaE2000(b));
    }
    return min;
}

/// True when luminance is ordered along the slice, rising or falling but never
/// changing direction.
pub fn isMonotonicLuminance(colors: []const Color) bool {
    if (colors.len < 2) return true;
    var rising = false;
    var falling = false;
    for (colors[0 .. colors.len - 1], colors[1..]) |a, b| {
        if (b.luminance() > a.luminance()) rising = true;
        if (b.luminance() < a.luminance()) falling = true;
    }
    return !(rising and falling);
}

/// Eight warm colours: reds, oranges and yellows.
pub const warm = [8]Rgb{
    .{ .r = 255, .g = 0, .b = 0 },
    .{ .r = 255, .g = 69, .b = 0 },
    .{ .r = 255, .g = 140, .b = 0 },
    .{ .r = 255, .g = 165, .b = 0 },
    .{ .r = 255, .g = 215, .b = 0 },
    .{ .r = 218, .g = 165, .b = 32 },
    .{ .r = 210, .g = 105, .b = 30 },
    .{ .r = 178, .g = 34, .b = 34 },
};

/// Eight cool colours: blues, cyans and teals.
pub const cool = [8]Rgb{
    .{ .r = 0, .g = 0, .b = 255 },
    .{ .r = 0, .g = 191, .b = 255 },
    .{ .r = 0, .g = 255, .b = 255 },
    .{ .r = 0, .g = 255, .b = 127 },
    .{ .r = 0, .g = 128, .b = 128 },
    .{ .r = 64, .g = 224, .b = 208 },
    .{ .r = 70, .g = 130, .b = 180 },
    .{ .r = 100, .g = 149, .b = 237 },
};

/// Eight earth tones: browns, tans and ambers.
pub const earth = [8]Rgb{
    .{ .r = 139, .g = 69, .b = 19 },
    .{ .r = 160, .g = 82, .b = 45 },
    .{ .r = 210, .g = 180, .b = 140 },
    .{ .r = 244, .g = 164, .b = 96 },
    .{ .r = 222, .g = 184, .b = 135 },
    .{ .r = 245, .g = 222, .b = 179 },
    .{ .r = 210, .g = 105, .b = 30 },
    .{ .r = 184, .g = 134, .b = 11 },
};

/// Eight pastel colours.
pub const pastel = [8]Rgb{
    .{ .r = 255, .g = 182, .b = 193 },
    .{ .r = 255, .g = 218, .b = 185 },
    .{ .r = 255, .g = 255, .b = 224 },
    .{ .r = 144, .g = 238, .b = 144 },
    .{ .r = 173, .g = 216, .b = 230 },
    .{ .r = 216, .g = 191, .b = 216 },
    .{ .r = 255, .g = 228, .b = 225 },
    .{ .r = 230, .g = 230, .b = 250 },
};

/// Eight saturated, high energy colours.
pub const neon = [8]Rgb{
    .{ .r = 255, .g = 0, .b = 255 },
    .{ .r = 0, .g = 255, .b = 255 },
    .{ .r = 255, .g = 255, .b = 0 },
    .{ .r = 0, .g = 255, .b = 0 },
    .{ .r = 255, .g = 0, .b = 0 },
    .{ .r = 255, .g = 165, .b = 0 },
    .{ .r = 127, .g = 0, .b = 255 },
    .{ .r = 255, .g = 20, .b = 147 },
};

test "palette sizes" {
    try testing.expectEqual(@as(usize, 16), ansi16.len);
    try testing.expectEqual(@as(usize, 16), ansi16Names.len);
    try testing.expectEqual(@as(usize, 88), ansi88.len);
    try testing.expectEqual(@as(usize, 88), ansi88Names.len);
    try testing.expectEqual(@as(usize, 256), ansi256.len);
    for ([_][8]Rgb{ warm, cool, earth, pastel, neon }) |subset| {
        try testing.expectEqual(@as(usize, 8), subset.len);
    }
}

test "ansi256 table matches the canonical conversion" {
    for (ansi256, 0..) |entry, i| {
        try testing.expectEqual(color.ansi256ToRgb(@intCast(i)), entry);
    }
    try testing.expectEqual(Rgb.init(255, 0, 0), ansi256[196]);
    try testing.expectEqual(Rgb.init(8, 8, 8), ansi256[232]);
    try testing.expectEqual(Rgb.init(238, 238, 238), ansi256[255]);
}

test "ansi88 layout" {
    for (ansi16, 0..) |entry, i| try testing.expectEqual(entry, ansi88[i]);
    try testing.expectEqual(Rgb.init(0, 0, 0), ansi88[16]);
    try testing.expectEqual(Rgb.init(255, 255, 255), ansi88[79]);
    try testing.expectEqual(Rgb.init(255, 0, 0), ansi88[16 + 3 * 16]);
    try testing.expectEqual(Rgb.init(0, 255, 0), ansi88[16 + 3 * 4]);
    try testing.expectEqual(Rgb.init(0, 0, 255), ansi88[16 + 3]);
    try testing.expectEqual(Rgb.init(139, 0, 0), ansi88[16 + 16]);
    try testing.expectEqual(@as(u8, 46), ansi88[80].r);
    try testing.expectEqual(@as(u8, 231), ansi88[87].r);
    for (ansi88[80..87], 0..) |entry, i| {
        try testing.expectEqual(entry.r, entry.g);
        try testing.expectEqual(entry.g, entry.b);
        if (i > 0) try testing.expect(entry.r > ansi88[80 + i - 1].r);
    }
}

test "palette names line up" {
    try testing.expectEqualStrings("black", ansi16Names[0]);
    try testing.expectEqualStrings("brightWhite", ansi16Names[15]);
    try testing.expectEqualStrings("red", ansi88Names[1]);
    try testing.expectEqualStrings("cube_3_3_3", ansi88Names[79]);
    try testing.expectEqualStrings("cube_0_0_0", ansi88Names[16]);
    try testing.expectEqualStrings("gray_0", ansi88Names[80]);
    try testing.expectEqualStrings("gray_7", ansi88Names[87]);
}

test "indexed constructors agree with the tables" {
    try testing.expectEqual(ansi256[196], color.ansi256.rgb(5, 0, 0).toRgb());
    try testing.expectEqual(@as(u8, 244), color.ansi256.gray(12).ansi256.index);
    try testing.expectEqual(ansi256[244], color.ansi256.gray(12).toRgb());
    // 88-palette indices resolve against palette.ansi88 on the terminal;
    // Ansi256.toRgb always uses the 256-colour defaults.
    try testing.expectEqual(@as(u8, 73), color.ansi88.rgb(3, 2, 1).ansi256.index);
    try testing.expectEqual(Rgb.init(255, 205, 139), ansi88[73]);
    try testing.expectEqual(@as(u8, 80), color.ansi88.gray(0).ansi256.index);
    try testing.expectEqual(@as(u8, 46), ansi88[80].r);
}

test "ramp fills the whole buffer exactly" {
    var buffer: [11]Rgb = undefined;
    ramp(&buffer, .{ .r = 0, .g = 0, .b = 0 }, .{ .r = 255, .g = 255, .b = 255 });
    try testing.expectEqual(Rgb.init(0, 0, 0), buffer[0]);
    try testing.expectEqual(Rgb.init(255, 255, 255), buffer[10]);
    for (buffer, 0..) |entry, i| {
        const expected: u8 = @intFromFloat(@round(@as(f64, @floatFromInt(i)) / 10.0 * 255.0));
        try testing.expectEqual(expected, entry.r);
        try testing.expectEqual(entry.r, entry.g);
        try testing.expectEqual(entry.g, entry.b);
    }

    var empty: [0]Rgb = .{};
    ramp(&empty, .{ .r = 1, .g = 2, .b = 3 }, .{ .r = 4, .g = 5, .b = 6 });

    var single: [1]Rgb = undefined;
    ramp(&single, .{ .r = 1, .g = 2, .b = 3 }, .{ .r = 4, .g = 5, .b = 6 });
    try testing.expectEqual(Rgb.init(1, 2, 3), single[0]);
}

test "gradient interpolates through every stop" {
    const stops = [3]Rgb{
        .{ .r = 255, .g = 0, .b = 0 },
        .{ .r = 0, .g = 255, .b = 0 },
        .{ .r = 0, .g = 0, .b = 255 },
    };
    var buffer: [11]Rgb = undefined;
    gradient(&buffer, &stops);
    try testing.expectEqual(stops[0], buffer[0]);
    try testing.expectEqual(stops[2], buffer[10]);
    try testing.expectEqual(stops[1], buffer[5]);

    const one = [_]Rgb{.{ .r = 7, .g = 8, .b = 9 }};
    var repeated: [4]Rgb = undefined;
    gradient(&repeated, &one);
    for (repeated) |entry| try testing.expectEqual(one[0], entry);

    var empty: [0]Rgb = .{};
    gradient(&empty, &one);
}

test "hue sweeps the circle" {
    var buffer: [13]Rgb = undefined;
    hue(&buffer);
    try testing.expectEqual(Rgb.init(255, 0, 0), buffer[0]);
    try testing.expectEqual(Rgb.init(255, 0, 0), buffer[12]);
    try testing.expect(buffer[3].g > 200);
    try testing.expect(buffer[6].b > 200);
    try testing.expect(buffer[9].b > 200);

    var empty: [0]Rgb = .{};
    hue(&empty);
}

test "sequential ramps one hue from light to dark" {
    var buffer: [9]Rgb = undefined;
    sequential(&buffer, 210);
    try testing.expect(buffer[0].toHsl().l > 85);
    try testing.expect(buffer[8].toHsl().l < 20);
    for (buffer) |entry| {
        const h: f64 = @floatFromInt(entry.toHsl().h);
        try testing.expectApproxEqAbs(@as(f64, 210), h, 1.0);
    }
    try testing.expect(isMonotonicLuminance(&[_]Color{
        .{ .rgb = buffer[0] },
        .{ .rgb = buffer[4] },
        .{ .rgb = buffer[8] },
    }));
}

test "diverging is symmetric around a light centre" {
    var buffer: [9]Rgb = undefined;
    diverging(&buffer, .{ 0, 220 });
    try testing.expect(buffer[4].toHsl().l > 85);
    try testing.expect(buffer[0].toHsl().l < 30);
    try testing.expect(buffer[8].toHsl().l < 30);
    try testing.expectApproxEqAbs(@as(f64, 0), @as(f64, @floatFromInt(buffer[0].toHsl().h)), 1.0);
    try testing.expectApproxEqAbs(@as(f64, 220), @as(f64, @floatFromInt(buffer[8].toHsl().h)), 1.0);

    var single: [1]Rgb = undefined;
    diverging(&single, .{ 0, 220 });
    try testing.expect(single[0].toHsl().l > 50);
}

test "categorical spreads hues evenly" {
    var buffer: [6]Rgb = undefined;
    categorical(&buffer);
    try testing.expectEqual(@as(u16, 0), buffer[0].toHsl().h);
    try testing.expectEqual(@as(u16, 60), buffer[1].toHsl().h);
    try testing.expectEqual(@as(u16, 180), buffer[3].toHsl().h);

    var empty: [0]Rgb = .{};
    categorical(&empty);
}

test "harmony buffers contain the scheme" {
    const base = color.rgb(255, 0, 0);

    var one: [1]Color = undefined;
    try testing.expectEqual(@as(usize, 1), complementary(&one, base).len);
    try testing.expectEqual(@as(u16, 180), one[0].toHsl().h);

    var three: [3]Color = undefined;
    try testing.expectEqual(@as(usize, 3), analogous(&three, base).len);
    try testing.expectEqual(@as(u16, 30), three[0].toHsl().h);
    try testing.expectEqual(@as(usize, 3), triadic(&three, base).len);
    try testing.expectEqual(@as(u16, 120), three[1].toHsl().h);
    try testing.expectEqual(@as(usize, 3), splitComplementary(&three, base).len);
    try testing.expectEqual(@as(u16, 150), three[1].toHsl().h);

    var four: [4]Color = undefined;
    try testing.expectEqual(@as(usize, 4), tetradic(&four, base).len);
    try testing.expectEqual(@as(u16, 270), four[3].toHsl().h);

    var short: [2]Color = undefined;
    try testing.expectEqual(@as(usize, 2), tetradic(&short, base).len);

    var empty: [0]Color = .{};
    try testing.expectEqual(@as(usize, 0), triadic(&empty, base).len);
}

test "readability grades" {
    const white = color.rgb(255, 255, 255);
    const black = color.rgb(0, 0, 0);
    try testing.expectEqual(Readability.aaa, readability(white, black));
    try testing.expectEqual(Readability.aaa, readability(black, white));
    try testing.expectEqual(Readability.fail, readability(white, white));
    try testing.expectEqual(Readability.fail, readability(color.rgb(255, 0, 0), color.rgb(0, 0, 255)));
}

test "contrast extremes need at least black and white" {
    const colors = [_]Color{ color.rgb(255, 255, 255), color.rgb(0, 0, 0), color.rgb(255, 0, 0) };
    try testing.expectApproxEqAbs(@as(f64, 21), maxContrastRatio(&colors), 0.01);
    try testing.expect(minContrastRatio(&colors) > 1);
    try testing.expect(minContrastRatio(&colors) < 5);
}

test "duplicate detection and closest pair" {
    try testing.expect(hasDuplicates(&[_]Color{ color.rgb(1, 2, 3), color.rgb(1, 2, 3) }));
    try testing.expect(!hasDuplicates(&[_]Color{ color.rgb(1, 2, 3), color.rgb(1, 2, 4) }));
    try testing.expect(!hasDuplicates(&[_]Color{color.rgb(1, 2, 3)}));
    try testing.expect(!hasDuplicates(&[_]Color{}));

    const colors = [_]Color{ color.rgb(255, 0, 0), color.rgb(250, 10, 10), color.rgb(0, 0, 255) };
    const closest = closestPair(&colors);
    try testing.expect(closest < color.rgb(255, 0, 0).deltaE2000(color.rgb(0, 0, 255)));
    try testing.expect(closest > 0);
}

test "monotonic luminance" {
    var dark_to_light: [4]Rgb = undefined;
    ramp(&dark_to_light, Rgb.black, Rgb.white);
    const as_colors = [_]Color{
        .{ .rgb = dark_to_light[0] },
        .{ .rgb = dark_to_light[1] },
        .{ .rgb = dark_to_light[2] },
        .{ .rgb = dark_to_light[3] },
    };
    try testing.expect(isMonotonicLuminance(&as_colors));

    const reversed = [_]Color{ as_colors[3], as_colors[2], as_colors[1], as_colors[0] };
    try testing.expect(isMonotonicLuminance(&reversed));

    const zigzag = [_]Color{ as_colors[0], as_colors[3], as_colors[1], as_colors[2] };
    try testing.expect(!isMonotonicLuminance(&zigzag));
    try testing.expect(isMonotonicLuminance(&[_]Color{}));
    try testing.expect(isMonotonicLuminance(&[_]Color{color.red}));
}

test {
    testing.refAllDecls(@This());
}
