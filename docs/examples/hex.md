# HEX Colors

Demonstrates HEX color input from integers, including background colors and HEX to RGB conversion.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== HEX Colors ===\n", .{});
    std.debug.print("{s}#FF0000 (Red){s}\n", .{ tint.fg(tint.hex(0xFF0000)), tint.reset });
    std.debug.print("{s}#00FF00 (Green){s}\n", .{ tint.fg(tint.hex(0x00FF00)), tint.reset });
    std.debug.print("{s}#0000FF (Blue){s}\n", .{ tint.fg(tint.hex(0x0000FF)), tint.reset });
    std.debug.print("{s}White on #1a1a2e{s}\n", .{ tint.bg(tint.hex(0x1a1a2e)), tint.reset });

    const color = tint.hex(0xFF6600);
    const rgb_val = color.toRgb();
    std.debug.print("\n#FF6600 -> RGB({d}, {d}, {d})\n", .{ rgb_val.r, rgb_val.g, rgb_val.b });
}
```

## Running

```bash
zig build run-hex
```
