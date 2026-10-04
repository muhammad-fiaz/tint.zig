---
title: Palette API
description: "Palette API reference: ANSI tables, ramp and gradient generators, harmony schemes, subsets and readability analysis."
keywords: "zig palette api, ansi tables, color gradient api, palette analysis"
---

# Palette API

## Tables

xterm-faithful RGB arrays plus their names. The 88-color table uses xterm's real layout: 16 base colors, a 4x4x4 cube on the levels `0/139/205/255`, and the 8-step grayscale ramp:

```zig
tint.palette.ansi16;      // [16]Rgb
tint.palette.ansi88;      // [88]Rgb
tint.palette.ansi256;     // [256]Rgb
tint.palette.ansi16Names; // [16][]const u8
tint.palette.ansi88Names; // [88][]const u8
```

## Generators

Every generator writes into a caller buffer and never allocates. Ends are exact, empty buffers are no-ops, and single slots hold the start color, so no call can divide by zero or leave entries uninitialized:

```zig
tint.palette.ramp(&out, start, end);       // two-color interpolation
tint.palette.gradient(&out, &stops);      // any number of stops
tint.palette.hue(&out);                   // full saturated wheel
tint.palette.sequential(&out, hue);       // one hue, light to dark
tint.palette.diverging(&out, .{ a, b });  // two hues through a light center
tint.palette.categorical(&out);           // evenly spaced distinct hues
```

## Harmony Schemes

Each scheme writes up to `out.len` colors and returns the slice that was written, so short buffers truncate instead of failing:

```zig
tint.palette.complementary(&out, base);
tint.palette.analogous(&out, base);
tint.palette.triadic(&out, base);
tint.palette.tetradic(&out, base);
tint.palette.splitComplementary(&out, base);
```

## Subsets

Five ready-made groups for quick picks, all `[8]Rgb`:

```zig
tint.palette.warm; tint.palette.cool; tint.palette.earth;
tint.palette.pastel; tint.palette.neon;
```

## Analysis

Grade a palette before shipping it. Contrast functions scan every pair and need at least two colors; `closestPair` reports the smallest CIEDE2000 gap; `isMonotonicLuminance` accepts ramps running in either direction:

```zig
tint.palette.Readability;              // fail/large/aa/aaa
tint.palette.readability(fg, bg);
tint.palette.minContrastRatio(&colors);
tint.palette.maxContrastRatio(&colors);
tint.palette.hasDuplicates(&colors);
tint.palette.closestPair(&colors);
tint.palette.isMonotonicLuminance(&colors);
```
