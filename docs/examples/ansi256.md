# ANSI 256

Demonstrates the full ANSI 256-color palette, RGB cube, and grayscale ramp.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== ANSI 256 Colors ===\n", .{});
    std.debug.print("{s}Index 1 (Red){s}\n", .{ tint.fg(tint.ansi256(1)), tint.reset });
    std.debug.print("{s}Index 196 (Pure Red){s}\n", .{ tint.fg(tint.ansi256(196)), tint.reset });
    std.debug.print("{s}Index 208 (Orange){s}\n", .{ tint.fg(tint.ansi256(208)), tint.reset });

    std.debug.print("\n=== Grayscale Ramp ===\n", .{});
    var i: u8 = 0;
    while (i < 24) : (i += 1) {
        const idx: u8 = 232 + i;
        std.debug.print("{s}Gray {d:3}{s} ", .{ tint.fg(tint.ansi256(idx)), i, tint.reset });
    }
    std.debug.print("\n", .{});

    const red_cube = tint.palette.rgb6(5, 0, 0);
    std.debug.print("{s}RGB(5,0,0) -> Index {d}{s}\n", .{
        tint.fg(tint.ansi256(red_cube.index)), red_cube.index, tint.reset,
    });
}
```

## Running

```bash
zig build run-ansi256
```
