---
title: ANSI Example
description: "Print the 16 ANSI base colors, bright variants and terminal defaults with names and RGB values."
keywords: "ansi 16 colors example, bright colors, terminal default color"
---

# ANSI Example

4-bit colors and terminal defaults. Run with `zig build run-ansi`.

```zig
for (tint.color.Ansi4.all) |a| {
    const c: tint.color.Color = .{ .ansi4 = a };
    std.debug.print("{s}##{s} ", .{ c.fg().slice(), reset });
}

tint.color.ansi4.red;          // base colors as values
tint.color.ansi4.default;      // terminal default
tint.palette.ansi16[i];        // RGB preview
tint.palette.ansi16Names[i];   // camelCase names
```
