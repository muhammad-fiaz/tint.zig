const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Gradient Examples ===\n\n", .{});

    // 2-color foreground gradient
    const fg_result = tint.fgGradient("Rainbow text with gradient!", &[_]tint.Color{
        tint.rgb(255, 0, 0),
        tint.rgb(0, 255, 0),
        tint.rgb(0, 0, 255),
    });
    std.debug.print("FG Gradient: {s}\n\n", .{fg_result});

    // 2-color background gradient
    const bg_result = tint.bgGradient("Background gradient text!", &[_]tint.Color{
        tint.rgb(255, 0, 0),
        tint.rgb(0, 0, 255),
    });
    std.debug.print("BG Gradient: {s}\n\n", .{bg_result});

    // Multi-stop gradient using palette
    const stops = [_]tint.RgbColor{
        .{ .r = 255, .g = 0, .b = 0 },
        .{ .r = 255, .g = 127, .b = 0 },
        .{ .r = 255, .g = 255, .b = 0 },
        .{ .r = 0, .g = 255, .b = 0 },
        .{ .r = 0, .g = 0, .b = 255 },
    };
    const gradient = tint.palette.multiGradient(&stops, 50);
    std.debug.print("Multi-stop gradient (first 10 colors):\n", .{});
    for (0..10) |i| {
        const c = gradient[i];
        std.debug.print("  [{d:3},{d:3},{d:3}] ", .{ c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // Hue gradient (rainbow)
    const hue = tint.palette.hueGradient(24);
    std.debug.print("Hue gradient (first 12 colors):\n", .{});
    for (0..12) |i| {
        const c = hue[i];
        std.debug.print("  [{d:3},{d:3},{d:3}] ", .{ c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // Color ramp
    const ramp = tint.palette.ramp(
        tint.rgb(255, 0, 0).toRgb(),
        tint.rgb(0, 0, 255).toRgb(),
        10,
    );
    std.debug.print("Red to Blue ramp (first 5 colors):\n", .{});
    for (0..5) |i| {
        const c = ramp[i];
        std.debug.print("  [{d:3},{d:3},{d:3}] ", .{ c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // 3-color gradient
    const g3 = tint.palette.gradient(
        tint.rgb(255, 0, 0).toRgb(),
        tint.rgb(0, 255, 0).toRgb(),
        tint.rgb(0, 0, 255).toRgb(),
        20,
    );
    std.debug.print("3-color gradient (first 10 colors):\n", .{});
    for (0..10) |i| {
        const c = g3[i];
        std.debug.print("  [{d:3},{d:3},{d:3}] ", .{ c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // Color wheel
    const wheel = tint.palette.colorWheel(24);
    std.debug.print("Color wheel (first 12 colors):\n", .{});
    for (0..12) |i| {
        const c = wheel[i];
        std.debug.print("  [{d:3},{d:3},{d:3}] ", .{ c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // Fade color toward gray
    const red = tint.rgb(255, 0, 0);
    std.debug.print("Fade red toward gray:\n", .{});
    for (0..6) |i| {
        const amount = @as(f64, @floatFromInt(i)) / 5.0;
        const faded = red.fade(amount);
        const c = faded.toRgb();
        std.debug.print("  fade({d:.1}): [{d:3},{d:3},{d:3}] ", .{ amount, c.r, c.g, c.b });
    }
    std.debug.print("\n\n", .{});

    // Saturate to specific value
    const desaturated = tint.rgb(100, 150, 200);
    const saturated = desaturated.saturateTo(100);
    std.debug.print("Saturate to 100: [{d},{d},{d}]\n\n", .{
        saturated.toRgb().r,
        saturated.toRgb().g,
        saturated.toRgb().b,
    });

    // Lighten to specific value
    const dark = tint.rgb(20, 20, 20);
    const light = dark.lightenTo(70);
    std.debug.print("Lighten to 70: [{d},{d},{d}]\n\n", .{
        light.toRgb().r,
        light.toRgb().g,
        light.toRgb().b,
    });

    // Grayscale using luminance
    const colorful = tint.rgb(255, 128, 0);
    const lum_gray = colorful.grayscaleLuminance();
    std.debug.print("Grayscale (luminance): [{d},{d},{d}]\n\n", .{
        lum_gray.toRgb().r,
        lum_gray.toRgb().g,
        lum_gray.toRgb().b,
    });

    // Mix in HSL space
    const c1 = tint.hsl(0, 100, 50); // Red
    const c2 = tint.hsl(120, 100, 50); // Green
    const hsl_mixed = c1.mixHsl(c2, 0.5);
    std.debug.print("HSL mix 50%: H={d} S={d} L={d}\n\n", .{
        hsl_mixed.toHsl().h,
        hsl_mixed.toHsl().s,
        hsl_mixed.toHsl().l,
    });

    // Blend (alias for mix)
    const blue = tint.rgb(0, 0, 255);
    const yellow = tint.rgb(255, 255, 0);
    const blended = blue.blend(yellow, 0.5);
    const br = blended.toRgb();
    std.debug.print("Blend blue/yellow 50%: [{d},{d},{d}]\n\n", .{
        br.r, br.g, br.b,
    });

    // Gradient with style
    const styled = tint.style(.{
        .fg = tint.rgb(255, 255, 255),
        .bg = tint.rgb(30, 30, 30),
        .bold = true,
    });
    std.debug.print("{s}Styled gradient text!{s}\n\n", .{
        styled.toAnsi(),
        tint.reset,
    });

    // Named color gradient
    const named_fg = tint.fgGradient("Named color gradient!", &[_]tint.Color{
        tint.rgb(tint.Named.coral.r, tint.Named.coral.g, tint.Named.coral.b),
        tint.rgb(tint.Named.teal.r, tint.Named.teal.g, tint.Named.teal.b),
        tint.rgb(tint.Named.gold.r, tint.Named.gold.g, tint.Named.gold.b),
    });
    std.debug.print("Named FG: {s}\n\n", .{named_fg});

    // Temperature gradient
    const temp_fg = tint.fgGradient("Temperature gradient!", &[_]tint.Color{
        tint.kelvin(2000),
        tint.kelvin(4000),
        tint.kelvin(6500),
        tint.kelvin(10000),
    });
    std.debug.print("Temperature FG: {s}\n\n", .{temp_fg});

    // Theme gradient
    const dark_theme = tint.themes.dark_theme;
    const theme_fg = tint.fgGradient("Theme gradient text!", &[_]tint.Color{
        dark_theme.primary,
        dark_theme.secondary,
        dark_theme.success,
        dark_theme.info,
    });
    std.debug.print("Theme FG: {s}\n\n", .{theme_fg});

    // Complementary color gradient
    const base = tint.rgb(255, 0, 0);
    const comp = base.complementary();
    const comp_fg = tint.fgGradient("Complementary gradient!", &[_]tint.Color{ base, comp });
    std.debug.print("Complementary FG: {s}\n\n", .{comp_fg});

    // Tetradic color gradient
    const tetrad = base.tetradic();
    const tetrad_fg = tint.fgGradient("Tetradic gradient!", &[_]tint.Color{
        base, tetrad[0], tetrad[1], tetrad[2],
    });
    std.debug.print("Tetradic FG: {s}\n\n", .{tetrad_fg});

    std.debug.print("=== Gradient Examples Complete ===\n", .{});
}
