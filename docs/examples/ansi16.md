# ANSI 16

Demonstrates the full ANSI 4-bit (16-color) palette with foreground and background colors.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== ANSI 4-Bit Colors ===\n", .{});
    std.debug.print("{s}Black{s}\n", .{ tint.fg(.{ .ansi4 = .black }), tint.reset });
    std.debug.print("{s}Red{s}\n", .{ tint.fg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}Green{s}\n", .{ tint.fg(.{ .ansi4 = .green }), tint.reset });
    std.debug.print("{s}Yellow{s}\n", .{ tint.fg(.{ .ansi4 = .yellow }), tint.reset });
    std.debug.print("{s}Blue{s}\n", .{ tint.fg(.{ .ansi4 = .blue }), tint.reset });
    std.debug.print("{s}Magenta{s}\n", .{ tint.fg(.{ .ansi4 = .magenta }), tint.reset });
    std.debug.print("{s}Cyan{s}\n", .{ tint.fg(.{ .ansi4 = .cyan }), tint.reset });
    std.debug.print("{s}White{s}\n", .{ tint.fg(.{ .ansi4 = .white }), tint.reset });

    std.debug.print("\n=== Background Colors ===\n", .{});
    std.debug.print("{s}Red background{s}\n", .{ tint.bg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}Green background{s}\n", .{ tint.bg(.{ .ansi4 = .green }), tint.reset });
    std.debug.print("{s}Blue background{s}\n", .{ tint.bg(.{ .ansi4 = .blue }), tint.reset });
}
```

## Running

```bash
zig build run-ansi16
```
