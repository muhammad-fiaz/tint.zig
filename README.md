<div align="center">

# tint.zig

**A fast, minimal terminal color and text styling library for Zig.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Zig 0.16+](https://img.shields.io/badge/Zig-0.16+-orange.svg)](https://ziglang.org/)
[![GitHub Stars](https://img.shields.io/github/stars/muhammad-fiaz/tint.zig?style=social)](https://github.com/muhammad-fiaz/tint.zig)
[![GitHub Issues](https://img.shields.io/github/issues/muhammad-fiaz/tint.zig)](https://github.com/muhammad-fiaz/tint.zig/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/muhammad-fiaz/tint.zig)](https://github.com/muhammad-fiaz/tint.zig/pulls)
[![Last Commit](https://img.shields.io/github/last-commit/muhammad-fiaz/tint.zig)](https://github.com/muhammad-fiaz/tint.zig)
[![CI](https://img.shields.io/github/actions/workflow/status/muhammad-fiaz/tint.zig/ci.yml?branch=main)](https://github.com/muhammad-fiaz/tint.zig/actions)
[![Platforms](https://img.shields.io/badge/platforms-windows%20%7C%20linux%20%7C%20macos%20%7C%20freebsd-lightgrey.svg)](https://github.com/muhammad-fiaz/tint.zig)
[![Release](https://img.shields.io/github/release/muhammad-fiaz/tint.zig.svg)](https://github.com/muhammad-fiaz/tint.zig/releases)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%9D%A4-red.svg)](https://github.com/sponsors/muhammad-fiaz)
[![Visitors](https://api.visitorbadge.io/api/visitors?path=muhammad-fiaz%2Ftint.zig&countColor=%2337d67a&style=flat)](https://visitorbadge.io)

**[Documentation](https://muhammad-fiaz.github.io/tint.zig/) | [Examples](examples/) | [API Reference](docs/api/)**


</div>



tint.zig is a fast, minimal, zero dependency terminal color and text styling library for Zig 0.16.0+. It provides ANSI/SGR escape sequence constructors for foreground, background, and underline colors, text attributes, composable styles, themes, and color palettes, without owning your application's output.

> [!NOTE]
> tint.zig constructs ANSI escape sequences and returns them to the caller. Your application owns all output. The library never prints to stdout/stderr, modifies terminal state, or auto-detects capabilities.



<details>
<summary><strong>Features</strong></summary>

- **Complete Color Support** — ANSI 4-bit, bright ANSI, 256-color, RGB/TrueColor, HEX, HSL, HSV, CMYK, CIE XYZ, CIE Lab
- **Explicit Styling** — Bold, italic, underline, strikethrough, overline, fraktur, frame, encircle, rapid blink, super/subscript
- **Composable Themes** — 16 built-in themes (dark, light, dracula, nord, monokai, tokyo_night, gruvbox, solarized, rose_pine, catppuccin, github, one_dark, material, palenight, everforest, kanagawa, cyberdream)
- **Color Conversion** — Convert between RGB, HEX, ANSI 256, HSL, HSV, CMYK, CIE XYZ, and CIE Lab
- **Color Manipulation** — Lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate, adjust hue
- **Color Harmony** — Complementary, analogous, triadic, split-complementary, tetradic
- **Color Analysis** — Luminance, contrast ratio, color distance, nearest ANSI 256, is light/dark
- **Color Temperature** — Kelvin to RGB conversion (1000K-40000K)
- **Named Colors** — 140+ CSS/X11 named colors as RGB values
- **Palettes** — ANSI 16, ANSI 256, RGB6 cube, grayscale ramp, color ramps, color wheel, warm/cool/earth/pastel/neon subsets
- **Zero Dependencies** — Pure Zig with no external dependencies
- **Client-Owned Output** — The library constructs ANSI codes; your application owns all output
- **Cross-Platform** — Windows, Linux, macOS, FreeBSD

</details>

<details>
<summary><strong>Prerequisites</strong></summary>

- Zig 0.16.0 or later
- No external dependencies required

</details>


## Installation

### Method 1: zig fetch (Recommended)

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig
```

### Method 2: zig fetch with git tag

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig#v0.0.1
```

### Method 3: Manual build.zig.zon

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...",
    },
},
```

### Method 4: Local clone

```bash
git clone https://github.com/muhammad-fiaz/tint.zig.git
```

```zig
.dependencies = .{
    .tint = .{
        .path = "../tint.zig",
    },
},
```

### Wire it into your build.zig

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "my_app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tint = b.dependency("tint", .{});
    exe.root_module.addImport("tint", tint.module("tint"));

    b.installArtifact(exe);
}
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

    // Using HEX colors
    std.debug.print("{s}Custom color{s}\n", .{
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


## API Overview

| Function | Description |
|----------|-------------|
| `tint.fg(color)` | Foreground ANSI escape sequence |
| `tint.bg(color)` | Background ANSI escape sequence |
| `tint.underline(color)` | Underline color ANSI escape sequence |
| `tint.style(opts)` | Composable style with options |
| `tint.rgb(r, g, b)` | Create RGB color |
| `tint.hex(value)` | Create HEX color from integer |
| `tint.ansi256(index)` | Create ANSI 256-color |
| `tint.hsl(h, s, l)` | Create HSL color |
| `tint.hsv(h, s, v)` | Create HSV color |
| `tint.cmyk(c, m, y, k)` | Create CMYK color |
| `tint.kelvin(temp)` | Create color from Kelvin temperature |
| `tint.Named.red` | 140+ CSS/X11 named colors |
| `tint.reset` | Full SGR reset |

> [!NOTE]
> All color functions return `[]const u8` containing the ANSI escape sequence. The library never owns the writer or modifies terminal state.


## Examples

| Example | Description | File |
|---------|-------------|------|
| Basic | Foreground, background, named colors | [`examples/basic.zig`](examples/basic.zig) |
| ANSI 16 | Full ANSI 16-color palette | [`examples/ansi16.zig`](examples/ansi16.zig) |
| Bright | Bright ANSI colors | [`examples/bright.zig`](examples/bright.zig) |
| ANSI 256 | 256-color palette | [`examples/ansi256.zig`](examples/ansi256.zig) |
| RGB | TrueColor RGB support | [`examples/rgb.zig`](examples/rgb.zig) |
| HEX | HEX color support | [`examples/hex.zig`](examples/hex.zig) |
| HSL | HSL color space | [`examples/hsl.zig`](examples/hsl.zig) |
| HSV | HSV color space | [`examples/hsv.zig`](examples/hsv.zig) |
| CMYK | CMYK color conversion | [`examples/cmyk.zig`](examples/cmyk.zig) |
| Color Temperature | Kelvin to RGB | [`examples/color_temperature.zig`](examples/color_temperature.zig) |
| Color Manipulation | Lighten, darken, mix, invert | [`examples/color_manipulation.zig`](examples/color_manipulation.zig) |
| Color Harmony | Complementary, triadic, etc. | [`examples/color_harmony.zig`](examples/color_harmony.zig) |
| Color Analysis | Luminance, contrast, distance | [`examples/color_analysis.zig`](examples/color_analysis.zig) |
| Styles | Composable text styles | [`examples/styles.zig`](examples/styles.zig) |
| Presets | Pre-built style presets | [`examples/presets.zig`](examples/presets.zig) |
| Underline Color | Colored underlines | [`examples/underline_color.zig`](examples/underline_color.zig) |
| Palettes | Color palette access | [`examples/palettes.zig`](examples/palettes.zig) |
| Themes | Theme system | [`examples/themes.zig`](examples/themes.zig) |
| Themes Extended | All 16 built-in themes | [`examples/themes_extended.zig`](examples/themes_extended.zig) |
| Gradient | Gradient text via lerp, fade, palette primitives | [`examples/gradient.zig`](examples/gradient.zig) |
| Composition | Style composition | [`examples/composition.zig`](examples/composition.zig) |
| Complete | Full feature showcase | [`examples/complete.zig`](examples/complete.zig) |

Run any example with:

```bash
zig build run-basic
zig build run-complete
```


## Design Philosophy

tint.zig follows one fundamental rule:

> **Explicit input → explicit color/style representation → correct ANSI/SGR code → returned to the client.**

The library never:
- Prints to stdout/stderr
- Owns the writer
- Modifies terminal state
- Auto-detects capabilities

Your application owns all output.


## Validation

- [x] ANSI 4-bit foreground and background colors
- [x] Bright ANSI foreground and background colors
- [x] ANSI 256-color (0-255) with full range support
- [x] RGB/TrueColor with 24-bit color
- [x] HEX color from integer (0xRRGGBB)
- [x] HSL and HSV color space conversion
- [x] CMYK color conversion
- [x] CIE XYZ and CIE Lab color spaces
- [x] 140+ CSS/X11 named colors
- [x] Composable styles (bold, italic, underline, fraktur, frame, encircle, etc.)
- [x] 16 built-in themes
- [x] Color manipulation (lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate)
- [x] Color harmony (complementary, analogous, triadic, split-complementary, tetradic)
- [x] Color analysis (luminance, contrast ratio, distance, nearest ANSI 256)
- [x] Color temperature (Kelvin to RGB)
- [x] Multi-stop palette gradients and rainbow hue gradients
- [x] Underline color support
- [x] ANSI 16 and ANSI 256 palette access
- [x] Color ramps and color wheel
- [x] Compile-time validation for all color inputs
- [x] Hue wrapping for HSL/HSV (370° → 10°)
- [x] Zero external dependencies
- [x] Cross-platform (Windows, Linux, macOS, FreeBSD)


## Security

For security concerns, please see [SECURITY.md](SECURITY.md).


## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

> [!TIP]
> If you find tint.zig useful, please consider giving it a star on GitHub. It helps others discover the project and motivates continued development.


## License

MIT License - see [LICENSE](LICENSE) for details.

---
