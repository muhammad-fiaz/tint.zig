const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;
    std.debug.print("=== tint.zig {s} on Zig {s} ===\n\n", .{ tint.version, tint.minimumZigVersion });

    std.debug.print("--- Colours ---\n", .{});
    const models = .{
        tint.color.ansi4.red,
        tint.color.ansi256.rgb(5, 0, 0),
        tint.color.rgb(255, 100, 20),
        tint.color.hex(0x7C3AED),
        tint.color.hsl(120, 80, 45),
        tint.color.hsv(280, 70, 90),
        tint.color.cmyk(0, 100, 100, 0),
        tint.color.kelvin(2700),
        tint.color.mediumPurple,
    };
    inline for (models) |c| {
        std.debug.print("{s}##{s} ", .{ c.fg().slice(), reset });
    }
    std.debug.print("\n", .{});

    std.debug.print("\n--- Layers ---\n", .{});
    std.debug.print("{s}fg{s} {s}{s}underline{s} {s}on bg{s}\n", .{
        tint.color.hex(0xFF6600).fg().slice(), reset,
        tint.color.white.fg().slice(),         tint.color.hex(0xFF6600).underline().slice(),
        reset,                                 tint.color.hex(0x1A1A2E).bg().slice(),
        reset,
    });

    std.debug.print("\n--- Styles ---\n", .{});
    std.debug.print("{s}bold{s} {s}italic{s} {s}underline{s} {s}strike{s} {s}overline{s}\n", .{
        tint.style.bold.toAnsi().slice(),          reset,
        tint.style.italic.toAnsi().slice(),        reset,
        tint.style.underline.toAnsi().slice(),     reset,
        tint.style.strikethrough.toAnsi().slice(), reset,
        tint.style.overline.toAnsi().slice(),      reset,
    });

    std.debug.print("\n--- Presets and composition ---\n", .{});
    std.debug.print("{s}error{s} {s}warning{s} {s}success{s} {s}info{s}\n", .{
        tint.style.err(tint.color.red).toAnsi().slice(),        reset,
        tint.style.warning(tint.color.yellow).toAnsi().slice(), reset,
        tint.style.success(tint.color.green).toAnsi().slice(),  reset,
        tint.style.info(tint.color.cyan).toAnsi().slice(),      reset,
    });

    std.debug.print("\n--- Manipulation ---\n", .{});
    const base = tint.color.rgb(100, 150, 200);
    inline for (.{
        base,               base.lighten(0.3), base.darken(0.3),
        base.saturate(0.3), base.invert(),     base.grayscale(),
    }) |c| {
        std.debug.print("{s}##{s} ", .{ c.fg().slice(), reset });
    }
    std.debug.print("\n", .{});

    std.debug.print("\n--- Analysis ---\n", .{});
    std.debug.print("white/black contrast {d:.2}:1\n", .{tint.color.white.contrastRatio(tint.color.black)});
    std.debug.print("red to blue {d:.2} CIEDE2000\n", .{tint.color.red.deltaE2000(tint.color.blue)});

    std.debug.print("\n--- Palettes ---\n", .{});
    std.debug.print("ansi16[1] rgb({d}, {d}, {d})\n", .{
        tint.palette.ansi16[1].r, tint.palette.ansi16[1].g, tint.palette.ansi16[1].b,
    });
    std.debug.print("ansi88[79] rgb({d}, {d}, {d})\n", .{
        tint.palette.ansi88[79].r, tint.palette.ansi88[79].g, tint.palette.ansi88[79].b,
    });
    var gradient: [24]tint.color.Rgb = undefined;
    tint.palette.ramp(&gradient, tint.color.red.toRgb(), tint.color.blue.toRgb());
    for (gradient) |entry| {
        std.debug.print("{s}#{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print("\n", .{});

    std.debug.print("\n--- Themes ({d}) ---\n", .{tint.theme.all.len});
    for ([_]tint.theme.Theme{ tint.theme.dark, tint.theme.tokyoNight }) |theme| {
        std.debug.print("{s:<12} {s}primary{s} {s}err{s}\n", .{
            theme.name,
            theme.role(.primary).fg().slice(),
            reset,
            theme.role(.err).fg().slice(),
            reset,
        });
    }
}
