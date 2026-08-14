const std = @import("std");
const testing = std.testing;

pub const color = @import("color.zig");
pub const style_mod = @import("style.zig");
pub const palette = @import("palette.zig");
pub const theme_mod = @import("theme.zig");

pub const Color = color.Color;
pub const RgbColor = color.RgbColor;
pub const HexColor = color.HexColor;
pub const Ansi256Color = color.Ansi256Color;
pub const HslColor = color.HslColor;
pub const HsvColor = color.HsvColor;
pub const CmykColor = color.CmykColor;
pub const XyzColor = color.XyzColor;
pub const LabColor = color.LabColor;
pub const Style = style_mod.Style;
pub const Theme = theme_mod.Theme;
pub const Named = color.Named;
pub const presets = style_mod.presets;

pub const ESC = "\x1b[";
pub const END = "m";

pub const reset = ESC ++ "0" ++ END;
pub const reset_bold = ESC ++ "22" ++ END;
pub const reset_dim = ESC ++ "22" ++ END;
pub const reset_italic = ESC ++ "23" ++ END;
pub const reset_underline = ESC ++ "24" ++ END;
pub const reset_blink = ESC ++ "25" ++ END;
pub const reset_reverse = ESC ++ "27" ++ END;
pub const reset_hidden = ESC ++ "28" ++ END;
pub const reset_strikethrough = ESC ++ "29" ++ END;
pub const reset_overline = ESC ++ "55" ++ END;
pub const reset_fg = ESC ++ "39" ++ END;
pub const reset_bg = ESC ++ "49" ++ END;
pub const reset_underline_color = ESC ++ "59" ++ END;
pub const reset_all = ESC ++ "0" ++ END;

pub const themes = theme_mod;

pub fn fg(c: Color) []const u8 {
    return c.toFg();
}

pub fn bg(c: Color) []const u8 {
    return c.toBg();
}

pub fn underline(c: Color) []const u8 {
    return c.toUnderline();
}

pub fn fgRgb(r: u8, g: u8, b: u8) []const u8 {
    return fg(.{ .rgb = RgbColor.init(r, g, b) });
}

pub fn bgRgb(r: u8, g: u8, b: u8) []const u8 {
    return bg(.{ .rgb = RgbColor.init(r, g, b) });
}

pub fn fgHex(value: u24) []const u8 {
    return fg(hex(value));
}

pub fn bgHex(value: u24) []const u8 {
    return bg(hex(value));
}

pub fn fg256(index: u8) []const u8 {
    return fg(ansi256(index));
}

pub fn bg256(index: u8) []const u8 {
    return bg(ansi256(index));
}

pub fn style(opts: style_mod.StyleOptions) Style {
    return Style.init(opts);
}

pub fn rgb(r: u8, g: u8, b: u8) Color {
    return Color{ .rgb = RgbColor.init(r, g, b) };
}

pub fn hex(value: u24) Color {
    return Color{ .hex = HexColor.fromInt(value) };
}

pub fn ansi256(index: u8) Color {
    return Color{ .ansi256 = Ansi256Color.init(index) };
}

pub fn hsl(h: u16, s: u8, l: u8) Color {
    return Color{ .hsl = HslColor.init(h, s, l) };
}

pub fn hsv(h: u16, s: u8, v: u8) Color {
    return Color{ .hsv = HsvColor.init(h, s, v) };
}

pub fn cmyk(c: u8, m: u8, y: u8, k: u8) Color {
    return Color{ .rgb = CmykColor.init(c, m, y, k).toRgb() };
}

pub fn kelvin(temp: u16) Color {
    return Color{ .rgb = Color.temperatureToRgb(temp) };
}

pub fn named_color(comptime name: []const u8) Color {
    return Color{ .rgb = @field(Named, name) };
}

pub fn fgGradient(text: []const u8, colors: []const Color) []const u8 {
    return Color.fgGradient(text, colors);
}

pub fn bgGradient(text: []const u8, colors: []const Color) []const u8 {
    return Color.bgGradient(text, colors);
}

pub fn fade(c: Color, amount: f64) Color {
    return c.fade(amount);
}

pub fn blend(c1: Color, c2: Color, ratio: f64) Color {
    return c1.blend(c2, ratio);
}

pub fn mixHsl(c1: Color, c2: Color, ratio: f64) Color {
    return c1.mixHsl(c2, ratio);
}

pub fn saturateTo(c: Color, target: u8) Color {
    return c.saturateTo(target);
}

pub fn lightenTo(c: Color, target: u8) Color {
    return c.lightenTo(target);
}

pub fn grayscaleLuminance(c: Color) Color {
    return c.grayscaleLuminance();
}

test "reset codes" {
    try testing.expectEqualStrings("\x1b[0m", reset);
    try testing.expectEqualStrings("\x1b[22m", reset_bold);
    try testing.expectEqualStrings("\x1b[23m", reset_italic);
    try testing.expectEqualStrings("\x1b[24m", reset_underline);
    try testing.expectEqualStrings("\x1b[25m", reset_blink);
    try testing.expectEqualStrings("\x1b[27m", reset_reverse);
    try testing.expectEqualStrings("\x1b[28m", reset_hidden);
    try testing.expectEqualStrings("\x1b[29m", reset_strikethrough);
    try testing.expectEqualStrings("\x1b[55m", reset_overline);
    try testing.expectEqualStrings("\x1b[39m", reset_fg);
    try testing.expectEqualStrings("\x1b[49m", reset_bg);
    try testing.expectEqualStrings("\x1b[59m", reset_underline_color);
}

test "ANSI 4-bit foreground" {
    try testing.expectEqualStrings("\x1b[30m", fg(.{ .ansi4 = .black }));
    try testing.expectEqualStrings("\x1b[31m", fg(.{ .ansi4 = .red }));
    try testing.expectEqualStrings("\x1b[32m", fg(.{ .ansi4 = .green }));
    try testing.expectEqualStrings("\x1b[33m", fg(.{ .ansi4 = .yellow }));
    try testing.expectEqualStrings("\x1b[34m", fg(.{ .ansi4 = .blue }));
    try testing.expectEqualStrings("\x1b[35m", fg(.{ .ansi4 = .magenta }));
    try testing.expectEqualStrings("\x1b[36m", fg(.{ .ansi4 = .cyan }));
    try testing.expectEqualStrings("\x1b[37m", fg(.{ .ansi4 = .white }));
}

test "ANSI 4-bit background" {
    try testing.expectEqualStrings("\x1b[40m", bg(.{ .ansi4 = .black }));
    try testing.expectEqualStrings("\x1b[41m", bg(.{ .ansi4 = .red }));
    try testing.expectEqualStrings("\x1b[42m", bg(.{ .ansi4 = .green }));
    try testing.expectEqualStrings("\x1b[43m", bg(.{ .ansi4 = .yellow }));
    try testing.expectEqualStrings("\x1b[44m", bg(.{ .ansi4 = .blue }));
    try testing.expectEqualStrings("\x1b[45m", bg(.{ .ansi4 = .magenta }));
    try testing.expectEqualStrings("\x1b[46m", bg(.{ .ansi4 = .cyan }));
    try testing.expectEqualStrings("\x1b[47m", bg(.{ .ansi4 = .white }));
}

test "bright ANSI foreground" {
    try testing.expectEqualStrings("\x1b[90m", fg(.{ .ansi4 = .bright_black }));
    try testing.expectEqualStrings("\x1b[91m", fg(.{ .ansi4 = .bright_red }));
    try testing.expectEqualStrings("\x1b[92m", fg(.{ .ansi4 = .bright_green }));
    try testing.expectEqualStrings("\x1b[93m", fg(.{ .ansi4 = .bright_yellow }));
    try testing.expectEqualStrings("\x1b[94m", fg(.{ .ansi4 = .bright_blue }));
    try testing.expectEqualStrings("\x1b[95m", fg(.{ .ansi4 = .bright_magenta }));
    try testing.expectEqualStrings("\x1b[96m", fg(.{ .ansi4 = .bright_cyan }));
    try testing.expectEqualStrings("\x1b[97m", fg(.{ .ansi4 = .bright_white }));
}

test "bright ANSI background" {
    try testing.expectEqualStrings("\x1b[100m", bg(.{ .ansi4 = .bright_black }));
    try testing.expectEqualStrings("\x1b[101m", bg(.{ .ansi4 = .bright_red }));
    try testing.expectEqualStrings("\x1b[102m", bg(.{ .ansi4 = .bright_green }));
    try testing.expectEqualStrings("\x1b[103m", bg(.{ .ansi4 = .bright_yellow }));
    try testing.expectEqualStrings("\x1b[104m", bg(.{ .ansi4 = .bright_blue }));
    try testing.expectEqualStrings("\x1b[105m", bg(.{ .ansi4 = .bright_magenta }));
    try testing.expectEqualStrings("\x1b[106m", bg(.{ .ansi4 = .bright_cyan }));
    try testing.expectEqualStrings("\x1b[107m", bg(.{ .ansi4 = .bright_white }));
}

test "default colors" {
    try testing.expectEqualStrings("\x1b[39m", fg(.{ .ansi4 = .default }));
    try testing.expectEqualStrings("\x1b[49m", bg(.{ .ansi4 = .default }));
}

test "ANSI 256 foreground" {
    try testing.expectEqualStrings("\x1b[38;5;0m", fg(.{ .ansi256 = .init(0) }));
    try testing.expectEqualStrings("\x1b[38;5;15m", fg(.{ .ansi256 = .init(15) }));
    try testing.expectEqualStrings("\x1b[38;5;16m", fg(.{ .ansi256 = .init(16) }));
    try testing.expectEqualStrings("\x1b[38;5;231m", fg(.{ .ansi256 = .init(231) }));
    try testing.expectEqualStrings("\x1b[38;5;232m", fg(.{ .ansi256 = .init(232) }));
    try testing.expectEqualStrings("\x1b[38;5;255m", fg(.{ .ansi256 = .init(255) }));
}

test "ANSI 256 background" {
    try testing.expectEqualStrings("\x1b[48;5;0m", bg(.{ .ansi256 = .init(0) }));
    try testing.expectEqualStrings("\x1b[48;5;255m", bg(.{ .ansi256 = .init(255) }));
}

test "RGB foreground" {
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", fg(.{ .rgb = .init(255, 0, 0) }));
    try testing.expectEqualStrings("\x1b[38;2;0;255;0m", fg(.{ .rgb = .init(0, 255, 0) }));
    try testing.expectEqualStrings("\x1b[38;2;0;0;255m", fg(.{ .rgb = .init(0, 0, 255) }));
}

test "RGB background" {
    try testing.expectEqualStrings("\x1b[48;2;255;0;0m", bg(.{ .rgb = .init(255, 0, 0) }));
    try testing.expectEqualStrings("\x1b[48;2;0;255;0m", bg(.{ .rgb = .init(0, 255, 0) }));
}

test "hex foreground" {
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", fg(hex(0xFF0000)));
    try testing.expectEqualStrings("\x1b[38;2;0;255;0m", fg(hex(0x00FF00)));
}

test "underline color" {
    try testing.expectEqualStrings("\x1b[58;2;255;100;20m", underline(.{ .rgb = .init(255, 100, 20) }));
    try testing.expectEqualStrings("\x1b[58;5;208m", underline(.{ .ansi256 = .init(208) }));
}

test "style composition" {
    const s = style(.{
        .fg = .{ .rgb = .init(255, 0, 0) },
        .bold = true,
    });
    try testing.expect(s.bold);
    try testing.expect(!s.italic);
}

test "style with method" {
    const base = style(.{
        .fg = .{ .rgb = .init(0, 255, 0) },
        .bold = true,
    });
    const extended = base.with(.{
        .underline = true,
    });
    try testing.expect(extended.bold);
    try testing.expect(extended.underline);
}

test "style toAnsi produces correct sequence" {
    const s = style(.{
        .fg = .{ .ansi256 = .init(196) },
        .bold = true,
    });
    const result = s.toAnsi();
    try testing.expect(result.len > 0);
}

test "named colors" {
    try testing.expectEqual(@as(u8, 255), Named.red.r);
    try testing.expectEqual(@as(u8, 0), Named.red.g);
    try testing.expectEqual(@as(u8, 0), Named.red.b);
}

test "palette access" {
    const c = palette.ansi16[1];
    try testing.expectEqual(@as(u8, 170), c.r);
}

test "color manipulation" {
    const c = rgb(100, 100, 100);
    const lightened = c.lighten(0.2);
    const rgb_val = lightened.toRgb();
    try testing.expect(rgb_val.r >= 100);
}

test "color invert" {
    const c = rgb(255, 0, 0);
    const inv = c.invert();
    const rgb_val = inv.toRgb();
    try testing.expectEqual(@as(u8, 0), rgb_val.r);
    try testing.expectEqual(@as(u8, 255), rgb_val.g);
    try testing.expectEqual(@as(u8, 255), rgb_val.b);
}

test "color grayscale" {
    const c = rgb(100, 150, 200);
    const g = c.grayscale();
    const rgb_val = g.toRgb();
    try testing.expectEqual(rgb_val.r, rgb_val.g);
    try testing.expectEqual(rgb_val.g, rgb_val.b);
}

test "color mix" {
    const c1 = rgb(255, 0, 0);
    const c2 = rgb(0, 0, 255);
    const mixed = c1.mix(c2, 0.5);
    const rgb_val = mixed.toRgb();
    try testing.expectEqual(@as(u8, 127), rgb_val.r);
    try testing.expectEqual(@as(u8, 0), rgb_val.g);
    try testing.expectEqual(@as(u8, 127), rgb_val.b);
}

test "convenience functions" {
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", fgRgb(255, 0, 0));
    try testing.expectEqualStrings("\x1b[48;2;0;255;0m", bgRgb(0, 255, 0));
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", fgHex(0xFF0000));
    try testing.expectEqualStrings("\x1b[48;2;0;255;0m", bgHex(0x00FF00));
    try testing.expectEqualStrings("\x1b[38;5;196m", fg256(196));
    try testing.expectEqualStrings("\x1b[48;5;196m", bg256(196));
}
