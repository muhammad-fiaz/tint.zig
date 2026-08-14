# Underline Color

Demonstrates colored underlines using ANSI 4-bit, ANSI 256, RGB, and HEX colors.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Underline Colors ===\n", .{});
    std.debug.print("{s}{s}Red underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }), tint.underline(.{ .ansi4 = .red }), tint.reset,
    });
    std.debug.print("{s}{s}Orange underline (256){s}\n", .{
        tint.fg(.{ .ansi4 = .white }), tint.underline(tint.ansi256(208)), tint.reset,
    });
    std.debug.print("{s}{s}Custom RGB underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }), tint.underline(tint.rgb(255, 100, 20)), tint.reset,
    });
    std.debug.print("{s}{s}HEX underline{s}\n", .{
        tint.fg(.{ .ansi4 = .white }), tint.underline(tint.hex(0xFF6600)), tint.reset,
    });
}
```

## Running

```bash
zig build run-underline_color
```
