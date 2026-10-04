---
title: Gradient Example
description: "Render per-character gradient text with interpolation, hue sweeps, temperature sweeps and style composition."
keywords: "gradient text example, color lerp, temperature gradient, styled gradient"
---

# Gradient Example

Per-character gradient text from interpolation primitives. Run with `zig build run-gradient`.

```zig
from.mix(to, t);                    // two-stop text
red.mixHue(blue, t, .shorter);      // hue sweep
tint.color.kelvin(temp);            // temperature sweep
tint.palette.gradient(&table, &stops);
base.fg(blended).toAnsi();          // style-composed gradient
```
