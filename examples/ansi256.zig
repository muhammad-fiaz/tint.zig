const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // ANSI 256 colors
    std.debug.print("=== ANSI 256 Colors ===\n", .{});

    // Standard colors (0-15)
    std.debug.print("{s}Index 1 (Red){s}\n", .{ tint.fg(tint.ansi256(1)), tint.reset });
    std.debug.print("{s}Index 2 (Green){s}\n", .{ tint.fg(tint.ansi256(2)), tint.reset });
    std.debug.print("{s}Index 3 (Yellow){s}\n", .{ tint.fg(tint.ansi256(3)), tint.reset });

    // RGB cube colors (16-231)
    std.debug.print("{s}Index 196 (Pure Red){s}\n", .{ tint.fg(tint.ansi256(196)), tint.reset });
    std.debug.print("{s}Index 46 (Pure Green){s}\n", .{ tint.fg(tint.ansi256(46)), tint.reset });
    std.debug.print("{s}Index 21 (Pure Blue){s}\n", .{ tint.fg(tint.ansi256(21)), tint.reset });
    std.debug.print("{s}Index 208 (Orange){s}\n", .{ tint.fg(tint.ansi256(208)), tint.reset });

    // Grayscale ramp (232-255)
    std.debug.print("\n=== Grayscale Ramp ===\n", .{});
    var i: u8 = 0;
    while (i < 24) : (i += 1) {
        const idx: u8 = 232 + i;
        std.debug.print("{s}Gray {d:3}{s} ", .{ tint.fg(tint.ansi256(idx)), i, tint.reset });
    }
    std.debug.print("\n", .{});

    // Using RGB cube helper
    std.debug.print("\n=== RGB Cube ===\n", .{});
    const red_cube = tint.palette.rgb6(5, 0, 0);
    std.debug.print("{s}RGB(5,0,0) -> Index {d}{s}\n", .{
        tint.fg(tint.ansi256(red_cube.index)),
        red_cube.index,
        tint.reset,
    });

    // Using grayscale helper
    const gray = tint.palette.gray(12);
    std.debug.print("{s}Gray(12) -> Index {d}{s}\n", .{
        tint.fg(tint.ansi256(gray.index)),
        gray.index,
        tint.reset,
    });
}
