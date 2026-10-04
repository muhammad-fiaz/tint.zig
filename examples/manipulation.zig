const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;
    const base = tint.color.rgb(100, 150, 200);

    std.debug.print("=== Relative adjustments ===\n", .{});
    inline for (.{
        .{ "lighten 20%", base.lighten(0.2) },
        .{ "darken 20%", base.darken(0.2) },
        .{ "saturate 20%", base.saturate(0.2) },
        .{ "desaturate 20%", base.desaturate(0.2) },
        .{ "fade 40%", base.fade(0.4) },
        .{ "invert", base.invert() },
        .{ "grayscale", base.grayscale() },
    }) |entry| {
        std.debug.print("{s}## {s:<14}{s} #{s}\n", .{ entry[1].fg().slice(), entry[0], reset, entry[1].toRgb().toString() });
    }

    std.debug.print("\n=== Absolute values ===\n", .{});
    inline for (.{
        .{ "lightness 25", base.withLightness(25) },
        .{ "lightness 75", base.withLightness(75) },
        .{ "saturation 20", base.withSaturation(20) },
        .{ "saturation 90", base.withSaturation(90) },
    }) |entry| {
        std.debug.print("{s}## {s:<14}{s}\n", .{ entry[1].fg().slice(), entry[0], reset });
    }

    std.debug.print("\n=== Interpolation spaces ===\n", .{});
    const from = tint.color.red;
    const to = tint.color.blue;
    inline for (.{ tint.color.Space.rgb, .hsl, .hsv, .lab, .lch, .oklab, .oklch }) |space| {
        std.debug.print("{s:<7} ", .{@tagName(space)});
        for (0..12) |i| {
            const t = @as(f64, @floatFromInt(i)) / 11.0;
            std.debug.print("{s}#{s}", .{ from.mixIn(to, t, space).fg().slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Hue paths (red to blue) ===\n", .{});
    inline for (.{ tint.color.HuePath.shorter, .longer, .increasing, .decreasing }) |path| {
        std.debug.print("{s:<11} ", .{@tagName(path)});
        for (0..12) |i| {
            const t = @as(f64, @floatFromInt(i)) / 11.0;
            std.debug.print("{s}#{s}", .{ from.mixHue(to, t, path).fg().slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Harmony ===\n", .{});
    std.debug.print("{s}## base{s} ", .{ base.fg().slice(), reset });
    std.debug.print("{s}## complementary{s}\n", .{ base.complementary().fg().slice(), reset });
    var triadic: [3]tint.color.Color = undefined;
    _ = tint.palette.triadic(&triadic, base);
    std.debug.print("triadic: ", .{});
    for (triadic) |c| std.debug.print("{s}##{s} ", .{ c.fg().slice(), reset });
    std.debug.print("\n", .{});
}
