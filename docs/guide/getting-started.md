# Getting Started

a guide to help you get started with `tint.zig`, a fast, minimal, zero dependency terminal color and text styling library for Zig 0.16.0+. This guide will walk you through installation, basic usage, and the design philosophy behind the library.

## Installation

### Method 1: Zig Fetch (Recommended)

**Stable Release (v0.0.1):**

```bash
zig fetch --save https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz
```

**Development Branch:**

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig.git
```

### Method 2: Manual `build.zig.zon` Configuration

**Stable Release:**

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

**Development Branch:**

```zig
.dependencies = .{
    .tint = .{
        .url = "git+https://github.com/muhammad-fiaz/tint.zig.git",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

### Method 3: Local Source Checkout

```bash
git clone https://github.com/muhammad-fiaz/tint.zig.git
cd tint.zig
zig build
```

To use a local checkout from another project, add a path dependency to your `build.zig.zon`:

```zig
.dependencies = .{
    .tint = .{
        .path = "../tint.zig",
    },
},
```

### Configure build.zig

Then add it to your `build.zig`:

```zig
const tint_dep = b.dependency("tint", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("tint", tint_dep.module("tint"));
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

> [!TIP]
> Use `tint.style()` to create reusable, composable styles. Call `.with()` to extend a style without modifying the original.

## Design Philosophy

`tint.zig` follows one fundamental rule:

> **Explicit input, explicit color/style representation, correct ANSI/SGR code, returned to the client.**

The library never:
- Prints to stdout/stderr
- Owns the writer
- Modifies terminal state
- Auto-detects capabilities

Your application owns all output.
