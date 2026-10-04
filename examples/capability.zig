const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Capability ladder ===\n", .{});
    std.debug.print("The same colours, rendered for four terminals.\n\n", .{});
    const swatches = .{
        tint.color.coral,
        tint.color.teal,
        tint.color.gold,
        tint.color.rebeccaPurple,
        tint.color.slateGray,
    };
    const caps = .{
        tint.ansi.Capability.trueColor,
        tint.ansi.Capability.ansi256,
        tint.ansi.Capability.ansi16,
        tint.ansi.Capability.none,
    };
    inline for (caps) |cap| {
        std.debug.print("{s:<10} ", .{@tagName(cap)});
        inline for (swatches) |c| {
            std.debug.print("{s}##{s}", .{ tint.ansi.render(c, .foreground, cap).slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Backgrounds downgrade too ===\n", .{});
    inline for (caps) |cap| {
        std.debug.print("{s:<10} ", .{@tagName(cap)});
        inline for (swatches) |c| {
            std.debug.print("{s}  {s}", .{ tint.ansi.render(c, .background, cap).slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Explicit, never detected ===\n", .{});
    std.debug.print("tint.zig never reads the environment. The caller picks:\n", .{});
    std.debug.print("  tint.ansi.render(color, .foreground, .ansi256)\n", .{});
}
