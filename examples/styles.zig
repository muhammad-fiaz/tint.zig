const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Text Attributes ===\n", .{});
    std.debug.print("{s}{s}Bold{s}\n", .{ tint.style(.{ .bold = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Dim{s}\n", .{ tint.style(.{ .dim = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Italic{s}\n", .{ tint.style(.{ .italic = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Underline{s}\n", .{ tint.style(.{ .underline = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Blink{s}\n", .{ tint.style(.{ .blink = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Reverse{s}\n", .{ tint.style(.{ .reverse = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Hidden{s}\n", .{ tint.style(.{ .hidden = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Strikethrough{s}\n", .{ tint.style(.{ .strikethrough = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Overline{s}\n", .{ tint.style(.{ .overline = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Fraktur{s}\n", .{ tint.style(.{ .fraktur = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Frame{s}\n", .{ tint.style(.{ .frame = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Encircle{s}\n", .{ tint.style(.{ .encircle = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Rapid Blink{s}\n", .{ tint.style(.{ .rapid_blink = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Super Script{s}\n", .{ tint.style(.{ .super_script = true }).toAnsi(), "", tint.reset });
    std.debug.print("{s}{s}Sub Script{s}\n", .{ tint.style(.{ .sub_script = true }).toAnsi(), "", tint.reset });

    // Combined with colors
    std.debug.print("\n=== Combined with Colors ===\n", .{});
    std.debug.print("{s}{s}{s}Bold Red{s}\n", .{ tint.style(.{ .bold = true }).toAnsi(), tint.fg(.{ .ansi4 = .red }), "", tint.reset });
    std.debug.print("{s}{s}{s}Italic Green{s}\n", .{ tint.style(.{ .italic = true }).toAnsi(), tint.fg(.{ .ansi4 = .green }), "", tint.reset });
    std.debug.print("{s}{s}{s}Underline Blue{s}\n", .{ tint.style(.{ .underline = true }).toAnsi(), tint.fg(.{ .ansi4 = .blue }), "", tint.reset });

    // Individual resets
    std.debug.print("\n=== Individual Resets ===\n", .{});
    std.debug.print("{s}{s}Bold{s} Normal{s}\n", .{ tint.style(.{ .bold = true }).toAnsi(), "", tint.reset_bold, tint.reset });
}
