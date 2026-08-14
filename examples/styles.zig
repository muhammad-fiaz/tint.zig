const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Text attributes
    std.debug.print("=== Text Attributes ===\n", .{});
    std.debug.print("{s}Bold{s}\n", .{ tint.style(.{ .bold = true }), tint.reset });
    std.debug.print("{s}Dim{s}\n", .{ tint.style(.{ .dim = true }), tint.reset });
    std.debug.print("{s}Italic{s}\n", .{ tint.style(.{ .italic = true }), tint.reset });
    std.debug.print("{s}Underline{s}\n", .{ tint.style(.{ .underline = true }), tint.reset });
    std.debug.print("{s}Blink{s}\n", .{ tint.style(.{ .blink = true }), tint.reset });
    std.debug.print("{s}Reverse{s}\n", .{ tint.style(.{ .reverse = true }), tint.reset });
    std.debug.print("{s}Hidden{s}\n", .{ tint.style(.{ .hidden = true }), tint.reset });
    std.debug.print("{s}Strikethrough{s}\n", .{ tint.style(.{ .strikethrough = true }), tint.reset });
    std.debug.print("{s}Double Underline{s}\n", .{ tint.style(.{ .double_underline = true }), tint.reset });
    std.debug.print("{s}Overline{s}\n", .{ tint.style(.{ .overline = true }), tint.reset });

    // Combined with colors
    std.debug.print("\n=== Combined with Colors ===\n", .{});
    std.debug.print("{s}{s}Bold Red{s}\n", .{ tint.style(.{ .bold = true }), tint.fg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}{s}Italic Green{s}\n", .{ tint.style(.{ .italic = true }), tint.fg(.{ .ansi4 = .green }), tint.reset });
    std.debug.print("{s}{s}Underline Blue{s}\n", .{ tint.style(.{ .underline = true }), tint.fg(.{ .ansi4 = .blue }), tint.reset });
    std.debug.print("{s}{s}{s}Bold Italic Magenta{s}\n", .{
        tint.style(.{ .bold = true }),
        tint.style(.{ .italic = true }),
        tint.fg(.{ .ansi4 = .magenta }),
        tint.reset,
    });

    // Individual resets
    std.debug.print("\n=== Individual Resets ===\n", .{});
    std.debug.print("{s}Bold{s} Normal{s}\n", .{ tint.style(.{ .bold = true }), tint.reset_bold, tint.reset });
}
