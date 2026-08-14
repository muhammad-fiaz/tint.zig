# Complete Demo

Demonstrates the entire tint.zig feature set.

## Code

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Standard ANSI colors
    std.debug.print("{s}Red{s} {s}Green{s} {s}Blue{s}\n", .{
        tint.fg(.{ .ansi4 = .red }), tint.reset,
        tint.fg(.{ .ansi4 = .green }), tint.reset,
        tint.fg(.{ .ansi4 = .blue }), tint.reset,
    });

    // Bright ANSI colors
    std.debug.print("{s}Bright Red{s} {s}Bright Green{s}\n", .{
        tint.fg(.{ .ansi4 = .bright_red }), tint.reset,
        tint.fg(.{ .ansi4 = .bright_green }), tint.reset,
    });

    // ANSI 256
    std.debug.print("{s}Orange (208){s} {s}Purple (129){s}\n", .{
        tint.fg(tint.ansi256(208)), tint.reset,
        tint.fg(tint.ansi256(129)), tint.reset,
    });

    // RGB
    std.debug.print("{s}Custom RGB{s}\n", .{
        tint.fg(tint.rgb(255, 100, 20)), tint.reset,
    });

    // HEX
    std.debug.print("{s}HEX purple{s}\n", .{
        tint.fg(tint.hex(0x7C3AED)), tint.reset,
    });

    // HSL
    std.debug.print("{s}HSL Red{s}\n", .{
        tint.fg(tint.hsl(0, 100, 50)), tint.reset,
    });

    // HSV
    std.debug.print("{s}HSV Blue{s}\n", .{
        tint.fg(tint.hsv(240, 100, 100)), tint.reset,
    });

    // CMYK
    std.debug.print("{s}CMYK Cyan{s}\n", .{
        tint.fg(tint.cmyk(100, 0, 0, 0)), tint.reset,
    });

    // Color temperature
    std.debug.print("{s}Warm (2700K){s} {s}Cool (6500K){s}\n", .{
        tint.fg(tint.kelvin(2700)), tint.reset,
        tint.fg(tint.kelvin(6500)), tint.reset,
    });

    // Style composition
    const error_style = tint.style(.{
        .fg = tint.hex(0xEF4444),
        .bold = true,
    });
    std.debug.print("{s}Bold error!{s}\n", .{
        error_style.toAnsi(), tint.reset,
    });

    // Extending styles
    const warning_style = error_style.with(.{
        .underline = true,
    });
    std.debug.print("{s}Underlined error!{s}\n", .{
        warning_style.toAnsi(), tint.reset,
    });

    // Preset styles
    std.debug.print("{s}Preset error{s}\n", .{
        tint.presets.err_style(.{ .ansi4 = .red }).toAnsi(), tint.reset,
    });

    // Color manipulation
    const base = tint.rgb(100, 150, 200);
    std.debug.print("{s}Lightened{s}\n", .{
        tint.fg(base.lighten(0.3)), tint.reset,
    });

    std.debug.print("{s}Darkened{s}\n", .{
        tint.fg(base.darken(0.3)), tint.reset,
    });

    std.debug.print("{s}Inverted{s}\n", .{
        tint.fg(base.invert()), tint.reset,
    });

    std.debug.print("{s}Grayscale{s}\n", .{
        tint.fg(base.grayscale()), tint.reset,
    });

    // Color harmony
    const red = tint.rgb(255, 0, 0);
    const comp = red.complementary();
    std.debug.print("{s}Complementary{s}\n", .{
        tint.fg(comp), tint.reset,
    });

    // Named colors
    std.debug.print("{s}Coral{s} {s}Teal{s} {s}Gold{s}\n", .{
        tint.fg(.{ .rgb = tint.Named.coral }), tint.reset,
        tint.fg(.{ .rgb = tint.Named.teal }), tint.reset,
        tint.fg(.{ .rgb = tint.Named.gold }), tint.reset,
    });

    // Palettes
    std.debug.print("{s}Palette Red{s}\n", .{
        tint.fg(tint.ansi256(tint.palette.rgb6(5, 0, 0).index)), tint.reset,
    });

    // Themes
    const theme = tint.themes.dark_theme;
    std.debug.print("{s}Theme primary{s}\n", .{
        tint.fg(theme.primary), tint.reset,
    });

    // Tokyo Night theme
    const tokyo = tint.themes.tokyo_night_theme;
    std.debug.print("{s}Tokyo Night primary{s}\n", .{
        tint.fg(tokyo.primary), tint.reset,
    });

    // Background colors
    std.debug.print("{s}White on blue{s}\n", .{
        tint.bg(.{ .ansi4 = .blue }), tint.reset,
    });

    // Underline colors
    std.debug.print("{s}Red underline{s}\n", .{
        tint.underline(tint.rgb(255, 0, 0)),
    });
}
```

## Key Features Demonstrated

1. ANSI 4-bit colors (foreground and background)
2. Bright ANSI colors
3. ANSI 256 colors
4. RGB/TrueColor
5. HEX colors
6. HSL and HSV colors
7. CMYK colors
8. Color temperature (Kelvin)
9. Named colors (140+ CSS/X11 names)
10. Style composition with `.with()`
11. Preset styles
12. Color manipulation (lighten, darken, invert, grayscale)
13. Color harmony (complementary)
14. Palettes (RGB cube, grayscale)
15. Themes (dark, tokyo_night, and 14 more)
16. Underline colors
