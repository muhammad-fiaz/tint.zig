const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Two-stop interpolation ===\n", .{});
    {
        const text = "red to blue";
        const from = tint.color.red;
        const to = tint.color.blue;
        const reset = tint.ansi.reset.all;
        const last = @max(text.len - 1, 1);
        for (text, 0..) |c, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(last));
            std.debug.print("{s}{c}{s}", .{ from.mix(to, t).fg().slice(), c, reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Hue sweep ===\n", .{});
    {
        const text = "hue across the full colour wheel";
        const reset = tint.ansi.reset.all;
        const last = @max(text.len - 1, 1);
        for (text, 0..) |c, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(last));
            const hue = tint.color.rgb(255, 0, 0).mixHue(tint.color.rgb(0, 0, 255), t, .shorter);
            std.debug.print("{s}{c}{s}", .{ hue.fg().slice(), c, reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Temperature sweep ===\n", .{});
    {
        const text = "warm to cool, 1000K to 40000K";
        const reset = tint.ansi.reset.all;
        const last = @max(text.len - 1, 1);
        for (text, 0..) |c, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(last));
            const temp: u16 = @intFromFloat(1000 + t * 39000);
            std.debug.print("{s}{c}{s}", .{ tint.color.kelvin(temp).fg().slice(), c, reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Palette ramp ===\n", .{});
    {
        var table: [64]tint.color.Rgb = undefined;
        const stops = [_]tint.color.Rgb{
            .{ .r = 255, .g = 0, .b = 0 },
            .{ .r = 255, .g = 215, .b = 0 },
            .{ .r = 0, .g = 128, .b = 0 },
            .{ .r = 0, .g = 0, .b = 255 },
        };
        tint.palette.gradient(&table, &stops);
        const reset = tint.ansi.reset.all;
        for (table) |entry| {
            std.debug.print("{s}#{s}", .{ tint.color.fromRgb(entry).fg().slice(), reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Bold gradient via Style ===\n", .{});
    {
        const text = "bold gradient via composition";
        const base = tint.style.bold;
        const reset = tint.ansi.reset.all;
        const last = @max(text.len - 1, 1);
        for (text, 0..) |c, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(last));
            const blended = tint.color.rgb(255, 0, 100).mix(tint.color.rgb(0, 100, 255), t);
            std.debug.print("{s}{c}{s}", .{ base.fg(blended).toAnsi().slice(), c, reset });
        }
        std.debug.print("\n", .{});
    }
}
