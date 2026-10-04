//! Explicit colour themes. A theme is plain data: the client selects the value
//! it wants and passes it around like any other value.

const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const style = @import("style.zig");
const palette = @import("palette.zig");

const Color = color.Color;
const Rgb = color.Rgb;

/// Semantic roles every theme provides. `err` is used because `error` is a
/// Zig primitive type name.
pub const Role = enum {
    primary,
    secondary,
    success,
    warning,
    err,
    info,
    text,
    muted,
    background,
    surface,

    /// The text roles, the ones usually drawn on a background.
    pub const foregrounds = [_]Role{ .primary, .secondary, .success, .warning, .err, .info, .text, .muted };
};

/// The colours a theme is built from. `background` and `surface` fall back to
/// `text` and `muted`.
pub const Options = struct {
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,
    info: Color,
    text: Color,
    muted: Color,
    background: ?Color = null,
    surface: ?Color = null,
};

/// A named set of semantic colours.
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

    pub fn create(name: []const u8, options: Options) Theme {
        return .{
            .name = name,
            .primary = options.primary,
            .secondary = options.secondary,
            .success = options.success,
            .warning = options.warning,
            .err = options.err,
            .info = options.info,
            .text = options.text,
            .muted = options.muted,
            .background = options.background orelse options.text,
            .surface = options.surface orelse options.muted,
        };
    }

    /// The colour behind a semantic role.
    pub fn role(self: Theme, r: Role) Color {
        return switch (r) {
            .primary => self.primary,
            .secondary => self.secondary,
            .success => self.success,
            .warning => self.warning,
            .err => self.err,
            .info => self.info,
            .text => self.text,
            .muted => self.muted,
            .background => self.background,
            .surface => self.surface,
        };
    }

    /// A style that draws `r` as foreground text.
    pub fn styled(self: Theme, r: Role) style.Style {
        return .{ .foreground = self.role(r) };
    }

    /// WCAG contrast between two roles of this theme.
    pub fn contrast(self: Theme, r: Role, against: Role) f64 {
        return self.role(r).contrastRatio(self.role(against));
    }

    /// Readability grade of `r` drawn on `against`.
    pub fn readability(self: Theme, r: Role, against: Role) palette.Readability {
        return palette.readability(self.role(r), self.role(against));
    }

    /// True when every foreground role reads well on the theme background.
    pub fn meets(self: Theme, minimum: palette.Readability) bool {
        for (Role.foregrounds) |r| {
            if (@backingInt(self.readability(r, .background)) < @backingInt(minimum)) return false;
        }
        return true;
    }
};

fn rgb(r: u8, g: u8, b: u8) Color {
    return .{ .rgb = Rgb.init(r, g, b) };
}

pub const dark = Theme.create("dark", .{ .primary = rgb(99, 102, 241), .secondary = rgb(139, 92, 246), .success = rgb(34, 197, 94), .warning = rgb(234, 179, 8), .err = rgb(239, 68, 68), .info = rgb(59, 130, 246), .text = rgb(229, 231, 235), .muted = rgb(156, 163, 175), .background = rgb(17, 24, 39), .surface = rgb(31, 41, 55) });

pub const light = Theme.create("light", .{ .primary = rgb(79, 70, 229), .secondary = rgb(124, 58, 237), .success = rgb(22, 163, 74), .warning = rgb(202, 138, 4), .err = rgb(220, 38, 38), .info = rgb(37, 99, 235), .text = rgb(17, 24, 39), .muted = rgb(107, 114, 128), .background = rgb(255, 255, 255), .surface = rgb(243, 244, 246) });

pub const dracula = Theme.create("dracula", .{ .primary = rgb(98, 114, 164), .secondary = rgb(189, 147, 249), .success = rgb(80, 250, 123), .warning = rgb(241, 250, 140), .err = rgb(255, 85, 85), .info = rgb(139, 233, 253), .text = rgb(248, 248, 242), .muted = rgb(98, 114, 164), .background = rgb(40, 42, 54), .surface = rgb(68, 71, 90) });

pub const nord = Theme.create("nord", .{ .primary = rgb(94, 129, 172), .secondary = rgb(136, 192, 208), .success = rgb(163, 190, 140), .warning = rgb(235, 203, 139), .err = rgb(191, 97, 106), .info = rgb(129, 161, 193), .text = rgb(236, 239, 244), .muted = rgb(76, 86, 106), .background = rgb(46, 52, 64), .surface = rgb(59, 66, 82) });

pub const monokai = Theme.create("monokai", .{
    .primary = rgb(253, 151, 31),
    .secondary = rgb(174, 129, 255),
    .success = rgb(166, 226, 46),
    .warning = rgb(230, 219, 100),
    .err = rgb(249, 38, 114),
    .info = rgb(102, 217, 239),
    .text = rgb(248, 248, 242),
    .muted = rgb(117, 113, 94),
    .background = rgb(39, 40, 34),
    .surface = rgb(62, 61, 50),
});

pub const tokyoNight = Theme.create("tokyoNight", .{ .primary = rgb(122, 162, 247), .secondary = rgb(187, 154, 247), .success = rgb(158, 206, 106), .warning = rgb(224, 175, 104), .err = rgb(247, 118, 142), .info = rgb(125, 207, 255), .text = rgb(192, 202, 245), .muted = rgb(86, 95, 137), .background = rgb(26, 27, 38), .surface = rgb(36, 40, 59) });

pub const gruvbox = Theme.create("gruvbox", .{
    .primary = rgb(131, 165, 152),
    .secondary = rgb(214, 153, 61),
    .success = rgb(184, 187, 38),
    .warning = rgb(250, 189, 47),
    .err = rgb(251, 73, 52),
    .info = rgb(69, 133, 136),
    .text = rgb(235, 219, 178),
    .muted = rgb(147, 153, 178),
    .background = rgb(40, 40, 40),
    .surface = rgb(60, 56, 54),
});

pub const solarized = Theme.create("solarized", .{ .primary = rgb(38, 139, 210), .secondary = rgb(108, 113, 196), .success = rgb(133, 153, 0), .warning = rgb(181, 137, 0), .err = rgb(203, 75, 22), .info = rgb(42, 161, 152), .text = rgb(253, 246, 227), .muted = rgb(147, 161, 161), .background = rgb(253, 246, 227), .surface = rgb(238, 232, 213) });

pub const rosePine = Theme.create("rosePine", .{ .primary = rgb(49, 116, 143), .secondary = rgb(196, 167, 231), .success = rgb(156, 207, 216), .warning = rgb(246, 193, 119), .err = rgb(235, 111, 146), .info = rgb(127, 179, 213), .text = rgb(224, 222, 244), .muted = rgb(110, 106, 134), .background = rgb(25, 23, 36), .surface = rgb(31, 29, 46) });

pub const catppuccin = Theme.create("catppuccin", .{ .primary = rgb(137, 180, 250), .secondary = rgb(180, 190, 254), .success = rgb(166, 227, 161), .warning = rgb(249, 226, 175), .err = rgb(243, 139, 168), .info = rgb(116, 199, 236), .text = rgb(205, 214, 244), .muted = rgb(88, 91, 112), .background = rgb(30, 30, 46), .surface = rgb(49, 50, 68) });

pub const github = Theme.create("github", .{ .primary = rgb(9, 105, 218), .secondary = rgb(130, 80, 223), .success = rgb(26, 127, 55), .warning = rgb(191, 135, 0), .err = rgb(248, 81, 73), .info = rgb(56, 139, 253), .text = rgb(36, 41, 47), .muted = rgb(110, 118, 129), .background = rgb(255, 255, 255), .surface = rgb(246, 248, 250) });

pub const oneDark = Theme.create("oneDark", .{ .primary = rgb(97, 175, 239), .secondary = rgb(198, 120, 221), .success = rgb(152, 195, 121), .warning = rgb(229, 192, 123), .err = rgb(224, 108, 117), .info = rgb(86, 182, 194), .text = rgb(171, 178, 191), .muted = rgb(92, 99, 112), .background = rgb(40, 44, 52), .surface = rgb(53, 59, 69) });

pub const material = Theme.create("material", .{ .primary = rgb(130, 170, 255), .secondary = rgb(199, 146, 234), .success = rgb(152, 195, 121), .warning = rgb(229, 192, 123), .err = rgb(224, 108, 117), .info = rgb(86, 182, 194), .text = rgb(171, 178, 191), .muted = rgb(92, 99, 112), .background = rgb(33, 33, 33), .surface = rgb(41, 41, 41) });

pub const palenight = Theme.create("palenight", .{ .primary = rgb(130, 170, 255), .secondary = rgb(199, 146, 234), .success = rgb(152, 195, 121), .warning = rgb(229, 192, 123), .err = rgb(224, 108, 117), .info = rgb(86, 182, 194), .text = rgb(171, 178, 191), .muted = rgb(92, 99, 112), .background = rgb(41, 45, 62), .surface = rgb(50, 55, 77) });

pub const everforest = Theme.create("everforest", .{ .primary = rgb(131, 192, 114), .secondary = rgb(193, 133, 178), .success = rgb(169, 177, 143), .warning = rgb(230, 191, 114), .err = rgb(230, 122, 112), .info = rgb(127, 187, 169), .text = rgb(211, 198, 170), .muted = rgb(134, 131, 116), .background = rgb(45, 53, 59), .surface = rgb(61, 72, 77) });

pub const kanagawa = Theme.create("kanagawa", .{ .primary = rgb(126, 156, 216), .secondary = rgb(187, 154, 247), .success = rgb(152, 187, 108), .warning = rgb(220, 190, 110), .err = rgb(232, 105, 132), .info = rgb(125, 168, 200), .text = rgb(220, 215, 190), .muted = rgb(148, 142, 118), .background = rgb(31, 31, 40), .surface = rgb(42, 42, 55) });

pub const cyberdream = Theme.create("cyberdream", .{ .primary = rgb(0, 149, 255), .secondary = rgb(130, 100, 255), .success = rgb(0, 225, 150), .warning = rgb(255, 200, 0), .err = rgb(255, 80, 80), .info = rgb(0, 200, 255), .text = rgb(220, 220, 220), .muted = rgb(100, 100, 120), .background = rgb(22, 24, 29), .surface = rgb(30, 33, 40) });

/// Every built-in theme, in presentation order.
pub const all = [17]Theme{
    dark,       light,      dracula, nord,    monokai,  tokyoNight, gruvbox,    solarized,
    rosePine,   catppuccin, github,  oneDark, material, palenight,  everforest, kanagawa,
    cyberdream,
};

test "create copies every option" {
    const custom = Theme.create("custom", .{
        .primary = rgb(1, 1, 1),
        .secondary = rgb(2, 2, 2),
        .success = rgb(3, 3, 3),
        .warning = rgb(4, 4, 4),
        .err = rgb(5, 5, 5),
        .info = rgb(6, 6, 6),
        .text = rgb(7, 7, 7),
        .muted = rgb(8, 8, 8),
    });
    try testing.expectEqualStrings("custom", custom.name);
    try testing.expectEqual(Rgb.init(1, 1, 1), custom.primary.toRgb());
    try testing.expectEqual(Rgb.init(5, 5, 5), custom.err.toRgb());
    try testing.expectEqual(custom.text, custom.background);
    try testing.expectEqual(custom.muted, custom.surface);

    const explicit = Theme.create("explicit", .{
        .primary = rgb(0, 0, 0),
        .secondary = rgb(0, 0, 0),
        .success = rgb(0, 0, 0),
        .warning = rgb(0, 0, 0),
        .err = rgb(0, 0, 0),
        .info = rgb(0, 0, 0),
        .text = rgb(1, 1, 1),
        .muted = rgb(2, 2, 2),
        .background = rgb(3, 3, 3),
        .surface = rgb(4, 4, 4),
    });
    try testing.expectEqual(Rgb.init(3, 3, 3), explicit.background.toRgb());
    try testing.expectEqual(Rgb.init(4, 4, 4), explicit.surface.toRgb());
}

test "role lookup reaches every field" {
    try testing.expectEqual(dark.primary, dark.role(.primary));
    try testing.expectEqual(dark.secondary, dark.role(.secondary));
    try testing.expectEqual(dark.success, dark.role(.success));
    try testing.expectEqual(dark.warning, dark.role(.warning));
    try testing.expectEqual(dark.err, dark.role(.err));
    try testing.expectEqual(dark.info, dark.role(.info));
    try testing.expectEqual(dark.text, dark.role(.text));
    try testing.expectEqual(dark.muted, dark.role(.muted));
    try testing.expectEqual(dark.background, dark.role(.background));
    try testing.expectEqual(dark.surface, dark.role(.surface));
}

test "styled builds a foreground style" {
    try testing.expectEqual(
        style.Style{ .foreground = dark.err },
        dark.styled(.err),
    );
    try testing.expectEqualStrings(
        dark.err.fg().slice(),
        dark.styled(.err).toAnsi().slice(),
    );
}

test "contrast and readability use the theme's own colours" {
    const ratio = dark.contrast(.text, .background);
    try testing.expectApproxEqAbs(
        dark.text.contrastRatio(dark.background),
        ratio,
        0.0001,
    );
    try testing.expect(ratio > 10);
    try testing.expectEqual(palette.Readability.aaa, dark.readability(.text, .background));
}

test "all contains every exported theme exactly once" {
    try testing.expectEqual(@as(usize, 17), all.len);
    var seen: [17][]const u8 = undefined;
    for (all, 0..) |theme, i| {
        try testing.expect(theme.name.len > 0);
        seen[i] = theme.name;
    }
    for (seen, 0..) |name, i| {
        for (seen[i + 1 ..]) |other| try testing.expect(!std.mem.eql(u8, name, other));
    }
}

test "every role is distinct inside every theme" {
    for (all) |theme| {
        const roles = [_]Color{ theme.primary, theme.secondary, theme.success, theme.warning, theme.err, theme.info };
        for (roles, 0..) |role, i| {
            for (roles[i + 1 ..]) |other| {
                try testing.expect(!std.meta.eql(role.toRgb(), other.toRgb()));
            }
        }
    }
}

test "dark spot values" {
    try testing.expectEqualStrings("dark", dark.name);
    try testing.expectEqual(Rgb.init(99, 102, 241), dark.primary.toRgb());
    try testing.expectEqual(Rgb.init(239, 68, 68), dark.err.toRgb());
    try testing.expectEqual(Rgb.init(17, 24, 39), dark.background.toRgb());
    try testing.expectEqual(Rgb.init(31, 41, 55), dark.surface.toRgb());
}

test "light and dark themes differ in lightness" {
    try testing.expect(light.text.isDark());
    try testing.expect(dark.text.isLight());
}

test {
    testing.refAllDecls(@This());
}
