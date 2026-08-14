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
    background: Color,
    surface: Color,

    pub fn init(name: []const u8, primary: Color, secondary: Color, success: Color, warning: Color, err_color: Color, info: Color, text: Color, muted: Color) Theme {
        return .{
            .name = name,
            .primary = primary,
            .secondary = secondary,
            .success = success,
            .warning = warning,
            .err = err_color,
            .info = info,
            .text = text,
            .muted = muted,
            .background = text,
            .surface = muted,
        };
    }

    pub fn initWithBackground(name: []const u8, primary: Color, secondary: Color, success: Color, warning: Color, err_color: Color, info: Color, text: Color, muted: Color, background: Color, surface: Color) Theme {
        return .{
            .name = name,
            .primary = primary,
            .secondary = secondary,
            .success = success,
            .warning = warning,
            .err = err_color,
            .info = info,
            .text = text,
            .muted = muted,
            .background = background,
            .surface = surface,
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

pub const tokyo_night_theme = Theme.init(
    "tokyo_night",
    .{ .rgb = color.RgbColor.init(122, 162, 247) },
    .{ .rgb = color.RgbColor.init(187, 154, 247) },
    .{ .rgb = color.RgbColor.init(158, 206, 106) },
    .{ .rgb = color.RgbColor.init(224, 175, 104) },
    .{ .rgb = color.RgbColor.init(247, 118, 142) },
    .{ .rgb = color.RgbColor.init(125, 207, 255) },
    .{ .rgb = color.RgbColor.init(192, 202, 245) },
    .{ .rgb = color.RgbColor.init(86, 95, 137) },
);

pub const gruvbox_theme = Theme.init(
    "gruvbox",
    .{ .rgb = color.RgbColor.init(131, 165, 152) },
    .{ .rgb = color.RgbColor.init(214, 153, 61) },
    .{ .rgb = color.RgbColor.init(184, 187, 38) },
    .{ .rgb = color.RgbColor.init(250, 189, 47) },
    .{ .rgb = color.RgbColor.init(251, 73, 52) },
    .{ .rgb = color.RgbColor.init(131, 165, 152) },
    .{ .rgb = color.RgbColor.init(235, 219, 178) },
    .{ .rgb = color.RgbColor.init(147, 153, 178) },
);

pub const solarized_theme = Theme.init(
    "solarized",
    .{ .rgb = color.RgbColor.init(38, 139, 210) },
    .{ .rgb = color.RgbColor.init(108, 113, 196) },
    .{ .rgb = color.RgbColor.init(133, 153, 0) },
    .{ .rgb = color.RgbColor.init(181, 137, 0) },
    .{ .rgb = color.RgbColor.init(203, 75, 22) },
    .{ .rgb = color.RgbColor.init(42, 161, 152) },
    .{ .rgb = color.RgbColor.init(253, 246, 227) },
    .{ .rgb = color.RgbColor.init(147, 161, 161) },
);

pub const rose_pine_theme = Theme.init(
    "rose_pine",
    .{ .rgb = color.RgbColor.init(49, 116, 143) },
    .{ .rgb = color.RgbColor.init(196, 167, 231) },
    .{ .rgb = color.RgbColor.init(156, 207, 216) },
    .{ .rgb = color.RgbColor.init(246, 193, 119) },
    .{ .rgb = color.RgbColor.init(235, 111, 146) },
    .{ .rgb = color.RgbColor.init(127, 179, 213) },
    .{ .rgb = color.RgbColor.init(224, 222, 244) },
    .{ .rgb = color.RgbColor.init(110, 106, 134) },
);

pub const catppuccin_theme = Theme.init(
    "catppuccin",
    .{ .rgb = color.RgbColor.init(137, 180, 250) },
    .{ .rgb = color.RgbColor.init(180, 190, 254) },
    .{ .rgb = color.RgbColor.init(166, 227, 161) },
    .{ .rgb = color.RgbColor.init(249, 226, 175) },
    .{ .rgb = color.RgbColor.init(243, 139, 168) },
    .{ .rgb = color.RgbColor.init(116, 199, 236) },
    .{ .rgb = color.RgbColor.init(205, 214, 244) },
    .{ .rgb = color.RgbColor.init(88, 91, 112) },
);

pub const github_theme = Theme.init(
    "github",
    .{ .rgb = color.RgbColor.init(9, 105, 218) },
    .{ .rgb = color.RgbColor.init(130, 80, 223) },
    .{ .rgb = color.RgbColor.init(26, 127, 55) },
    .{ .rgb = color.RgbColor.init(191, 135, 0) },
    .{ .rgb = color.RgbColor.init(248, 81, 73) },
    .{ .rgb = color.RgbColor.init(56, 139, 253) },
    .{ .rgb = color.RgbColor.init(36, 41, 47) },
    .{ .rgb = color.RgbColor.init(110, 118, 129) },
);

pub const one_dark_theme = Theme.init(
    "one_dark",
    .{ .rgb = color.RgbColor.init(97, 175, 239) },
    .{ .rgb = color.RgbColor.init(198, 120, 221) },
    .{ .rgb = color.RgbColor.init(152, 195, 121) },
    .{ .rgb = color.RgbColor.init(229, 192, 123) },
    .{ .rgb = color.RgbColor.init(224, 108, 117) },
    .{ .rgb = color.RgbColor.init(86, 182, 194) },
    .{ .rgb = color.RgbColor.init(171, 178, 191) },
    .{ .rgb = color.RgbColor.init(92, 99, 112) },
);

pub const material_theme = Theme.init(
    "material",
    .{ .rgb = color.RgbColor.init(130, 170, 255) },
    .{ .rgb = color.RgbColor.init(199, 146, 234) },
    .{ .rgb = color.RgbColor.init(152, 195, 121) },
    .{ .rgb = color.RgbColor.init(229, 192, 123) },
    .{ .rgb = color.RgbColor.init(224, 108, 117) },
    .{ .rgb = color.RgbColor.init(86, 182, 194) },
    .{ .rgb = color.RgbColor.init(171, 178, 191) },
    .{ .rgb = color.RgbColor.init(92, 99, 112) },
);

pub const palenight_theme = Theme.init(
    "palenight",
    .{ .rgb = color.RgbColor.init(130, 170, 255) },
    .{ .rgb = color.RgbColor.init(199, 146, 234) },
    .{ .rgb = color.RgbColor.init(152, 195, 121) },
    .{ .rgb = color.RgbColor.init(229, 192, 123) },
    .{ .rgb = color.RgbColor.init(224, 108, 117) },
    .{ .rgb = color.RgbColor.init(86, 182, 194) },
    .{ .rgb = color.RgbColor.init(171, 178, 191) },
    .{ .rgb = color.RgbColor.init(92, 99, 112) },
);

pub const everforest_theme = Theme.init(
    "everforest",
    .{ .rgb = color.RgbColor.init(131, 192, 114) },
    .{ .rgb = color.RgbColor.init(193, 133, 178) },
    .{ .rgb = color.RgbColor.init(169, 177, 143) },
    .{ .rgb = color.RgbColor.init(230, 191, 114) },
    .{ .rgb = color.RgbColor.init(230, 122, 112) },
    .{ .rgb = color.RgbColor.init(127, 187, 169) },
    .{ .rgb = color.RgbColor.init(211, 198, 170) },
    .{ .rgb = color.RgbColor.init(134, 131, 116) },
);

pub const kanagawa_theme = Theme.init(
    "kanagawa",
    .{ .rgb = color.RgbColor.init(126, 156, 216) },
    .{ .rgb = color.RgbColor.init(187, 154, 247) },
    .{ .rgb = color.RgbColor.init(152, 187, 108) },
    .{ .rgb = color.RgbColor.init(220, 190, 110) },
    .{ .rgb = color.RgbColor.init(232, 105, 132) },
    .{ .rgb = color.RgbColor.init(125, 168, 200) },
    .{ .rgb = color.RgbColor.init(220, 215, 190) },
    .{ .rgb = color.RgbColor.init(148, 142, 118) },
);

pub const cyberdream_theme = Theme.init(
    "cyberdream",
    .{ .rgb = color.RgbColor.init(0, 149, 255) },
    .{ .rgb = color.RgbColor.init(130, 100, 255) },
    .{ .rgb = color.RgbColor.init(0, 225, 150) },
    .{ .rgb = color.RgbColor.init(255, 200, 0) },
    .{ .rgb = color.RgbColor.init(255, 80, 80) },
    .{ .rgb = color.RgbColor.init(0, 200, 255) },
    .{ .rgb = color.RgbColor.init(220, 220, 220) },
    .{ .rgb = color.RgbColor.init(100, 100, 120) },
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
    _ = tokyo_night_theme;
    _ = gruvbox_theme;
    _ = solarized_theme;
    _ = rose_pine_theme;
    _ = catppuccin_theme;
    _ = github_theme;
    _ = one_dark_theme;
    _ = material_theme;
    _ = palenight_theme;
    _ = everforest_theme;
    _ = kanagawa_theme;
    _ = cyberdream_theme;
}

test "theme init" {
    const t = Theme.init(
        "test",
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
        .{ .rgb = color.RgbColor.init(0, 0, 0) },
    );
    try testing.expectEqualStrings("test", t.name);
}
