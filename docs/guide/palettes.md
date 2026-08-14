# Palettes

tint.zig provides access to standard color palettes and utilities for generating custom color sequences.

## ANSI 16 Palette

```zig
const colors = tint.palette.ansi16;
// 16 AnsiRgb values with names
const names = tint.palette.ansi16_names;
// "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
// "bright_black", "bright_red", "bright_green", "bright_yellow",
// "bright_blue", "bright_magenta", "bright_cyan", "bright_white"
```

## ANSI 256 Palette

```zig
const colors = tint.palette.ansi256;
// 256 AnsiRgb values (comptime-generated)
```

## RGB Cube Helper

Convert 6x6x6 coordinates to ANSI 256 index:

```zig
const result = tint.palette.rgb6(5, 0, 0);
// result.index = 196 (ANSI 256 index for red)
tint.fg(tint.ansi256(result.index));
```

## Grayscale Helper

Access grayscale ramp (indices 232-255):

```zig
const result = tint.palette.gray(12);
// result.index = 244 (ANSI 256 index for gray)
tint.fg(tint.ansi256(result.index));
```

## Color Ramp

Linear interpolation between two colors:

```zig
const ramp = tint.palette.ramp(
    .{ .r = 0, .g = 0, .b = 0 },     // Start (black)
    .{ .r = 255, .g = 255, .b = 255 }, // End (white)
    10,                                // Number of steps
);
// ramp[0] = black, ramp[5] = gray, ramp[10] = white
```

## Gradient

Three-color gradient:

```zig
const gradient = tint.palette.gradient(
    .{ .r = 255, .g = 0, .b = 0 },   // Red
    .{ .r = 0, .g = 255, .b = 0 },   // Green
    .{ .r = 0, .g = 0, .b = 255 },   // Blue
    10,                                // Number of steps
);
```

## Color Wheel

Full hue rainbow:

```zig
const wheel = tint.palette.colorWheel(12);
// 12 evenly spaced hues around the color wheel
```

## Palette Subsets

Pre-defined color groups:

```zig
const warm = tint.palette.warm_palette;    // 8 warm colors (reds, oranges, yellows)
const cool = tint.palette.cool_palette;    // 8 cool colors (blues, cyans, teals)
const earth = tint.palette.earth_palette;  // 8 earth tones (browns, tans)
const pastel = tint.palette.pastel_palette; // 8 pastel colors
const neon = tint.palette.neon_palette;    // 8 neon/bright colors
```
