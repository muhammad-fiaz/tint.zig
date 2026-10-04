const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== ANSI 16 ===\n", .{});
    for (tint.palette.ansi16, 0..) |entry, i| {
        std.debug.print("{s}##{s} {s:<14}rgb({d:>3}, {d:>3}, {d:>3})\n", .{
            tint.color.fromRgb(entry).fg().slice(), reset,
            tint.palette.ansi16Names[i],            entry.r,
            entry.g,                                entry.b,
        });
    }

    std.debug.print("\n=== Ramps need a buffer ===\n", .{});
    var ramp: [24]tint.color.Rgb = undefined;
    tint.palette.ramp(&ramp, tint.color.black.toRgb(), tint.color.white.toRgb());
    for (ramp) |entry| {
        std.debug.print("{s}##{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print("\n", .{});

    var hues: [72]tint.color.Rgb = undefined;
    tint.palette.hue(&hues);
    for (hues) |entry| {
        std.debug.print("{s}#{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print("\n", .{});

    std.debug.print("\n=== Sequential, diverging, categorical ===\n", .{});
    var sequential: [12]tint.color.Rgb = undefined;
    tint.palette.sequential(&sequential, 210);
    for (sequential) |entry| {
        std.debug.print("{s}##{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print(" sequential\n", .{});

    var diverging: [13]tint.color.Rgb = undefined;
    tint.palette.diverging(&diverging, .{ 0, 220 });
    for (diverging) |entry| {
        std.debug.print("{s}##{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print(" diverging\n", .{});

    var categorical: [8]tint.color.Rgb = undefined;
    tint.palette.categorical(&categorical);
    for (categorical) |entry| {
        std.debug.print("{s}##{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
    }
    std.debug.print(" categorical\n", .{});

    std.debug.print("\n=== Subsets ===\n", .{});
    const subsets = .{
        .{ "warm", tint.palette.warm },
        .{ "cool", tint.palette.cool },
        .{ "earth", tint.palette.earth },
        .{ "pastel", tint.palette.pastel },
        .{ "neon", tint.palette.neon },
    };
    inline for (subsets) |subset| {
        std.debug.print("  {s:<8}{s}", .{ subset[0], reset });
        for (subset[1]) |entry| {
            std.debug.print("{s}##{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Palette checks ===\n", .{});
    const candidates = [_]tint.color.Color{ tint.color.white, tint.color.black, tint.color.red };
    std.debug.print("min contrast {d:.2}  max contrast {d:.2}\n", .{
        tint.palette.minContrastRatio(&candidates),
        tint.palette.maxContrastRatio(&candidates),
    });
    std.debug.print("duplicates={} ordered={}\n", .{
        tint.palette.hasDuplicates(&candidates),
        tint.palette.isMonotonicLuminance(&candidates),
    });
}
