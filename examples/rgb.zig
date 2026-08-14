const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // RGB / TrueColor
    std.debug.print("=== RGB / TrueColor ===\n", .{});

    // Pure colors
    std.debug.print("{s}Pure Red (255,0,0){s}\n", .{ tint.fg(tint.rgb(255, 0, 0)), tint.reset });
    std.debug.print("{s}Pure Green (0,255,0){s}\n", .{ tint.fg(tint.rgb(0, 255, 0)), tint.reset });
    std.debug.print("{s}Pure Blue (0,0,255){s}\n", .{ tint.fg(tint.rgb(0, 0, 255)), tint.reset });

    // Arbitrary colors
    std.debug.print("{s}Custom Orange (255,100,20){s}\n", .{ tint.fg(tint.rgb(255, 100, 20)), tint.reset });
    std.debug.print("{s}Custom Purple (128,0,128){s}\n", .{ tint.fg(tint.rgb(128, 0, 128)), tint.reset });
    std.debug.print("{s}Custom Teal (0,128,128){s}\n", .{ tint.fg(tint.rgb(0, 128, 128)), tint.reset });

    // Background
    std.debug.print("{s}White on RGB background{s}\n", .{
        tint.bg(tint.rgb(50, 50, 100)),
        tint.reset,
    });

    // Gradient simulation
    std.debug.print("\n=== Gradient ===\n", .{});
    var r: u8 = 0;
    while (r < 255) : (r += 17) {
        std.debug.print("{s}█{s}", .{ tint.fg(tint.rgb(r, 0, 255 - r)), tint.reset });
    }
    std.debug.print("\n", .{});
}
