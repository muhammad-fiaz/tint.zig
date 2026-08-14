# HSL Colors

Demonstrates the HSL (Hue, Saturation, Lightness) color space with hue spectrum, saturation, and lightness variations.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== HSL Colors ===\n", .{});
    std.debug.print("{s}HSL(0, 100, 50) - Red{s}\n", .{ tint.fg(tint.hsl(0, 100, 50)), tint.reset });
    std.debug.print("{s}HSL(120, 100, 50) - Green{s}\n", .{ tint.fg(tint.hsl(120, 100, 50)), tint.reset });
    std.debug.print("{s}HSL(240, 100, 50) - Blue{s}\n", .{ tint.fg(tint.hsl(240, 100, 50)), tint.reset });

    std.debug.print("\n=== Hue Spectrum ===\n", .{});
    var h: u16 = 0;
    while (h < 360) : (h += 15) {
        std.debug.print("{s}#{s}", .{ tint.fg(tint.hsl(h, 100, 50)), tint.reset });
    }
    std.debug.print("\n", .{});
}
```

## Running

```bash
zig build run-hsl
```
