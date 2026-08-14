# Palettes

Demonstrates access to the ANSI 16, ANSI 256, RGB 6x6x6 cube, and grayscale palettes.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== ANSI 16 Palette ===\n", .{});
    var i: usize = 0;
    while (i < 16) : (i += 1) {
        const c = tint.palette.ansi16[i];
        std.debug.print("{s}{d:3}{s} ", .{ tint.fg(tint.rgb(c.r, c.g, c.b)), i, tint.reset });
    }
    std.debug.print("\n", .{});

    std.debug.print("\n=== ANSI 256 Palette (rows of 16) ===\n", .{});
    i = 0;
    while (i < 256) : (i += 1) {
        const c = tint.palette.ansi256[i];
        std.debug.print("{s}##{s}", .{ tint.fg(tint.rgb(c.r, c.g, c.b)), tint.reset });
        if (i % 16 == 15) std.debug.print("\n", .{});
    }
}
```

## Running

```bash
zig build run-palettes
```
