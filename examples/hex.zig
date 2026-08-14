const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // HEX colors
    std.debug.print("=== HEX Colors ===\n", .{});

    // Standard HEX
    std.debug.print("{s}#FF0000 (Red){s}\n", .{ tint.fg(tint.hex(0xFF0000)), tint.reset });
    std.debug.print("{s}#00FF00 (Green){s}\n", .{ tint.fg(tint.hex(0x00FF00)), tint.reset });
    std.debug.print("{s}#0000FF (Blue){s}\n", .{ tint.fg(tint.hex(0x0000FF)), tint.reset });

    // Lowercase
    std.debug.print("{s}#ff6600 (lowercase){s}\n", .{ tint.fg(tint.hex(0xff6600)), tint.reset });

    // Without hash
    std.debug.print("{s}FF6600 (without hash){s}\n", .{ tint.fg(tint.hex(0xFF6600)), tint.reset });

    // Short format (3-char hex)
    std.debug.print("{s}#F00 (short){s}\n", .{ tint.fg(tint.hex(0xFF0000)), tint.reset });

    // Integer HEX
    std.debug.print("{s}0xFF6600 (integer){s}\n", .{ tint.fg(tint.hex(0xFF6600)), tint.reset });

    // Background
    std.debug.print("{s}White on #1a1a2e{s}\n", .{
        tint.bg(tint.hex(0x1a1a2e)),
        tint.reset,
    });

    // HEX to RGB conversion
    const color = tint.hex(0xFF6600);
    const rgb_val = color.toRgb();
    std.debug.print("\n#FF6600 -> RGB({d}, {d}, {d})\n", .{ rgb_val.r, rgb_val.g, rgb_val.b });
}
