const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== CMYK Colors ===\n\n", .{});

    // Pure CMYK colors
    std.debug.print("{s}Cyan (100,0,0,0){s}\n", .{
        tint.fg(tint.cmyk(100, 0, 0, 0)), tint.reset,
    });
    std.debug.print("{s}Magenta (0,100,0,0){s}\n", .{
        tint.fg(tint.cmyk(0, 100, 0, 0)), tint.reset,
    });
    std.debug.print("{s}Yellow (0,0,100,0){s}\n", .{
        tint.fg(tint.cmyk(0, 0, 100, 0)), tint.reset,
    });
    std.debug.print("{s}Key/Black (0,0,0,100){s}\n", .{
        tint.fg(tint.cmyk(0, 0, 0, 100)), tint.reset,
    });

    // Mixed CMYK colors
    std.debug.print("{s}Red (0,100,100,0){s}\n", .{
        tint.fg(tint.cmyk(0, 100, 100, 0)), tint.reset,
    });
    std.debug.print("{s}Green (100,0,100,0){s}\n", .{
        tint.fg(tint.cmyk(100, 0, 100, 0)), tint.reset,
    });
    std.debug.print("{s}Blue (100,100,0,0){s}\n", .{
        tint.fg(tint.cmyk(100, 100, 0, 0)), tint.reset,
    });

    // CMYK with black ink
    std.debug.print("{s}Dark Red (0,100,100,20){s}\n", .{
        tint.fg(tint.cmyk(0, 100, 100, 20)), tint.reset,
    });
    std.debug.print("{s}Navy (100,100,0,50){s}\n", .{
        tint.fg(tint.cmyk(100, 100, 0, 50)), tint.reset,
    });

    // CMYK conversion
    std.debug.print("\n--- CMYK Conversion ---\n", .{});
    const red = tint.cmyk(0, 100, 100, 0);
    const rgb = red.toRgb();
    std.debug.print("CMYK(0,100,100,0) -> RGB({d},{d},{d})\n", .{ rgb.r, rgb.g, rgb.b });

    // RGB to CMYK (use Named.coral as RgbColor, convert to Color first)
    const coral_rgb = tint.Named.coral;
    const coral_color = tint.Color{ .rgb = coral_rgb };
    const cmyk = coral_color.toCmyk();
    std.debug.print("Coral -> CMYK({d},{d},{d},{d})\n", .{ cmyk.c, cmyk.m, cmyk.y, cmyk.k });
}
