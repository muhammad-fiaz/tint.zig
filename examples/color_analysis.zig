const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Color Analysis ===\n\n", .{});

    const red = tint.rgb(255, 0, 0);
    const blue = tint.rgb(0, 0, 255);
    const white = tint.rgb(255, 255, 255);
    const black = tint.rgb(0, 0, 0);

    // Luminance
    std.debug.print("--- Luminance ---\n", .{});
    std.debug.print("{s}Red{s} luminance: {d:.4}\n", .{ tint.fg(red), tint.reset, red.luminance() });
    std.debug.print("{s}Blue{s} luminance: {d:.4}\n", .{ tint.fg(blue), tint.reset, blue.luminance() });
    std.debug.print("{s}White{s} luminance: {d:.4}\n", .{ tint.fg(white), tint.reset, white.luminance() });
    std.debug.print("{s}Black{s} luminance: {d:.4}\n", .{ tint.fg(black), tint.reset, black.luminance() });

    // Light/Dark check
    std.debug.print("\n--- Light/Dark ---\n", .{});
    std.debug.print("{s}Red{s} is light: {} is dark: {}\n", .{ tint.fg(red), tint.reset, red.isLight(), red.isDark() });
    std.debug.print("{s}White{s} is light: {} is dark: {}\n", .{ tint.fg(white), tint.reset, white.isLight(), white.isDark() });
    std.debug.print("{s}Black{s} is light: {} is dark: {}\n", .{ tint.fg(black), tint.reset, black.isLight(), black.isDark() });

    // Contrast ratio
    std.debug.print("\n--- Contrast Ratio (WCAG) ---\n", .{});
    const ratio_bw = white.contrastRatio(black);
    std.debug.print("White/Black: {d:.2}:1\n", .{ratio_bw});
    const ratio_rb = red.contrastRatio(black);
    std.debug.print("Red/Black: {d:.2}:1\n", .{ratio_rb});

    // Color distance
    std.debug.print("\n--- Color Distance (CIE76) ---\n", .{});
    std.debug.print("Red to Blue: {d:.2}\n", .{red.colorDistance(blue)});
    std.debug.print("Red to Red: {d:.2}\n", .{red.colorDistance(red)});

    // Nearest ANSI 256
    std.debug.print("\n--- Nearest ANSI 256 ---\n", .{});
    std.debug.print("{s}Red (255,0,0){s} -> ANSI 256 index: {d}\n", .{ tint.fg(red), tint.reset, red.nearestAnsi256() });
    std.debug.print("{s}Blue (0,0,255){s} -> ANSI 256 index: {d}\n", .{ tint.fg(blue), tint.reset, blue.nearestAnsi256() });

    // CIE Lab
    std.debug.print("\n--- CIE Lab ---\n", .{});
    const lab = red.toLab();
    std.debug.print("{s}Red{s} -> Lab({d:.2}, {d:.2}, {d:.2})\n", .{ tint.fg(red), tint.reset, lab.l, lab.a, lab.b_val });
    const lab2 = blue.toLab();
    std.debug.print("{s}Blue{s} -> Lab({d:.2}, {d:.2}, {d:.2})\n", .{ tint.fg(blue), tint.reset, lab2.l, lab2.a, lab2.b_val });
    std.debug.print("Lab distance: {d:.2}\n", .{lab.distance(lab2)});
}
