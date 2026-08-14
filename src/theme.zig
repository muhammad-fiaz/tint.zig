const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const Color = color.Color;

pub const Theme = struct {
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,
    info: Color,
    text: Color,
    muted: Color,

    pub fn init(name: []const u8, primary: Color, secondary: Color, success: Color, warning: Color, err: Color, info: Color, text: Color, muted: Color) Theme {
        return .{
            .name = name,
            .primary = primary,
            .secondary = secondary,
            .success = success,
            .warning = warning,
            .err = err,
            .info = info,
            .text = text,
            .muted = muted,
        };
    }
};

pub const dark_theme = Theme.init(
    "dark",
    .{ .rgb = color.RgbColor.init(99, 102, 241) },
    .{ .rgb = color.RgbColor.init(139, 92, 246) },
    .{ .rgb = color.RgbColor.init(34, 197, 94) },
    .{ .rgb = color.RgbColor.init(234, 179, 8) },
    .{ .rgb = color.RgbColor.init(239, 68, 68) },
    .{ .rgb = color.RgbColor.init(59, 130, 246) },
    .{ .rgb = color.RgbColor.init(229, 231, 235) },
    .{ .rgb = color.RgbColor.init(156, 163, 175) },
);

pub const light_theme = Theme.init(
    "light",
    .{ .rgb = color.RgbColor.init(79, 70, 229) },
    .{ .rgb = color.RgbColor.init(124, 58, 237) },
    .{ .rgb = color.RgbColor.init(22, 163, 74) },
    .{ .rgb = color.RgbColor.init(202, 138, 4) },
    .{ .rgb = color.RgbColor.init(220, 38, 38) },
    .{ .rgb = color.RgbColor.init(37, 99, 235) },
    .{ .rgb = color.RgbColor.init(17, 24, 39) },
    .{ .rgb = color.RgbColor.init(107, 114, 128) },
);

pub const dracula_theme = Theme.init(
    "dracula",
    .{ .rgb = color.RgbColor.init(98, 114, 164) },
    .{ .rgb = color.RgbColor.init(189, 147, 249) },
    .{ .rgb = color.RgbColor.init(80, 250, 123) },
    .{ .rgb = color.RgbColor.init(241, 250, 140) },
    .{ .rgb = color.RgbColor.init(255, 85, 85) },
    .{ .rgb = color.RgbColor.init(139, 233, 253) },
    .{ .rgb = color.RgbColor.init(248, 248, 242) },
    .{ .rgb = color.RgbColor.init(98, 114, 164) },
);

pub const nord_theme = Theme.init(
    "nord",
    .{ .rgb = color.RgbColor.init(94, 129, 172) },
    .{ .rgb = color.RgbColor.init(136, 192, 208) },
    .{ .rgb = color.RgbColor.init(163, 190, 140) },
    .{ .rgb = color.RgbColor.init(235, 203, 139) },
    .{ .rgb = color.RgbColor.init(191, 97, 106) },
    .{ .rgb = color.RgbColor.init(129, 161, 193) },
    .{ .rgb = color.RgbColor.init(236, 239, 244) },
    .{ .rgb = color.RgbColor.init(76, 86, 106) },
);

pub const monokai_theme = Theme.init(
    "monokai",
    .{ .rgb = color.RgbColor.init(166, 226, 46) },
    .{ .rgb = color.RgbColor.init(174, 129, 255) },
    .{ .rgb = color.RgbColor.init(166, 226, 46) },
    .{ .rgb = color.RgbColor.init(230, 219, 100) },
    .{ .rgb = color.RgbColor.init(249, 38, 114) },
    .{ .rgb = color.RgbColor.init(102, 217, 239) },
    .{ .rgb = color.RgbColor.init(248, 248, 242) },
    .{ .rgb = color.RgbColor.init(117, 113, 94) },
);

test "theme has name" {
    try testing.expectEqualStrings("dark", dark_theme.name);
}

test "theme has colors" {
    const r1 = dark_theme.primary.toRgb();
    try testing.expectEqual(@as(u8, 99), r1.r);
    const r2 = dark_theme.err.toRgb();
    try testing.expectEqual(@as(u8, 239), r2.r);
}

test "all built-in themes" {
    _ = light_theme;
    _ = dracula_theme;
    _ = nord_theme;
    _ = monokai_theme;
}
