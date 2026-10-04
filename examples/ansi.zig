const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Foreground ===\n", .{});
    for (tint.color.Ansi4.all) |a| {
        const c: tint.color.Color = .{ .ansi4 = a };
        std.debug.print("{s}##{s} ", .{ c.fg().slice(), reset });
    }

    std.debug.print("\n\n=== Background ===\n", .{});
    for (tint.color.Ansi4.all) |a| {
        const c: tint.color.Color = .{ .ansi4 = a };
        std.debug.print("{s}  {s} ", .{ c.bg().slice(), reset });
    }

    std.debug.print("\n\n=== Names and RGB values ===\n", .{});
    for (tint.color.Ansi4.all, 0..) |a, i| {
        const entry = tint.palette.ansi16[i];
        const c: tint.color.Color = .{ .ansi4 = a };
        std.debug.print("{s}{s:<14}{s} rgb({d:>3}, {d:>3}, {d:>3})\n", .{
            c.fg().slice(),
            tint.palette.ansi16Names[i],
            reset,
            entry.r,
            entry.g,
            entry.b,
        });
    }

    std.debug.print("\n=== Terminal default ===\n", .{});
    std.debug.print("{s}default fg{s} ", .{ tint.color.ansi4.default.fg().slice(), reset });
    std.debug.print("{s} default bg{s}\n", .{ tint.color.ansi4.default.bg().slice(), reset });
}
