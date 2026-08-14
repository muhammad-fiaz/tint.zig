# Themes

Demonstrates using built-in themes, creating custom themes with `background` and `surface` fields, and switching between themes.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const dark = tint.themes.dark_theme;
    std.debug.print("{s}Primary{s}\n", .{ tint.fg(dark.primary), tint.reset });
    std.debug.print("{s}Error{s}\n", .{ tint.fg(dark.err), tint.reset });

    const custom = tint.Theme{
        .name = "custom", .primary = tint.hex(0x6366F1),
        .secondary = tint.hex(0x8B5CF6), .success = tint.hex(0x10B981),
        .warning = tint.hex(0xF59E0B), .err = tint.hex(0xEF4444),
        .info = tint.hex(0x3B82F6), .text = tint.hex(0xE5E7EB),
        .muted = tint.hex(0x6B7280), .background = tint.hex(0x1F2937),
        .surface = tint.hex(0x374151),
    };
    std.debug.print("{s}Custom Primary{s}\n", .{ tint.fg(custom.primary), tint.reset });
}
```

## Running

```bash
zig build run-themes
```
