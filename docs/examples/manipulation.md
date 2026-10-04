---
title: Manipulation Example
description: "Lighten, darken, saturate, fade and invert colors; interpolate in every space and walk explicit hue paths."
keywords: "color manipulation example, color interpolation, hue rotation, color harmony"
---

# Manipulation Example

Adjustments, interpolation spaces, hue paths, harmony. Run with `zig build run-manipulation`.

```zig
base.lighten(0.2); base.fade(0.4); base.invert();
base.withLightness(75);

from.mixIn(to, t, .oklab);       // rgb/hsl/hsv/lab/lch/oklab/oklch
from.mixHue(to, t, .shorter);    // shorter/longer/increasing/decreasing

base.complementary();
var triadic: [3]tint.color.Color = undefined;
_ = tint.palette.triadic(&triadic, base);
```
