const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Foreground ===\n", .{});
    std.debug.print("{s}red{s} ", .{ tint.color.red.fg().slice(), reset });
    std.debug.print("{s}green{s} ", .{ tint.color.green.fg().slice(), reset });
    std.debug.print("{s}blue{s}\n", .{ tint.color.blue.fg().slice(), reset });

    std.debug.print("\n=== Background ===\n", .{});
    std.debug.print("{s} white on blue {s}\n", .{ tint.color.blue.bg().slice(), reset });
    std.debug.print("{s} black on yellow {s}\n", .{ tint.color.yellow.bg().slice(), reset });

    std.debug.print("\n=== Underline colour ===\n", .{});
    std.debug.print("{s}{s}coloured underline{s}\n", .{
        tint.color.white.fg().slice(),
        tint.color.rgb(255, 100, 20).underline().slice(),
        reset,
    });

    std.debug.print("\n=== Named colours are values ===\n", .{});
    const colors = .{
        tint.color.coral,
        tint.color.teal,
        tint.color.gold,
        tint.color.mediumPurple,
        tint.color.tomato,
    };
    inline for (colors) |c| {
        const rgb = c.toRgb();
        std.debug.print("{s}##{s} rgb({d}, {d}, {d})\n", .{
            c.fg().slice(), reset, rgb.r, rgb.g, rgb.b,
        });
    }
}
