const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // 2 color foreground gradient using Color.lerp (core primitive)
    std.debug.print("\n=== Foreground Gradient (2 colors) ===\n", .{});
    {
        const text = "Gradient text using lerp!";
        const c1 = tint.Color{ .rgb = tint.RgbColor.init(255, 0, 0) };
        const c2 = tint.Color{ .rgb = tint.RgbColor.init(0, 0, 255) };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // 3 color foreground gradient (red -> green -> blue)
    std.debug.print("\n=== Foreground Gradient (3 colors) ===\n", .{});
    {
        const text = "Rainbow gradient with 3 stops!";
        const c1 = tint.Color{ .rgb = tint.RgbColor.init(255, 0, 0) };
        const c2 = tint.Color{ .rgb = tint.RgbColor.init(0, 255, 0) };
        const c3 = tint.Color{ .rgb = tint.RgbColor.init(0, 0, 255) };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = if (t < 0.5)
                tint.Color.lerp(c1, c2, t * 2.0)
            else
                tint.Color.lerp(c2, c3, (t - 0.5) * 2.0);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Background gradient
    std.debug.print("\n=== Background Gradient ===\n", .{});
    {
        const text = "Background gradient text!";
        const c1 = tint.Color{ .rgb = tint.RgbColor.init(0, 0, 100) };
        const c2 = tint.Color{ .rgb = tint.RgbColor.init(100, 0, 0) };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            std.debug.print("{s}{c}{s}", .{ c.toBg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Warm gradient using named colors
    std.debug.print("\n=== Warm Gradient (Named Colors) ===\n", .{});
    {
        const text = "Warm gradient using named colors!";
        const c1 = tint.Color{ .rgb = tint.Named.red };
        const c2 = tint.Color{ .rgb = tint.Named.orange };
        const c3 = tint.Color{ .rgb = tint.Named.gold };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = if (t < 0.5)
                tint.Color.lerp(c1, c2, t * 2.0)
            else
                tint.Color.lerp(c2, c3, (t - 0.5) * 2.0);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Cool gradient using HSL
    std.debug.print("\n=== Cool Gradient (HSL) ===\n", .{});
    {
        const text = "Cool gradient via HSL conversion!";
        const c1 = tint.hsl(200, 100, 50);
        const c2 = tint.hsl(280, 100, 50);
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Gradient with luminance awareness
    std.debug.print("\n=== Luminance Aware Gradient ===\n", .{});
    {
        const text = "Luminance adjusts for readability!";
        const c1 = tint.Color{ .rgb = tint.RgbColor.init(255, 0, 0) };
        const c2 = tint.Color{ .rgb = tint.RgbColor.init(0, 200, 255) };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            _ = c.luminance();
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Palette gradient using multiGradient
    std.debug.print("\n=== Palette Gradient (multiGradient) ===\n", .{});
    {
        const stops = [_]tint.RgbColor{
            .{ .r = 255, .g = 0, .b = 0 },
            .{ .r = 0, .g = 255, .b = 0 },
            .{ .r = 0, .g = 0, .b = 255 },
            .{ .r = 255, .g = 0, .b = 255 },
        };
        const gradient = tint.palette.multiGradient(&stops, 50);
        var i: u8 = 0;
        while (i < 50) : (i += 1) {
            const c = tint.Color{ .rgb = gradient[i] };
            std.debug.print("{s}#{s}", .{ c.toFg(), tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Hue gradient (rainbow)
    std.debug.print("\n=== Hue Gradient (Rainbow) ===\n", .{});
    {
        const gradient = tint.palette.hueGradient(24);
        var i: u8 = 0;
        while (i < 24) : (i += 1) {
            const c = tint.Color{ .rgb = gradient[i] };
            std.debug.print("{s}#{s}", .{ c.toFg(), tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Complementary gradient
    std.debug.print("\n=== Complementary Gradient ===\n", .{});
    {
        const base = tint.rgb(255, 100, 0);
        const comp = base.complementary();
        const text = "Complementary gradient!";
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(base, comp, t);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Triadic gradient
    std.debug.print("\n=== Triadic Gradient ===\n", .{});
    {
        const base = tint.hsl(0, 100, 50);
        const tri = base.triadic();
        const text = "Triadic harmony gradient!";
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const seg = t * 2.0;
            const c = if (seg < 1.0)
                tint.Color.lerp(base, tri[0], seg)
            else
                tint.Color.lerp(tri[0], tri[1], seg - 1.0);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Temperature gradient
    std.debug.print("\n=== Temperature Gradient ===\n", .{});
    {
        const text = "Temperature gradient warm to cool!";
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const temp: u16 = @intFromFloat(1000.0 + t * 39000.0);
            const c = tint.Color{ .rgb = tint.Color.temperatureToRgb(temp) };
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Fade gradient
    std.debug.print("\n=== Fade Gradient ===\n", .{});
    {
        const text = "Fade effect using primitives!";
        const base = tint.rgb(255, 100, 50);
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = base.fade(t);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    // Style composed gradient
    std.debug.print("\n=== Style Composed Gradient ===\n", .{});
    {
        const base = tint.Style.init(.{ .bold = true });
        const text = "Bold gradient with style composition!";
        const c1 = tint.rgb(255, 0, 100);
        const c2 = tint.rgb(0, 100, 255);
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            const s = base.withFg(c);
            std.debug.print("{s}{c}{s}", .{ s.toAnsi(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n=== Demo Complete ===\n", .{});
}
