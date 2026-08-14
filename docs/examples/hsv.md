# HSV Colors

Demonstrates the HSV (Hue, Saturation, Value) color space with hue spectrum, saturation, and value variations.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== HSV Colors ===\n", .{});
    std.debug.print("{s}HSV(0, 100, 100) - Red{s}\n", .{ tint.fg(tint.hsv(0, 100, 100)), tint.reset });
    std.debug.print("{s}HSV(120, 100, 100) - Green{s}\n", .{ tint.fg(tint.hsv(120, 100, 100)), tint.reset });
    std.debug.print("{s}HSV(240, 100, 100) - Blue{s}\n", .{ tint.fg(tint.hsv(240, 100, 100)), tint.reset });

    std.debug.print("\n=== Hue Spectrum ===\n", .{});
    var h: u16 = 0;
    while (h < 360) : (h += 15) {
        std.debug.print("{s}#{s}", .{ tint.fg(tint.hsv(h, 100, 100)), tint.reset });
    }
    std.debug.print("\n", .{});
}
```

## Running

```bash
zig build run-hsv
```
