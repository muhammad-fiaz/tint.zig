const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== 256-colour palette ===\n", .{});
    for (0..256) |i| {
        const c = tint.color.ansi256.index(@intCast(i));
        std.debug.print("{s}##{s}", .{ c.fg().slice(), reset });
        if (i % 16 == 15) {
            std.debug.print("\n", .{});
        } else {
            std.debug.print(" ", .{});
        }
    }

    std.debug.print("\n=== 88-colour palette ===\n", .{});
    for (0..88) |i| {
        const entry = tint.palette.ansi88[i];
        const c = tint.color.rgb(entry.r, entry.g, entry.b);
        std.debug.print("{s}##{s}", .{ c.fg().slice(), reset });
        if (i % 16 == 15) {
            std.debug.print("\n", .{});
        } else {
            std.debug.print(" ", .{});
        }
    }

    std.debug.print("\n=== Index constructors ===\n", .{});
    const entries = .{
        tint.color.ansi256.rgb(5, 0, 0),
        tint.color.ansi256.rgb(0, 0, 5),
        tint.color.ansi256.gray(12),
        tint.color.ansi88.rgb(3, 2, 1),
        tint.color.ansi88.gray(7),
    };
    inline for (entries) |c| {
        std.debug.print("{s}## index {d:>3}{s}\n", .{ c.fg().slice(), c.ansi256.index, reset });
    }

    std.debug.print("\n=== Downgrade ladder ===\n", .{});
    const source = tint.color.rgb(200, 30, 90);
    inline for (.{ tint.ansi.Capability.trueColor, .ansi256, .ansi16, .none }) |cap| {
        const rendered = tint.ansi.render(source, .foreground, cap);
        std.debug.print("{s}{s:<10}{s} {s}\n", .{ rendered.slice(), @tagName(cap), reset, rendered.slice() });
    }
}
