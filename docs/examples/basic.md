# Basic Example

Simple colored output with tint.zig.

## Code

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Basic foreground colors
    std.debug.print("{s}Red text{s}\n", .{ tint.fg(.{ .ansi4 = .red }), tint.reset });
    std.debug.print("{s}Green text{s}\n", .{ tint.fg(.{ .ansi4 = .green }), tint.reset });
    std.debug.print("{s}Blue text{s}\n", .{ tint.fg(.{ .ansi4 = .blue }), tint.reset });

    // Background colors
    std.debug.print("{s}White on blue{s}\n", .{ tint.bg(.{ .ansi4 = .blue }), tint.reset });

    // HEX colors
    std.debug.print("{s}Custom orange{s}\n", .{ tint.fg(tint.hex(0xFF6600)), tint.reset });

    // Styles
    const bold_style = tint.style(.{ .bold = true, .fg = .{ .ansi4 = .yellow } });
    std.debug.print("{s}Bold yellow{s}\n", .{ bold_style.toAnsi(), tint.reset });
}
```

## Key Points

- Use `tint.fg()` for foreground colors
- Use `tint.bg()` for background colors
- Use `tint.hex(0xRRGGBB)` for HEX colors
- Use `tint.style()` for composable styles
- Always use `tint.reset` to clear styling
