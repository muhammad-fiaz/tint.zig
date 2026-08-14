const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Color Manipulation ===\n\n", .{});

    const base = tint.rgb(100, 150, 200);
    std.debug.print("{s}Base (100,150,200){s}\n", .{ tint.fg(base), tint.reset });

    // Lighten
    std.debug.print("\n--- Lighten ---\n", .{});
    std.debug.print("{s}Lighten 10%{s}\n", .{ tint.fg(base.lighten(0.1)), tint.reset });
    std.debug.print("{s}Lighten 20%{s}\n", .{ tint.fg(base.lighten(0.2)), tint.reset });
    std.debug.print("{s}Lighten 30%{s}\n", .{ tint.fg(base.lighten(0.3)), tint.reset });
    std.debug.print("{s}Lighten 50%{s}\n", .{ tint.fg(base.lighten(0.5)), tint.reset });

    // Darken
    std.debug.print("\n--- Darken ---\n", .{});
    std.debug.print("{s}Darken 10%{s}\n", .{ tint.fg(base.darken(0.1)), tint.reset });
    std.debug.print("{s}Darken 20%{s}\n", .{ tint.fg(base.darken(0.2)), tint.reset });
    std.debug.print("{s}Darken 30%{s}\n", .{ tint.fg(base.darken(0.3)), tint.reset });

    // Saturate
    std.debug.print("\n--- Saturate ---\n", .{});
    std.debug.print("{s}Saturate 20%{s}\n", .{ tint.fg(base.saturate(0.2)), tint.reset });
    std.debug.print("{s}Saturate 50%{s}\n", .{ tint.fg(base.saturate(0.5)), tint.reset });

    // Desaturate
    std.debug.print("\n--- Desaturate ---\n", .{});
    std.debug.print("{s}Desaturate 10%{s}\n", .{ tint.fg(base.desaturate(0.1)), tint.reset });
    std.debug.print("{s}Desaturate 20%{s}\n", .{ tint.fg(base.desaturate(0.2)), tint.reset });
    std.debug.print("{s}Grayscale{s}\n", .{ tint.fg(base.grayscale()), tint.reset });

    // Invert
    std.debug.print("\n--- Invert ---\n", .{});
    std.debug.print("{s}Inverted{s}\n", .{ tint.fg(base.invert()), tint.reset });

    // Mix
    std.debug.print("\n--- Mix ---\n", .{});
    const red = tint.rgb(255, 0, 0);
    const blue = tint.rgb(0, 0, 255);
    std.debug.print("{s}Red{s}\n", .{ tint.fg(red), tint.reset });
    std.debug.print("{s}25% Red + 75% Blue{s}\n", .{ tint.fg(red.mix(blue, 0.25)), tint.reset });
    std.debug.print("{s}50% Red + 50% Blue{s}\n", .{ tint.fg(red.mix(blue, 0.5)), tint.reset });
    std.debug.print("{s}75% Red + 25% Blue{s}\n", .{ tint.fg(red.mix(blue, 0.75)), tint.reset });
    std.debug.print("{s}Blue{s}\n", .{ tint.fg(blue), tint.reset });

    // Rotate hue
    std.debug.print("\n--- Rotate Hue ---\n", .{});
    const hsl = tint.hsl(0, 100, 50);
    std.debug.print("{s}0deg Red{s}\n", .{ tint.fg(hsl), tint.reset });
    std.debug.print("{s}60deg rotated{s}\n", .{ tint.fg(hsl.rotate(60)), tint.reset });
    std.debug.print("{s}120deg rotated{s}\n", .{ tint.fg(hsl.rotate(120)), tint.reset });
    std.debug.print("{s}180deg rotated{s}\n", .{ tint.fg(hsl.rotate(180)), tint.reset });
    std.debug.print("{s}240deg rotated{s}\n", .{ tint.fg(hsl.rotate(240)), tint.reset });
    std.debug.print("{s}300deg rotated{s}\n", .{ tint.fg(hsl.rotate(300)), tint.reset });

    // Lerp
    std.debug.print("\n--- Lerp ---\n", .{});
    std.debug.print("{s}Lerp 0.0{s}\n", .{ tint.fg(tint.Color.lerp(red, blue, 0.0)), tint.reset });
    std.debug.print("{s}Lerp 0.25{s}\n", .{ tint.fg(tint.Color.lerp(red, blue, 0.25)), tint.reset });
    std.debug.print("{s}Lerp 0.5{s}\n", .{ tint.fg(tint.Color.lerp(red, blue, 0.5)), tint.reset });
    std.debug.print("{s}Lerp 0.75{s}\n", .{ tint.fg(tint.Color.lerp(red, blue, 0.75)), tint.reset });
    std.debug.print("{s}Lerp 1.0{s}\n", .{ tint.fg(tint.Color.lerp(red, blue, 1.0)), tint.reset });
}
