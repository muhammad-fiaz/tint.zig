const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Basic foreground colors
    std.debug.print("{s}Red text{s}\n", .{ tint.fg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}Green text{s}\n", .{ tint.fg(.{ .ansi4 = .green }), tint.reset });
    std.debug.print("{s}Blue text{s}\n", .{ tint.fg(.{ .ansi4 = .blue }), tint.reset });

    // Background colors
    std.debug.print("{s}White on blue{s}\n", .{ tint.bg(.{ .ansi4 = .blue }), tint.reset });

    // Combined foreground and background
    std.debug.print("{s}{s}Warning{s}\n", .{
        tint.fg(.{ .ansi4 = .yellow }),
        tint.bg(.{ .ansi4 = .black }),
        tint.reset,
    });

    // Named color constants
    std.debug.print("{s}This is red using named constant{s}\n", .{ tint.fg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}This is green using named constant{s}\n", .{ tint.fg(.{ .ansi4 = .green }), tint.reset });
}
