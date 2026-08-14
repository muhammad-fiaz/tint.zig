# Style Composition

Demonstrates building complex styles from simpler ones using `style()`, `.with()`, and `.compose()`.

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const error_style = tint.style(.{ .fg = tint.hex(0xEF4444), .bold = true });
    const warning_style = error_style.with(.{ .fg = tint.hex(0xF59E0B), .underline = true });
    const info_style = tint.style(.{ .fg = tint.hex(0x3B82F6), .italic = true });

    std.debug.print("{s}Error message{s}\n", .{ error_style.toAnsi(), tint.reset });
    std.debug.print("{s}Warning message{s}\n", .{ warning_style.toAnsi(), tint.reset });
    std.debug.print("{s}Info message{s}\n", .{ info_style.toAnsi(), tint.reset });
}
```

## Running

```bash
zig build run-composition
```
