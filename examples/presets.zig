const std = @import("std");
const tint = @import("tint");
const style_presets = tint.presets;

pub fn main() void {
    std.debug.print("=== Preset Styles ===\n\n", .{});

    // Error style
    const err = style_presets.err_style(.{ .ansi4 = .red });
    std.debug.print("{s}Error: Something went wrong!{s}\n", .{ err.toAnsi(), tint.reset });

    // Warning style
    const warn = style_presets.warning(.{ .ansi4 = .yellow });
    std.debug.print("{s}Warning: Check your input.{s}\n", .{ warn.toAnsi(), tint.reset });

    // Success style
    const ok = style_presets.success(.{ .ansi4 = .green });
    std.debug.print("{s}Success: Operation completed.{s}\n", .{ ok.toAnsi(), tint.reset });

    // Info style
    const info = style_presets.info(.{ .ansi4 = .cyan });
    std.debug.print("{s}Info: Processing...{s}\n", .{ info.toAnsi(), tint.reset });

    // Debug style
    const debug = style_presets.debug(.{ .ansi4 = .bright_black });
    std.debug.print("{s}Debug: variable = 42{s}\n", .{ debug.toAnsi(), tint.reset });

    // Link style
    const link = style_presets.link(.{ .ansi4 = .blue });
    std.debug.print("{s}https://example.com{s}\n", .{ link.toAnsi(), tint.reset });

    // Code style
    const code = style_presets.code(.{ .ansi4 = .white }, .{ .ansi4 = .black });
    std.debug.print("{s} const x = 42; {s}\n", .{ code.toAnsi(), tint.reset });

    // Header style
    const hdr = style_presets.header(.{ .ansi4 = .bright_white });
    std.debug.print("{s}# Section Header{s}\n", .{ hdr.toAnsi(), tint.reset });

    // Muted style
    const muted = style_presets.muted(.{ .ansi4 = .bright_black });
    std.debug.print("{s}This is muted text{s}\n", .{ muted.toAnsi(), tint.reset });

    // Highlight style
    const hl = style_presets.highlight(.{ .ansi4 = .black }, .{ .ansi4 = .yellow });
    std.debug.print("{s} HIGHLIGHTED TEXT {s}\n", .{ hl.toAnsi(), tint.reset });

    // Strikethrough
    const strike = style_presets.strikethrough_text(.{ .ansi4 = .red });
    std.debug.print("{s}Deleted text{s}\n", .{ strike.toAnsi(), tint.reset });

    // Blink
    const blink = style_presets.blink_text(.{ .ansi4 = .yellow });
    std.debug.print("{s}Blinking text{s}\n", .{ blink.toAnsi(), tint.reset });

    // Reverse
    const rev = style_presets.reverse_text(.{ .ansi4 = .cyan });
    std.debug.print("{s}Reversed text{s}\n", .{ rev.toAnsi(), tint.reset });

    // Hidden
    const hidden = style_presets.hidden_text(.{ .ansi4 = .white });
    std.debug.print("{s}Hidden text{s}\n", .{ hidden.toAnsi(), tint.reset });

    // Overlined
    const over = style_presets.overlined(.{ .ansi4 = .green });
    std.debug.print("{s}Overlined text{s}\n", .{ over.toAnsi(), tint.reset });

    // Framed
    const framed = style_presets.framed(.{ .ansi4 = .blue });
    std.debug.print("{s}Framed text{s}\n", .{ framed.toAnsi(), tint.reset });

    // Encircled
    const circled = style_presets.encircled(.{ .ansi4 = .magenta });
    std.debug.print("{s}Encircled text{s}\n", .{ circled.toAnsi(), tint.reset });
}
