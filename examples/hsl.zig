const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // HSL colors
    std.debug.print("=== HSL Colors ===\n", .{});

    // Pure red: HSL(0, 100, 50)
    std.debug.print("{s}HSL(0, 100, 50) - Red{s}\n", .{ tint.fg(tint.hsl(0, 100, 50)), tint.reset });

    // Pure green: HSL(120, 100, 50)
    std.debug.print("{s}HSL(120, 100, 50) - Green{s}\n", .{ tint.fg(tint.hsl(120, 100, 50)), tint.reset });

    // Pure blue: HSL(240, 100, 50)
    std.debug.print("{s}HSL(240, 100, 50) - Blue{s}\n", .{ tint.fg(tint.hsl(240, 100, 50)), tint.reset });

    // Hue spectrum
    std.debug.print("\n=== Hue Spectrum ===\n", .{});
    var h: u16 = 0;
    while (h < 360) : (h += 15) {
        std.debug.print("{s}█{s}", .{ tint.fg(tint.hsl(h, 100, 50)), tint.reset });
    }
    std.debug.print("\n", .{});

    // Saturation variations
    std.debug.print("\n=== Saturation Variations ===\n", .{});
    var s: u8 = 0;
    while (s <= 100) : (s += 10) {
        std.debug.print("{s}S={d:3}%{s} ", .{ tint.fg(tint.hsl(200, s, 50)), s, tint.reset });
    }
    std.debug.print("\n", .{});

    // Lightness variations
    std.debug.print("\n=== Lightness Variations ===\n", .{});
    var l: u8 = 0;
    while (l <= 100) : (l += 10) {
        std.debug.print("{s}L={d:3}%{s} ", .{ tint.fg(tint.hsl(120, 100, l)), l, tint.reset });
    }
    std.debug.print("\n", .{});
}
