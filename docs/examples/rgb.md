# RGB / TrueColor

Demonstrates 24-bit RGB TrueColor support with arbitrary colors and gradient simulation.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== RGB / TrueColor ===\n", .{});
    std.debug.print("{s}Pure Red (255,0,0){s}\n", .{ tint.fg(tint.rgb(255, 0, 0)), tint.reset });
    std.debug.print("{s}Pure Green (0,255,0){s}\n", .{ tint.fg(tint.rgb(0, 255, 0)), tint.reset });
    std.debug.print("{s}Pure Blue (0,0,255){s}\n", .{ tint.fg(tint.rgb(0, 0, 255)), tint.reset });
    std.debug.print("{s}Custom Orange (255,100,20){s}\n", .{ tint.fg(tint.rgb(255, 100, 20)), tint.reset });

    std.debug.print("{s}White on RGB background{s}\n", .{
        tint.bg(tint.rgb(50, 50, 100)), tint.reset,
    });
}
```

## Running

```bash
zig build run-rgb
```
