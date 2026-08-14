const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Color Temperature ===\n\n", .{});

    // Warm to cool
    const temps = [_]struct { temp: u16, name: []const u8 }{
        .{ .temp = 1000, .name = "Candle light" },
        .{ .temp = 2000, .name = "Warm white" },
        .{ .temp = 2700, .name = "Incandescent" },
        .{ .temp = 3000, .name = "Halogen" },
        .{ .temp = 4000, .name = "Fluorescent" },
        .{ .temp = 5000, .name = "Direct sunlight" },
        .{ .temp = 5500, .name = "Noon sunlight" },
        .{ .temp = 6000, .name = "Daylight" },
        .{ .temp = 6500, .name = "Cloudy daylight" },
        .{ .temp = 7000, .name = "Shade" },
        .{ .temp = 7500, .name = "Overcast sky" },
        .{ .temp = 8000, .name = "Light blue sky" },
        .{ .temp = 9300, .name = "LCD white" },
        .{ .temp = 10000, .name = "Blue sky" },
        .{ .temp = 15000, .name = "Deep blue sky" },
        .{ .temp = 20000, .name = "Very blue" },
        .{ .temp = 30000, .name = "UV blue" },
        .{ .temp = 40000, .name = "Near UV" },
    };

    for (temps) |t| {
        const rgb = tint.Color.temperatureToRgb(t.temp);
        std.debug.print("{s}{d: >5}K - {s}{s}\n", .{
            tint.fg(.{ .rgb = rgb }),
            t.temp,
            t.name,
            tint.reset,
        });
    }

    // Direct kelvin usage
    std.debug.print("\n--- Direct Kelvin ---\n", .{});
    std.debug.print("{s}2700K Warm{s}\n", .{ tint.fg(tint.kelvin(2700)), tint.reset });
    std.debug.print("{s}6500K Cool{s}\n", .{ tint.fg(tint.kelvin(6500)), tint.reset });

    // Conversion
    const warm = tint.kelvin(2700);
    const rgb = warm.toRgb();
    std.debug.print("2700K -> RGB({d},{d},{d})\n", .{ rgb.r, rgb.g, rgb.b });
}
