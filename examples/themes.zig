const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Using built-in themes
    std.debug.print("=== Dark Theme ===\n", .{});
    const dark = tint.themes.dark_theme;
    std.debug.print("{s}Primary{s}\n", .{ tint.fg(dark.primary), tint.reset });
    std.debug.print("{s}Secondary{s}\n", .{ tint.fg(dark.secondary), tint.reset });
    std.debug.print("{s}Success{s}\n", .{ tint.fg(dark.success), tint.reset });
    std.debug.print("{s}Warning{s}\n", .{ tint.fg(dark.warning), tint.reset });
    std.debug.print("{s}Error{s}\n", .{ tint.fg(dark.err), tint.reset });
    std.debug.print("{s}Info{s}\n", .{ tint.fg(dark.info), tint.reset });
    std.debug.print("{s}Muted{s}\n", .{ tint.fg(dark.muted), tint.reset });

    // Custom theme
    std.debug.print("\n=== Custom Theme ===\n", .{});
    const custom = tint.Theme{
        .name = "custom",
        .primary = tint.hex(0x6366F1),
        .secondary = tint.hex(0x8B5CF6),
        .success = tint.hex(0x10B981),
        .warning = tint.hex(0xF59E0B),
        .err = tint.hex(0xEF4444),
        .info = tint.hex(0x3B82F6),
        .text = tint.hex(0xE5E7EB),
        .muted = tint.hex(0x6B7280),
        .background = tint.hex(0x1F2937),
        .surface = tint.hex(0x374151),
    };
    std.debug.print("{s}Custom Primary{s}\n", .{ tint.fg(custom.primary), tint.reset });
    std.debug.print("{s}Custom Error{s}\n", .{ tint.fg(custom.err), tint.reset });

    // Theme switching (explicit data selection)
    std.debug.print("\n=== Theme Switching ===\n", .{});
    var use_dark = true;
    var active_theme = if (use_dark) dark else custom;
    std.debug.print("{s}Active: Primary{s}\n", .{ tint.fg(active_theme.primary), tint.reset });

    use_dark = false;
    active_theme = if (use_dark) dark else custom;
    std.debug.print("{s}Switched: Primary{s}\n", .{ tint.fg(active_theme.primary), tint.reset });
}
