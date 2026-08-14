const std = @import("std");
const testing = std.testing;

pub const RgbColor = struct {
    r: u8,
    g: u8,
    b: u8,

    pub fn init(r: u8, g: u8, b: u8) RgbColor {
        return .{ .r = r, .g = g, .b = b };
    }

    const NUM_BUFS = 8;
    threadlocal var fg_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var fg_idx: usize = 0;
    threadlocal var bg_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var bg_idx: usize = 0;
    threadlocal var ul_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var ul_idx: usize = 0;

    fn nextFg() *[20]u8 {
        const b = &fg_bufs[fg_idx % NUM_BUFS];
        fg_idx +%= 1;
        return b;
    }
    fn nextBg() *[20]u8 {
        const b = &bg_bufs[bg_idx % NUM_BUFS];
        bg_idx +%= 1;
        return b;
    }
    fn nextUl() *[20]u8 {
        const b = &ul_bufs[ul_idx % NUM_BUFS];
        ul_idx +%= 1;
        return b;
    }

    pub fn toFg(self: RgbColor) []const u8 {
        const result = std.fmt.bufPrint(nextFg(), "\x1b[38;2;{d};{d};{d}m", .{ self.r, self.g, self.b }) catch "\x1b[39m";
        return result;
    }

    pub fn toBg(self: RgbColor) []const u8 {
        const result = std.fmt.bufPrint(nextBg(), "\x1b[48;2;{d};{d};{d}m", .{ self.r, self.g, self.b }) catch "\x1b[49m";
        return result;
    }

    pub fn toUnderline(self: RgbColor) []const u8 {
        const result = std.fmt.bufPrint(nextUl(), "\x1b[58;2;{d};{d};{d}m", .{ self.r, self.g, self.b }) catch "\x1b[59m";
        return result;
    }

    pub fn luminance(self: RgbColor) f64 {
        const r = @as(f64, @floatFromInt(self.r)) / 255.0;
        const g = @as(f64, @floatFromInt(self.g)) / 255.0;
        const b = @as(f64, @floatFromInt(self.b)) / 255.0;
        return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }
};

pub const HexColor = struct {
    value: u24,

    pub fn init(hex_string: []const u8) !HexColor {
        const s = if (hex_string.len > 0 and hex_string[0] == '#') hex_string[1..] else hex_string;
        if (s.len != 3 and s.len != 6) return error.InvalidHexLength;
        if (s.len == 3) {
            const r = try parseHexDigit(s[0]);
            const g = try parseHexDigit(s[1]);
            const b = try parseHexDigit(s[2]);
            return .{ .value = @as(u24, @intCast(r * 17)) << 16 | @as(u24, @intCast(g * 17)) << 8 | @as(u24, @intCast(b * 17)) };
        }
        const r = try parseHexPair(s[0..2]);
        const g = try parseHexPair(s[2..4]);
        const b = try parseHexPair(s[4..6]);
        return .{ .value = @as(u24, @intCast(r)) << 16 | @as(u24, @intCast(g)) << 8 | @as(u24, @intCast(b)) };
    }

    pub fn fromInt(value: u24) HexColor {
        return .{ .value = value };
    }

    pub fn toRgb(self: HexColor) RgbColor {
        return .{
            .r = @intCast((self.value >> 16) & 0xFF),
            .g = @intCast((self.value >> 8) & 0xFF),
            .b = @intCast(self.value & 0xFF),
        };
    }

    pub fn toString(self: HexColor) [7]u8 {
        return std.fmt.bytesToHex(std.fmt.bytesToHex([3]u8{ self.toRgb().r, self.toRgb().g, self.toRgb().b }));
    }

    fn parseHexDigit(c: u8) !u8 {
        return switch (c) {
            '0'...'9' => c - '0',
            'a'...'f' => c - 'a' + 10,
            'A'...'F' => c - 'A' + 10,
            else => error.InvalidHexDigit,
        };
    }

    fn parseHexPair(s: []const u8) !u8 {
        const hi = try parseHexDigit(s[0]);
        const lo = try parseHexDigit(s[1]);
        return hi * 16 + lo;
    }
};

pub const Ansi256Color = struct {
    index: u8,

    pub fn init(index: u8) Ansi256Color {
        return .{ .index = index };
    }

    pub fn toRgb(self: Ansi256Color) RgbColor {
        if (self.index < 16) return ansi16_to_rgb[self.index];
        if (self.index >= 232) {
            const gray: u8 = @intCast(8 + (self.index - 232) * 10);
            return .{ .r = gray, .g = gray, .b = gray };
        }
        const idx = self.index - 16;
        const b: u8 = @intCast(idx % 6);
        const g: u8 = @intCast((idx / 6) % 6);
        const r: u8 = @intCast(idx / 36);
        return .{
            .r = if (r == 0) 0 else @intCast(55 + r * 40),
            .g = if (g == 0) 0 else @intCast(55 + g * 40),
            .b = if (b == 0) 0 else @intCast(55 + b * 40),
        };
    }
};

pub const HslColor = struct {
    h: u16,
    s: u8,
    l: u8,

    pub fn init(h: u16, s: u8, l: u8) HslColor {
        return .{ .h = h % 360, .s = s, .l = l };
    }

    pub fn toRgb(self: HslColor) RgbColor {
        const h_f: f64 = @floatFromInt(self.h);
        const s_f: f64 = @as(f64, @floatFromInt(self.s)) / 100.0;
        const l_f: f64 = @as(f64, @floatFromInt(self.l)) / 100.0;
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
        return .{
            .r = @intCast(@as(u8, @intFromFloat((r + m) * 255.0))),
            .g = @intCast(@as(u8, @intFromFloat((g + m) * 255.0))),
            .b = @intCast(@as(u8, @intFromFloat((b + m) * 255.0))),
        };
    }
};

pub const HsvColor = struct {
    h: u16,
    s: u8,
    v: u8,

    pub fn init(h: u16, s: u8, v: u8) HsvColor {
        return .{ .h = h % 360, .s = s, .v = v };
    }

    pub fn toRgb(self: HsvColor) RgbColor {
        const h_f: f64 = @floatFromInt(self.h);
        const s_f: f64 = @as(f64, @floatFromInt(self.s)) / 100.0;
        const v_f: f64 = @as(f64, @floatFromInt(self.v)) / 100.0;
        const c = v_f * s_f;
        const x = c * (1.0 - @abs(@rem(h_f / 60.0, 2.0) - 1.0));
        const m = v_f - c;
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
        return .{
            .r = @intCast(@as(u8, @intFromFloat((r + m) * 255.0))),
            .g = @intCast(@as(u8, @intFromFloat((g + m) * 255.0))),
            .b = @intCast(@as(u8, @intFromFloat((b + m) * 255.0))),
        };
    }
};

pub const CmykColor = struct {
    c: u8,
    m: u8,
    y: u8,
    k: u8,

    pub fn init(c: u8, m: u8, y: u8, k: u8) CmykColor {
        return .{ .c = c, .m = m, .y = y, .k = k };
    }

    pub fn toRgb(self: CmykColor) RgbColor {
        const c_f = @as(f64, @floatFromInt(self.c)) / 100.0;
        const m_f = @as(f64, @floatFromInt(self.m)) / 100.0;
        const y_f = @as(f64, @floatFromInt(self.y)) / 100.0;
        const k_f = @as(f64, @floatFromInt(self.k)) / 100.0;
        const r = @as(u8, @intFromFloat((1.0 - c_f) * (1.0 - k_f) * 255.0));
        const g = @as(u8, @intFromFloat((1.0 - m_f) * (1.0 - k_f) * 255.0));
        const b = @as(u8, @intFromFloat((1.0 - y_f) * (1.0 - k_f) * 255.0));
        return .{ .r = r, .g = g, .b = b };
    }

    pub fn fromRgb(rgb: RgbColor) CmykColor {
        const r_f = @as(f64, @floatFromInt(rgb.r)) / 255.0;
        const g_f = @as(f64, @floatFromInt(rgb.g)) / 255.0;
        const b_f = @as(f64, @floatFromInt(rgb.b)) / 255.0;
        const k = 1.0 - @max(r_f, @max(g_f, b_f));
        if (k == 1.0) return .{ .c = 0, .m = 0, .y = 0, .k = 100 };
        const c = @as(u8, @intFromFloat((1.0 - r_f - k) / (1.0 - k) * 100.0));
        const m = @as(u8, @intFromFloat((1.0 - g_f - k) / (1.0 - k) * 100.0));
        const y = @as(u8, @intFromFloat((1.0 - b_f - k) / (1.0 - k) * 100.0));
        return .{ .c = c, .m = m, .y = y, .k = @intFromFloat(k * 100.0) };
    }
};

pub const XyzColor = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn init(x: f64, y: f64, z: f64) XyzColor {
        return .{ .x = x, .y = y, .z = z };
    }

    pub fn fromRgb(rgb: RgbColor) XyzColor {
        var r = @as(f64, @floatFromInt(rgb.r)) / 255.0;
        var g = @as(f64, @floatFromInt(rgb.g)) / 255.0;
        var b = @as(f64, @floatFromInt(rgb.b)) / 255.0;
        r = if (r > 0.04045) std.math.pow(f64, (r + 0.055) / 1.055, 2.4) else r / 12.92;
        g = if (g > 0.04045) std.math.pow(f64, (g + 0.055) / 1.055, 2.4) else g / 12.92;
        b = if (b > 0.04045) std.math.pow(f64, (b + 0.055) / 1.055, 2.4) else b / 12.92;
        return .{
            .x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375,
            .y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750,
            .z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041,
        };
    }

    pub fn toRgb(self: XyzColor) RgbColor {
        var r = self.x * 3.2404542 + self.y * -1.5371385 + self.z * -0.4985314;
        var g = self.x * -0.9692660 + self.y * 1.8760108 + self.z * 0.0415560;
        var b = self.x * 0.0556434 + self.y * -0.2040259 + self.z * 1.0572252;
        r = if (r > 0.0031308) 1.055 * std.math.pow(f64, r, 1.0 / 2.4) - 0.055 else 12.92 * r;
        g = if (g > 0.0031308) 1.055 * std.math.pow(f64, g, 1.0 / 2.4) - 0.055 else 12.92 * g;
        b = if (b > 0.0031308) 1.055 * std.math.pow(f64, b, 1.0 / 2.4) - 0.055 else 12.92 * b;
        return .{
            .r = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(r * 255.0))))),
            .g = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(g * 255.0))))),
            .b = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(b * 255.0))))),
        };
    }
};

pub const LabColor = struct {
    l: f64,
    a: f64,
    b_val: f64,

    pub fn init(l: f64, a: f64, b_val: f64) LabColor {
        return .{ .l = l, .a = a, .b_val = b_val };
    }

    pub fn fromXyz(xyz: XyzColor) LabColor {
        const ref_x = 0.95047;
        const ref_y = 1.00000;
        const ref_z = 1.08883;
        const x = xyz.x / ref_x;
        const y = xyz.y / ref_y;
        const z = xyz.z / ref_z;
        const x_f = if (x > 0.008856) std.math.pow(f64, x, 1.0 / 3.0) else (903.3 * x + 16.0) / 116.0;
        const y_f = if (y > 0.008856) std.math.pow(f64, y, 1.0 / 3.0) else (903.3 * y + 16.0) / 116.0;
        const z_f = if (z > 0.008856) std.math.pow(f64, z, 1.0 / 3.0) else (903.3 * z + 16.0) / 116.0;
        return .{
            .l = 116.0 * y_f - 16.0,
            .a = 500.0 * (x_f - y_f),
            .b_val = 200.0 * (y_f - z_f),
        };
    }

    pub fn toXyz(self: LabColor) XyzColor {
        const y = (self.l + 16.0) / 116.0;
        const x = self.a / 500.0 + y;
        const z = y - self.b_val / 200.0;
        const x_f = if (x * x * x > 0.008856) std.math.pow(f64, x, 3.0) else (116.0 * x - 16.0) / 903.3;
        const y_f = if (self.l > 7.9996) std.math.pow(f64, y, 3.0) else self.l / 903.3;
        const z_f = if (z * z * z > 0.008856) std.math.pow(f64, z, 3.0) else (116.0 * z - 16.0) / 903.3;
        return .{
            .x = x_f * 0.95047,
            .y = y_f * 1.00000,
            .z = z_f * 1.08883,
        };
    }

    pub fn distance(self: LabColor, other: LabColor) f64 {
        const dl = self.l - other.l;
        const da = self.a - other.a;
        const db = self.b_val - other.b_val;
        return @sqrt(dl * dl + da * da + db * db);
    }
};

pub const Ansi4 = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    bright_black,
    bright_red,
    bright_green,
    bright_yellow,
    bright_blue,
    bright_magenta,
    bright_cyan,
    bright_white,
    default,
};

pub const Color = union(enum) {
    ansi4: Ansi4,
    ansi256: Ansi256Color,
    rgb: RgbColor,
    hex: HexColor,
    hsl: HslColor,
    hsv: HsvColor,

    const NUM_BUFS = 8;
    threadlocal var fg_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var fg_idx: usize = 0;
    threadlocal var bg_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var bg_idx: usize = 0;
    threadlocal var ul_bufs: [NUM_BUFS][20]u8 = undefined;
    threadlocal var ul_idx: usize = 0;

    fn nextFgb() *[20]u8 {
        const b = &fg_bufs[fg_idx % NUM_BUFS];
        fg_idx +%= 1;
        return b;
    }
    fn nextBgb() *[20]u8 {
        const b = &bg_bufs[bg_idx % NUM_BUFS];
        bg_idx +%= 1;
        return b;
    }
    fn nextUlb() *[20]u8 {
        const b = &ul_bufs[ul_idx % NUM_BUFS];
        ul_idx +%= 1;
        return b;
    }

    pub fn toFg(self: Color) []const u8 {
        return switch (self) {
            .ansi4 => |a| ansi4_fg(a),
            .ansi256 => |a| {
                const result = std.fmt.bufPrint(nextFgb(), "\x1b[38;5;{d}m", .{a.index}) catch "\x1b[39m";
                return result;
            },
            .rgb => |r| {
                const result = std.fmt.bufPrint(nextFgb(), "\x1b[38;2;{d};{d};{d}m", .{ r.r, r.g, r.b }) catch "\x1b[39m";
                return result;
            },
            .hex => |h| {
                const rgb = h.toRgb();
                return rgb.toFg();
            },
            .hsl => |h| h.toRgb().toFg(),
            .hsv => |h| h.toRgb().toFg(),
        };
    }

    pub fn toBg(self: Color) []const u8 {
        return switch (self) {
            .ansi4 => |a| ansi4_bg(a),
            .ansi256 => |a| {
                const result = std.fmt.bufPrint(nextBgb(), "\x1b[48;5;{d}m", .{a.index}) catch "\x1b[49m";
                return result;
            },
            .rgb => |r| {
                const result = std.fmt.bufPrint(nextBgb(), "\x1b[48;2;{d};{d};{d}m", .{ r.r, r.g, r.b }) catch "\x1b[49m";
                return result;
            },
            .hex => |h| {
                const rgb = h.toRgb();
                return rgb.toBg();
            },
            .hsl => |h| h.toRgb().toBg(),
            .hsv => |h| h.toRgb().toBg(),
        };
    }

    pub fn toUnderline(self: Color) []const u8 {
        return switch (self) {
            .ansi4 => |a| ansi4_ul(a),
            .ansi256 => |a| {
                const result = std.fmt.bufPrint(nextUlb(), "\x1b[58;5;{d}m", .{a.index}) catch "\x1b[59m";
                return result;
            },
            .rgb => |r| {
                const result = std.fmt.bufPrint(nextUlb(), "\x1b[58;2;{d};{d};{d}m", .{ r.r, r.g, r.b }) catch "\x1b[59m";
                return result;
            },
            .hex => |h| {
                const rgb = h.toRgb();
                return rgb.toUnderline();
            },
            .hsl => |h| h.toRgb().toUnderline(),
            .hsv => |h| h.toRgb().toUnderline(),
        };
    }

    fn ansi4_fg(a: Ansi4) []const u8 {
        return switch (a) {
            .black => "\x1b[30m",
            .red => "\x1b[31m",
            .green => "\x1b[32m",
            .yellow => "\x1b[33m",
            .blue => "\x1b[34m",
            .magenta => "\x1b[35m",
            .cyan => "\x1b[36m",
            .white => "\x1b[37m",
            .bright_black => "\x1b[90m",
            .bright_red => "\x1b[91m",
            .bright_green => "\x1b[92m",
            .bright_yellow => "\x1b[93m",
            .bright_blue => "\x1b[94m",
            .bright_magenta => "\x1b[95m",
            .bright_cyan => "\x1b[96m",
            .bright_white => "\x1b[97m",
            .default => "\x1b[39m",
        };
    }

    fn ansi4_bg(a: Ansi4) []const u8 {
        return switch (a) {
            .black => "\x1b[40m",
            .red => "\x1b[41m",
            .green => "\x1b[42m",
            .yellow => "\x1b[43m",
            .blue => "\x1b[44m",
            .magenta => "\x1b[45m",
            .cyan => "\x1b[46m",
            .white => "\x1b[47m",
            .bright_black => "\x1b[100m",
            .bright_red => "\x1b[101m",
            .bright_green => "\x1b[102m",
            .bright_yellow => "\x1b[103m",
            .bright_blue => "\x1b[104m",
            .bright_magenta => "\x1b[105m",
            .bright_cyan => "\x1b[106m",
            .bright_white => "\x1b[107m",
            .default => "\x1b[49m",
        };
    }

    fn ansi4_ul(a: Ansi4) []const u8 {
        return switch (a) {
            .black => "\x1b[58;5;0m",
            .red => "\x1b[58;5;1m",
            .green => "\x1b[58;5;2m",
            .yellow => "\x1b[58;5;3m",
            .blue => "\x1b[58;5;4m",
            .magenta => "\x1b[58;5;5m",
            .cyan => "\x1b[58;5;6m",
            .white => "\x1b[58;5;7m",
            .bright_black => "\x1b[58;5;8m",
            .bright_red => "\x1b[58;5;9m",
            .bright_green => "\x1b[58;5;10m",
            .bright_yellow => "\x1b[58;5;11m",
            .bright_blue => "\x1b[58;5;12m",
            .bright_magenta => "\x1b[58;5;13m",
            .bright_cyan => "\x1b[58;5;14m",
            .bright_white => "\x1b[58;5;15m",
            .default => "\x1b[59m",
        };
    }

    pub fn toRgb(self: Color) RgbColor {
        return switch (self) {
            .ansi4 => |a| switch (a) {
                .black => .{ .r = 0, .g = 0, .b = 0 },
                .red => .{ .r = 170, .g = 0, .b = 0 },
                .green => .{ .r = 0, .g = 170, .b = 0 },
                .yellow => .{ .r = 170, .g = 170, .b = 0 },
                .blue => .{ .r = 0, .g = 0, .b = 170 },
                .magenta => .{ .r = 170, .g = 0, .b = 170 },
                .cyan => .{ .r = 0, .g = 170, .b = 170 },
                .white => .{ .r = 170, .g = 170, .b = 170 },
                .bright_black => .{ .r = 85, .g = 85, .b = 85 },
                .bright_red => .{ .r = 255, .g = 85, .b = 85 },
                .bright_green => .{ .r = 85, .g = 255, .b = 85 },
                .bright_yellow => .{ .r = 255, .g = 255, .b = 85 },
                .bright_blue => .{ .r = 85, .g = 85, .b = 255 },
                .bright_magenta => .{ .r = 255, .g = 85, .b = 255 },
                .bright_cyan => .{ .r = 85, .g = 255, .b = 255 },
                .bright_white => .{ .r = 255, .g = 255, .b = 255 },
                .default => .{ .r = 0, .g = 0, .b = 0 },
            },
            .ansi256 => |a| a.toRgb(),
            .rgb => |r| r,
            .hex => |h| h.toRgb(),
            .hsl => |h| h.toRgb(),
            .hsv => |h| h.toRgb(),
        };
    }

    pub fn toHex(self: Color) u24 {
        const rgb = self.toRgb();
        return @as(u24, @intCast(rgb.r)) << 16 | @as(u24, @intCast(rgb.g)) << 8 | @as(u24, @intCast(rgb.b));
    }

    pub fn toHsl(self: Color) HslColor {
        const c = self.toRgb();
        return rgb_to_hsl(c.r, c.g, c.b);
    }

    pub fn toHsv(self: Color) HsvColor {
        const c = self.toRgb();
        return rgb_to_hsv(c.r, c.g, c.b);
    }

    pub fn toCmyk(self: Color) CmykColor {
        return CmykColor.fromRgb(self.toRgb());
    }

    pub fn toLab(self: Color) LabColor {
        const xyz = XyzColor.fromRgb(self.toRgb());
        return LabColor.fromXyz(xyz);
    }

    pub fn toXyz(self: Color) XyzColor {
        return XyzColor.fromRgb(self.toRgb());
    }

    pub fn luminance(self: Color) f64 {
        return self.toRgb().luminance();
    }

    pub fn lighten(self: Color, amount: f64) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        const new_l = @min(100, @as(u8, @intFromFloat(@as(f64, @floatFromInt(hsl.l)) + amount * 100.0)));
        return .{ .hsl = HslColor.init(hsl.h, hsl.s, new_l) };
    }

    pub fn darken(self: Color, amount: f64) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        const new_l = @max(0, @as(u8, @intFromFloat(@as(f64, @floatFromInt(hsl.l)) - amount * 100.0)));
        return .{ .hsl = HslColor.init(hsl.h, hsl.s, new_l) };
    }

    pub fn saturate(self: Color, amount: f64) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        const new_s = @min(100, @as(u8, @intFromFloat(@as(f64, @floatFromInt(hsl.s)) + amount * 100.0)));
        return .{ .hsl = HslColor.init(hsl.h, new_s, hsl.l) };
    }

    pub fn desaturate(self: Color, amount: f64) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        const new_s = @max(0, @as(u8, @intFromFloat(@as(f64, @floatFromInt(hsl.s)) - amount * 100.0)));
        return .{ .hsl = HslColor.init(hsl.h, new_s, hsl.l) };
    }

    pub fn invert(self: Color) Color {
        const c = self.toRgb();
        return .{ .rgb = RgbColor.init(255 - c.r, 255 - c.g, 255 - c.b) };
    }

    pub fn grayscale(self: Color) Color {
        const c = self.toRgb();
        const gray: u8 = @intCast((@as(u16, c.r) * 77 + @as(u16, c.g) * 150 + @as(u16, c.b) * 29) >> 8);
        return .{ .rgb = RgbColor.init(gray, gray, gray) };
    }

    pub fn mix(self: Color, other: Color, ratio: f64) Color {
        const c1 = self.toRgb();
        const c2 = other.toRgb();
        const r = @as(u8, @intFromFloat(@as(f64, @floatFromInt(c1.r)) * (1.0 - ratio) + @as(f64, @floatFromInt(c2.r)) * ratio));
        const g = @as(u8, @intFromFloat(@as(f64, @floatFromInt(c1.g)) * (1.0 - ratio) + @as(f64, @floatFromInt(c2.g)) * ratio));
        const b = @as(u8, @intFromFloat(@as(f64, @floatFromInt(c1.b)) * (1.0 - ratio) + @as(f64, @floatFromInt(c2.b)) * ratio));
        return .{ .rgb = RgbColor.init(r, g, b) };
    }

    pub fn rotate(self: Color, degrees: u16) Color {
        const hsl = self.toHsl();
        return .{ .hsl = HslColor.init((hsl.h + degrees) % 360, hsl.s, hsl.l) };
    }

    pub fn adjustHue(self: Color, degrees: i32) Color {
        const hsl = self.toHsl();
        const new_h = @as(i32, @intCast(hsl.h)) + degrees;
        const wrapped = @mod(new_h, @as(i32, 360));
        return .{ .hsl = HslColor.init(@intCast(wrapped), hsl.s, hsl.l) };
    }

    pub fn temperatureToRgb(temp: u16) RgbColor {
        const t = @as(f64, @floatFromInt(temp)) / 100.0;
        var r: f64 = 0;
        var g: f64 = 0;
        var b: f64 = 0;
        if (t <= 66) {
            r = 255;
            g = 99.4708025861 * @log(t) - 161.1195681661;
            if (t <= 19) {
                b = 0;
            } else {
                b = 138.5177312231 * @log(t - 10) - 305.0447927307;
            }
        } else {
            r = 329.698727446 * std.math.pow(f64, t - 60, -0.1332047592);
            g = 288.1221695283 * std.math.pow(f64, t - 60, -0.0755148492);
            b = 255;
        }
        return .{
            .r = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(r))))),
            .g = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(g))))),
            .b = @intCast(@max(0, @min(255, @as(u8, @intFromFloat(b))))),
        };
    }

    pub fn kelvin(temp: u16) Color {
        return .{ .rgb = Color.temperatureToRgb(temp) };
    }

    pub fn complementary(self: Color) Color {
        return self.rotate(180);
    }

    pub fn analogous(self: Color) [2]Color {
        return .{ self.rotate(30), self.rotate(330) };
    }

    pub fn triadic(self: Color) [2]Color {
        return .{ self.rotate(120), self.rotate(240) };
    }

    pub fn splitComplementary(self: Color) [2]Color {
        return .{ self.rotate(150), self.rotate(210) };
    }

    pub fn tetradic(self: Color) [3]Color {
        return .{ self.rotate(90), self.rotate(180), self.rotate(270) };
    }

    pub fn monochromatic(self: Color, count: u8) [8]Color {
        var result: [8]Color = undefined;
        const n = @min(count, @as(u8, 8));
        var i: u8 = 0;
        while (i < n) : (i += 1) {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(n -| 1));
            result[i] = if (t < 0.5)
                self.lighten(t * 2.0)
            else
                self.darken((t - 0.5) * 2.0);
        }
        return result;
    }

    pub fn isLight(self: Color) bool {
        return self.luminance() > 0.5;
    }

    pub fn isDark(self: Color) bool {
        return self.luminance() <= 0.5;
    }

    pub fn colorDistance(self: Color, other: Color) f64 {
        return self.toLab().distance(other.toLab());
    }

    pub fn contrastRatio(self: Color, other: Color) f64 {
        const l1 = self.luminance();
        const l2 = other.luminance();
        const lighter = @max(l1, l2);
        const darker = @min(l1, l2);
        return (lighter + 0.05) / (darker + 0.05);
    }

    pub fn lerp(c1: Color, c2: Color, t: f64) Color {
        const r1 = c1.toRgb();
        const r2 = c2.toRgb();
        const r = @as(u8, @intFromFloat(@as(f64, @floatFromInt(r1.r)) * (1.0 - t) + @as(f64, @floatFromInt(r2.r)) * t));
        const g = @as(u8, @intFromFloat(@as(f64, @floatFromInt(r1.g)) * (1.0 - t) + @as(f64, @floatFromInt(r2.g)) * t));
        const b = @as(u8, @intFromFloat(@as(f64, @floatFromInt(r1.b)) * (1.0 - t) + @as(f64, @floatFromInt(r2.b)) * t));
        return .{ .rgb = RgbColor.init(r, g, b) };
    }

    pub fn nearestAnsi256(self: Color) u8 {
        const target = self.toRgb();
        var best_index: u8 = 0;
        var best_distance: f64 = std.math.floatMax(f64);
        var i: u16 = 0;
        while (i < 256) : (i += 1) {
            const palette_rgb = ansi256_to_rgb(@intCast(i));
            const dr = @as(f64, @floatFromInt(target.r)) - @as(f64, @floatFromInt(palette_rgb.r));
            const dg = @as(f64, @floatFromInt(target.g)) - @as(f64, @floatFromInt(palette_rgb.g));
            const db = @as(f64, @floatFromInt(target.b)) - @as(f64, @floatFromInt(palette_rgb.b));
            const distance = dr * dr + dg * dg + db * db;
            if (distance < best_distance) {
                best_distance = distance;
                best_index = @intCast(i);
            }
        }
        return best_index;
    }

    pub fn fade(self: Color, amount: f64) Color {
        const c = self.toRgb();
        const a = @max(0.0, @min(1.0, amount));
        const gray: u8 = @intFromFloat(a * 255.0);
        return .{ .rgb = RgbColor.init(
            @intFromFloat(@as(f64, @floatFromInt(c.r)) * a + @as(f64, @floatFromInt(gray)) * (1.0 - a)),
            @intFromFloat(@as(f64, @floatFromInt(c.g)) * a + @as(f64, @floatFromInt(gray)) * (1.0 - a)),
            @intFromFloat(@as(f64, @floatFromInt(c.b)) * a + @as(f64, @floatFromInt(gray)) * (1.0 - a)),
        ) };
    }

    pub fn blend(self: Color, other: Color, ratio: f64) Color {
        return self.mix(other, ratio);
    }

    pub fn grayscaleLuminance(self: Color) Color {
        const c = self.toRgb();
        const lum = c.luminance();
        const gray: u8 = @intFromFloat(lum * 255.0);
        return .{ .rgb = RgbColor.init(gray, gray, gray) };
    }

    pub fn saturateTo(self: Color, target_saturation: u8) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        return .{ .hsl = HslColor.init(hsl.h, target_saturation, hsl.l) };
    }

    pub fn lightenTo(self: Color, target_lightness: u8) Color {
        const c = self.toRgb();
        const hsl = rgb_to_hsl(c.r, c.g, c.b);
        return .{ .hsl = HslColor.init(hsl.h, hsl.s, target_lightness) };
    }

    pub fn mixHsl(self: Color, other: Color, ratio: f64) Color {
        const h1 = self.toHsl();
        const h2 = other.toHsl();
        const new_h: u16 = @intFromFloat(@as(f64, @floatFromInt(h1.h)) * (1.0 - ratio) + @as(f64, @floatFromInt(h2.h)) * ratio);
        const new_s: u8 = @intFromFloat(@as(f64, @floatFromInt(h1.s)) * (1.0 - ratio) + @as(f64, @floatFromInt(h2.s)) * ratio);
        const new_l: u8 = @intFromFloat(@as(f64, @floatFromInt(h1.l)) * (1.0 - ratio) + @as(f64, @floatFromInt(h2.l)) * ratio);
        return .{ .hsl = HslColor.init(new_h, new_s, new_l) };
    }
};

fn ansi256_to_rgb(index: u16) RgbColor {
    if (index < 16) return ansi16_to_rgb[index];
    if (index >= 232) {
        const gray: u8 = @intCast(8 + (index - 232) * 10);
        return .{ .r = gray, .g = gray, .b = gray };
    }
    const idx = index - 16;
    const b: u8 = @intCast(idx % 6);
    const g: u8 = @intCast((idx / 6) % 6);
    const r: u8 = @intCast(idx / 36);
    return .{
        .r = if (r == 0) 0 else @intCast(55 + r * 40),
        .g = if (g == 0) 0 else @intCast(55 + g * 40),
        .b = if (b == 0) 0 else @intCast(55 + b * 40),
    };
}

fn rgb_to_hsl(r: u8, g: u8, b: u8) HslColor {
    const rf: f64 = @as(f64, @floatFromInt(r)) / 255.0;
    const gf: f64 = @as(f64, @floatFromInt(g)) / 255.0;
    const bf: f64 = @as(f64, @floatFromInt(b)) / 255.0;
    const max = @max(rf, @max(gf, bf));
    const min = @min(rf, @min(gf, bf));
    const l = (max + min) / 2.0;
    if (max == min) return .{ .h = 0, .s = 0, .l = @intFromFloat(l * 100.0) };
    const d = max - min;
    const s = if (l > 0.5) d / (2.0 - max - min) else d / (max + min);
    var h: f64 = 0;
    if (max == rf) {
        h = (gf - bf) / d;
        if (gf < bf) h += 6.0;
    } else if (max == gf) {
        h = (bf - rf) / d + 2.0;
    } else {
        h = (rf - gf) / d + 4.0;
    }
    h *= 60.0;
    return .{ .h = @intFromFloat(h), .s = @intFromFloat(s * 100.0), .l = @intFromFloat(l * 100.0) };
}

fn rgb_to_hsv(r: u8, g: u8, b: u8) HsvColor {
    const rf: f64 = @as(f64, @floatFromInt(r)) / 255.0;
    const gf: f64 = @as(f64, @floatFromInt(g)) / 255.0;
    const bf: f64 = @as(f64, @floatFromInt(b)) / 255.0;
    const max = @max(rf, @max(gf, bf));
    const min = @min(rf, @min(gf, bf));
    const d = max - min;
    var h: f64 = 0;
    if (d != 0) {
        if (max == rf) {
            h = (gf - bf) / d;
            if (gf < bf) h += 6.0;
        } else if (max == gf) {
            h = (bf - rf) / d + 2.0;
        } else {
            h = (rf - gf) / d + 4.0;
        }
        h *= 60.0;
    }
    const s = if (max == 0) 0 else d / max;
    return .{ .h = @intFromFloat(h), .s = @intFromFloat(s * 100.0), .v = @intFromFloat(max * 100.0) };
}

pub const Named = struct {
    pub const alice_blue: RgbColor = .{ .r = 240, .g = 248, .b = 255 };
    pub const antique_white: RgbColor = .{ .r = 250, .g = 235, .b = 215 };
    pub const aqua: RgbColor = .{ .r = 0, .g = 255, .b = 255 };
    pub const aquamarine: RgbColor = .{ .r = 127, .g = 255, .b = 212 };
    pub const azure: RgbColor = .{ .r = 240, .g = 255, .b = 255 };
    pub const beige: RgbColor = .{ .r = 245, .g = 245, .b = 220 };
    pub const bisque: RgbColor = .{ .r = 255, .g = 228, .b = 196 };
    pub const black: RgbColor = .{ .r = 0, .g = 0, .b = 0 };
    pub const blanched_almond: RgbColor = .{ .r = 255, .g = 235, .b = 205 };
    pub const blue: RgbColor = .{ .r = 0, .g = 0, .b = 255 };
    pub const blue_violet: RgbColor = .{ .r = 138, .g = 43, .b = 226 };
    pub const brown: RgbColor = .{ .r = 165, .g = 42, .b = 42 };
    pub const burly_wood: RgbColor = .{ .r = 222, .g = 184, .b = 135 };
    pub const cadet_blue: RgbColor = .{ .r = 95, .g = 158, .b = 160 };
    pub const chartreuse: RgbColor = .{ .r = 127, .g = 255, .b = 0 };
    pub const chocolate: RgbColor = .{ .r = 210, .g = 105, .b = 30 };
    pub const coral: RgbColor = .{ .r = 255, .g = 127, .b = 80 };
    pub const cornflower_blue: RgbColor = .{ .r = 100, .g = 149, .b = 237 };
    pub const cornsilk: RgbColor = .{ .r = 255, .g = 248, .b = 220 };
    pub const crimson: RgbColor = .{ .r = 220, .g = 20, .b = 60 };
    pub const cyan: RgbColor = .{ .r = 0, .g = 255, .b = 255 };
    pub const dark_blue: RgbColor = .{ .r = 0, .g = 0, .b = 139 };
    pub const dark_cyan: RgbColor = .{ .r = 0, .g = 139, .b = 139 };
    pub const dark_goldenrod: RgbColor = .{ .r = 184, .g = 134, .b = 11 };
    pub const dark_gray: RgbColor = .{ .r = 169, .g = 169, .b = 169 };
    pub const dark_green: RgbColor = .{ .r = 0, .g = 100, .b = 0 };
    pub const dark_khaki: RgbColor = .{ .r = 189, .g = 183, .b = 107 };
    pub const dark_magenta: RgbColor = .{ .r = 139, .g = 0, .b = 139 };
    pub const dark_olive_green: RgbColor = .{ .r = 85, .g = 107, .b = 47 };
    pub const dark_orange: RgbColor = .{ .r = 255, .g = 140, .b = 0 };
    pub const dark_orchid: RgbColor = .{ .r = 153, .g = 50, .b = 204 };
    pub const dark_red: RgbColor = .{ .r = 139, .g = 0, .b = 0 };
    pub const dark_salmon: RgbColor = .{ .r = 233, .g = 150, .b = 122 };
    pub const dark_sea_green: RgbColor = .{ .r = 143, .g = 188, .b = 143 };
    pub const dark_slate_blue: RgbColor = .{ .r = 72, .g = 61, .b = 139 };
    pub const dark_slate_gray: RgbColor = .{ .r = 47, .g = 79, .b = 79 };
    pub const dark_turquoise: RgbColor = .{ .r = 0, .g = 206, .b = 209 };
    pub const dark_violet: RgbColor = .{ .r = 148, .g = 0, .b = 211 };
    pub const deep_pink: RgbColor = .{ .r = 255, .g = 20, .b = 147 };
    pub const deep_sky_blue: RgbColor = .{ .r = 0, .g = 191, .b = 255 };
    pub const dim_gray: RgbColor = .{ .r = 105, .g = 105, .b = 105 };
    pub const dodger_blue: RgbColor = .{ .r = 30, .g = 144, .b = 255 };
    pub const firebrick: RgbColor = .{ .r = 178, .g = 34, .b = 34 };
    pub const floral_white: RgbColor = .{ .r = 255, .g = 250, .b = 240 };
    pub const forest_green: RgbColor = .{ .r = 34, .g = 139, .b = 34 };
    pub const fuchsia: RgbColor = .{ .r = 255, .g = 0, .b = 255 };
    pub const gainsboro: RgbColor = .{ .r = 220, .g = 220, .b = 220 };
    pub const ghost_white: RgbColor = .{ .r = 248, .g = 248, .b = 255 };
    pub const gold: RgbColor = .{ .r = 255, .g = 215, .b = 0 };
    pub const goldenrod: RgbColor = .{ .r = 218, .g = 165, .b = 32 };
    pub const gray: RgbColor = .{ .r = 128, .g = 128, .b = 128 };
    pub const green: RgbColor = .{ .r = 0, .g = 128, .b = 0 };
    pub const green_yellow: RgbColor = .{ .r = 173, .g = 255, .b = 47 };
    pub const honeydew: RgbColor = .{ .r = 240, .g = 255, .b = 240 };
    pub const hot_pink: RgbColor = .{ .r = 255, .g = 105, .b = 180 };
    pub const indian_red: RgbColor = .{ .r = 205, .g = 92, .b = 92 };
    pub const indigo: RgbColor = .{ .r = 75, .g = 0, .b = 130 };
    pub const ivory: RgbColor = .{ .r = 255, .g = 255, .b = 240 };
    pub const khaki: RgbColor = .{ .r = 240, .g = 230, .b = 140 };
    pub const lavender: RgbColor = .{ .r = 230, .g = 230, .b = 250 };
    pub const lavender_blush: RgbColor = .{ .r = 255, .g = 240, .b = 245 };
    pub const lawn_green: RgbColor = .{ .r = 124, .g = 252, .b = 0 };
    pub const lemon_chiffon: RgbColor = .{ .r = 255, .g = 250, .b = 205 };
    pub const light_blue: RgbColor = .{ .r = 173, .g = 216, .b = 230 };
    pub const light_coral: RgbColor = .{ .r = 240, .g = 128, .b = 128 };
    pub const light_cyan: RgbColor = .{ .r = 224, .g = 255, .b = 255 };
    pub const light_goldenrod_yellow: RgbColor = .{ .r = 250, .g = 250, .b = 210 };
    pub const light_gray: RgbColor = .{ .r = 211, .g = 211, .b = 211 };
    pub const light_green: RgbColor = .{ .r = 144, .g = 238, .b = 144 };
    pub const light_pink: RgbColor = .{ .r = 255, .g = 182, .b = 193 };
    pub const light_salmon: RgbColor = .{ .r = 255, .g = 160, .b = 122 };
    pub const light_sea_green: RgbColor = .{ .r = 32, .g = 178, .b = 170 };
    pub const light_sky_blue: RgbColor = .{ .r = 135, .g = 206, .b = 250 };
    pub const light_slate_gray: RgbColor = .{ .r = 119, .g = 136, .b = 153 };
    pub const light_steel_blue: RgbColor = .{ .r = 176, .g = 196, .b = 222 };
    pub const light_yellow: RgbColor = .{ .r = 255, .g = 255, .b = 224 };
    pub const lime: RgbColor = .{ .r = 0, .g = 255, .b = 0 };
    pub const lime_green: RgbColor = .{ .r = 50, .g = 205, .b = 50 };
    pub const linen: RgbColor = .{ .r = 250, .g = 240, .b = 230 };
    pub const magenta: RgbColor = .{ .r = 255, .g = 0, .b = 255 };
    pub const maroon: RgbColor = .{ .r = 128, .g = 0, .b = 0 };
    pub const medium_aquamarine: RgbColor = .{ .r = 102, .g = 205, .b = 170 };
    pub const medium_blue: RgbColor = .{ .r = 0, .g = 0, .b = 205 };
    pub const medium_orchid: RgbColor = .{ .r = 186, .g = 85, .b = 211 };
    pub const medium_purple: RgbColor = .{ .r = 147, .g = 112, .b = 219 };
    pub const medium_sea_green: RgbColor = .{ .r = 60, .g = 179, .b = 113 };
    pub const medium_slate_blue: RgbColor = .{ .r = 123, .g = 104, .b = 238 };
    pub const medium_spring_green: RgbColor = .{ .r = 0, .g = 250, .b = 154 };
    pub const medium_turquoise: RgbColor = .{ .r = 72, .g = 209, .b = 204 };
    pub const medium_violet_red: RgbColor = .{ .r = 199, .g = 21, .b = 133 };
    pub const midnight_blue: RgbColor = .{ .r = 25, .g = 25, .b = 112 };
    pub const mint_cream: RgbColor = .{ .r = 245, .g = 255, .b = 250 };
    pub const misty_rose: RgbColor = .{ .r = 255, .g = 228, .b = 225 };
    pub const moccasin: RgbColor = .{ .r = 255, .g = 228, .b = 181 };
    pub const navajo_white: RgbColor = .{ .r = 255, .g = 222, .b = 173 };
    pub const navy: RgbColor = .{ .r = 0, .g = 0, .b = 128 };
    pub const old_lace: RgbColor = .{ .r = 253, .g = 245, .b = 230 };
    pub const olive: RgbColor = .{ .r = 128, .g = 128, .b = 0 };
    pub const olive_drab: RgbColor = .{ .r = 107, .g = 142, .b = 35 };
    pub const orange: RgbColor = .{ .r = 255, .g = 165, .b = 0 };
    pub const orange_red: RgbColor = .{ .r = 255, .g = 69, .b = 0 };
    pub const orchid: RgbColor = .{ .r = 218, .g = 112, .b = 214 };
    pub const pale_goldenrod: RgbColor = .{ .r = 238, .g = 232, .b = 170 };
    pub const pale_green: RgbColor = .{ .r = 152, .g = 251, .b = 152 };
    pub const pale_turquoise: RgbColor = .{ .r = 175, .g = 238, .b = 238 };
    pub const pale_violet_red: RgbColor = .{ .r = 219, .g = 112, .b = 147 };
    pub const papaya_whip: RgbColor = .{ .r = 255, .g = 239, .b = 213 };
    pub const peach_puff: RgbColor = .{ .r = 255, .g = 218, .b = 185 };
    pub const peru: RgbColor = .{ .r = 205, .g = 133, .b = 63 };
    pub const pink: RgbColor = .{ .r = 255, .g = 192, .b = 203 };
    pub const plum: RgbColor = .{ .r = 221, .g = 160, .b = 221 };
    pub const powder_blue: RgbColor = .{ .r = 176, .g = 224, .b = 230 };
    pub const purple: RgbColor = .{ .r = 128, .g = 0, .b = 128 };
    pub const rebecca_purple: RgbColor = .{ .r = 102, .g = 51, .b = 153 };
    pub const red: RgbColor = .{ .r = 255, .g = 0, .b = 0 };
    pub const rosy_brown: RgbColor = .{ .r = 188, .g = 143, .b = 143 };
    pub const royal_blue: RgbColor = .{ .r = 65, .g = 105, .b = 225 };
    pub const saddle_brown: RgbColor = .{ .r = 139, .g = 69, .b = 19 };
    pub const salmon: RgbColor = .{ .r = 250, .g = 128, .b = 114 };
    pub const sandy_brown: RgbColor = .{ .r = 244, .g = 164, .b = 96 };
    pub const sea_green: RgbColor = .{ .r = 46, .g = 139, .b = 87 };
    pub const seashell: RgbColor = .{ .r = 255, .g = 245, .b = 238 };
    pub const sienna: RgbColor = .{ .r = 160, .g = 82, .b = 45 };
    pub const silver: RgbColor = .{ .r = 192, .g = 192, .b = 192 };
    pub const sky_blue: RgbColor = .{ .r = 135, .g = 206, .b = 235 };
    pub const slate_blue: RgbColor = .{ .r = 106, .g = 90, .b = 205 };
    pub const slate_gray: RgbColor = .{ .r = 112, .g = 128, .b = 144 };
    pub const snow: RgbColor = .{ .r = 255, .g = 250, .b = 250 };
    pub const spring_green: RgbColor = .{ .r = 0, .g = 255, .b = 127 };
    pub const steel_blue: RgbColor = .{ .r = 70, .g = 130, .b = 180 };
    pub const tan: RgbColor = .{ .r = 210, .g = 180, .b = 140 };
    pub const teal: RgbColor = .{ .r = 0, .g = 128, .b = 128 };
    pub const thistle: RgbColor = .{ .r = 216, .g = 191, .b = 216 };
    pub const tomato: RgbColor = .{ .r = 255, .g = 99, .b = 71 };
    pub const turquoise: RgbColor = .{ .r = 64, .g = 224, .b = 208 };
    pub const violet: RgbColor = .{ .r = 238, .g = 130, .b = 238 };
    pub const wheat: RgbColor = .{ .r = 245, .g = 222, .b = 179 };
    pub const white: RgbColor = .{ .r = 255, .g = 255, .b = 255 };
    pub const white_smoke: RgbColor = .{ .r = 245, .g = 245, .b = 245 };
    pub const yellow: RgbColor = .{ .r = 255, .g = 255, .b = 0 };
    pub const yellow_green: RgbColor = .{ .r = 154, .g = 205, .b = 50 };
};

const ansi16_to_rgb = [16]RgbColor{
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

test "HexColor init" {
    const c = try HexColor.init("#FF0000");
    try testing.expectEqual(@as(u24, 0xFF0000), c.value);
}

test "HexColor short format" {
    const c = try HexColor.init("#F00");
    try testing.expectEqual(@as(u24, 0xFF0000), c.value);
}

test "HexColor without hash" {
    const c = try HexColor.init("FF0000");
    try testing.expectEqual(@as(u24, 0xFF0000), c.value);
}

test "HexColor invalid length" {
    try testing.expectError(error.InvalidHexLength, HexColor.init("#FF"));
    try testing.expectError(error.InvalidHexLength, HexColor.init("#FFFF"));
}

test "HexColor invalid digit" {
    try testing.expectError(error.InvalidHexDigit, HexColor.init("#GG0000"));
}

test "HslColor wraps hue" {
    const c = HslColor.init(370, 50, 50);
    try testing.expectEqual(@as(u16, 10), c.h);
}

test "HsvColor wraps hue" {
    const c = HsvColor.init(720, 50, 50);
    try testing.expectEqual(@as(u16, 0), c.h);
}

test "Color union toFg" {
    const c1 = Color{ .ansi4 = .red };
    try testing.expectEqualStrings("\x1b[31m", c1.toFg());
    const c2 = Color{ .ansi256 = Ansi256Color.init(196) };
    try testing.expectEqualStrings("\x1b[38;5;196m", c2.toFg());
}

test "Color union toBg" {
    const c1 = Color{ .ansi4 = .blue };
    try testing.expectEqualStrings("\x1b[44m", c1.toBg());
}

test "Color union toUnderline" {
    const c = Color{ .ansi256 = Ansi256Color.init(208) };
    try testing.expectEqualStrings("\x1b[58;5;208m", c.toUnderline());
}

test "Color invert" {
    const c = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const inv = c.invert();
    try testing.expectEqual(@as(u8, 0), inv.toRgb().r);
    try testing.expectEqual(@as(u8, 255), inv.toRgb().g);
    try testing.expectEqual(@as(u8, 255), inv.toRgb().b);
}

test "Color grayscale" {
    const c = Color{ .rgb = RgbColor.init(100, 150, 200) };
    const g = c.grayscale();
    try testing.expectEqual(g.toRgb().r, g.toRgb().g);
    try testing.expectEqual(g.toRgb().g, g.toRgb().b);
}

test "Color mix" {
    const c1 = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const c2 = Color{ .rgb = RgbColor.init(0, 0, 255) };
    const mixed = c1.mix(c2, 0.5);
    try testing.expectEqual(@as(u8, 127), mixed.toRgb().r);
    try testing.expectEqual(@as(u8, 0), mixed.toRgb().g);
    try testing.expectEqual(@as(u8, 127), mixed.toRgb().b);
}

test "CmykColor conversion" {
    const cmyk = CmykColor.init(0, 100, 100, 0);
    const rgb = cmyk.toRgb();
    try testing.expectEqual(@as(u8, 255), rgb.r);
    try testing.expectEqual(@as(u8, 0), rgb.g);
    try testing.expectEqual(@as(u8, 0), rgb.b);
}

test "CmykColor fromRgb" {
    const rgb = RgbColor.init(255, 0, 0);
    const cmyk = CmykColor.fromRgb(rgb);
    try testing.expectEqual(@as(u8, 0), cmyk.c);
    try testing.expectEqual(@as(u8, 100), cmyk.m);
    try testing.expectEqual(@as(u8, 100), cmyk.y);
    try testing.expectEqual(@as(u8, 0), cmyk.k);
}

test "XyzColor conversion" {
    const xyz = XyzColor.init(0.4124, 0.2126, 0.0193);
    const rgb = xyz.toRgb();
    try testing.expect(rgb.r > 0);
}

test "LabColor distance" {
    const lab1 = LabColor.init(50.0, 0.0, 0.0);
    const lab2 = LabColor.init(50.0, 10.0, 0.0);
    const d = lab1.distance(lab2);
    try testing.expect(d > 0);
}

test "Color rotation" {
    const c = Color{ .hsl = HslColor.init(0, 100, 50) };
    const rotated = c.rotate(180);
    try testing.expectEqual(@as(u16, 180), rotated.toHsl().h);
}

test "Color harmony" {
    const c = Color{ .rgb = RgbColor.init(255, 0, 0) };
    _ = c.complementary();
    _ = c.analogous();
    _ = c.triadic();
    _ = c.splitComplementary();
    _ = c.tetradic();
}

test "Color light and dark" {
    const light = Color{ .rgb = RgbColor.init(255, 255, 255) };
    const dark = Color{ .rgb = RgbColor.init(0, 0, 0) };
    try testing.expect(light.isLight());
    try testing.expect(dark.isDark());
}

test "Color contrast ratio" {
    const white = Color{ .rgb = RgbColor.init(255, 255, 255) };
    const black = Color{ .rgb = RgbColor.init(0, 0, 0) };
    const ratio = white.contrastRatio(black);
    try testing.expect(ratio > 20.0);
}

test "Color lerp" {
    const c1 = Color{ .rgb = RgbColor.init(0, 0, 0) };
    const c2 = Color{ .rgb = RgbColor.init(255, 255, 255) };
    const mid = Color.lerp(c1, c2, 0.5);
    try testing.expectEqual(@as(u8, 127), mid.toRgb().r);
}

test "Color nearestAnsi256" {
    const red = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const idx = red.nearestAnsi256();
    try testing.expect(idx < 256);
}

test "Color toHex" {
    const c = Color{ .rgb = RgbColor.init(255, 128, 0) };
    try testing.expectEqual(@as(u24, 0xFF8000), c.toHex());
}

test "Color temperature" {
    const warm = Color.temperatureToRgb(3000);
    const cool = Color.temperatureToRgb(7000);
    try testing.expect(warm.r > cool.r);
}

test "RgbColor luminance" {
    const white = RgbColor.init(255, 255, 255);
    const black = RgbColor.init(0, 0, 0);
    try testing.expect(white.luminance() > black.luminance());
}

test "Color fade" {
    const c = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const faded = c.fade(0.5);
    const rgb = faded.toRgb();
    try testing.expect(rgb.r > 0);
    try testing.expect(rgb.r < 255);
}

test "Color blend" {
    const c1 = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const c2 = Color{ .rgb = RgbColor.init(0, 0, 255) };
    const blended = c1.blend(c2, 0.5);
    const rgb = blended.toRgb();
    try testing.expectEqual(@as(u8, 127), rgb.r);
    try testing.expectEqual(@as(u8, 127), rgb.b);
}

test "Color mixHsl" {
    const c1 = Color{ .hsl = HslColor.init(0, 100, 50) };
    const c2 = Color{ .hsl = HslColor.init(120, 100, 50) };
    const mixed = c1.mixHsl(c2, 0.5);
    const hsl = mixed.toHsl();
    try testing.expect(hsl.h >= 50 and hsl.h <= 70);
}

test "Color saturateTo" {
    const c = Color{ .rgb = RgbColor.init(128, 128, 128) };
    const saturated = c.saturateTo(100);
    const hsl = saturated.toHsl();
    try testing.expectEqual(@as(u8, 100), hsl.s);
}

test "Color lightenTo" {
    const c = Color{ .rgb = RgbColor.init(0, 0, 0) };
    const lightened = c.lightenTo(50);
    const hsl = lightened.toHsl();
    try testing.expect(hsl.l >= 49 and hsl.l <= 51);
}

test "Color grayscaleLuminance" {
    const c = Color{ .rgb = RgbColor.init(255, 0, 0) };
    const g = c.grayscaleLuminance();
    const rgb = g.toRgb();
    try testing.expectEqual(rgb.r, rgb.g);
    try testing.expectEqual(rgb.g, rgb.b);
}
