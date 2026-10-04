---
title: Analysis Example
description: "Measure luminance, WCAG contrast, readability grades, CIE color distance and palette quantization."
keywords: "color analysis example, luminance, contrast ratio, deltaE, nearest ansi"
---

# Analysis Example

Luminance, contrast, distance, quantization. Run with `zig build run-analysis`.

```zig
c.luminance(); c.isLight();
fg.contrastRatio(bg);
tint.palette.readability(fg, bg);  // fail/large/aa/aaa

red.deltaE76(blue); red.deltaE94(blue); red.deltaE2000(blue);
red.oklabDistance(blue);

c.nearestAnsi256(); c.nearestAnsi16();
```
