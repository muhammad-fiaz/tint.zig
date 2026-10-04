---
title: Complete Tour
description: "Tour the whole tint.zig API in one program: colors, layers, styles, presets, analysis, palettes and themes."
keywords: "tint.zig tour, complete example, terminal color showcase"
---

# Complete Tour

The whole library in one program. Run with `zig build run-complete`.

```zig
tint.color.ansi4.red;
tint.color.ansi256.rgb(5, 0, 0);
tint.color.rgb(255, 100, 20);
tint.color.hex(0x7C3AED);
tint.color.hsl(120, 80, 45);
tint.color.cmyk(0, 100, 100, 0);
tint.color.kelvin(2700);
tint.color.mediumPurple;

tint.style.bold; tint.style.err(...);
base.merge(.{ .underline = true });

tint.palette.ramp(&gradient, red, blue);
tint.theme.dark; tint.theme.tokyoNight;
white.contrastRatio(black);
```
