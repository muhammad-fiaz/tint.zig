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

**[Documentation](https://muhammad-fiaz.github.io/tint.zig/) | [Examples](https://muhammad-fiaz.github.io/tint.zig/examples/) | [API Reference](https://muhammad-fiaz.github.io/tint.zig/api/)**


</div>


tint.zig is a fast, minimal, zero dependency terminal color and text styling library for Zig 0.16.0+. It provides ANSI/SGR escape sequence constructors for foreground, background, and underline colors, text attributes, composable styles, themes, and color palettes, without owning your application's output.

> [!NOTE]
> tint.zig constructs ANSI escape sequences and returns them to the caller. Your application owns all output. The library never prints to stdout/stderr, modifies terminal state, or auto-detects capabilities.


<details>
<summary><strong>Features</strong></summary>

- [**Complete Color Support**](https://muhammad-fiaz.github.io/tint.zig/guide/colors): ANSI 4-bit, bright ANSI, 256-color, RGB/TrueColor, HEX, HSL, HSV, CMYK, CIE XYZ, CIE Lab
- [**Explicit Styling**](https://muhammad-fiaz.github.io/tint.zig/guide/styles): Bold, italic, underline, strikethrough, overline, fraktur, frame, encircle, rapid blink, super/subscript
- [**Composable Themes**](https://muhammad-fiaz.github.io/tint.zig/guide/themes): 17 built-in themes (dark, light, dracula, nord, monokai, tokyo_night, gruvbox, solarized, rose_pine, catppuccin, github, one_dark, material, palenight, everforest, kanagawa, cyberdream)
- [**Color Conversion**](https://muhammad-fiaz.github.io/tint.zig/api/color): Convert between RGB, HEX, ANSI 256, HSL, HSV, CMYK, CIE XYZ, and CIE Lab
- [**Color Manipulation**](https://muhammad-fiaz.github.io/tint.zig/api/color): Lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate, adjust hue
- [**Color Harmony**](https://muhammad-fiaz.github.io/tint.zig/api/color): Complementary, analogous, triadic, split-complementary, tetradic
- [**Color Analysis**](https://muhammad-fiaz.github.io/tint.zig/api/color): Luminance, contrast ratio, color distance, nearest ANSI 256, is light/dark
- [**Color Temperature**](https://muhammad-fiaz.github.io/tint.zig/api/color): Kelvin to RGB conversion (1000K-40000K)
- [**Named Colors**](https://muhammad-fiaz.github.io/tint.zig/api/color): 140+ CSS/X11 named colors as RGB values
- [**Palettes**](https://muhammad-fiaz.github.io/tint.zig/guide/palettes): ANSI 16, ANSI 88, ANSI 256, RGB6 cube, grayscale ramp, color ramps, color wheel, warm/cool/earth/pastel/neon subsets
- **Zero Dependencies**: Pure Zig with no external dependencies
- **Client-Owned Output**: The library constructs ANSI codes; your application owns all output
- **Cross-Platform**: Windows, Linux, macOS, FreeBSD

</details>

<details>
<summary><strong>Prerequisites</strong></summary>

- Zig 0.16.0 or later
- No external dependencies required

</details>

---

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

---

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

---

## Guides

| Guide | Description |
|-------|-------------|
| [Getting Started](https://muhammad-fiaz.github.io/tint.zig/guide/getting-started) | Introduction and first steps |
| [Installation](https://muhammad-fiaz.github.io/tint.zig/guide/installation) | Setup and configuration |
| [Colors](https://muhammad-fiaz.github.io/tint.zig/guide/colors) | Color types and usage |
| [Styles](https://muhammad-fiaz.github.io/tint.zig/guide/styles) | Text attributes and composable styles |
| [Palettes](https://muhammad-fiaz.github.io/tint.zig/guide/palettes) | Color palettes and ramps |
| [Themes](https://muhammad-fiaz.github.io/tint.zig/guide/themes) | Theme system and customization |

---

## API Overview

| Function | Description | Docs |
|----------|-------------|------|
| `tint.fg(color)` | Foreground ANSI escape sequence | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.bg(color)` | Background ANSI escape sequence | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.underline(color)` | Underline color ANSI escape sequence | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.style(opts)` | Composable style with options | [Style API](https://muhammad-fiaz.github.io/tint.zig/api/style) |
| `tint.rgb(r, g, b)` | Create RGB color | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.hex(value)` | Create HEX color from integer | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.ansi256(index)` | Create ANSI 256-color | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.hsl(h, s, l)` | Create HSL color | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.hsv(h, s, v)` | Create HSV color | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.cmyk(c, m, y, k)` | Create CMYK color | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.kelvin(temp)` | Create color from Kelvin temperature | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.Named.red` | 140+ CSS/X11 named colors | [Color API](https://muhammad-fiaz.github.io/tint.zig/api/color) |
| `tint.fg88(index)` | ANSI 88 foreground | [Palette API](https://muhammad-fiaz.github.io/tint.zig/api/palette) |
| `tint.bg88(index)` | ANSI 88 background | [Palette API](https://muhammad-fiaz.github.io/tint.zig/api/palette) |
| `tint.reset` | Full SGR reset | [Style API](https://muhammad-fiaz.github.io/tint.zig/api/style) |

> [!NOTE]
> All color functions return `[]const u8` containing the ANSI escape sequence. The library never owns the writer or modifies terminal state.

---

## Examples

| Example | Description | Docs | Source |
|---------|-------------|------|--------|
| Basic | Foreground, background, named colors | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/basic) | [`basic.zig`](examples/basic.zig) |
| ANSI 16 | Full ANSI 4-bit palette | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/ansi16) | [`ansi16.zig`](examples/ansi16.zig) |
| Bright Colors | Bright ANSI colors | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/bright) | [`bright.zig`](examples/bright.zig) |
| ANSI 256 | 256-color palette | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/ansi256) | [`ansi256.zig`](examples/ansi256.zig) |
| RGB / TrueColor | 24-bit RGB color | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/rgb) | [`rgb.zig`](examples/rgb.zig) |
| HEX Colors | HEX color support | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/hex) | [`hex.zig`](examples/hex.zig) |
| HSL Colors | HSL color space | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/hsl) | [`hsl.zig`](examples/hsl.zig) |
| HSV Colors | HSV color space | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/hsv) | [`hsv.zig`](examples/hsv.zig) |
| CMYK | CMYK print colors | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/cmyk) | [`cmyk.zig`](examples/cmyk.zig) |
| Color Temperature | Kelvin to RGB | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/color-temperature) | [`color_temperature.zig`](examples/color_temperature.zig) |
| Color Manipulation | Lighten, darken, mix, invert | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/color-manipulation) | [`color_manipulation.zig`](examples/color_manipulation.zig) |
| Color Harmony | Complementary, triadic, etc. | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/color-harmony) | [`color_harmony.zig`](examples/color_harmony.zig) |
| Color Analysis | Luminance, contrast, distance | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/color-analysis) | [`color_analysis.zig`](examples/color_analysis.zig) |
| Styles | Text attributes | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/styles) | [`styles.zig`](examples/styles.zig) |
| Presets | Built-in preset styles | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/presets) | [`presets.zig`](examples/presets.zig) |
| Underline Color | Colored underlines | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/underline-color) | [`underline_color.zig`](examples/underline_color.zig) |
| Palettes | Palette access | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/palettes) | [`palettes.zig`](examples/palettes.zig) |
| Themes | Theme usage and custom themes | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/themes) | [`themes.zig`](examples/themes.zig) |
| Themes Extended | All 17 built-in themes | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/themes-extended) | [`themes_extended.zig`](examples/themes_extended.zig) |
| Gradient | Gradient text via lerp, fade, palette primitives | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/gradient) | [`gradient.zig`](examples/gradient.zig) |
| Composition | Style composition | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/composition) | [`composition.zig`](examples/composition.zig) |
| Complete Demo | Full feature showcase | [Docs](https://muhammad-fiaz.github.io/tint.zig/examples/complete) | [`complete.zig`](examples/complete.zig) |

Run any example with:

```bash
zig build run-basic
zig build run-complete
```

---

## Design Philosophy

tint.zig follows one fundamental rule:

> **Explicit input, explicit color/style representation, correct ANSI/SGR code, returned to the client.**

The library never:
- Prints to stdout/stderr
- Owns the writer
- Modifies terminal state
- Auto-detects capabilities

Your application owns all output.

---

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
- [x] 17 built-in themes
- [x] Color manipulation (lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate)
- [x] Color harmony (complementary, analogous, triadic, split-complementary, tetradic)
- [x] Color analysis (luminance, contrast ratio, distance, nearest ANSI 256)
- [x] Color temperature (Kelvin to RGB)
- [x] Multi-stop palette gradients and rainbow hue gradients
- [x] Underline color support
- [x] ANSI 16, ANSI 88, and ANSI 256 palette access
- [x] Color ramps and color wheel
- [x] Compile-time validation for all color inputs
- [x] Hue wrapping for HSL/HSV (370 degrees wraps to 10 degrees)
- [x] Zero external dependencies
- [x] Cross-platform (Windows, Linux, macOS, FreeBSD)

---

## Security

For security concerns, please see [SECURITY.md](SECURITY.md).

---

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

> [!TIP]
> If you find tint.zig useful, please consider giving it a star on GitHub. It helps others discover the project and motivates continued development.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**[Documentation](https://muhammad-fiaz.github.io/tint.zig/) | [Examples](https://muhammad-fiaz.github.io/tint.zig/examples/) | [API Reference](https://muhammad-fiaz.github.io/tint.zig/api/) | [GitHub](https://github.com/muhammad-fiaz/tint.zig)**
