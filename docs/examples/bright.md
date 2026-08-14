# Bright Colors

Demonstrates bright ANSI 4-bit colors for foreground and background.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== Bright ANSI Colors ===\n", .{});
    std.debug.print("{s}Bright Black (Gray){s}\n", .{ tint.fg(.{ .ansi4 = .bright_black }), tint.reset });
    std.debug.print("{s}Bright Red{s}\n", .{ tint.fg(.{ .ansi4 = .bright_red }), tint.reset });
    std.debug.print("{s}Bright Green{s}\n", .{ tint.fg(.{ .ansi4 = .bright_green }), tint.reset });
    std.debug.print("{s}Bright Yellow{s}\n", .{ tint.fg(.{ .ansi4 = .bright_yellow }), tint.reset });
    std.debug.print("{s}Bright Blue{s}\n", .{ tint.fg(.{ .ansi4 = .bright_blue }), tint.reset });
    std.debug.print("{s}Bright Magenta{s}\n", .{ tint.fg(.{ .ansi4 = .bright_magenta }), tint.reset });
    std.debug.print("{s}Bright Cyan{s}\n", .{ tint.fg(.{ .ansi4 = .bright_cyan }), tint.reset });
    std.debug.print("{s}Bright White{s}\n", .{ tint.fg(.{ .ansi4 = .bright_white }), tint.reset });

    std.debug.print("\n=== Bright Background Colors ===\n", .{});
    std.debug.print("{s}Bright Red bg{s}\n", .{ tint.bg(.{ .ansi4 = .bright_red }), tint.reset });
    std.debug.print("{s}Bright Green bg{s}\n", .{ tint.bg(.{ .ansi4 = .bright_green }), tint.reset });
    std.debug.print("{s}Bright Blue bg{s}\n", .{ tint.bg(.{ .ansi4 = .bright_blue }), tint.reset });
}
```

## Running

```bash
zig build run-bright
```
