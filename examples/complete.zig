const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== tint.zig Complete Demo ===\n\n", .{});

    // Standard ANSI colors
    std.debug.print("--- ANSI 4-Bit Colors ---\n", .{});
    std.debug.print("{s}Red{s} {s}Green{s} {s}Blue{s}\n", .{
        tint.fg(.{ .ansi4 = .red }),   tint.reset,
        tint.fg(.{ .ansi4 = .green }), tint.reset,
        tint.fg(.{ .ansi4 = .blue }),  tint.reset,
    });

    // Bright colors
    std.debug.print("\n--- Bright Colors ---\n", .{});
    std.debug.print("{s}Bright Red{s} {s}Bright Green{s} {s}Bright Blue{s}\n", .{
        tint.fg(.{ .ansi4 = .bright_red }),   tint.reset,
        tint.fg(.{ .ansi4 = .bright_green }), tint.reset,
        tint.fg(.{ .ansi4 = .bright_blue }),  tint.reset,
    });

    // ANSI 256
    std.debug.print("\n--- ANSI 256 Colors ---\n", .{});
    std.debug.print("{s}Orange (208){s} {s}Purple (129){s} {s}Teal (49){s}\n", .{
        tint.fg(tint.ansi256(208)), tint.reset,
        tint.fg(tint.ansi256(129)), tint.reset,
        tint.fg(tint.ansi256(49)),  tint.reset,
    });

    // RGB
    std.debug.print("\n--- RGB / TrueColor ---\n", .{});
    std.debug.print("{s}Custom RGB (255,100,20){s}\n", .{
        tint.fg(tint.rgb(255, 100, 20)),
        tint.reset,
    });

    // HEX
    std.debug.print("\n--- HEX Colors ---\n", .{});
    std.debug.print("{s}#7C3AED{s} {s}#06B6D4{s}\n", .{
        tint.fg(tint.hex(0x7C3AED)), tint.reset,
        tint.fg(tint.hex(0x06B6D4)), tint.reset,
    });

    // Foreground and background
    std.debug.print("\n--- Foreground & Background ---\n", .{});
    std.debug.print("{s}{s}White on Blue{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.bg(.{ .ansi4 = .blue }),
        tint.reset,
    });

    // Underline colors
    std.debug.print("\n--- Underline Colors ---\n", .{});
    std.debug.print("{s}{s}Custom underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(tint.rgb(255, 100, 20)),
        tint.reset,
    });

    // Text attributes
    std.debug.print("\n--- Text Attributes ---\n", .{});
    std.debug.print("{s}{s}Bold{s} {s}{s}Italic{s} {s}{s}Underline{s} {s}{s}Strikethrough{s}\n", .{
        tint.style(.{ .bold = true }).toAnsi(),          "", tint.reset,
        tint.style(.{ .italic = true }).toAnsi(),        "", tint.reset,
        tint.style(.{ .underline = true }).toAnsi(),     "", tint.reset,
        tint.style(.{ .strikethrough = true }).toAnsi(), "", tint.reset,
    });

    // Combined styles
    std.debug.print("\n--- Combined Styles ---\n", .{});
    std.debug.print("{s}{s}{s}{s}Bold Italic Underline Cyan{s}\n", .{
        tint.style(.{ .bold = true }).toAnsi(),
        tint.style(.{ .italic = true }).toAnsi(),
        tint.style(.{ .underline = true }).toAnsi(),
        tint.fg(.{ .ansi4 = .cyan }),
        tint.reset,
    });

    // Named colors
    std.debug.print("\n--- Named Colors ---\n", .{});
    const coral = tint.Named.coral;
    const teal = tint.Named.teal;
    const gold = tint.Named.gold;
    std.debug.print("{s}Coral{s} ", .{ tint.fg(.{ .rgb = coral }), tint.reset });
    std.debug.print("{s}Teal{s} ", .{ tint.fg(.{ .rgb = teal }), tint.reset });
    std.debug.print("{s}Gold{s}\n", .{ tint.fg(.{ .rgb = gold }), tint.reset });

    // Custom theme
    std.debug.print("\n--- Custom Theme ---\n", .{});
    const theme = tint.Theme{
        .name = "demo",
        .primary = tint.hex(0x7C3AED),
        .secondary = tint.hex(0x06B6D4),
        .success = tint.hex(0x22C55E),
        .warning = tint.hex(0xF59E0B),
        .err = tint.hex(0xEF4444),
        .info = tint.hex(0x3B82F6),
        .text = tint.hex(0xE5E7EB),
        .muted = tint.hex(0x6B7280),
    };

    std.debug.print("{s}Primary: {s}████████{s}\n", .{ tint.fg(theme.primary), tint.bg(theme.primary), tint.reset });
    std.debug.print("{s}Error: {s}████████{s}\n", .{ tint.fg(theme.err), tint.bg(theme.err), tint.reset });

    // Style composition
    std.debug.print("\n--- Style Composition ---\n", .{});
    const error_style = tint.style(.{
        .fg = theme.err,
        .bold = true,
    });
    std.debug.print("{s}This is an error message{s}\n", .{ error_style.toAnsi(), tint.reset });

    // Reset codes
    std.debug.print("\n--- Reset Codes ---\n", .{});
    std.debug.print("{s}Full reset: {s}\n", .{ tint.style(.{ .bold = true }).toAnsi(), tint.reset });

    // Color manipulation
    std.debug.print("\n--- Color Manipulation ---\n", .{});
    const base_color = tint.rgb(100, 150, 200);
    std.debug.print("{s}Original{s}\n", .{ tint.fg(base_color), tint.reset });
    std.debug.print("{s}Lightened{s}\n", .{ tint.fg(base_color.lighten(0.3)), tint.reset });
    std.debug.print("{s}Darkened{s}\n", .{ tint.fg(base_color.darken(0.3)), tint.reset });
    std.debug.print("{s}Inverted{s}\n", .{ tint.fg(base_color.invert()), tint.reset });
    std.debug.print("{s}Grayscale{s}\n", .{ tint.fg(base_color.grayscale()), tint.reset });

    std.debug.print("\n=== Demo Complete ===\n", .{});
}
