# Getting Started

tint.zig is a comprehensive, explicit color and text styling library for Zig.

## Installation

Add tint.zig as a dependency in your `build.zig.zon`:

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...",
    },
},
```

Then import it in your code:

```zig
const tint = @import("tint");
```

## Quick Start

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Basic colored output
    std.debug.print("{s}Error: something went wrong!{s}\n", .{
        tint.fg(.{ .ansi4 = .red }),
        tint.reset,
    });

    // Using RGB colors
    std.debug.print("{s}Custom color{s}\n", .{
        tint.fg(tint.rgb(255, 100, 20)),
        tint.reset,
    });

    // Using HEX colors
    std.debug.print("{s}HEX color{s}\n", .{
        tint.fg(tint.hex(0xFF6600)),
        tint.reset,
    });

    // Using styles
    const error_style = tint.style(.{
        .fg = tint.hex(0xEF4444),
        .bold = true,
    });
    std.debug.print("{s}Bold error!{s}\n", .{ error_style.toAnsi(), tint.reset });
}
```

## Design Philosophy

tint.zig follows one fundamental rule:

> **Explicit input → explicit color/style representation → correct ANSI/SGR code → returned to the client.**

The library:
- Never prints to stdout/stderr
- Never owns the writer
- Never modifies terminal state
- Never auto-detects capabilities

Your application owns all output. tint.zig only constructs the ANSI codes.
