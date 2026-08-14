const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Color Harmony ===\n\n", .{});

    const base = tint.rgb(255, 0, 0);
    std.debug.print("{s}Base: Red (255,0,0){s}\n\n", .{ tint.fg(base), tint.reset });

    // Complementary
    std.debug.print("--- Complementary ---\n", .{});
    const comp = base.complementary();
    std.debug.print("{s}Complementary{s}\n", .{ tint.fg(comp), tint.reset });

    // Analogous
    std.debug.print("\n--- Analogous ---\n", .{});
    const analogous = base.analogous();
    std.debug.print("{s}Analogous -30°{s}\n", .{ tint.fg(analogous[0]), tint.reset });
    std.debug.print("{s}Base{s}\n", .{ tint.fg(base), tint.reset });
    std.debug.print("{s}Analogous +30°{s}\n", .{ tint.fg(analogous[1]), tint.reset });

    // Triadic
    std.debug.print("\n--- Triadic ---\n", .{});
    const triadic = base.triadic();
    std.debug.print("{s}Base{s}\n", .{ tint.fg(base), tint.reset });
    std.debug.print("{s}Triadic +120°{s}\n", .{ tint.fg(triadic[0]), tint.reset });
    std.debug.print("{s}Triadic +240°{s}\n", .{ tint.fg(triadic[1]), tint.reset });

    // Split complementary
    std.debug.print("\n--- Split Complementary ---\n", .{});
    const split = base.splitComplementary();
    std.debug.print("{s}Base{s}\n", .{ tint.fg(base), tint.reset });
    std.debug.print("{s}Split +150°{s}\n", .{ tint.fg(split[0]), tint.reset });
    std.debug.print("{s}Split +210°{s}\n", .{ tint.fg(split[1]), tint.reset });

    // Tetradic
    std.debug.print("\n--- Tetradic ---\n", .{});
    const tetradic = base.tetradic();
    std.debug.print("{s}Base{s}\n", .{ tint.fg(base), tint.reset });
    std.debug.print("{s}Tetradic +90°{s}\n", .{ tint.fg(tetradic[0]), tint.reset });
    std.debug.print("{s}Tetradic +180°{s}\n", .{ tint.fg(tetradic[1]), tint.reset });
    std.debug.print("{s}Tetradic +270°{s}\n", .{ tint.fg(tetradic[2]), tint.reset });

    // Different base color
    std.debug.print("\n--- Blue Harmony ---\n", .{});
    const blue = tint.rgb(0, 100, 255);
    std.debug.print("{s}Base: Blue{s}\n", .{ tint.fg(blue), tint.reset });
    const b_comp = blue.complementary();
    std.debug.print("{s}Complementary{s}\n", .{ tint.fg(b_comp), tint.reset });
}
