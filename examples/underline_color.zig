const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Underline colors
    std.debug.print("=== Underline Colors ===\n", .{});

    // ANSI color underline
    std.debug.print("{s}{s}Red underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(.{ .ansi4 = .red }),
        tint.reset,
    });

    // ANSI 256 underline
    std.debug.print("{s}{s}Orange underline (256){s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(tint.ansi256(208)),
        tint.reset,
    });

    // RGB underline
    std.debug.print("{s}{s}Custom RGB underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(tint.rgb(255, 100, 20)),
        tint.reset,
    });

    // HEX underline
    std.debug.print("{s}{s}HEX underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(tint.hex(0xFF6600)),
        tint.reset,
    });

    // Default underline color
    std.debug.print("{s}{s}Default underline color{s}\n", .{
        tint.fg(.{ .ansi4 = .white }),
        tint.underline(.{ .ansi4 = .default }),
        tint.reset,
    });
}
