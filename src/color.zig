//! Colour models. `Color` is the one representation the rest of the library
//! works with; the other types are the individual colour spaces.

const std = @import("std");
const testing = std.testing;
const ansi = @import("ansi.zig");
const util = @import("util.zig");

/// The 16 colours every terminal must support.
pub const Ansi4 = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    brightBlack,
    brightRed,
    brightGreen,
    brightYellow,
    brightBlue,
    brightMagenta,
    brightCyan,
    brightWhite,
    /// Restores the terminal's own default colour.
    default,

    /// The 16 real colours, in palette order.
    pub const all = [_]Ansi4{
        .black,       .red,           .green,       .yellow,
        .blue,        .magenta,       .cyan,        .white,
        .brightBlack, .brightRed,     .brightGreen, .brightYellow,
        .brightBlue,  .brightMagenta, .brightCyan,  .brightWhite,
    };

    /// Maps an SGR colour code to `Ansi4`. Accepts foreground (30-37, 90-97,
    /// 39), background (40-47, 100-107, 49) and underline (59) defaults.
    pub fn fromCode(code: u8) ?Ansi4 {
        return switch (code) {
            30, 40 => .black,
            31, 41 => .red,
            32, 42 => .green,
            33, 43 => .yellow,
            34, 44 => .blue,
            35, 45 => .magenta,
            36, 46 => .cyan,
            37, 47 => .white,
            90, 100 => .brightBlack,
            91, 101 => .brightRed,
            92, 102 => .brightGreen,
            93, 103 => .brightYellow,
            94, 104 => .brightBlue,
            95, 105 => .brightMagenta,
            96, 106 => .brightCyan,
            97, 107 => .brightWhite,
            39, 49, 59 => .default,
            else => null,
        };
    }
};

const ansi4_foreground_params = [17][]const u8{
    "30", "31", "32", "33", "34", "35", "36", "37",
    "90", "91", "92", "93", "94", "95", "96", "97",
    "39",
};

const ansi4_background_params = [17][]const u8{
    "40",  "41",  "42",  "43",  "44",  "45",  "46",  "47",
    "100", "101", "102", "103", "104", "105", "106", "107",
    "49",
};

const ansi4_underline_params = [17][]const u8{
    "58;5;0", "58;5;1", "58;5;2",  "58;5;3",  "58;5;4",  "58;5;5",  "58;5;6",  "58;5;7",
    "58;5;8", "58;5;9", "58;5;10", "58;5;11", "58;5;12", "58;5;13", "58;5;14", "58;5;15",
    "59",
};

/// SGR parameters for an ANSI 4-bit colour in `layer`.
pub fn ansi4Params(layer: ansi.Layer, a: Ansi4) []const u8 {
    return switch (layer) {
        .foreground => ansi4_foreground_params[@backingInt(a)],
        .background => ansi4_background_params[@backingInt(a)],
        .underline => ansi4_underline_params[@backingInt(a)],
    };
}

/// sRGB triple, components in `0...255`.
pub const Rgb = struct {
    r: u8,
    g: u8,
    b: u8,

    pub const black: Rgb = .{ .r = 0, .g = 0, .b = 0 };
    pub const white: Rgb = .{ .r = 255, .g = 255, .b = 255 };

    pub fn init(r: u8, g: u8, b: u8) Rgb {
        return .{ .r = r, .g = g, .b = b };
    }

    /// Colour temperature in Kelvin. `kelvin` must be in `1000...40000`.
    pub fn fromKelvin(temperature: u16) Rgb {
        std.debug.assert(temperature >= 1000 and temperature <= 40000);
        const t = @as(f64, @floatFromInt(temperature)) / 100.0;
        var r: f64 = 0;
        var g: f64 = 0;
        var b: f64 = 0;
        if (t <= 66) {
            r = 255;
            g = 99.4708025861 * std.math.log(f64, std.math.e, t) - 161.1195681661;
            b = if (t <= 19) 0 else 138.5177312231 * std.math.log(f64, std.math.e, t - 10) - 305.0447927307;
        } else {
            r = 329.698727446 * std.math.pow(f64, t - 60, -0.1332047592);
            g = 288.1221695283 * std.math.pow(f64, t - 60, -0.0755148492);
            b = 255;
        }
        return .{ .r = util.channel(r), .g = util.channel(g), .b = util.channel(b) };
    }

    /// WCAG 2.x relative luminance, in `0.0...1.0`.
    pub fn luminance(self: Rgb) f64 {
        return 0.2126 * linearize(self.r) + 0.7152 * linearize(self.g) + 0.0722 * linearize(self.b);
    }

    pub fn toHex(self: Rgb) Hex {
        return .{ .value = @as(u24, self.r) << 16 | @as(u24, self.g) << 8 | @as(u24, self.b) };
    }

    /// `#rrggbb` with lower-case digits.
    pub fn toString(self: Rgb) [7]u8 {
        const digits = std.fmt.bytesToHex([3]u8{ self.r, self.g, self.b }, .lower);
        return .{'#'} ++ digits;
    }

    pub fn toHsl(self: Rgb) Hsl {
        return Hsl.fromRgb(self);
    }

    pub fn toHsv(self: Rgb) Hsv {
        return Hsv.fromRgb(self);
    }

    pub fn toCmyk(self: Rgb) Cmyk {
        return Cmyk.fromRgb(self);
    }

    pub fn toXyz(self: Rgb) Xyz {
        return Xyz.fromRgb(self);
    }

    pub fn toLab(self: Rgb) Lab {
        return Lab.fromXyz(self.toXyz());
    }

    pub fn toLch(self: Rgb) Lch {
        return Lch.fromLab(self.toLab());
    }

    pub fn toOklab(self: Rgb) Oklab {
        return Oklab.fromRgb(self);
    }

    pub fn toOklch(self: Rgb) Oklch {
        return Oklch.fromOklab(self.toOklab());
    }
};

fn linearize(value: u8) f64 {
    const c = @as(f64, @floatFromInt(value)) / 255.0;
    return if (c > 0.04045) std.math.pow(f64, (c + 0.055) / 1.055, 2.4) else c / 12.92;
}

fn delinearize(value: f64) f64 {
    return if (value > 0.0031308) 1.055 * std.math.pow(f64, value, 1.0 / 2.4) - 0.055 else 12.92 * value;
}

fn percent(value: f64) u8 {
    return @intFromFloat(std.math.clamp(value, 0, 1) * 100.0);
}

/// Shifts a `0...100` percentage by a fraction and clamps the result.
fn shiftPercent(base: u8, delta: f64) u8 {
    return @intFromFloat(std.math.clamp(@as(f64, @floatFromInt(base)) + delta * 100.0, 0, 100));
}

/// A 24-bit colour stored as `0xRRGGBB`.
pub const Hex = struct {
    value: u24,

    pub const ParseError = error{
        /// Not 3, 4, 6 or 8 hexadecimal digits.
        InvalidHexLength,
        /// Not a hexadecimal digit.
        InvalidHexDigit,
    };

    /// Parses `#RGB`, `#RGBA`, `#RRGGBB` or `#RRGGBBAA`. The `#` is optional
    /// and so is a `0x` prefix; digit case does not matter.
    ///
    /// Alpha digits are validated and then discarded. SGR has no transparency,
    /// so keeping them would misrepresent what the terminal draws.
    pub fn parse(text: []const u8) ParseError!Hex {
        var digits = text;
        if (digits.len > 0 and digits[0] == '#') {
            digits = digits[1..];
        } else if (digits.len > 2 and digits[0] == '0' and (digits[1] == 'x' or digits[1] == 'X')) {
            digits = digits[2..];
        }

        switch (digits.len) {
            3, 4 => {
                var value: u24 = 0;
                for (digits[0..3]) |c| value = value << 8 | @as(u24, try hexDigit(c)) * 17;
                if (digits.len == 4) _ = try hexDigit(digits[3]);
                return .{ .value = value };
            },
            6, 8 => {
                var value: u24 = 0;
                for (digits[0..6]) |c| value = value << 4 | @as(u24, try hexDigit(c));
                if (digits.len == 8) {
                    _ = try hexDigit(digits[6]);
                    _ = try hexDigit(digits[7]);
                }
                return .{ .value = value };
            },
            else => return error.InvalidHexLength,
        }
    }

    /// Parses like `Hex.parse` and also returns the alpha digits as `0...255`.
    /// The alpha is informational only: it never reaches the terminal.
    pub fn parseWithOpacity(text: []const u8) ParseError!struct { hex: Hex, opacity: u8 } {
        const value = try Hex.parse(text);
        var digits = text;
        if (digits.len > 0 and digits[0] == '#') {
            digits = digits[1..];
        } else if (digits.len > 2 and digits[0] == '0' and (digits[1] == 'x' or digits[1] == 'X')) {
            digits = digits[2..];
        }
        const alpha: u8 = switch (digits.len) {
            4 => try hexDigit(digits[3]) * 17,
            8 => try hexDigit(digits[6]) * 16 + try hexDigit(digits[7]),
            else => 255,
        };
        return .{ .hex = value, .opacity = alpha };
    }

    /// The alpha digits of the string, or `255` when it carries none.
    pub fn opacity(text: []const u8) ParseError!u8 {
        return (try Hex.parseWithOpacity(text)).opacity;
    }

    pub fn toRgb(self: Hex) Rgb {
        return .{
            .r = @truncate(self.value >> 16),
            .g = @truncate(self.value >> 8),
            .b = @truncate(self.value),
        };
    }

    /// `#rrggbb` with lower-case digits.
    pub fn toString(self: Hex) [7]u8 {
        return self.toRgb().toString();
    }
};

fn hexDigit(c: u8) Hex.ParseError!u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => error.InvalidHexDigit,
    };
}

/// An indexed colour, addressed with the SGR `38;5;n` form.
///
/// The index space is shared by every indexed terminal: on an 88-colour
/// terminal indices resolve against `palette.ansi88`, on a 256-colour
/// terminal against `palette.ansi256`.
pub const Ansi256 = struct {
    index: u8,

    pub fn init(index: u8) Ansi256 {
        return .{ .index = index };
    }

    /// Resolves the index against the 256-colour palette.
    pub fn toRgb(self: Ansi256) Rgb {
        return ansi256ToRgb(self.index);
    }
};

/// xterm's 256-colour layout: the 16 base colours, a 6x6x6 cube on the levels
/// `0, 95, 135, 175, 215, 255` at `16...231`, and a 24 step grayscale ramp
/// starting at 8 at `232...255`.
pub fn ansi256ToRgb(index: u8) Rgb {
    if (index < 16) return ansi16[index];
    if (index >= 232) return grayRamp(index - 232);
    const offset: u8 = index - 16;
    return .{
        .r = cubeLevel(offset / 36),
        .g = cubeLevel((offset / 6) % 6),
        .b = cubeLevel(offset % 6),
    };
}

fn cubeLevel(step: u8) u8 {
    return if (step == 0) 0 else 55 + step * 40;
}

fn grayRamp(step: u8) Rgb {
    const level: u8 = 8 + step * 10;
    return .{ .r = level, .g = level, .b = level };
}

/// The 16 base colours, VGA/xterm defaults.
pub const ansi16 = [16]Rgb{
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

/// Names of `ansi16`, indexed the same way.
pub const ansi16Names = [16][]const u8{
    "black",       "red",           "green",       "yellow",
    "blue",        "magenta",       "cyan",        "white",
    "brightBlack", "brightRed",     "brightGreen", "brightYellow",
    "brightBlue",  "brightMagenta", "brightCyan",  "brightWhite",
};

/// Hue in degrees with percentage saturation and lightness. Hue wraps at 360.
pub const Hsl = struct {
    h: u16,
    s: u8,
    l: u8,

    pub fn init(h: u16, s: u8, l: u8) Hsl {
        std.debug.assert(s <= 100 and l <= 100);
        return .{ .h = h % 360, .s = s, .l = l };
    }

    pub fn fromRgb(source: Rgb) Hsl {
        const rf = @as(f64, @floatFromInt(source.r)) / 255.0;
        const gf = @as(f64, @floatFromInt(source.g)) / 255.0;
        const bf = @as(f64, @floatFromInt(source.b)) / 255.0;
        const max = @max(rf, @max(gf, bf));
        const min = @min(rf, @min(gf, bf));
        const delta = max - min;
        const l = (max + min) / 2.0;
        if (delta == 0) return .{ .h = 0, .s = 0, .l = percent(l) };
        const s = if (l > 0.5) delta / (2.0 - max - min) else delta / (max + min);
        return .{ .h = @intFromFloat(hueOf(max, rf, gf, bf, delta) * 60.0), .s = percent(s), .l = percent(l) };
    }

    pub fn toRgb(self: Hsl) Rgb {
        const h = @as(f64, @floatFromInt(self.h));
        const s = @as(f64, @floatFromInt(self.s)) / 100.0;
        const l = @as(f64, @floatFromInt(self.l)) / 100.0;
        const chroma = (1.0 - @abs(2.0 * l - 1.0)) * s;
        const x = chroma * (1.0 - @abs(@rem(h / 60.0, 2.0) - 1.0));
        const m = l - chroma / 2.0;
        const triple = hueTriple(h / 60.0, chroma, x);
        return .{
            .r = util.channel((triple[0] + m) * 255.0),
            .g = util.channel((triple[1] + m) * 255.0),
            .b = util.channel((triple[2] + m) * 255.0),
        };
    }
};

/// Hue in degrees, `0...360` for a non-grey colour.
fn hueOf(max: f64, rf: f64, gf: f64, bf: f64, delta: f64) f64 {
    if (delta == 0) return 0;
    var h: f64 = undefined;
    if (max == rf) {
        h = (gf - bf) / delta;
        if (gf < bf) h += 6.0;
    } else if (max == gf) {
        h = (bf - rf) / delta + 2.0;
    } else {
        h = (rf - gf) / delta + 4.0;
    }
    return h;
}

/// (R, G, B) contributions of chroma and X for the 60 degree hue sector
/// containing `sixtieths`.
fn hueTriple(sixtieths: f64, chroma: f64, x: f64) [3]f64 {
    const c = chroma;
    if (sixtieths < 1) return .{ c, x, 0 };
    if (sixtieths < 2) return .{ x, c, 0 };
    if (sixtieths < 3) return .{ 0, c, x };
    if (sixtieths < 4) return .{ 0, x, c };
    if (sixtieths < 5) return .{ x, 0, c };
    return .{ c, 0, x };
}

/// Hue in degrees with percentage saturation and value. Hue wraps at 360.
pub const Hsv = struct {
    h: u16,
    s: u8,
    v: u8,

    pub fn init(h: u16, s: u8, v: u8) Hsv {
        std.debug.assert(s <= 100 and v <= 100);
        return .{ .h = h % 360, .s = s, .v = v };
    }

    pub fn fromRgb(source: Rgb) Hsv {
        const rf = @as(f64, @floatFromInt(source.r)) / 255.0;
        const gf = @as(f64, @floatFromInt(source.g)) / 255.0;
        const bf = @as(f64, @floatFromInt(source.b)) / 255.0;
        const max = @max(rf, @max(gf, bf));
        const min = @min(rf, @min(gf, bf));
        const delta = max - min;
        return .{
            .h = @intFromFloat(hueOf(max, rf, gf, bf, delta) * 60.0),
            .s = percent(if (max == 0) 0 else delta / max),
            .v = percent(max),
        };
    }

    pub fn toRgb(self: Hsv) Rgb {
        const h = @as(f64, @floatFromInt(self.h));
        const s = @as(f64, @floatFromInt(self.s)) / 100.0;
        const v = @as(f64, @floatFromInt(self.v)) / 100.0;
        const chroma = v * s;
        const x = chroma * (1.0 - @abs(@rem(h / 60.0, 2.0) - 1.0));
        const m = v - chroma;
        const triple = hueTriple(h / 60.0, chroma, x);
        return .{
            .r = util.channel((triple[0] + m) * 255.0),
            .g = util.channel((triple[1] + m) * 255.0),
            .b = util.channel((triple[2] + m) * 255.0),
        };
    }
};

/// Percentage cyan, magenta, yellow and key (black).
pub const Cmyk = struct {
    c: u8,
    m: u8,
    y: u8,
    k: u8,

    pub fn init(c: u8, m: u8, y: u8, k: u8) Cmyk {
        std.debug.assert(c <= 100 and m <= 100 and y <= 100 and k <= 100);
        return .{ .c = c, .m = m, .y = y, .k = k };
    }

    pub fn fromRgb(source: Rgb) Cmyk {
        const rf = @as(f64, @floatFromInt(source.r)) / 255.0;
        const gf = @as(f64, @floatFromInt(source.g)) / 255.0;
        const bf = @as(f64, @floatFromInt(source.b)) / 255.0;
        const k = 1.0 - @max(rf, @max(gf, bf));
        if (k == 1.0) return .{ .c = 0, .m = 0, .y = 0, .k = 100 };
        const scale = 1.0 - k;
        return .{
            .c = cmykChannel((1.0 - rf - k) / scale),
            .m = cmykChannel((1.0 - gf - k) / scale),
            .y = cmykChannel((1.0 - bf - k) / scale),
            .k = cmykChannel(k),
        };
    }

    pub fn toRgb(self: Cmyk) Rgb {
        const k = @as(f64, @floatFromInt(self.k)) / 100.0;
        return .{
            .r = cmykToChannel(self.c, k),
            .g = cmykToChannel(self.m, k),
            .b = cmykToChannel(self.y, k),
        };
    }
};

fn cmykChannel(value: f64) u8 {
    return @intFromFloat(std.math.clamp(value, 0, 1) * 100.0);
}

fn cmykToChannel(component: u8, k: f64) u8 {
    const value = 1.0 - @as(f64, @floatFromInt(component)) / 100.0;
    return util.channel(value * (1.0 - k) * 255.0);
}

/// CIE 1931 tristimulus values relative to a D65 white point.
pub const Xyz = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn fromRgb(source: Rgb) Xyz {
        const r = linearize(source.r);
        const g = linearize(source.g);
        const b = linearize(source.b);
        return .{
            .x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375,
            .y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750,
            .z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041,
        };
    }

    pub fn toRgb(self: Xyz) Rgb {
        const r = delinearize(self.x * 3.2404542 + self.y * -1.5371385 + self.z * -0.4985314);
        const g = delinearize(self.x * -0.9692660 + self.y * 1.8760108 + self.z * 0.0415560);
        const b = delinearize(self.x * 0.0556434 + self.y * -0.2040259 + self.z * 1.0572252);
        return .{ .r = util.channel(r * 255.0), .g = util.channel(g * 255.0), .b = util.channel(b * 255.0) };
    }
};

const white_x = 0.95047;
const white_y = 1.00000;
const white_z = 1.08883;
const lab_epsilon = 0.008856;
const lab_kappa = 903.3;

/// CIE L*a*b*, a perceptually uniform space.
pub const Lab = struct {
    l: f64,
    a: f64,
    b: f64,

    pub fn fromXyz(xyz: Xyz) Lab {
        const fx = labForward(xyz.x / white_x);
        const fy = labForward(xyz.y / white_y);
        const fz = labForward(xyz.z / white_z);
        return .{ .l = 116.0 * fy - 16.0, .a = 500.0 * (fx - fy), .b = 200.0 * (fy - fz) };
    }

    pub fn toXyz(self: Lab) Xyz {
        const fy = (self.l + 16.0) / 116.0;
        const fx = self.a / 500.0 + fy;
        const fz = fy - self.b / 200.0;
        return .{ .x = labInverse(fx) * white_x, .y = labInverse(fy) * white_y, .z = labInverse(fz) * white_z };
    }

    /// CIE76 difference. Cheap, but not perceptually uniform.
    pub fn deltaE76(self: Lab, other: Lab) f64 {
        const dl = self.l - other.l;
        const da = self.a - other.a;
        const db = self.b - other.b;
        return @sqrt(dl * dl + da * da + db * db);
    }

    /// CIE94 difference with the graphic-arts weights (`kL = kC = kH = 1`).
    pub fn deltaE94(self: Lab, other: Lab) f64 {
        const dl = self.l - other.l;
        const c1 = std.math.hypot(self.a, self.b);
        const c2 = std.math.hypot(other.a, other.b);
        const dc = c1 - c2;
        const da = self.a - other.a;
        const db = self.b - other.b;
        const dh2 = @max(da * da + db * db - dc * dc, 0);
        const sc = 1 + 0.045 * c1;
        const sh = 1 + 0.015 * c1;
        const tc = dc / sc;
        return @sqrt(dl * dl + tc * tc + dh2 / (sh * sh));
    }

    /// CIEDE2000 difference, the current perceptual standard.
    pub fn deltaE2000(self: Lab, other: Lab) f64 {
        const c1 = std.math.hypot(self.a, self.b);
        const c2 = std.math.hypot(other.a, other.b);
        const c_bar = (c1 + c2) / 2.0;
        const c_bar7 = std.math.pow(f64, c_bar, 7);
        const twenty_five7 = std.math.pow(f64, 25.0, 7);
        const g = 0.5 * (1 - @sqrt(c_bar7 / (c_bar7 + twenty_five7)));

        const a1 = (1 + g) * self.a;
        const a2 = (1 + g) * other.a;
        const cp1 = std.math.hypot(a1, self.b);
        const cp2 = std.math.hypot(a2, other.b);

        const h1 = huePrime(self.b, a1);
        const h2 = huePrime(other.b, a2);

        const dlp = other.l - self.l;
        const dcp = cp2 - cp1;

        var dh: f64 = 0;
        if (cp1 * cp2 != 0) {
            dh = h2 - h1;
            if (dh > 180) {
                dh -= 360;
            } else if (dh < -180) {
                dh += 360;
            }
        }
        const dHp = 2 * @sqrt(cp1 * cp2) * std.math.sin(dh * std.math.pi / 360.0);

        const lp_bar = (self.l + other.l) / 2.0;
        const cp_bar = (cp1 + cp2) / 2.0;

        var hp_bar: f64 = 0;
        if (cp1 * cp2 != 0) {
            const sum = h1 + h2;
            if (@abs(h1 - h2) > 180) {
                hp_bar = if (sum < 360) (sum + 360) / 2 else (sum - 360) / 2;
            } else {
                hp_bar = sum / 2;
            }
        }

        const t = 1 -
            0.17 * std.math.cos((hp_bar - 30) * std.math.pi / 180.0) +
            0.24 * std.math.cos(2 * hp_bar * std.math.pi / 180.0) +
            0.32 * std.math.cos((3 * hp_bar + 6) * std.math.pi / 180.0) -
            0.20 * std.math.cos((4 * hp_bar - 63) * std.math.pi / 180.0);

        const d_theta = 30 * std.math.exp(-std.math.pow(f64, (hp_bar - 275) / 25, 2.0));
        const cp_bar7 = std.math.pow(f64, cp_bar, 7);
        const rc = 2 * @sqrt(cp_bar7 / (cp_bar7 + twenty_five7));
        const lp_term = lp_bar - 50;
        const sl = 1 + 0.015 * lp_term * lp_term / @sqrt(20 + lp_term * lp_term);
        const sc = 1 + 0.045 * cp_bar;
        const sh = 1 + 0.015 * cp_bar * t;
        const rt = -std.math.sin(2 * d_theta * std.math.pi / 180.0) * rc;

        const tl = dlp / sl;
        const tc = dcp / sc;
        const th = dHp / sh;
        return @sqrt(tl * tl + tc * tc + th * th + rt * tc * th);
    }
};

fn huePrime(b: f64, a_prime: f64) f64 {
    if (b == 0 and a_prime == 0) return 0;
    const angle = std.math.atan2(b, a_prime) * 180.0 / std.math.pi;
    return if (angle >= 0) angle else angle + 360.0;
}

fn labForward(t: f64) f64 {
    return if (t > lab_epsilon) std.math.cbrt(t) else (lab_kappa * t + 16.0) / 116.0;
}

fn labInverse(f: f64) f64 {
    const cube = f * f * f;
    return if (cube > lab_epsilon) cube else (116.0 * f - 16.0) / lab_kappa;
}

/// CIE L*C*H: the cylindrical form of L*a*b*. Hue and chroma are explicit.
pub const Lch = struct {
    l: f64,
    /// Chroma, roughly `0...150`.
    c: f64,
    /// Hue angle in degrees, `0...360`.
    h: f64,

    pub fn fromLab(lab: Lab) Lch {
        const c = std.math.hypot(lab.a, lab.b);
        // Below this chroma the hue angle is noise, so report zero.
        if (c < 0.0001) return .{ .l = lab.l, .c = 0, .h = 0 };
        const h = std.math.atan2(lab.b, lab.a) * 180.0 / std.math.pi;
        return .{ .l = lab.l, .c = c, .h = if (h < 0) h + 360.0 else h };
    }

    pub fn toLab(self: Lch) Lab {
        const radians = self.h * std.math.pi / 180.0;
        return .{ .l = self.l, .a = self.c * std.math.cos(radians), .b = self.c * std.math.sin(radians) };
    }
};

/// BjÃ¶rn Ottosson's OKLab, perceptually uniform and designed for sRGB.
pub const Oklab = struct {
    l: f64,
    a: f64,
    b: f64,

    pub fn fromRgb(source: Rgb) Oklab {
        const l = std.math.cbrt(0.4122214708 * linearize(source.r) + 0.5363325363 * linearize(source.g) + 0.0514459929 * linearize(source.b));
        const m = std.math.cbrt(0.2119034982 * linearize(source.r) + 0.6806995451 * linearize(source.g) + 0.1073969566 * linearize(source.b));
        const s = std.math.cbrt(0.0883024619 * linearize(source.r) + 0.2817188376 * linearize(source.g) + 0.6299787005 * linearize(source.b));
        return .{
            .l = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
            .a = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
            .b = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
        };
    }

    pub fn toRgb(self: Oklab) Rgb {
        const l_ = self.l + 0.3963377774 * self.a + 0.2158037573 * self.b;
        const m_ = self.l - 0.1055613458 * self.a - 0.0638541728 * self.b;
        const s_ = self.l - 0.0894841775 * self.a - 1.2914855480 * self.b;
        const l = l_ * l_ * l_;
        const m = m_ * m_ * m_;
        const s = s_ * s_ * s_;
        return .{
            .r = util.channel(delinearize(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s) * 255.0),
            .g = util.channel(delinearize(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s) * 255.0),
            .b = util.channel(delinearize(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s) * 255.0),
        };
    }

    /// Euclidean OKLab distance. Close to CIEDE2000 for a fraction of the cost.
    pub fn distance(self: Oklab, other: Oklab) f64 {
        const dl = self.l - other.l;
        const da = self.a - other.a;
        const db = self.b - other.b;
        return @sqrt(dl * dl + da * da + db * db);
    }
};

/// The cylindrical form of OKLab: lightness, chroma, hue angle.
pub const Oklch = struct {
    l: f64,
    c: f64,
    h: f64,

    pub fn fromOklab(oklab: Oklab) Oklch {
        const c = std.math.hypot(oklab.a, oklab.b);
        // Below this chroma the hue angle is noise, so report zero.
        if (c < 0.0001) return .{ .l = oklab.l, .c = 0, .h = 0 };
        const h = std.math.atan2(oklab.b, oklab.a) * 180.0 / std.math.pi;
        return .{ .l = oklab.l, .c = c, .h = if (h < 0) h + 360.0 else h };
    }

    pub fn toOklab(self: Oklch) Oklab {
        const radians = self.h * std.math.pi / 180.0;
        return .{ .l = self.l, .a = self.c * std.math.cos(radians), .b = self.c * std.math.sin(radians) };
    }
};

/// Which space `Color.mixIn` interpolates in.
pub const Space = enum {
    rgb,
    hsl,
    hsv,
    lab,
    lch,
    oklab,
    oklch,
};

/// How `Color.mixHue` walks around the hue circle.
pub const HuePath = enum {
    /// The shorter of the two arcs.
    shorter,
    /// The longer of the two arcs.
    longer,
    /// Always forward through 0 degrees.
    increasing,
    /// Always backward through 0 degrees.
    decreasing,

    fn delta(self: HuePath, from: f64, to: f64) f64 {
        const raw = @mod(to - from, 360.0);
        return switch (self) {
            .increasing => raw,
            .decreasing => raw - 360.0,
            .shorter => if (raw > 180) raw - 360 else raw,
            .longer => if (raw <= 180) raw + 360 else raw,
        };
    }
};

/// Any colour tint.zig can render or convert.
pub const Color = union(enum) {
    ansi4: Ansi4,
    ansi256: Ansi256,
    rgb: Rgb,
    hex: Hex,
    hsl: Hsl,
    hsv: Hsv,

    pub fn fg(self: Color) ansi.Sequence {
        return self.sequence(.foreground);
    }

    pub fn bg(self: Color) ansi.Sequence {
        return self.sequence(.background);
    }

    pub fn underline(self: Color) ansi.Sequence {
        return self.sequence(.underline);
    }

    pub fn sequence(self: Color, layer: ansi.Layer) ansi.Sequence {
        return switch (self) {
            // The parameter tables hold at most 7 bytes, well within capacity.
            .ansi4 => |a| ansi.literal(ansi4Params(layer, a)) catch unreachable,
            .ansi256 => |a| ansi.indexed(layer, a.index),
            .rgb => |c| ansi.trueColor(layer, c.r, c.g, c.b),
            .hex => |c| {
                const channels = c.toRgb();
                return ansi.trueColor(layer, channels.r, channels.g, channels.b);
            },
            .hsl => |c| {
                const channels = c.toRgb();
                return ansi.trueColor(layer, channels.r, channels.g, channels.b);
            },
            .hsv => |c| {
                const channels = c.toRgb();
                return ansi.trueColor(layer, channels.r, channels.g, channels.b);
            },
        };
    }

    pub fn toRgb(self: Color) Rgb {
        return switch (self) {
            .ansi4 => |a| switch (a) {
                .default => ansi16[0],
                else => ansi16[@backingInt(a)],
            },
            .ansi256 => |a| a.toRgb(),
            .rgb => |c| c,
            .hex => |c| c.toRgb(),
            .hsl => |c| c.toRgb(),
            .hsv => |c| c.toRgb(),
        };
    }

    pub fn toHex(self: Color) Hex {
        return self.toRgb().toHex();
    }

    pub fn toHsl(self: Color) Hsl {
        return self.toRgb().toHsl();
    }

    pub fn toHsv(self: Color) Hsv {
        return self.toRgb().toHsv();
    }

    pub fn toCmyk(self: Color) Cmyk {
        return self.toRgb().toCmyk();
    }

    pub fn toXyz(self: Color) Xyz {
        return self.toRgb().toXyz();
    }

    pub fn toLab(self: Color) Lab {
        return self.toRgb().toLab();
    }

    pub fn toLch(self: Color) Lch {
        return self.toRgb().toLch();
    }

    pub fn toOklab(self: Color) Oklab {
        return self.toRgb().toOklab();
    }

    pub fn toOklch(self: Color) Oklch {
        return self.toRgb().toOklch();
    }

    pub fn luminance(self: Color) f64 {
        return self.toRgb().luminance();
    }

    /// WCAG contrast ratio, in `1.0...21.0`.
    pub fn contrastRatio(self: Color, other: Color) f64 {
        const a = self.luminance();
        const b = other.luminance();
        return (@max(a, b) + 0.05) / (@min(a, b) + 0.05);
    }

    /// CIE76 colour difference.
    pub fn deltaE76(self: Color, other: Color) f64 {
        return self.toLab().deltaE76(other.toLab());
    }

    /// CIE94 colour difference.
    pub fn deltaE94(self: Color, other: Color) f64 {
        return self.toLab().deltaE94(other.toLab());
    }

    /// CIEDE2000 colour difference.
    pub fn deltaE2000(self: Color, other: Color) f64 {
        return self.toLab().deltaE2000(other.toLab());
    }

    /// OKLab difference. A cheap stand-in for CIEDE2000.
    pub fn oklabDistance(self: Color, other: Color) f64 {
        return self.toOklab().distance(other.toOklab());
    }

    pub fn isLight(self: Color) bool {
        return self.luminance() > 0.5;
    }

    pub fn isDark(self: Color) bool {
        return !self.isLight();
    }

    /// The 256-palette index closest to this colour, by OKLab distance.
    pub fn nearestAnsi256(self: Color) Ansi256 {
        const target = self.toOklab();
        var best: Ansi256 = .init(0);
        var best_distance = std.math.floatMax(f64);
        for (0..256) |i| {
            const index: u8 = @intCast(i);
            const distance = target.distance(ansi256ToRgb(index).toOklab());
            if (distance < best_distance) {
                best_distance = distance;
                best = .init(index);
            }
        }
        return best;
    }

    /// The base colour closest to this colour, by OKLab distance.
    pub fn nearestAnsi16(self: Color) Ansi4 {
        const target = self.toOklab();
        var best: Ansi4 = .black;
        var best_distance = std.math.floatMax(f64);
        for (Ansi4.all) |a| {
            const distance = target.distance(ansi16[@backingInt(a)].toOklab());
            if (distance < best_distance) {
                best_distance = distance;
                best = a;
            }
        }
        return best;
    }

    /// The closest representation the terminal can display. Deterministic and
    /// side-effect free: the caller states the capability.
    pub fn downgrade(self: Color, capability: ansi.Capability) Color {
        return switch (capability) {
            .trueColor => self,
            .ansi256 => .{ .ansi256 = self.nearestAnsi256() },
            .ansi16 => .{ .ansi4 = self.nearestAnsi16() },
            .none => .{ .ansi4 = .default },
        };
    }

    pub fn lighten(self: Color, amount: f64) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, current.s, shiftPercent(current.l, amount)));
    }

    pub fn darken(self: Color, amount: f64) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, current.s, shiftPercent(current.l, -amount)));
    }

    pub fn saturate(self: Color, amount: f64) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, shiftPercent(current.s, amount), current.l));
    }

    pub fn desaturate(self: Color, amount: f64) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, shiftPercent(current.s, -amount), current.l));
    }

    /// Sets HSL lightness to an absolute percentage.
    pub fn withLightness(self: Color, lightness: u8) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, current.s, lightness));
    }

    /// Sets HSL saturation to an absolute percentage.
    pub fn withSaturation(self: Color, saturation: u8) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h, saturation, current.l));
    }

    /// Per-channel inversion.
    pub fn invert(self: Color) Color {
        const c = self.toRgb();
        return fromRgb(.init(255 - c.r, 255 - c.g, 255 - c.b));
    }

    /// BT.601 weighted grayscale.
    pub fn grayscale(self: Color) Color {
        const c = self.toRgb();
        const level: u8 = @intCast((@as(u16, c.r) * 77 + @as(u16, c.g) * 150 + @as(u16, c.b) * 29) >> 8);
        return fromRgb(.init(level, level, level));
    }

    /// Grayscale using relative luminance.
    pub fn grayscaleLuminance(self: Color) Color {
        const level = util.channel(self.luminance() * 255.0);
        return fromRgb(.init(level, level, level));
    }

    /// Blends towards `other`, in sRGB. `ratio` is clamped to `0.0...1.0`.
    pub fn mix(self: Color, other: Color, ratio: f64) Color {
        return self.mixIn(other, ratio, .rgb);
    }

    /// Blends towards `other` in the given space.
    pub fn mixIn(self: Color, other: Color, ratio: f64, space: Space) Color {
        const t = std.math.clamp(ratio, 0.0, 1.0);
        const a = self.toRgb();
        const b = other.toRgb();
        return switch (space) {
            .rgb => fromRgb(.init(
                util.mixInt(a.r, b.r, t),
                util.mixInt(a.g, b.g, t),
                util.mixInt(a.b, b.b, t),
            )),
            .hsl => {
                const x = a.toHsl();
                const y = b.toHsl();
                return fromHsl(Hsl.init(
                    @intFromFloat(util.mixFloat(x.h, y.h, t)),
                    @intFromFloat(util.mixFloat(x.s, y.s, t)),
                    @intFromFloat(util.mixFloat(x.l, y.l, t)),
                ));
            },
            .hsv => {
                const x = a.toHsv();
                const y = b.toHsv();
                return fromHsv(Hsv.init(
                    @intFromFloat(util.mixFloat(x.h, y.h, t)),
                    @intFromFloat(util.mixFloat(x.s, y.s, t)),
                    @intFromFloat(util.mixFloat(x.v, y.v, t)),
                ));
            },
            .lab => {
                const x = a.toLab();
                const y = b.toLab();
                return fromLab(.{
                    .l = util.mixFloat(x.l, y.l, t),
                    .a = util.mixFloat(x.a, y.a, t),
                    .b = util.mixFloat(x.b, y.b, t),
                });
            },
            .lch => {
                const x = a.toLch();
                const y = b.toLch();
                return fromLch(.{
                    .l = util.mixFloat(x.l, y.l, t),
                    .c = util.mixFloat(x.c, y.c, t),
                    .h = util.wrapHue(x.h + HuePath.shorter.delta(x.h, y.h) * t),
                });
            },
            .oklab => {
                const x = a.toOklab();
                const y = b.toOklab();
                return fromOklab(.{
                    .l = util.mixFloat(x.l, y.l, t),
                    .a = util.mixFloat(x.a, y.a, t),
                    .b = util.mixFloat(x.b, y.b, t),
                });
            },
            .oklch => {
                const x = a.toOklch();
                const y = b.toOklch();
                return fromOklch(.{
                    .l = util.mixFloat(x.l, y.l, t),
                    .c = util.mixFloat(x.c, y.c, t),
                    .h = util.wrapHue(x.h + HuePath.shorter.delta(x.h, y.h) * t),
                });
            },
        };
    }

    /// Blends towards `other` walking the hue circle along `path`, in OKLCH.
    pub fn mixHue(self: Color, other: Color, ratio: f64, path: HuePath) Color {
        const t = std.math.clamp(ratio, 0.0, 1.0);
        const x = self.toOklch();
        const y = other.toOklch();
        return fromOklch(.{
            .l = util.mixFloat(x.l, y.l, t),
            .c = util.mixFloat(x.c, y.c, t),
            .h = util.wrapHue(x.h + path.delta(x.h, y.h) * t),
        });
    }

    /// Fades towards mid grey. `1.0` leaves the colour untouched.
    pub fn fade(self: Color, amount: f64) Color {
        const t = std.math.clamp(amount, 0.0, 1.0);
        return self.mixIn(gray, 1.0 - t, .oklab);
    }

    /// Rotates the hue forward by `degrees`.
    pub fn rotate(self: Color, degrees: u16) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(current.h + degrees % 360, current.s, current.l));
    }

    /// Rotates the hue by a signed number of degrees.
    pub fn adjustHue(self: Color, degrees: i32) Color {
        const current = self.toHsl();
        return fromHsl(Hsl.init(@intCast(@mod(@as(i32, current.h) + degrees, 360)), current.s, current.l));
    }

    /// The colour opposite on the wheel.
    pub fn complementary(self: Color) Color {
        return self.rotate(180);
    }

    /// The two neighbours 30 degrees to either side.
    pub fn analogous(self: Color) [2]Color {
        return .{ self.rotate(30), self.rotate(330) };
    }

    /// Two colours evenly spaced 120 degrees apart.
    pub fn triadic(self: Color) [2]Color {
        return .{ self.rotate(120), self.rotate(240) };
    }

    /// The two neighbours of the complement.
    pub fn splitComplementary(self: Color) [2]Color {
        return .{ self.rotate(150), self.rotate(210) };
    }

    /// Three colours evenly spaced 90 degrees apart.
    pub fn tetradic(self: Color) [3]Color {
        return .{ self.rotate(90), self.rotate(180), self.rotate(270) };
    }

    /// Fills `out` with a lightness ramp at this colour's hue and saturation,
    /// from white down to black. A single slot holds this colour itself.
    pub fn monochromatic(self: Color, out: []Color) void {
        if (out.len == 0) return;
        if (out.len == 1) {
            out[0] = self;
            return;
        }
        const current = self.toHsl();
        const divisor: f64 = @floatFromInt(out.len - 1);
        for (out, 0..) |*slot, i| {
            const l: u8 = @intFromFloat(100.0 - @as(f64, @floatFromInt(i)) / divisor * 100.0);
            slot.* = fromHsl(Hsl.init(current.h, current.s, l));
        }
    }
};

pub fn fromRgb(c: Rgb) Color {
    return .{ .rgb = c };
}

pub fn fromHex(c: Hex) Color {
    return .{ .hex = c };
}

pub fn fromHsl(c: Hsl) Color {
    return .{ .hsl = c };
}

pub fn fromHsv(c: Hsv) Color {
    return .{ .hsv = c };
}

pub fn fromLab(lab: Lab) Color {
    return .{ .rgb = lab.toXyz().toRgb() };
}

pub fn fromLch(lch: Lch) Color {
    return fromLab(lch.toLab());
}

pub fn fromOklab(c: Oklab) Color {
    return .{ .rgb = c.toRgb() };
}

pub fn fromOklch(c: Oklch) Color {
    return fromOklab(c.toOklab());
}

/// A 24-bit colour.
pub fn rgb(r: u8, g: u8, b: u8) Color {
    return .{ .rgb = Rgb.init(r, g, b) };
}

/// A colour from a `0xRRGGBB` integer.
pub fn hex(value: u24) Color {
    return .{ .hex = .{ .value = value } };
}

/// A colour from HSL. `s` and `l` must be in `0...100`; hue wraps at 360.
pub fn hsl(h: u16, s: u8, l: u8) Color {
    return .{ .hsl = Hsl.init(h, s, l) };
}

/// A colour from HSV. `s` and `v` must be in `0...100`; hue wraps at 360.
pub fn hsv(h: u16, s: u8, v: u8) Color {
    return .{ .hsv = Hsv.init(h, s, v) };
}

/// A colour from percentage cyan, magenta, yellow and key.
pub fn cmyk(c: u8, m: u8, y: u8, k: u8) Color {
    return .{ .rgb = Cmyk.init(c, m, y, k).toRgb() };
}

/// A colour from a colour temperature in Kelvin, `1000...40000`.
pub fn kelvin(temperature: u16) Color {
    return .{ .rgb = Rgb.fromKelvin(temperature) };
}

/// The 16 base colours as values. `ansi4.red` is the colour, `Ansi4` the type.
pub const ansi4 = struct {
    pub const black: Color = .{ .ansi4 = .black };
    pub const red: Color = .{ .ansi4 = .red };
    pub const green: Color = .{ .ansi4 = .green };
    pub const yellow: Color = .{ .ansi4 = .yellow };
    pub const blue: Color = .{ .ansi4 = .blue };
    pub const magenta: Color = .{ .ansi4 = .magenta };
    pub const cyan: Color = .{ .ansi4 = .cyan };
    pub const white: Color = .{ .ansi4 = .white };
    pub const brightBlack: Color = .{ .ansi4 = .brightBlack };
    pub const brightRed: Color = .{ .ansi4 = .brightRed };
    pub const brightGreen: Color = .{ .ansi4 = .brightGreen };
    pub const brightYellow: Color = .{ .ansi4 = .brightYellow };
    pub const brightBlue: Color = .{ .ansi4 = .brightBlue };
    pub const brightMagenta: Color = .{ .ansi4 = .brightMagenta };
    pub const brightCyan: Color = .{ .ansi4 = .brightCyan };
    pub const brightWhite: Color = .{ .ansi4 = .brightWhite };
    pub const default: Color = .{ .ansi4 = .default };
};

/// Indexed colours of the 256-colour palette.
pub const ansi256 = struct {
    /// An arbitrary index, `0...255`.
    pub fn index(i: u8) Color {
        return .{ .ansi256 = Ansi256.init(i) };
    }

    /// The 6x6x6 cube. Each coordinate must be in `0...5`.
    pub fn rgb(r: u8, g: u8, b: u8) Color {
        std.debug.assert(r <= 5 and g <= 5 and b <= 5);
        return .{ .ansi256 = .{ .index = 16 + 36 * r + 6 * g + b } };
    }

    /// The grayscale ramp. `level` must be in `0...23`.
    pub fn gray(level: u8) Color {
        std.debug.assert(level <= 23);
        return .{ .ansi256 = .{ .index = 232 + level } };
    }
};

/// Indexed colours of the 88-colour palette. The emitted indices resolve
/// against `palette.ansi88` on an 88-colour terminal; `toRgb` still uses the
/// 256-colour defaults, so read RGB previews from `palette.ansi88`.
pub const ansi88 = struct {
    /// The 4x4x4 cube. Each coordinate must be in `0...3`.
    pub fn rgb(r: u8, g: u8, b: u8) Color {
        std.debug.assert(r <= 3 and g <= 3 and b <= 3);
        return .{ .ansi256 = .{ .index = 16 + 16 * r + 4 * g + b } };
    }

    /// The grayscale ramp. `level` must be in `0...7`.
    pub fn gray(level: u8) Color {
        std.debug.assert(level <= 7);
        return .{ .ansi256 = .{ .index = 80 + level } };
    }
};

/// Looks a colour up by hexadecimal string or CSS/X11 name, e.g. for command
/// line flags. Matching ignores case and underscores, so `parse` accepts
/// `rebeccapurple`, `rebecca_purple` and `rebeccaPurple` alike. The
/// compile-time `color.<name>` constants are the faster path.
pub fn parse(text: []const u8) ?Color {
    inline for (names) |name| {
        if (std.mem.eql(u8, text, name) or matchesLoose(text, name)) {
            return @field(@This(), snakeToCamel(name));
        }
    }
    if (Hex.parse(text)) |value| return .{ .hex = value } else |_| {}
    return null;
}

/// Case- and underscore-insensitive comparison against a snake_case name.
/// Leading and trailing underscores are rejected; internal ones are ignored.
fn matchesLoose(text: []const u8, snake: []const u8) bool {
    if (text.len == 0 or text.len > 64) return false;
    if (text[0] == '_' or text[text.len - 1] == '_') return false;
    var normalized: [64]u8 = undefined;
    var len: usize = 0;
    for (text) |c| {
        if (c == '_') continue;
        normalized[len] = std.ascii.toLower(c);
        len += 1;
    }
    if (len == 0) return false;
    var j: usize = 0;
    for (snake) |c| {
        if (c == '_') continue;
        if (j >= len or normalized[j] != c) return false;
        j += 1;
    }
    return j == len;
}

/// Every CSS/X11 name tint.zig knows, sorted. String literals are written out
/// because struct reflection strings do not survive into the binary.
pub const names: [148][]const u8 = .{
    "alice_blue",        "antique_white",       "aqua",                   "aquamarine",
    "azure",             "beige",               "bisque",                 "black",
    "blanched_almond",   "blue",                "blue_violet",            "brown",
    "burly_wood",        "cadet_blue",          "chartreuse",             "chocolate",
    "coral",             "cornflower_blue",     "cornsilk",               "crimson",
    "cyan",              "dark_blue",           "dark_cyan",              "dark_goldenrod",
    "dark_gray",         "dark_green",          "dark_grey",              "dark_khaki",
    "dark_magenta",      "dark_olive_green",    "dark_orange",            "dark_orchid",
    "dark_red",          "dark_salmon",         "dark_sea_green",         "dark_slate_blue",
    "dark_slate_gray",   "dark_slate_grey",     "dark_turquoise",         "dark_violet",
    "deep_pink",         "deep_sky_blue",       "dim_gray",               "dim_grey",
    "dodger_blue",       "firebrick",           "floral_white",           "forest_green",
    "fuchsia",           "gainsboro",           "ghost_white",            "gold",
    "goldenrod",         "gray",                "green",                  "green_yellow",
    "grey",              "honeydew",            "hot_pink",               "indian_red",
    "indigo",            "ivory",               "khaki",                  "lavender",
    "lavender_blush",    "lawn_green",          "lemon_chiffon",          "light_blue",
    "light_coral",       "light_cyan",          "light_goldenrod_yellow", "light_gray",
    "light_green",       "light_grey",          "light_pink",             "light_salmon",
    "light_sea_green",   "light_sky_blue",      "light_slate_gray",       "light_slate_grey",
    "light_steel_blue",  "light_yellow",        "lime",                   "lime_green",
    "linen",             "magenta",             "maroon",                 "medium_aquamarine",
    "medium_blue",       "medium_orchid",       "medium_purple",          "medium_sea_green",
    "medium_slate_blue", "medium_spring_green", "medium_turquoise",       "medium_violet_red",
    "midnight_blue",     "mint_cream",          "misty_rose",             "moccasin",
    "navajo_white",      "navy",                "old_lace",               "olive",
    "olive_drab",        "orange",              "orange_red",             "orchid",
    "pale_goldenrod",    "pale_green",          "pale_turquoise",         "pale_violet_red",
    "papaya_whip",       "peach_puff",          "peru",                   "pink",
    "plum",              "powder_blue",         "purple",                 "rebecca_purple",
    "red",               "rosy_brown",          "royal_blue",             "saddle_brown",
    "salmon",            "sandy_brown",         "sea_green",              "seashell",
    "sienna",            "silver",              "sky_blue",               "slate_blue",
    "slate_gray",        "slate_grey",          "snow",                   "spring_green",
    "steel_blue",        "tan",                 "teal",                   "thistle",
    "tomato",            "turquoise",           "violet",                 "wheat",
    "white",             "white_smoke",         "yellow",                 "yellow_green",
};

fn snakeCamelLen(comptime snake: []const u8) usize {
    @setEvalBranchQuota(10000);
    var len = snake.len;
    for (snake) |c| {
        if (c == '_') len -= 1;
    }
    return len;
}

fn snakeToCamel(comptime snake: []const u8) *const [snakeCamelLen(snake)]u8 {
    @setEvalBranchQuota(10000);
    var out: [snakeCamelLen(snake)]u8 = undefined;
    var j: usize = 0;
    var i: usize = 0;
    while (i < snake.len) : (i += 1) {
        if (snake[i] == '_') {
            i += 1;
            out[j] = std.ascii.toUpper(snake[i]);
        } else {
            out[j] = snake[i];
        }
        j += 1;
    }
    const result = out;
    return &result;
}

fn namesEqual(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    for (a, b) |x, y| {
        if (x != y) return false;
    }
    return true;
}

fn namesLess(a: []const u8, b: []const u8) bool {
    const n = @min(a.len, b.len);
    for (a[0..n], b[0..n]) |x, y| {
        if (x != y) return x < y;
    }
    return a.len < b.len;
}

comptime {
    // The name list must be sorted with no duplicates.
    for (names[0 .. names.len - 1], names[1..]) |a, b| {
        if (!namesLess(a, b)) @compileError("names must be sorted and unique");
    }
    // Every listed name must resolve to an alias holding the struct value.
    // (Struct declaration names cannot be enumerated in Zig 0.17, and
    // @hasDecl only sees public declarations, so @field does the checking.)
    for (names) |snake| {
        const camel = snakeToCamel(snake);
        if (!std.meta.eql(@field(@This(), camel).toRgb(), @field(StructOfNames, snake))) {
            @compileError("color alias " ++ camel ++ " does not match " ++ snake);
        }
    }
}

const StructOfNames = struct {
    const alice_blue: Rgb = .{ .r = 240, .g = 248, .b = 255 };
    const antique_white: Rgb = .{ .r = 250, .g = 235, .b = 215 };
    const aqua: Rgb = .{ .r = 0, .g = 255, .b = 255 };
    const aquamarine: Rgb = .{ .r = 127, .g = 255, .b = 212 };
    const azure: Rgb = .{ .r = 240, .g = 255, .b = 255 };
    const beige: Rgb = .{ .r = 245, .g = 245, .b = 220 };
    const bisque: Rgb = .{ .r = 255, .g = 228, .b = 196 };
    const black: Rgb = .{ .r = 0, .g = 0, .b = 0 };
    const blanched_almond: Rgb = .{ .r = 255, .g = 235, .b = 205 };
    const blue: Rgb = .{ .r = 0, .g = 0, .b = 255 };
    const blue_violet: Rgb = .{ .r = 138, .g = 43, .b = 226 };
    const brown: Rgb = .{ .r = 165, .g = 42, .b = 42 };
    const burly_wood: Rgb = .{ .r = 222, .g = 184, .b = 135 };
    const cadet_blue: Rgb = .{ .r = 95, .g = 158, .b = 160 };
    const chartreuse: Rgb = .{ .r = 127, .g = 255, .b = 0 };
    const chocolate: Rgb = .{ .r = 210, .g = 105, .b = 30 };
    const coral: Rgb = .{ .r = 255, .g = 127, .b = 80 };
    const cornflower_blue: Rgb = .{ .r = 100, .g = 149, .b = 237 };
    const cornsilk: Rgb = .{ .r = 255, .g = 248, .b = 220 };
    const crimson: Rgb = .{ .r = 220, .g = 20, .b = 60 };
    const cyan: Rgb = .{ .r = 0, .g = 255, .b = 255 };
    const dark_blue: Rgb = .{ .r = 0, .g = 0, .b = 139 };
    const dark_cyan: Rgb = .{ .r = 0, .g = 139, .b = 139 };
    const dark_goldenrod: Rgb = .{ .r = 184, .g = 134, .b = 11 };
    const dark_gray: Rgb = .{ .r = 169, .g = 169, .b = 169 };
    const dark_green: Rgb = .{ .r = 0, .g = 100, .b = 0 };
    const dark_grey: Rgb = .{ .r = 169, .g = 169, .b = 169 };
    const dark_khaki: Rgb = .{ .r = 189, .g = 183, .b = 107 };
    const dark_magenta: Rgb = .{ .r = 139, .g = 0, .b = 139 };
    const dark_olive_green: Rgb = .{ .r = 85, .g = 107, .b = 47 };
    const dark_orange: Rgb = .{ .r = 255, .g = 140, .b = 0 };
    const dark_orchid: Rgb = .{ .r = 153, .g = 50, .b = 204 };
    const dark_red: Rgb = .{ .r = 139, .g = 0, .b = 0 };
    const dark_salmon: Rgb = .{ .r = 233, .g = 150, .b = 122 };
    const dark_sea_green: Rgb = .{ .r = 143, .g = 188, .b = 143 };
    const dark_slate_blue: Rgb = .{ .r = 72, .g = 61, .b = 139 };
    const dark_slate_gray: Rgb = .{ .r = 47, .g = 79, .b = 79 };
    const dark_slate_grey: Rgb = .{ .r = 47, .g = 79, .b = 79 };
    const dark_turquoise: Rgb = .{ .r = 0, .g = 206, .b = 209 };
    const dark_violet: Rgb = .{ .r = 148, .g = 0, .b = 211 };
    const deep_pink: Rgb = .{ .r = 255, .g = 20, .b = 147 };
    const deep_sky_blue: Rgb = .{ .r = 0, .g = 191, .b = 255 };
    const dim_gray: Rgb = .{ .r = 105, .g = 105, .b = 105 };
    const dim_grey: Rgb = .{ .r = 105, .g = 105, .b = 105 };
    const dodger_blue: Rgb = .{ .r = 30, .g = 144, .b = 255 };
    const firebrick: Rgb = .{ .r = 178, .g = 34, .b = 34 };
    const floral_white: Rgb = .{ .r = 255, .g = 250, .b = 240 };
    const forest_green: Rgb = .{ .r = 34, .g = 139, .b = 34 };
    const fuchsia: Rgb = .{ .r = 255, .g = 0, .b = 255 };
    const gainsboro: Rgb = .{ .r = 220, .g = 220, .b = 220 };
    const ghost_white: Rgb = .{ .r = 248, .g = 248, .b = 255 };
    const gold: Rgb = .{ .r = 255, .g = 215, .b = 0 };
    const goldenrod: Rgb = .{ .r = 218, .g = 165, .b = 32 };
    const gray: Rgb = .{ .r = 128, .g = 128, .b = 128 };
    const green: Rgb = .{ .r = 0, .g = 128, .b = 0 };
    const green_yellow: Rgb = .{ .r = 173, .g = 255, .b = 47 };
    const grey: Rgb = .{ .r = 128, .g = 128, .b = 128 };
    const honeydew: Rgb = .{ .r = 240, .g = 255, .b = 240 };
    const hot_pink: Rgb = .{ .r = 255, .g = 105, .b = 180 };
    const indian_red: Rgb = .{ .r = 205, .g = 92, .b = 92 };
    const indigo: Rgb = .{ .r = 75, .g = 0, .b = 130 };
    const ivory: Rgb = .{ .r = 255, .g = 255, .b = 240 };
    const khaki: Rgb = .{ .r = 240, .g = 230, .b = 140 };
    const lavender: Rgb = .{ .r = 230, .g = 230, .b = 250 };
    const lavender_blush: Rgb = .{ .r = 255, .g = 240, .b = 245 };
    const lawn_green: Rgb = .{ .r = 124, .g = 252, .b = 0 };
    const lemon_chiffon: Rgb = .{ .r = 255, .g = 250, .b = 205 };
    const light_blue: Rgb = .{ .r = 173, .g = 216, .b = 230 };
    const light_coral: Rgb = .{ .r = 240, .g = 128, .b = 128 };
    const light_cyan: Rgb = .{ .r = 224, .g = 255, .b = 255 };
    const light_goldenrod_yellow: Rgb = .{ .r = 250, .g = 250, .b = 210 };
    const light_gray: Rgb = .{ .r = 211, .g = 211, .b = 211 };
    const light_green: Rgb = .{ .r = 144, .g = 238, .b = 144 };
    const light_grey: Rgb = .{ .r = 211, .g = 211, .b = 211 };
    const light_pink: Rgb = .{ .r = 255, .g = 182, .b = 193 };
    const light_salmon: Rgb = .{ .r = 255, .g = 160, .b = 122 };
    const light_sea_green: Rgb = .{ .r = 32, .g = 178, .b = 170 };
    const light_sky_blue: Rgb = .{ .r = 135, .g = 206, .b = 250 };
    const light_slate_gray: Rgb = .{ .r = 119, .g = 136, .b = 153 };
    const light_slate_grey: Rgb = .{ .r = 119, .g = 136, .b = 153 };
    const light_steel_blue: Rgb = .{ .r = 176, .g = 196, .b = 222 };
    const light_yellow: Rgb = .{ .r = 255, .g = 255, .b = 224 };
    const lime: Rgb = .{ .r = 0, .g = 255, .b = 0 };
    const lime_green: Rgb = .{ .r = 50, .g = 205, .b = 50 };
    const linen: Rgb = .{ .r = 250, .g = 240, .b = 230 };
    const magenta: Rgb = .{ .r = 255, .g = 0, .b = 255 };
    const maroon: Rgb = .{ .r = 128, .g = 0, .b = 0 };
    const medium_aquamarine: Rgb = .{ .r = 102, .g = 205, .b = 170 };
    const medium_blue: Rgb = .{ .r = 0, .g = 0, .b = 205 };
    const medium_orchid: Rgb = .{ .r = 186, .g = 85, .b = 211 };
    const medium_purple: Rgb = .{ .r = 147, .g = 112, .b = 219 };
    const medium_sea_green: Rgb = .{ .r = 60, .g = 179, .b = 113 };
    const medium_slate_blue: Rgb = .{ .r = 123, .g = 104, .b = 238 };
    const medium_spring_green: Rgb = .{ .r = 0, .g = 250, .b = 154 };
    const medium_turquoise: Rgb = .{ .r = 72, .g = 209, .b = 204 };
    const medium_violet_red: Rgb = .{ .r = 199, .g = 21, .b = 133 };
    const midnight_blue: Rgb = .{ .r = 25, .g = 25, .b = 112 };
    const mint_cream: Rgb = .{ .r = 245, .g = 255, .b = 250 };
    const misty_rose: Rgb = .{ .r = 255, .g = 228, .b = 225 };
    const moccasin: Rgb = .{ .r = 255, .g = 228, .b = 181 };
    const navajo_white: Rgb = .{ .r = 255, .g = 222, .b = 173 };
    const navy: Rgb = .{ .r = 0, .g = 0, .b = 128 };
    const old_lace: Rgb = .{ .r = 253, .g = 245, .b = 230 };
    const olive: Rgb = .{ .r = 128, .g = 128, .b = 0 };
    const olive_drab: Rgb = .{ .r = 107, .g = 142, .b = 35 };
    const orange: Rgb = .{ .r = 255, .g = 165, .b = 0 };
    const orange_red: Rgb = .{ .r = 255, .g = 69, .b = 0 };
    const orchid: Rgb = .{ .r = 218, .g = 112, .b = 214 };
    const pale_goldenrod: Rgb = .{ .r = 238, .g = 232, .b = 170 };
    const pale_green: Rgb = .{ .r = 152, .g = 251, .b = 152 };
    const pale_turquoise: Rgb = .{ .r = 175, .g = 238, .b = 238 };
    const pale_violet_red: Rgb = .{ .r = 219, .g = 112, .b = 147 };
    const papaya_whip: Rgb = .{ .r = 255, .g = 239, .b = 213 };
    const peach_puff: Rgb = .{ .r = 255, .g = 218, .b = 185 };
    const peru: Rgb = .{ .r = 205, .g = 133, .b = 63 };
    const pink: Rgb = .{ .r = 255, .g = 192, .b = 203 };
    const plum: Rgb = .{ .r = 221, .g = 160, .b = 221 };
    const powder_blue: Rgb = .{ .r = 176, .g = 224, .b = 230 };
    const purple: Rgb = .{ .r = 128, .g = 0, .b = 128 };
    const rebecca_purple: Rgb = .{ .r = 102, .g = 51, .b = 153 };
    const red: Rgb = .{ .r = 255, .g = 0, .b = 0 };
    const rosy_brown: Rgb = .{ .r = 188, .g = 143, .b = 143 };
    const royal_blue: Rgb = .{ .r = 65, .g = 105, .b = 225 };
    const saddle_brown: Rgb = .{ .r = 139, .g = 69, .b = 19 };
    const salmon: Rgb = .{ .r = 250, .g = 128, .b = 114 };
    const sandy_brown: Rgb = .{ .r = 244, .g = 164, .b = 96 };
    const sea_green: Rgb = .{ .r = 46, .g = 139, .b = 87 };
    const seashell: Rgb = .{ .r = 255, .g = 245, .b = 238 };
    const sienna: Rgb = .{ .r = 160, .g = 82, .b = 45 };
    const silver: Rgb = .{ .r = 192, .g = 192, .b = 192 };
    const sky_blue: Rgb = .{ .r = 135, .g = 206, .b = 235 };
    const slate_blue: Rgb = .{ .r = 106, .g = 90, .b = 205 };
    const slate_gray: Rgb = .{ .r = 112, .g = 128, .b = 144 };
    const slate_grey: Rgb = .{ .r = 112, .g = 128, .b = 144 };
    const snow: Rgb = .{ .r = 255, .g = 250, .b = 250 };
    const spring_green: Rgb = .{ .r = 0, .g = 255, .b = 127 };
    const steel_blue: Rgb = .{ .r = 70, .g = 130, .b = 180 };
    const tan: Rgb = .{ .r = 210, .g = 180, .b = 140 };
    const teal: Rgb = .{ .r = 0, .g = 128, .b = 128 };
    const thistle: Rgb = .{ .r = 216, .g = 191, .b = 216 };
    const tomato: Rgb = .{ .r = 255, .g = 99, .b = 71 };
    const turquoise: Rgb = .{ .r = 64, .g = 224, .b = 208 };
    const violet: Rgb = .{ .r = 238, .g = 130, .b = 238 };
    const wheat: Rgb = .{ .r = 245, .g = 222, .b = 179 };
    const white: Rgb = .{ .r = 255, .g = 255, .b = 255 };
    const white_smoke: Rgb = .{ .r = 245, .g = 245, .b = 245 };
    const yellow: Rgb = .{ .r = 255, .g = 255, .b = 0 };
    const yellow_green: Rgb = .{ .r = 154, .g = 205, .b = 50 };
};

/// The 148 CSS/X11 named colours, including the seven `grey` spellings the
/// CSS standard defines as aliases of their `gray` counterparts.
pub const aliceBlue: Color = .{ .rgb = StructOfNames.alice_blue };
pub const antiqueWhite: Color = .{ .rgb = StructOfNames.antique_white };
pub const aqua: Color = .{ .rgb = StructOfNames.aqua };
pub const aquamarine: Color = .{ .rgb = StructOfNames.aquamarine };
pub const azure: Color = .{ .rgb = StructOfNames.azure };
pub const beige: Color = .{ .rgb = StructOfNames.beige };
pub const bisque: Color = .{ .rgb = StructOfNames.bisque };
pub const black: Color = .{ .rgb = StructOfNames.black };
pub const blanchedAlmond: Color = .{ .rgb = StructOfNames.blanched_almond };
pub const blue: Color = .{ .rgb = StructOfNames.blue };
pub const blueViolet: Color = .{ .rgb = StructOfNames.blue_violet };
pub const brown: Color = .{ .rgb = StructOfNames.brown };
pub const burlyWood: Color = .{ .rgb = StructOfNames.burly_wood };
pub const cadetBlue: Color = .{ .rgb = StructOfNames.cadet_blue };
pub const chartreuse: Color = .{ .rgb = StructOfNames.chartreuse };
pub const chocolate: Color = .{ .rgb = StructOfNames.chocolate };
pub const coral: Color = .{ .rgb = StructOfNames.coral };
pub const cornflowerBlue: Color = .{ .rgb = StructOfNames.cornflower_blue };
pub const cornsilk: Color = .{ .rgb = StructOfNames.cornsilk };
pub const crimson: Color = .{ .rgb = StructOfNames.crimson };
pub const cyan: Color = .{ .rgb = StructOfNames.cyan };
pub const darkBlue: Color = .{ .rgb = StructOfNames.dark_blue };
pub const darkCyan: Color = .{ .rgb = StructOfNames.dark_cyan };
pub const darkGoldenrod: Color = .{ .rgb = StructOfNames.dark_goldenrod };
pub const darkGray: Color = .{ .rgb = StructOfNames.dark_gray };
pub const darkGreen: Color = .{ .rgb = StructOfNames.dark_green };
pub const darkGrey: Color = .{ .rgb = StructOfNames.dark_grey };
pub const darkKhaki: Color = .{ .rgb = StructOfNames.dark_khaki };
pub const darkMagenta: Color = .{ .rgb = StructOfNames.dark_magenta };
pub const darkOliveGreen: Color = .{ .rgb = StructOfNames.dark_olive_green };
pub const darkOrange: Color = .{ .rgb = StructOfNames.dark_orange };
pub const darkOrchid: Color = .{ .rgb = StructOfNames.dark_orchid };
pub const darkRed: Color = .{ .rgb = StructOfNames.dark_red };
pub const darkSalmon: Color = .{ .rgb = StructOfNames.dark_salmon };
pub const darkSeaGreen: Color = .{ .rgb = StructOfNames.dark_sea_green };
pub const darkSlateBlue: Color = .{ .rgb = StructOfNames.dark_slate_blue };
pub const darkSlateGray: Color = .{ .rgb = StructOfNames.dark_slate_gray };
pub const darkSlateGrey: Color = .{ .rgb = StructOfNames.dark_slate_grey };
pub const darkTurquoise: Color = .{ .rgb = StructOfNames.dark_turquoise };
pub const darkViolet: Color = .{ .rgb = StructOfNames.dark_violet };
pub const deepPink: Color = .{ .rgb = StructOfNames.deep_pink };
pub const deepSkyBlue: Color = .{ .rgb = StructOfNames.deep_sky_blue };
pub const dimGray: Color = .{ .rgb = StructOfNames.dim_gray };
pub const dimGrey: Color = .{ .rgb = StructOfNames.dim_grey };
pub const dodgerBlue: Color = .{ .rgb = StructOfNames.dodger_blue };
pub const firebrick: Color = .{ .rgb = StructOfNames.firebrick };
pub const floralWhite: Color = .{ .rgb = StructOfNames.floral_white };
pub const forestGreen: Color = .{ .rgb = StructOfNames.forest_green };
pub const fuchsia: Color = .{ .rgb = StructOfNames.fuchsia };
pub const gainsboro: Color = .{ .rgb = StructOfNames.gainsboro };
pub const ghostWhite: Color = .{ .rgb = StructOfNames.ghost_white };
pub const gold: Color = .{ .rgb = StructOfNames.gold };
pub const goldenrod: Color = .{ .rgb = StructOfNames.goldenrod };
pub const gray: Color = .{ .rgb = StructOfNames.gray };
pub const green: Color = .{ .rgb = StructOfNames.green };
pub const greenYellow: Color = .{ .rgb = StructOfNames.green_yellow };
pub const grey: Color = .{ .rgb = StructOfNames.grey };
pub const honeydew: Color = .{ .rgb = StructOfNames.honeydew };
pub const hotPink: Color = .{ .rgb = StructOfNames.hot_pink };
pub const indianRed: Color = .{ .rgb = StructOfNames.indian_red };
pub const indigo: Color = .{ .rgb = StructOfNames.indigo };
pub const ivory: Color = .{ .rgb = StructOfNames.ivory };
pub const khaki: Color = .{ .rgb = StructOfNames.khaki };
pub const lavender: Color = .{ .rgb = StructOfNames.lavender };
pub const lavenderBlush: Color = .{ .rgb = StructOfNames.lavender_blush };
pub const lawnGreen: Color = .{ .rgb = StructOfNames.lawn_green };
pub const lemonChiffon: Color = .{ .rgb = StructOfNames.lemon_chiffon };
pub const lightBlue: Color = .{ .rgb = StructOfNames.light_blue };
pub const lightCoral: Color = .{ .rgb = StructOfNames.light_coral };
pub const lightCyan: Color = .{ .rgb = StructOfNames.light_cyan };
pub const lightGoldenrodYellow: Color = .{ .rgb = StructOfNames.light_goldenrod_yellow };
pub const lightGray: Color = .{ .rgb = StructOfNames.light_gray };
pub const lightGreen: Color = .{ .rgb = StructOfNames.light_green };
pub const lightGrey: Color = .{ .rgb = StructOfNames.light_grey };
pub const lightPink: Color = .{ .rgb = StructOfNames.light_pink };
pub const lightSalmon: Color = .{ .rgb = StructOfNames.light_salmon };
pub const lightSeaGreen: Color = .{ .rgb = StructOfNames.light_sea_green };
pub const lightSkyBlue: Color = .{ .rgb = StructOfNames.light_sky_blue };
pub const lightSlateGray: Color = .{ .rgb = StructOfNames.light_slate_gray };
pub const lightSlateGrey: Color = .{ .rgb = StructOfNames.light_slate_grey };
pub const lightSteelBlue: Color = .{ .rgb = StructOfNames.light_steel_blue };
pub const lightYellow: Color = .{ .rgb = StructOfNames.light_yellow };
pub const lime: Color = .{ .rgb = StructOfNames.lime };
pub const limeGreen: Color = .{ .rgb = StructOfNames.lime_green };
pub const linen: Color = .{ .rgb = StructOfNames.linen };
pub const magenta: Color = .{ .rgb = StructOfNames.magenta };
pub const maroon: Color = .{ .rgb = StructOfNames.maroon };
pub const mediumAquamarine: Color = .{ .rgb = StructOfNames.medium_aquamarine };
pub const mediumBlue: Color = .{ .rgb = StructOfNames.medium_blue };
pub const mediumOrchid: Color = .{ .rgb = StructOfNames.medium_orchid };
pub const mediumPurple: Color = .{ .rgb = StructOfNames.medium_purple };
pub const mediumSeaGreen: Color = .{ .rgb = StructOfNames.medium_sea_green };
pub const mediumSlateBlue: Color = .{ .rgb = StructOfNames.medium_slate_blue };
pub const mediumSpringGreen: Color = .{ .rgb = StructOfNames.medium_spring_green };
pub const mediumTurquoise: Color = .{ .rgb = StructOfNames.medium_turquoise };
pub const mediumVioletRed: Color = .{ .rgb = StructOfNames.medium_violet_red };
pub const midnightBlue: Color = .{ .rgb = StructOfNames.midnight_blue };
pub const mintCream: Color = .{ .rgb = StructOfNames.mint_cream };
pub const mistyRose: Color = .{ .rgb = StructOfNames.misty_rose };
pub const moccasin: Color = .{ .rgb = StructOfNames.moccasin };
pub const navajoWhite: Color = .{ .rgb = StructOfNames.navajo_white };
pub const navy: Color = .{ .rgb = StructOfNames.navy };
pub const oldLace: Color = .{ .rgb = StructOfNames.old_lace };
pub const olive: Color = .{ .rgb = StructOfNames.olive };
pub const oliveDrab: Color = .{ .rgb = StructOfNames.olive_drab };
pub const orange: Color = .{ .rgb = StructOfNames.orange };
pub const orangeRed: Color = .{ .rgb = StructOfNames.orange_red };
pub const orchid: Color = .{ .rgb = StructOfNames.orchid };
pub const paleGoldenrod: Color = .{ .rgb = StructOfNames.pale_goldenrod };
pub const paleGreen: Color = .{ .rgb = StructOfNames.pale_green };
pub const paleTurquoise: Color = .{ .rgb = StructOfNames.pale_turquoise };
pub const paleVioletRed: Color = .{ .rgb = StructOfNames.pale_violet_red };
pub const papayaWhip: Color = .{ .rgb = StructOfNames.papaya_whip };
pub const peachPuff: Color = .{ .rgb = StructOfNames.peach_puff };
pub const peru: Color = .{ .rgb = StructOfNames.peru };
pub const pink: Color = .{ .rgb = StructOfNames.pink };
pub const plum: Color = .{ .rgb = StructOfNames.plum };
pub const powderBlue: Color = .{ .rgb = StructOfNames.powder_blue };
pub const purple: Color = .{ .rgb = StructOfNames.purple };
pub const rebeccaPurple: Color = .{ .rgb = StructOfNames.rebecca_purple };
pub const red: Color = .{ .rgb = StructOfNames.red };
pub const rosyBrown: Color = .{ .rgb = StructOfNames.rosy_brown };
pub const royalBlue: Color = .{ .rgb = StructOfNames.royal_blue };
pub const saddleBrown: Color = .{ .rgb = StructOfNames.saddle_brown };
pub const salmon: Color = .{ .rgb = StructOfNames.salmon };
pub const sandyBrown: Color = .{ .rgb = StructOfNames.sandy_brown };
pub const seaGreen: Color = .{ .rgb = StructOfNames.sea_green };
pub const seashell: Color = .{ .rgb = StructOfNames.seashell };
pub const sienna: Color = .{ .rgb = StructOfNames.sienna };
pub const silver: Color = .{ .rgb = StructOfNames.silver };
pub const skyBlue: Color = .{ .rgb = StructOfNames.sky_blue };
pub const slateBlue: Color = .{ .rgb = StructOfNames.slate_blue };
pub const slateGray: Color = .{ .rgb = StructOfNames.slate_gray };
pub const slateGrey: Color = .{ .rgb = StructOfNames.slate_grey };
pub const snow: Color = .{ .rgb = StructOfNames.snow };
pub const springGreen: Color = .{ .rgb = StructOfNames.spring_green };
pub const steelBlue: Color = .{ .rgb = StructOfNames.steel_blue };
pub const tan: Color = .{ .rgb = StructOfNames.tan };
pub const teal: Color = .{ .rgb = StructOfNames.teal };
pub const thistle: Color = .{ .rgb = StructOfNames.thistle };
pub const tomato: Color = .{ .rgb = StructOfNames.tomato };
pub const turquoise: Color = .{ .rgb = StructOfNames.turquoise };
pub const violet: Color = .{ .rgb = StructOfNames.violet };
pub const wheat: Color = .{ .rgb = StructOfNames.wheat };
pub const white: Color = .{ .rgb = StructOfNames.white };
pub const whiteSmoke: Color = .{ .rgb = StructOfNames.white_smoke };
pub const yellow: Color = .{ .rgb = StructOfNames.yellow };
pub const yellowGreen: Color = .{ .rgb = StructOfNames.yellow_green };

test "ansi4 namespace holds colours" {
    try testing.expectEqual(Color{ .ansi4 = .red }, ansi4.red);
    try testing.expectEqualStrings("\x1b[91m", ansi4.brightRed.fg().slice());
    try testing.expectEqualStrings("\x1b[107m", ansi4.brightWhite.bg().slice());
    try testing.expectEqualStrings("\x1b[39m", ansi4.default.fg().slice());
}

test "ansi256 namespace constructors" {
    try testing.expectEqual(@as(u8, 16), ansi256.rgb(0, 0, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 196), ansi256.rgb(5, 0, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 46), ansi256.rgb(0, 5, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 21), ansi256.rgb(0, 0, 5).ansi256.index);
    try testing.expectEqual(@as(u8, 231), ansi256.rgb(5, 5, 5).ansi256.index);
    try testing.expectEqual(@as(u8, 232), ansi256.gray(0).ansi256.index);
    try testing.expectEqual(@as(u8, 244), ansi256.gray(12).ansi256.index);
    try testing.expectEqual(@as(u8, 255), ansi256.gray(23).ansi256.index);
    try testing.expectEqual(@as(u8, 196), ansi256.index(196).ansi256.index);
    try testing.expectEqualStrings("\x1b[38;5;196m", ansi256.rgb(5, 0, 0).fg().slice());
}

test "ansi88 namespace constructors" {
    try testing.expectEqual(@as(u8, 16), ansi88.rgb(0, 0, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 79), ansi88.rgb(3, 3, 3).ansi256.index);
    try testing.expectEqual(@as(u8, 64), ansi88.rgb(3, 0, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 20), ansi88.rgb(0, 1, 0).ansi256.index);
    try testing.expectEqual(@as(u8, 19), ansi88.rgb(0, 0, 3).ansi256.index);
    try testing.expectEqual(@as(u8, 80), ansi88.gray(0).ansi256.index);
    try testing.expectEqual(@as(u8, 87), ansi88.gray(7).ansi256.index);
    try testing.expectEqualStrings("\x1b[38;5;79m", ansi88.rgb(3, 3, 3).fg().slice());
}

test "ansi4 sequences" {
    try testing.expectEqualStrings("\x1b[30m", ansi4.black.fg().slice());
    try testing.expectEqualStrings("\x1b[31m", ansi4.red.fg().slice());
    try testing.expectEqualStrings("\x1b[37m", ansi4.white.fg().slice());
    try testing.expectEqualStrings("\x1b[90m", ansi4.brightBlack.fg().slice());
    try testing.expectEqualStrings("\x1b[97m", ansi4.brightWhite.fg().slice());
    try testing.expectEqualStrings("\x1b[39m", ansi4.default.fg().slice());
    try testing.expectEqualStrings("\x1b[41m", ansi4.red.bg().slice());
    try testing.expectEqualStrings("\x1b[101m", ansi4.brightRed.bg().slice());
    try testing.expectEqualStrings("\x1b[49m", ansi4.default.bg().slice());
    try testing.expectEqualStrings("\x1b[58;5;9m", ansi4.brightRed.underline().slice());
    try testing.expectEqualStrings("\x1b[59m", ansi4.default.underline().slice());
}

test "Ansi4.fromCode" {
    try testing.expectEqual(Ansi4.red, Ansi4.fromCode(31).?);
    try testing.expectEqual(Ansi4.red, Ansi4.fromCode(41).?);
    try testing.expectEqual(Ansi4.brightRed, Ansi4.fromCode(91).?);
    try testing.expectEqual(Ansi4.brightRed, Ansi4.fromCode(101).?);
    try testing.expectEqual(Ansi4.default, Ansi4.fromCode(39).?);
    try testing.expectEqual(Ansi4.default, Ansi4.fromCode(49).?);
    try testing.expectEqual(Ansi4.default, Ansi4.fromCode(59).?);
    try testing.expect(Ansi4.fromCode(0) == null);
    try testing.expect(Ansi4.fromCode(29) == null);
    try testing.expect(Ansi4.fromCode(38) == null);
    try testing.expect(Ansi4.fromCode(255) == null);
    for (Ansi4.all, 0..) |a, i| {
        const code: u8 = if (i < 8) @intCast(30 + i) else @intCast(90 + i - 8);
        try testing.expectEqual(a, Ansi4.fromCode(code).?);
    }
}

test "indexed sequences" {
    try testing.expectEqualStrings("\x1b[38;5;0m", ansi256.index(0).fg().slice());
    try testing.expectEqualStrings("\x1b[38;5;196m", ansi256.index(196).fg().slice());
    try testing.expectEqualStrings("\x1b[38;5;255m", ansi256.index(255).fg().slice());
    try testing.expectEqualStrings("\x1b[48;5;16m", ansi256.index(16).bg().slice());
    try testing.expectEqualStrings("\x1b[58;5;208m", ansi256.index(208).underline().slice());
}

test "rgb, hex, hsl and hsv sequences agree" {
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", rgb(255, 0, 0).fg().slice());
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", hex(0xFF0000).fg().slice());
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", hsl(0, 100, 50).fg().slice());
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", hsv(0, 100, 100).fg().slice());
    try testing.expectEqualStrings("\x1b[48;2;0;255;0m", rgb(0, 255, 0).bg().slice());
    try testing.expectEqualStrings("\x1b[58;2;255;100;20m", rgb(255, 100, 20).underline().slice());
}

test "Hex.parse accepted forms" {
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("#FF0000")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("FF0000")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("#F00")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("f00")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("0xFF0000")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("0Xff0000")).value);
    try testing.expectEqual(@as(u24, 0xFFFFFF), (try Hex.parse("#FFFFFF")).value);
    try testing.expectEqual(@as(u24, 0x000000), (try Hex.parse("#000")).value);
    try testing.expectEqual(@as(u24, 0x0A0B0C), (try Hex.parse("0a0b0c")).value);
}

test "Hex.parse accepts and discards alpha" {
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("#F00F")).value);
    try testing.expectEqual(@as(u24, 0xFF0000), (try Hex.parse("#FF000080")).value);
    try testing.expectEqual(@as(u8, 255), try Hex.opacity("#FF0000"));
    try testing.expectEqual(@as(u8, 255), try Hex.opacity("#FF0000FF"));
    try testing.expectEqual(@as(u8, 128), try Hex.opacity("#FF000080"));
    try testing.expectEqual(@as(u8, 255), try Hex.opacity("#F00F"));
    try testing.expectEqual(@as(u8, 170), try Hex.opacity("#F00A"));
    try testing.expectEqual(@as(u8, 0), try Hex.opacity("#FF000000"));
    try testing.expectError(error.InvalidHexDigit, Hex.parse("#FF0000GG"));
}

test "Hex.parse rejects malformed input" {
    try testing.expectError(error.InvalidHexLength, Hex.parse(""));
    try testing.expectError(error.InvalidHexLength, Hex.parse("#"));
    try testing.expectError(error.InvalidHexLength, Hex.parse("#FF"));
    try testing.expectError(error.InvalidHexLength, Hex.parse("#F"));
    try testing.expectError(error.InvalidHexLength, Hex.parse("#FFFFF"));
    try testing.expectError(error.InvalidHexLength, Hex.parse("#FFFFFFF"));
    try testing.expectError(error.InvalidHexLength, Hex.parse("0xFFFFFFF"));
    try testing.expectError(error.InvalidHexDigit, Hex.parse("#GG0000"));
    try testing.expectError(error.InvalidHexDigit, Hex.parse("FF00ZZ"));
    try testing.expectError(error.InvalidHexDigit, Hex.parse("#G00"));
}

test "hex round trips" {
    try testing.expectEqual(@as(u24, 0xFF8000), rgb(255, 128, 0).toHex().value);
    try testing.expectEqualStrings("#ff8000", &rgb(255, 128, 0).toRgb().toString());
    try testing.expectEqualStrings("#000000", &rgb(0, 0, 0).toRgb().toString());
    try testing.expectEqual(Rgb.init(1, 2, 3), hex(0x010203).toRgb());
    try testing.expectEqualStrings("#ffffff", &hex(0xFFFFFF).toRgb().toString());
}

test "ansi256ToRgb covers the palette" {
    try testing.expectEqual(Rgb.init(0, 0, 0), ansi256ToRgb(0));
    try testing.expectEqual(Rgb.init(170, 0, 170), ansi256ToRgb(5));
    try testing.expectEqual(Rgb.init(255, 255, 255), ansi256ToRgb(15));
    try testing.expectEqual(Rgb.init(0, 0, 255), ansi256ToRgb(21));
    try testing.expectEqual(Rgb.init(0, 255, 0), ansi256ToRgb(46));
    try testing.expectEqual(Rgb.init(255, 0, 0), ansi256ToRgb(196));
    try testing.expectEqual(Rgb.init(255, 135, 0), ansi256ToRgb(208));
    try testing.expectEqual(Rgb.init(8, 8, 8), ansi256ToRgb(232));
    try testing.expectEqual(Rgb.init(238, 238, 238), ansi256ToRgb(255));
    for (0..256) |i| {
        try testing.expectEqual(ansi256ToRgb(@intCast(i)), ansi256.index(@intCast(i)).toRgb());
    }
}

test "hue wrapping at 360" {
    try testing.expectEqual(@as(u16, 10), Hsl.init(370, 50, 50).h);
    try testing.expectEqual(@as(u16, 0), Hsl.init(360, 50, 50).h);
    try testing.expectEqual(@as(u16, 359), Hsl.init(359, 50, 50).h);
    try testing.expectEqual(@as(u16, 0), Hsv.init(720, 50, 50).h);
}

test "hsl boundaries and anchors" {
    try testing.expectEqual(Rgb.init(0, 0, 0), Hsl.init(0, 100, 0).toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 255), Hsl.init(0, 100, 100).toRgb());
    try testing.expectEqual(Rgb.init(128, 128, 128), Hsl.init(0, 0, 50).toRgb());
    try testing.expectEqual(Rgb.init(255, 0, 0), Hsl.init(0, 100, 50).toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 0), Hsl.init(60, 100, 50).toRgb());
    try testing.expectEqual(Rgb.init(0, 255, 0), Hsl.init(120, 100, 50).toRgb());
    try testing.expectEqual(Rgb.init(0, 255, 255), Hsl.init(180, 100, 50).toRgb());
    try testing.expectEqual(Rgb.init(0, 0, 255), Hsl.init(240, 100, 50).toRgb());
    try testing.expectEqual(Rgb.init(255, 0, 255), Hsl.init(300, 100, 50).toRgb());
}

test "hsv boundaries and anchors" {
    try testing.expectEqual(Rgb.init(0, 0, 0), Hsv.init(0, 100, 0).toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 255), Hsv.init(0, 0, 100).toRgb());
    try testing.expectEqual(Rgb.init(255, 0, 0), Hsv.init(0, 100, 100).toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 0), Hsv.init(60, 100, 100).toRgb());
    try testing.expectEqual(Rgb.init(0, 255, 0), Hsv.init(120, 100, 100).toRgb());
    try testing.expectEqual(Rgb.init(0, 0, 255), Hsv.init(240, 100, 100).toRgb());
}

test "rgb to hsl and hsv round trip" {
    // Whole-percentage HSL/HSV quantization costs up to two steps.
    const back = Rgb.init(100, 150, 200).toHsl().toRgb();
    try testing.expect(@abs(@as(i16, back.r) - 100) <= 2);
    try testing.expect(@abs(@as(i16, back.g) - 150) <= 2);
    try testing.expect(@abs(@as(i16, back.b) - 200) <= 2);

    const hsv_back = Rgb.init(10, 200, 90).toHsv().toRgb();
    try testing.expect(@abs(@as(i16, hsv_back.r) - 10) <= 2);
    try testing.expect(@abs(@as(i16, hsv_back.g) - 200) <= 2);
    try testing.expect(@abs(@as(i16, hsv_back.b) - 90) <= 2);
}

test "cmyk conversion" {
    try testing.expectEqual(Rgb.init(255, 0, 0), Cmyk.init(0, 100, 100, 0).toRgb());
    try testing.expectEqual(Rgb.init(0, 0, 0), Cmyk.init(0, 0, 0, 100).toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 255), Cmyk.init(0, 0, 0, 0).toRgb());
    try testing.expectEqual(Rgb.init(0, 255, 255), Cmyk.init(100, 0, 0, 0).toRgb());

    const redCmyk = Cmyk.fromRgb(Rgb.init(255, 0, 0));
    try testing.expectEqual(@as(u8, 0), redCmyk.c);
    try testing.expectEqual(@as(u8, 100), redCmyk.m);
    try testing.expectEqual(@as(u8, 100), redCmyk.y);
    try testing.expectEqual(@as(u8, 0), redCmyk.k);
    try testing.expectEqual(@as(u8, 100), Cmyk.fromRgb(Rgb.init(0, 0, 0)).k);

    for ([_]Rgb{ Rgb.init(1, 2, 3), Rgb.init(254, 128, 7), Rgb.white }) |source| {
        // Whole-percentage CMYK quantization costs up to two steps.
        const back = Cmyk.fromRgb(source).toRgb();
        try testing.expect(@abs(@as(i16, back.r) - source.r) <= 2);
        try testing.expect(@abs(@as(i16, back.g) - source.g) <= 2);
        try testing.expect(@abs(@as(i16, back.b) - source.b) <= 2);
    }
}

test "xyz round trip" {
    for ([_]Rgb{ Rgb.init(255, 0, 0), Rgb.init(0, 255, 0), Rgb.init(0, 0, 255), Rgb.init(18, 52, 86) }) |source| {
        const back = source.toXyz().toRgb();
        try testing.expect(@abs(@as(i16, back.r) - source.r) <= 1);
        try testing.expect(@abs(@as(i16, back.g) - source.g) <= 1);
        try testing.expect(@abs(@as(i16, back.b) - source.b) <= 1);
    }
}

test "xyz to rgb clamps out of gamut values" {
    const negative = (Xyz{ .x = -1, .y = -1, .z = -1 }).toRgb();
    try testing.expectEqual(@as(u8, 0), negative.r);
    try testing.expectEqual(Rgb.init(255, 255, 255), (Xyz{ .x = 10, .y = 10, .z = 10 }).toRgb());
}

test "lab reference values" {
    const labWhite = Rgb.white.toLab();
    try testing.expectApproxEqAbs(@as(f64, 100), labWhite.l, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 0), labWhite.a, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 0), labWhite.b, 0.01);

    const labRed = Rgb.init(255, 0, 0).toLab();
    try testing.expectApproxEqAbs(@as(f64, 53.2408), labRed.l, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 80.0925), labRed.a, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 67.2032), labRed.b, 0.01);

    const labGreen = Rgb.init(0, 255, 0).toLab();
    try testing.expectApproxEqAbs(@as(f64, 87.7347), labGreen.l, 0.01);
    try testing.expectApproxEqAbs(@as(f64, -86.1827), labGreen.a, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 83.1793), labGreen.b, 0.01);

    const labBlue = Rgb.init(0, 0, 255).toLab();
    try testing.expectApproxEqAbs(@as(f64, 32.2970), labBlue.l, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 79.1875), labBlue.a, 0.01);
    try testing.expectApproxEqAbs(@as(f64, -107.8602), labBlue.b, 0.01);
}

test "lab round trip" {
    for ([_]Rgb{ Rgb.white, Rgb.black, Rgb.init(255, 0, 0), Rgb.init(18, 52, 86) }) |source| {
        const back = source.toLab().toXyz().toRgb();
        try testing.expect(@abs(@as(i16, back.r) - source.r) <= 1);
        try testing.expect(@abs(@as(i16, back.g) - source.g) <= 1);
        try testing.expect(@abs(@as(i16, back.b) - source.b) <= 1);
    }
}

test "lch reference values and round trip" {
    const lchRed = Rgb.init(255, 0, 0).toLch();
    try testing.expectApproxEqAbs(@as(f64, 53.2408), lchRed.l, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 104.5516), lchRed.c, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 40.0), lchRed.h, 0.05);

    const labBack = lchRed.toLab();
    try testing.expectApproxEqAbs(@as(f64, 80.0925), labBack.a, 0.01);
    try testing.expectApproxEqAbs(@as(f64, 67.2032), labBack.b, 0.01);

    const lchGrey = Rgb.init(128, 128, 128).toLch();
    try testing.expectApproxEqAbs(@as(f64, 0), lchGrey.c, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0), lchGrey.h, 0.001);
}

test "oklab reference values" {
    const oklabWhite = Rgb.white.toOklab();
    try testing.expectApproxEqAbs(@as(f64, 1.0), oklabWhite.l, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.0), oklabWhite.a, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.0), oklabWhite.b, 0.001);

    try testing.expectApproxEqAbs(@as(f64, 0.0), Rgb.black.toOklab().l, 0.001);

    const oklabRed = Rgb.init(255, 0, 0).toOklab();
    try testing.expectApproxEqAbs(@as(f64, 0.6280), oklabRed.l, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.2249), oklabRed.a, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.1258), oklabRed.b, 0.001);

    const oklabGreen = Rgb.init(0, 255, 0).toOklab();
    try testing.expectApproxEqAbs(@as(f64, 0.8664), oklabGreen.l, 0.001);
    try testing.expectApproxEqAbs(@as(f64, -0.2339), oklabGreen.a, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.1795), oklabGreen.b, 0.001);

    const oklabBlue = Rgb.init(0, 0, 255).toOklab();
    try testing.expectApproxEqAbs(@as(f64, 0.4520), oklabBlue.l, 0.001);
    try testing.expectApproxEqAbs(@as(f64, -0.0324), oklabBlue.a, 0.001);
    try testing.expectApproxEqAbs(@as(f64, -0.3115), oklabBlue.b, 0.001);
}

test "oklab round trip" {
    for ([_]Rgb{ Rgb.white, Rgb.black, Rgb.init(255, 0, 0), Rgb.init(12, 200, 90) }) |source| {
        const back = source.toOklab().toRgb();
        try testing.expect(@abs(@as(i16, back.r) - source.r) <= 1);
        try testing.expect(@abs(@as(i16, back.g) - source.g) <= 1);
        try testing.expect(@abs(@as(i16, back.b) - source.b) <= 1);
    }
}

test "oklch reference values and round trip" {
    const oklchRed = Rgb.init(255, 0, 0).toOklch();
    try testing.expectApproxEqAbs(@as(f64, 0.6280), oklchRed.l, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.2577), oklchRed.c, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 29.23), oklchRed.h, 0.05);

    const oklabBack = oklchRed.toOklab();
    try testing.expectApproxEqAbs(@as(f64, 0.2249), oklabBack.a, 0.0005);
    try testing.expectApproxEqAbs(@as(f64, 0.1258), oklabBack.b, 0.0005);

    const oklchGrey = Rgb.init(128, 128, 128).toOklch();
    try testing.expectApproxEqAbs(@as(f64, 0.0), oklchGrey.c, 0.001);
    try testing.expectApproxEqAbs(@as(f64, 0.0), oklchGrey.h, 0.001);
}

test "color distance metrics agree on ordering" {
    const pureRed = rgb(255, 0, 0);
    const near_red = rgb(250, 10, 10);
    const pureBlue = rgb(0, 0, 255);

    for ([_]*const fn (Color, Color) f64{ &Color.deltaE76, &Color.deltaE94, &Color.deltaE2000, &Color.oklabDistance }) |metric| {
        try testing.expectApproxEqAbs(@as(f64, 0), metric(pureRed, pureRed), 0.0001);
        try testing.expect(metric(pureRed, near_red) < metric(pureRed, pureBlue));
        try testing.expect(metric(pureRed, pureBlue) > 0);
    }
    try testing.expect(pureRed.deltaE2000(rgb(0, 255, 0)) > 50);
}

test "deltaE2000 matches Sharma's reference pairs" {
    const pair_one_a = Lab{ .l = 50.0, .a = 2.6772, .b = -79.7751 };
    const pair_one_b = Lab{ .l = 50.0, .a = 0.0, .b = -82.7485 };
    try testing.expectApproxEqAbs(@as(f64, 2.0425), pair_one_a.deltaE2000(pair_one_b), 0.001);

    const pair_two_a = Lab{ .l = 50.0, .a = 3.1571, .b = -77.2803 };
    const pair_two_b = Lab{ .l = 50.0, .a = 0.0, .b = -82.7485 };
    try testing.expectApproxEqAbs(@as(f64, 2.8615), pair_two_a.deltaE2000(pair_two_b), 0.001);

    // Sharma's unit pair is constructed to differ by exactly 1.0.
    const unit_a = Lab{ .l = 50.0, .a = -1.3802, .b = -84.2814 };
    const unit_b = Lab{ .l = 50.0, .a = 0.0, .b = -82.7485 };
    try testing.expectApproxEqAbs(@as(f64, 1.0), unit_a.deltaE2000(unit_b), 0.001);
}

test "deltaE94 reference pair" {
    const a = Lab{ .l = 50.0, .a = 2.6772, .b = -79.7751 };
    const b = Lab{ .l = 50.0, .a = 0.0, .b = -82.7485 };
    try testing.expectApproxEqAbs(@as(f64, 1.395), a.deltaE94(b), 0.02);
    try testing.expectApproxEqAbs(@as(f64, 0), a.deltaE94(a), 0.0001);
}

test "contrast ratio" {
    try testing.expectApproxEqAbs(@as(f64, 21), rgb(255, 255, 255).contrastRatio(rgb(0, 0, 0)), 0.01);
    try testing.expectApproxEqAbs(@as(f64, 1), rgb(255, 255, 255).contrastRatio(rgb(255, 255, 255)), 0.0001);
    try testing.expectApproxEqAbs(
        rgb(255, 255, 255).contrastRatio(rgb(0, 0, 0)),
        rgb(0, 0, 0).contrastRatio(rgb(255, 255, 255)),
        0.0001,
    );
    try testing.expect(rgb(255, 255, 255).contrastRatio(rgb(0, 0, 255)) > 2);
}

test "luminance" {
    try testing.expectApproxEqAbs(@as(f64, 0), rgb(0, 0, 0).luminance(), 0.0001);
    try testing.expectApproxEqAbs(@as(f64, 1), rgb(255, 255, 255).luminance(), 0.0001);
    try testing.expect(rgb(0, 255, 0).luminance() > rgb(255, 0, 0).luminance());
    try testing.expect(rgb(255, 0, 0).luminance() > rgb(0, 0, 255).luminance());
}

test "light and dark detection" {
    try testing.expect(rgb(255, 255, 255).isLight());
    try testing.expect(rgb(0, 0, 0).isDark());
    try testing.expect(!rgb(128, 128, 128).isLight());
    try testing.expectEqual(!rgb(12, 34, 56).isLight(), rgb(12, 34, 56).isDark());
}

test "nearestAnsi256 finds exact palette entries" {
    for (0..256) |i| {
        const index: u8 = @intCast(i);
        const nearest = ansi256.index(index).nearestAnsi256();
        try testing.expectEqual(ansi256ToRgb(index), nearest.toRgb());
    }
    try testing.expectEqual(@as(u8, 196), rgb(255, 0, 0).nearestAnsi256().index);
}

test "nearestAnsi16 picks a base colour" {
    try testing.expectEqual(Ansi4.brightRed, rgb(255, 0, 0).nearestAnsi16());
    try testing.expectEqual(Ansi4.brightWhite, rgb(255, 255, 255).nearestAnsi16());
    try testing.expectEqual(Ansi4.black, rgb(0, 0, 0).nearestAnsi16());
    try testing.expectEqual(Ansi4.brightBlue, rgb(0, 0, 255).nearestAnsi16());
    for (Ansi4.all) |a| {
        try testing.expectEqual(a, fromRgb(ansi16[@backingInt(a)]).nearestAnsi16());
    }
}

test "downgrade follows the capability ladder" {
    const source = rgb(200, 30, 90);
    try testing.expectEqual(source, source.downgrade(.trueColor));
    try testing.expectEqual(std.meta.Tag(Color).ansi256, std.meta.activeTag(source.downgrade(.ansi256)));
    try testing.expectEqual(std.meta.Tag(Color).ansi4, std.meta.activeTag(source.downgrade(.ansi16)));
    try testing.expectEqual(Ansi4.default, source.downgrade(.none).ansi4);
    try testing.expectEqualStrings("\x1b[39m", source.downgrade(.none).fg().slice());
    try testing.expectEqualStrings("\x1b[91m", rgb(255, 0, 0).downgrade(.ansi16).fg().slice());
}

test "invert" {
    try testing.expectEqual(Rgb.init(0, 255, 255), rgb(255, 0, 0).invert().toRgb());
    try testing.expectEqual(rgb(255, 0, 0), rgb(0, 255, 255).invert());
}

test "grayscale variants equalise channels" {
    const source = rgb(100, 150, 200);
    for ([_]Color{ source.grayscale(), source.grayscaleLuminance() }) |sample| {
        const value = sample.toRgb();
        try testing.expectEqual(value.r, value.g);
        try testing.expectEqual(value.g, value.b);
    }
}

test "mix endpoints and clamping" {
    const pureRed = rgb(255, 0, 0);
    const pureBlue = rgb(0, 0, 255);
    try testing.expectEqual(pureRed.toRgb(), pureRed.mix(pureBlue, 0.0).toRgb());
    try testing.expectEqual(pureBlue.toRgb(), pureRed.mix(pureBlue, 1.0).toRgb());
    try testing.expectEqual(pureRed.toRgb(), pureRed.mix(pureBlue, -1.0).toRgb());
    try testing.expectEqual(pureBlue.toRgb(), pureRed.mix(pureBlue, 2.0).toRgb());
    const half = pureRed.mix(pureBlue, 0.5).toRgb();
    try testing.expectEqual(@as(u8, 128), half.r);
    try testing.expectEqual(@as(u8, 128), half.b);
}

test "mixIn endpoints hold in every space" {
    const a = rgb(200, 30, 90);
    const b = rgb(30, 90, 200);
    // RGB is exact; perceptual spaces round-trip through floats within a step;
    // HSL/HSV quantize to whole percentages, so allow a few steps there.
    inline for (.{
        .{ Space.rgb, 0 },   .{ Space.hsl, 4 }, .{ Space.hsv, 4 },
        .{ Space.lab, 1 },   .{ Space.lch, 2 }, .{ Space.oklab, 1 },
        .{ Space.oklch, 2 },
    }) |case| {
        for ([_]Rgb{ a.mixIn(b, 0.0, case[0]).toRgb(), a.mixIn(b, 1.0, case[0]).toRgb() }, [_]Rgb{ a.toRgb(), b.toRgb() }) |got, want| {
            try testing.expect(@abs(@as(i16, got.r) - want.r) <= case[1]);
            try testing.expect(@abs(@as(i16, got.g) - want.g) <= case[1]);
            try testing.expect(@abs(@as(i16, got.b) - want.b) <= case[1]);
        }
    }
    try testing.expectEqual(a.toRgb(), a.mixIn(b, 0.0, .rgb).toRgb());
    try testing.expectEqual(b.toRgb(), a.mixIn(b, 1.0, .rgb).toRgb());
}

test "perceptual interpolation passes through mid grey" {
    const paper = rgb(255, 255, 255);
    const ink = rgb(0, 0, 0);
    // Linear sRGB stops at 127, which is perceptually too bright (OKLab 0.6).
    try testing.expect(paper.mixIn(ink, 0.5, .rgb).toOklab().l > 0.55);
    // OKLab stops at the true perceptual middle.
    const perceptual = paper.mixIn(ink, 0.5, .oklab);
    try testing.expectApproxEqAbs(@as(f64, 0.5), perceptual.toOklab().l, 0.02);
    try testing.expect(perceptual.luminance() < paper.mixIn(ink, 0.5, .rgb).luminance());
    const lab = paper.mixIn(ink, 0.5, .lab);
    try testing.expectApproxEqAbs(@as(f64, 50), lab.toLab().l, 1.0);
}

test "hsl interpolation walks hue" {
    const mixed = rgb(255, 0, 0).mixIn(rgb(0, 255, 0), 0.5, .hsl).toHsl();
    try testing.expect(mixed.h >= 50 and mixed.h <= 70);
    try testing.expectEqual(@as(u8, 100), mixed.s);
}

test "hue paths are explicit" {
    const a = rgb(255, 0, 0);
    const b = rgb(0, 0, 255);

    // Red sits at OKLCH 29 degrees, blue at 264: forward passes through
    // green, backward through magenta.
    try testing.expectApproxEqAbs(@as(f64, 142.5), a.mixHue(b, 0.5, .increasing).toOklch().h, 2.0);
    try testing.expectApproxEqAbs(@as(f64, 326.1), a.mixHue(b, 0.5, .decreasing).toOklch().h, 2.0);
    try testing.expectApproxEqAbs(@as(f64, 326.1), a.mixHue(b, 0.5, .shorter).toOklch().h, 2.0);
    try testing.expectApproxEqAbs(@as(f64, 142.5), a.mixHue(b, 0.5, .longer).toOklch().h, 2.0);
}

test "fade blends towards mid grey" {
    const pureRed = rgb(255, 0, 0);
    try testing.expectEqual(pureRed.toRgb(), pureRed.fade(1.0).toRgb());
    const faded = pureRed.fade(0.0).toRgb();
    try testing.expect(@abs(@as(i16, faded.r) - 128) <= 1);
    try testing.expect(@abs(@as(i16, faded.g) - 128) <= 1);
    try testing.expect(pureRed.fade(0.5).deltaE2000(gray) < pureRed.deltaE2000(gray));
}

test "lighten and darken clamp" {
    const midGrey = rgb(128, 128, 128);
    try testing.expectEqual(@as(u8, 100), midGrey.lighten(10.0).toHsl().l);
    try testing.expectEqual(@as(u8, 0), midGrey.darken(10.0).toHsl().l);
    try testing.expect(midGrey.lighten(0.1).toHsl().l > midGrey.toHsl().l);
    try testing.expect(midGrey.darken(0.1).toHsl().l < midGrey.toHsl().l);
}

test "saturate and desaturate clamp" {
    const pureBlue = rgb(0, 0, 255);
    try testing.expectEqual(@as(u8, 100), pureBlue.saturate(10.0).toHsl().s);
    try testing.expectEqual(@as(u8, 0), pureBlue.desaturate(10.0).toHsl().s);
    const mutedBlue = rgb(100, 100, 200);
    try testing.expect(mutedBlue.saturate(0.1).toHsl().s > mutedBlue.toHsl().s);
    try testing.expect(pureBlue.desaturate(0.1).toHsl().s < pureBlue.toHsl().s);
}

test "absolute setters" {
    const source = rgb(128, 128, 128);
    try testing.expectEqual(@as(u8, 50), source.withLightness(50).toHsl().l);
    try testing.expectEqual(@as(u8, 100), source.withSaturation(100).toHsl().s);
    try testing.expectEqual(@as(u8, 0), source.withSaturation(0).toHsl().s);
}

test "hue rotation wraps both ways" {
    const pureRed = hsl(0, 100, 50);
    try testing.expectEqual(@as(u16, 180), pureRed.rotate(180).toHsl().h);
    try testing.expectEqual(@as(u16, 0), pureRed.rotate(360).toHsl().h);
    try testing.expectEqual(@as(u16, 0), pureRed.rotate(720).toHsl().h);
    // Non-anchor hues lose at most a degree through 8-bit channels.
    try testing.expectApproxEqAbs(@as(f64, 350), @as(f64, @floatFromInt(pureRed.rotate(350).toHsl().h)), 1.0);
    try testing.expectApproxEqAbs(@as(f64, 350), @as(f64, @floatFromInt(pureRed.adjustHue(-10).toHsl().h)), 1.0);
    try testing.expectApproxEqAbs(@as(f64, 10), @as(f64, @floatFromInt(pureRed.adjustHue(370).toHsl().h)), 1.0);
}

test "harmony preserves hue and saturation" {
    const pureRed = rgb(255, 0, 0);
    try testing.expectEqual(@as(u16, 180), pureRed.complementary().toHsl().h);
    try expectHue(pureRed.analogous()[0], 30);
    try expectHue(pureRed.analogous()[1], 330);
    try testing.expectEqual(@as(u16, 120), pureRed.triadic()[0].toHsl().h);
    try testing.expectEqual(@as(u16, 240), pureRed.triadic()[1].toHsl().h);
    try expectHue(pureRed.splitComplementary()[0], 150);
    try expectHue(pureRed.splitComplementary()[1], 210);
    try expectHue(pureRed.tetradic()[0], 90);
    try testing.expectEqual(@as(u16, 180), pureRed.tetradic()[1].toHsl().h);
    try expectHue(pureRed.tetradic()[2], 270);
    for ([_]Color{ pureRed.complementary(), pureRed.analogous()[0], pureRed.triadic()[0], pureRed.tetradic()[2] }) |derived| {
        try testing.expectEqual(@as(u8, 100), derived.toHsl().s);
    }
}

/// Hues survive 8-bit channel quantization within a degree.
fn expectHue(c: Color, expected: u16) !void {
    const got: f64 = @floatFromInt(c.toHsl().h);
    const want: f64 = @floatFromInt(expected);
    try testing.expectApproxEqAbs(want, got, 1.0);
}

test "monochromatic fills the caller owned buffer" {
    const pureRed = rgb(255, 0, 0);

    var empty: [0]Color = .{};
    pureRed.monochromatic(&empty);

    var one: [1]Color = undefined;
    pureRed.monochromatic(&one);
    try testing.expectEqual(pureRed.toHsl().l, one[0].toHsl().l);

    var five: [5]Color = undefined;
    pureRed.monochromatic(&five);
    try testing.expectEqual(@as(u8, 100), five[0].toHsl().l);
    try testing.expectEqual(@as(u8, 0), five[4].toHsl().l);
    for (five, 0..) |c, i| {
        // Every stop stays on the red axis with falling lightness.
        try testing.expectEqual(@as(u16, 0), c.toHsl().h);
        if (i > 0) try testing.expect(five[i].toHsl().l < five[i - 1].toHsl().l);
    }
}

test "kelvin conversion" {
    const warm = Rgb.fromKelvin(2700);
    const cool = Rgb.fromKelvin(6500);
    try testing.expect(warm.g < cool.g);
    try testing.expect(warm.b < cool.b);
    try testing.expect(Rgb.fromKelvin(1000).b < warm.b);
    try testing.expect(Rgb.fromKelvin(40000).b > cool.b);
    try testing.expectApproxEqAbs(@as(f64, 255), Rgb.fromKelvin(6500).r, 1.0);
    try testing.expectApproxEqAbs(@as(f64, 255), Rgb.fromKelvin(40000).b, 1.0);
    try testing.expectEqual(Rgb.fromKelvin(6500), kelvin(6500).toRgb());
}

test "ansi4 resolves against the base palette" {
    for (Ansi4.all) |a| {
        try testing.expectEqual(ansi16[@backingInt(a)], (Color{ .ansi4 = a }).toRgb());
    }
    try testing.expectEqual(Rgb.black, ansi4.default.toRgb());
}

test "named colours are complete and self consistent" {
    try testing.expectEqual(@as(usize, 148), names.len);
    for (names, 0..) |name, i| {
        if (i > 0) try testing.expect(std.mem.lessThan(u8, names[i - 1], name));
        const resolved = parse(name) orelse return error.TestExpectedEqual;
        try testing.expectEqual(parse(names[i]).?.toRgb(), resolved.toRgb());
    }
    try testing.expectEqual(Rgb.init(255, 0, 0), red.toRgb());
    try testing.expectEqual(Rgb.init(0, 0, 0), black.toRgb());
    try testing.expectEqual(Rgb.init(255, 255, 255), white.toRgb());
    try testing.expectEqual(Rgb.init(102, 51, 153), rebeccaPurple.toRgb());
    try testing.expectEqual(Rgb.init(255, 105, 180), hotPink.toRgb());
    try testing.expectEqual(Rgb.init(128, 128, 128), gray.toRgb());
}

test "parse resolves names and hex strings" {
    try testing.expectEqual(Rgb.init(255, 0, 0), parse("red").?.toRgb());
    try testing.expectEqual(Rgb.init(0, 0, 128), parse("navy").?.toRgb());
    try testing.expectEqual(@as(u24, 0xFF0000), parse("#FF0000").?.toHex().value);
    try testing.expectEqual(@as(u24, 0xFF0000), parse("f00").?.toHex().value);
    try testing.expectEqual(@as(u24, 0xFF0000), parse("0xFF0000").?.toHex().value);
    try testing.expect(parse("not_a_colour") == null);
    try testing.expect(parse("#GG0000") == null);
    try testing.expect(parse("") == null);
}

test "parse accepts every spelling of a name" {
    try testing.expectEqual(Rgb.init(102, 51, 153), parse("rebecca_purple").?.toRgb());
    try testing.expectEqual(Rgb.init(102, 51, 153), parse("rebeccapurple").?.toRgb());
    try testing.expectEqual(Rgb.init(102, 51, 153), parse("rebeccaPurple").?.toRgb());
    try testing.expectEqual(Rgb.init(102, 51, 153), parse("REBECCAPURPLE").?.toRgb());
    try testing.expectEqual(Rgb.init(102, 51, 153), parse("Rebecca_Purple").?.toRgb());
    try testing.expectEqual(Rgb.init(255, 0, 0), parse("RED").?.toRgb());
    try testing.expect(parse("red_") == null);
    try testing.expect(parse("_red") == null);
}

test "rgb sweep stays finite and bounded" {
    var r: u16 = 0;
    while (r < 256) : (r += 17) {
        var g: u16 = 0;
        while (g < 256) : (g += 17) {
            var b: u16 = 0;
            while (b < 256) : (b += 17) {
                const source = rgb(@intCast(r), @intCast(g), @intCast(b));
                const xyz = source.toXyz();
                try testing.expect(std.math.isFinite(xyz.x + xyz.y + xyz.z));
                const lab = source.toLab();
                try testing.expect(std.math.isFinite(lab.l + lab.a + lab.b));
                const oklab = source.toOklab();
                try testing.expect(std.math.isFinite(oklab.l + oklab.a + oklab.b));
                try testing.expect(source.luminance() >= 0 and source.luminance() <= 1);
                try testing.expect(source.contrastRatio(white) >= 1 and source.contrastRatio(white) <= 21);
                const back = source.toLab().toXyz().toRgb();
                try testing.expect(@abs(@as(i16, back.r) - @as(i16, source.toRgb().r)) <= 2);
                const nearest = source.nearestAnsi256();
                try testing.expect(nearest.index <= 255);
                const asHex = source.toHex();
                try testing.expectEqual(source.toRgb(), fromHex(asHex).toRgb());
            }
        }
    }
}

test {
    testing.refAllDecls(@This());
}
