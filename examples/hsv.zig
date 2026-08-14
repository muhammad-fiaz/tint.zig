const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // HSV colors
    std.debug.print("=== HSV Colors ===\n", .{});

    // Pure red: HSV(0, 100, 100)
    std.debug.print("{s}HSV(0, 100, 100) - Red{s}\n", .{ tint.fg(tint.hsv(0, 100, 100)), tint.reset });

    // Pure green: HSV(120, 100, 100)
    std.debug.print("{s}HSV(120, 100, 100) - Green{s}\n", .{ tint.fg(tint.hsv(120, 100, 100)), tint.reset });

    // Pure blue: HSV(240, 100, 100)
    std.debug.print("{s}HSV(240, 100, 100) - Blue{s}\n", .{ tint.fg(tint.hsv(240, 100, 100)), tint.reset });

    // Hue spectrum
    std.debug.print("\n=== Hue Spectrum ===\n", .{});
    var h: u16 = 0;
    while (h < 360) : (h += 15) {
        std.debug.print("{s}#{s}", .{ tint.fg(tint.hsv(h, 100, 100)), tint.reset });
    }
    std.debug.print("\n", .{});

    // Saturation variations
    std.debug.print("\n=== Saturation Variations ===\n", .{});
    var s: u8 = 0;
    while (s <= 100) : (s += 10) {
        std.debug.print("{s}S={d:3}%{s} ", .{ tint.fg(tint.hsv(120, s, 100)), s, tint.reset });
    }
    std.debug.print("\n", .{});

    // Value variations
    std.debug.print("\n=== Value Variations ===\n", .{});
    var v: u8 = 0;
    while (v <= 100) : (v += 10) {
        std.debug.print("{s}V={d:3}%{s} ", .{ tint.fg(tint.hsv(120, 100, v)), v, tint.reset });
    }
    std.debug.print("\n", .{});
}
