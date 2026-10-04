const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Attributes ===\n", .{});
    const attrs = .{
        .{ "bold", tint.style.bold },
        .{ "dim", tint.style.dim },
        .{ "italic", tint.style.italic },
        .{ "underline", tint.style.underline },
        .{ "blink", tint.style.blink },
        .{ "reverse", tint.style.reverse },
        .{ "hidden", tint.style.hidden },
        .{ "strikethrough", tint.style.strikethrough },
        .{ "overline", tint.style.overline },
        .{ "fraktur", tint.style.fraktur },
        .{ "frame", tint.style.frame },
        .{ "encircle", tint.style.encircle },
    };
    inline for (attrs) |entry| {
        std.debug.print("  {s}{s:<14}{s}\n", .{ entry[1].toAnsi().slice(), entry[0], reset });
    }

    std.debug.print("\n=== Fluent composition ===\n", .{});
    const heading = tint.style.bold.fg(tint.color.cyan);
    const warning = tint.style.bold.fg(tint.color.yellow).merge(.{ .underline = true });
    const code = tint.style.fg(tint.color.white).bg(tint.color.black);
    std.debug.print("{s}heading{s}\n", .{ heading.toAnsi().slice(), reset });
    std.debug.print("{s}warning{s}\n", .{ warning.toAnsi().slice(), reset });
    std.debug.print("{s} code {s}\n", .{ code.toAnsi().slice(), reset });

    std.debug.print("\n=== Presets ===\n", .{});
    const presets = .{
        .{ "error", tint.style.err(tint.color.red) },
        .{ "warning", tint.style.warning(tint.color.yellow) },
        .{ "success", tint.style.success(tint.color.green) },
        .{ "info", tint.style.info(tint.color.cyan) },
        .{ "debug", tint.style.debug(tint.color.ansi4.brightBlack) },
        .{ "link", tint.style.link(tint.color.blue) },
        .{ "muted", tint.style.muted(tint.color.ansi4.brightBlack) },
    };
    inline for (presets) |entry| {
        std.debug.print("{s}{s:<8}{s} sample text\n", .{ entry[1].toAnsi().slice(), entry[0], reset });
    }

    std.debug.print("\n=== Merge, override, without ===\n", .{});
    const base = tint.style.bold.fg(tint.color.red);
    std.debug.print("{s}merged{s}\n", .{ base.merge(.{ .italic = true }).toAnsi().slice(), reset });
    std.debug.print("{s}cleared{s}\n", .{ base.without(tint.style.bold).toAnsi().slice(), reset });
    std.debug.print("minimal reset for bold red: {s}\n", .{base.reset().slice()});

    std.debug.print("\n=== Caller-owned rendering ===\n", .{});
    var buffer: [64]u8 = undefined;
    const rendered = heading.render(&buffer, "hello") catch "too small";
    std.debug.print("{s}\n", .{rendered});
}
