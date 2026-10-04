const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;
    const white = tint.color.white;
    const black = tint.color.black;

    std.debug.print("=== Luminance ===\n", .{});
    const samples = .{
        tint.color.white,
        tint.color.yellow,
        tint.color.lime,
        tint.color.red,
        tint.color.blue,
        tint.color.black,
    };
    inline for (samples) |c| {
        std.debug.print("{s}##{s} luminance {d:.4} light={} dark={}\n", .{
            c.fg().slice(), reset, c.luminance(), c.isLight(), c.isDark(),
        });
    }

    std.debug.print("\n=== Contrast and readability ===\n", .{});
    const pairs = .{
        .{ white, black },
        .{ tint.color.red, black },
        .{ tint.color.yellow, tint.color.navy },
        .{ tint.color.white, tint.color.silver },
    };
    inline for (pairs) |pair| {
        const ratio = pair[0].contrastRatio(pair[1]);
        std.debug.print("{s}##{s} on {s}##{s}  {d:>5.2}:1  {s}\n", .{
            pair[0].fg().slice(), reset,
            pair[1].bg().slice(), reset,
            ratio,                @tagName(tint.palette.readability(pair[0], pair[1])),
        });
    }

    std.debug.print("\n=== Colour distance ===\n", .{});
    const red = tint.color.red;
    std.debug.print("red to red          {d:.4} / {d:.4} / {d:.4}\n", .{
        red.deltaE76(red), red.deltaE94(red), red.deltaE2000(red),
    });
    std.debug.print("red to (250,10,10)  {d:.4} / {d:.4} / {d:.4}\n", .{
        red.deltaE76(tint.color.rgb(250, 10, 10)),
        red.deltaE94(tint.color.rgb(250, 10, 10)),
        red.deltaE2000(tint.color.rgb(250, 10, 10)),
    });
    std.debug.print("red to blue         {d:.4} / {d:.4} / {d:.4}\n", .{
        red.deltaE76(tint.color.blue),
        red.deltaE94(tint.color.blue),
        red.deltaE2000(tint.color.blue),
    });

    std.debug.print("\n=== Quantization ===\n", .{});
    for ([_]tint.color.Color{ tint.color.coral, tint.color.teal, tint.color.gold }) |c| {
        const closest = c.nearestAnsi256();
        std.debug.print("{s}##{s} -> 256:{d:>3} 16:{s}\n", .{
            c.fg().slice(), reset, closest.index, @tagName(c.nearestAnsi16()),
        });
    }
}
