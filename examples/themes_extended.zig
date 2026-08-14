const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== All Built-in Themes ===\n\n", .{});

    const themes = [_]struct { name: []const u8, theme: tint.Theme }{
        .{ .name = "dark", .theme = tint.themes.dark_theme },
        .{ .name = "light", .theme = tint.themes.light_theme },
        .{ .name = "dracula", .theme = tint.themes.dracula_theme },
        .{ .name = "nord", .theme = tint.themes.nord_theme },
        .{ .name = "monokai", .theme = tint.themes.monokai_theme },
        .{ .name = "tokyo_night", .theme = tint.themes.tokyo_night_theme },
        .{ .name = "gruvbox", .theme = tint.themes.gruvbox_theme },
        .{ .name = "solarized", .theme = tint.themes.solarized_theme },
        .{ .name = "rose_pine", .theme = tint.themes.rose_pine_theme },
        .{ .name = "catppuccin", .theme = tint.themes.catppuccin_theme },
        .{ .name = "github", .theme = tint.themes.github_theme },
        .{ .name = "one_dark", .theme = tint.themes.one_dark_theme },
        .{ .name = "material", .theme = tint.themes.material_theme },
        .{ .name = "palenight", .theme = tint.themes.palenight_theme },
        .{ .name = "everforest", .theme = tint.themes.everforest_theme },
        .{ .name = "kanagawa", .theme = tint.themes.kanagawa_theme },
        .{ .name = "cyberdream", .theme = tint.themes.cyberdream_theme },
    };

    for (themes) |t| {
        std.debug.print("--- {s} ---\n", .{t.name});
        std.debug.print("{s}Primary{s} | {s}Secondary{s} | {s}Success{s} | {s}Warning{s} | {s}Error{s} | {s}Info{s} | {s}Text{s} | {s}Muted{s}\n", .{
            tint.fg(t.theme.primary),   tint.reset,
            tint.fg(t.theme.secondary), tint.reset,
            tint.fg(t.theme.success),   tint.reset,
            tint.fg(t.theme.warning),   tint.reset,
            tint.fg(t.theme.err),       tint.reset,
            tint.fg(t.theme.info),      tint.reset,
            tint.fg(t.theme.text),      tint.reset,
            tint.fg(t.theme.muted),     tint.reset,
        });
        std.debug.print("\n", .{});
    }

    // Use a theme
    std.debug.print("--- Using Tokyo Night ---\n", .{});
    const tokyo = tint.themes.tokyo_night_theme;
    const err_style = tint.style(.{ .fg = tokyo.err, .bold = true });
    std.debug.print("{s}Error in Tokyo Night theme!{s}\n", .{ err_style.toAnsi(), tint.reset });

    // Use dark theme
    std.debug.print("\n--- Using Dark Theme ---\n", .{});
    const dark = tint.themes.dark_theme;
    std.debug.print("{s}Dark theme: success{s}\n", .{ tint.fg(dark.success), tint.reset });
    std.debug.print("{s}Dark theme: warning{s}\n", .{ tint.fg(dark.warning), tint.reset });
    std.debug.print("{s}Dark theme: info{s}\n", .{ tint.fg(dark.info), tint.reset });
}
