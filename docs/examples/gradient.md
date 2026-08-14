# Gradient

Demonstrates how to build foreground and background gradient text using the library's core primitives (`Color.lerp`, `Color.fade`, `palette.multiGradient`, `palette.hueGradient`). No built-in gradient function is needed; gradients are composed explicitly from color manipulation methods.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("\n=== Foreground Gradient (2 colors) ===\n", .{});
    {
        const text = "Gradient text using lerp!";
        const c1 = tint.Color{ .rgb = tint.RgbColor.init(255, 0, 0) };
        const c2 = tint.Color{ .rgb = tint.RgbColor.init(0, 0, 255) };
        for (text, 0..) |ch, i| {
            const t = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(text.len - 1));
            const c = tint.Color.lerp(c1, c2, t);
            std.debug.print("{s}{c}{s}", .{ c.toFg(), ch, tint.reset });
        }
        std.debug.print("\n", .{});
    }
    // ... more gradient examples
}
```

## Running

```bash
zig build run-gradient
```
