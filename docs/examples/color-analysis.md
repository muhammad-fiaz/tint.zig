# Color Analysis

tint.zig provides functions to analyze color properties.

## Luminance

Relative luminance (0.0 = black, 1.0 = white).

```zig
const red = tint.rgb(255, 0, 0);
const lum = red.luminance(); // ~0.2126
```

## Light / Dark

Check if a color is perceived as light or dark.

```zig
const red = tint.rgb(255, 0, 0);
if (red.isLight()) {
    // Use dark text
} else {
    // Use light text
}
```

## Contrast Ratio

WCAG 2.0 contrast ratio between two colors (1:1 to 21:1).

```zig
const white = tint.rgb(255, 255, 255);
const black = tint.rgb(0, 0, 0);
const ratio = white.contrastRatio(black); // 21.0
```

## Color Distance

Perceptual distance between two colors using CIE76.

```zig
const red = tint.rgb(255, 0, 0);
const blue = tint.rgb(0, 0, 255);
const dist = red.colorDistance(blue); // ~100+ (far apart)
```

## Nearest ANSI 256

Find the closest ANSI 256 color index.

```zig
const red = tint.rgb(255, 0, 0);
const index = red.nearestAnsi256(); // 196
```

## CIE Lab

Convert to CIE Lab color space for perceptual analysis.

```zig
const red = tint.rgb(255, 0, 0);
const lab = red.toLab();
std.debug.print("L={d:.2} a={d:.2} b={d:.2}\n", .{ lab.l, lab.a, lab.b_val });
```

## Running

```bash
zig build run-color_analysis
```

## Source

See [`examples/color_analysis.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/color_analysis.zig) for the complete example.
