const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Color palettes
    std.debug.print("=== ANSI 16 Palette ===\n", .{});
    var i: u8 = 0;
    while (i < 16) : (i += 1) {
        const c = tint.palette.ansi16[i];
        std.debug.print("{s}{d:3}{s} ", .{
            tint.fg(tint.rgb(c.r, c.g, c.b)),
            i,
            tint.reset,
        });
    }
    std.debug.print("\n", .{});

    // Full 256 palette
    std.debug.print("\n=== ANSI 256 Palette (rows of 16) ===\n", .{});
    i = 0;
    while (i < 256) : (i += 1) {
        const c = tint.palette.ansi256[i];
        std.debug.print("{s}██{s}", .{
            tint.fg(tint.rgb(c.r, c.g, c.b)),
            tint.reset,
        });
        if (i % 16 == 15) {
            std.debug.print("\n", .{});
        }
    }

    // RGB cube
    std.debug.print("\n=== RGB Cube (6x6x6) ===\n", .{});
    var r: u8 = 0;
    while (r < 6) : (r += 1) {
        var g: u8 = 0;
        while (g < 6) : (g += 1) {
            var b: u8 = 0;
            while (b < 6) : (b += 1) {
                const result = tint.palette.rgb6(r, g, b);
                const c = tint.palette.ansi256[result.index];
                std.debug.print("{s}██{s}", .{
                    tint.fg(tint.rgb(c.r, c.g, c.b)),
                    tint.reset,
                });
            }
            std.debug.print(" ", .{});
        }
        std.debug.print("\n", .{});
    }

    // Grayscale ramp
    std.debug.print("\n=== Grayscale Ramp ===\n", .{});
    i = 0;
    while (i < 24) : (i += 1) {
        const result = tint.palette.gray(i);
        const c = tint.palette.ansi256[result.index];
        std.debug.print("{s}██{s}", .{
            tint.fg(tint.rgb(c.r, c.g, c.b)),
            tint.reset,
        });
    }
    std.debug.print("\n", .{});
}
