---
title: ANSI 256 Example
description: "Print the 256 and 88 color palettes, indexed constructors, and the capability downgrade ladder."
keywords: "ansi 256 example, 88 color palette, indexed color, terminal capability"
---

# ANSI 256 Example

Indexed colors, both palettes, and explicit capabilities. Run with `zig build run-ansi256`.

```zig
tint.color.ansi256.rgb(5, 0, 0);   // 6x6x6 cube
tint.color.ansi256.gray(12);       // grayscale ramp
tint.color.ansi256.index(196);     // arbitrary index
tint.color.ansi88.rgb(3, 2, 1);    // 4x4x4 cube
tint.color.ansi88.gray(7);

tint.ansi.render(color, .foreground, .ansi256);
tint.ansi.render(color, .foreground, .ansi16);
tint.ansi.render(color, .foreground, .none);
```
