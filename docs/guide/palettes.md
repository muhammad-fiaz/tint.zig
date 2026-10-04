---
title: Palettes
description: "Work with ANSI palettes, ramps, gradients, sequential and diverging schemes, harmony colors and readability checks."
keywords: "zig color palette, ansi 256 palette, color gradient, color ramp, color harmony, palette analysis"
---

# Palettes

Tables mirror xterm so RGB previews match what terminals show. Generators write into caller-owned buffers and never allocate; analysis helpers answer whether a palette is fit for terminal output.

## Tables

The three indexed palettes as RGB arrays, plus their names:

```zig
tint.palette.ansi16;      // [16]Rgb, the base colors every terminal has
tint.palette.ansi88;      // [88]Rgb, xterm 4x4x4 cube + grayscale layout
tint.palette.ansi256;     // [256]Rgb, 6x6x6 cube + grayscale layout
tint.palette.ansi16Names; // camelCase names, same indexing
tint.palette.ansi88Names;
```

## Indexed Constructors

Build indexed `Color` values without remembering index math. Each validates its range; out-of-range literals are compile errors:

```zig
tint.color.ansi256.rgb(5, 0, 0);  // 6x6x6 cube, coordinates 0...5
tint.color.ansi256.gray(12);      // grayscale ramp, level 0...23
tint.color.ansi256.index(196);    // arbitrary index 0...255
tint.color.ansi88.rgb(3, 2, 1);   // 4x4x4 cube, coordinates 0...3
tint.color.ansi88.gray(7);        // grayscale ramp, level 0...7
```

88-palette indices resolve against the 88-color palette on the terminal; read RGB previews from `palette.ansi88`.

## Generators

`ramp` interpolates between two colors. `gradient` interpolates through any number of stops. `hue` sweeps the full color wheel. `sequential` builds a single-hue light-to-dark ramp, `diverging` builds a two-hue ramp through a light center, and `categorical` spreads distinct hues evenly:

```zig
var ramp: [24]tint.color.Rgb = undefined;
tint.palette.ramp(&ramp, black, white);

var multi: [48]tint.color.Rgb = undefined;
tint.palette.gradient(&multi, &stops);

var wheel: [72]tint.color.Rgb = undefined;
tint.palette.hue(&wheel);

var seq: [12]tint.color.Rgb = undefined;
tint.palette.sequential(&seq, 210);
tint.palette.diverging(&div, .{ 0, 220 });
tint.palette.categorical(&cat);
```

First and last elements are exactly the ends. Empty buffers are no-ops and single slots hold the start color, so there are no division-by-zero paths.

## Harmony Schemes

Write a harmony scheme into a buffer and get back exactly what was written, so short buffers simply truncate the scheme:

```zig
var out: [4]tint.color.Color = undefined;
const used = tint.palette.tetradic(&out, base);
```

Also `complementary`, `analogous`, `triadic` and `splitComplementary`. The same schemes exist as `Color` methods when a fixed-size result is handier.

## Subsets

Five ready-made groups for quick picks:

```zig
tint.palette.warm; tint.palette.cool; tint.palette.earth;
tint.palette.pastel; tint.palette.neon;
```

## Analysis

Grade a palette before shipping it. `readability` maps a foreground/background pair to its WCAG grade; the contrast functions scan every pair (they need at least two colors); `closestPair` reports the smallest CIEDE2000 gap; `isMonotonicLuminance` tells whether luminance runs in one direction:

```zig
tint.palette.readability(fg, bg);       // fail/large/aa/aaa
tint.palette.minContrastRatio(&colors);
tint.palette.maxContrastRatio(&colors);
tint.palette.hasDuplicates(&colors);
tint.palette.closestPair(&colors);
tint.palette.isMonotonicLuminance(&colors);
```
