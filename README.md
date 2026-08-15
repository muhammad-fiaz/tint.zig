<div align="center">


# tint.zig

<a href="https://muhammad-fiaz.github.io/tint.zig/"><img src="https://img.shields.io/badge/docs-muhammad--fiaz.github.io-blue" alt="Documentation"></a>
<a href="https://ziglang.org/"><img src="https://img.shields.io/badge/Zig-0.16.0-orange.svg?logo=zig" alt="Zig Version"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig"><img src="https://img.shields.io/github/stars/muhammad-fiaz/tint.zig" alt="GitHub stars"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig/issues"><img src="https://img.shields.io/github/issues/muhammad-fiaz/tint.zig" alt="GitHub issues"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig/pulls"><img src="https://img.shields.io/github/issues-pr/muhammad-fiaz/tint.zig" alt="GitHub pull requests"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig"><img src="https://img.shields.io/github/last-commit/muhammad-fiaz/tint.zig" alt="GitHub last commit"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig"><img src="https://img.shields.io/github/license/muhammad-fiaz/tint.zig" alt="License"></a>
<a href="https://github.com/muhammad-fiaz/tint.zig/actions/workflows/ci.yml"><img src="https://github.com/muhammad-fiaz/tint.zig/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
<img src="https://img.shields.io/badge/platforms-linux%20%7C%20windows%20%7C%20macos%20%7C%20freebsd-blue" alt="Supported Platforms">
<a href="https://github.com/muhammad-fiaz/tint.zig/releases/latest"><img src="https://img.shields.io/github/v/release/muhammad-fiaz/tint.zig?label=Latest%20Release&style=flat-square" alt="Latest Release"></a>
<a href="https://pay.muhammadfiaz.com"><img src="https://img.shields.io/badge/Sponsor-pay.muhammadfiaz.com-ff69b4?style=flat&logo=heart" alt="Sponsor"></a>
<a href="https://github.com/sponsors/muhammad-fiaz"><img src="https://img.shields.io/badge/Sponsor-GitHub-pink?style=social&logo=github" alt="GitHub Sponsors"></a>
<a href="https://hits.sh/muhammad-fiaz/tint.zig/"><img src="https://hits.sh/muhammad-fiaz/tint.zig.svg?label=Visitors&extraCount=0&color=green" alt="Repo Visitors"></a>

<p><em>A fast, minimal terminal color and text styling library for Zig.</em></p>

<b><a href="https://muhammad-fiaz.github.io/tint.zig/">Documentation</a> |
<a href="https://muhammad-fiaz.github.io/tint.zig/api/">API Reference</a> |
<a href="https://muhammad-fiaz.github.io/tint.zig/guide/getting-started">Quick Start</a> |
<a href="CONTRIBUTING.md">Contributing</a></b>

</div>

`tint.zig` is a fast, minimal, zero dependency terminal color and text styling library for Zig 0.16.0+. It provides ANSI/SGR escape sequence constructors for foreground, background, and underline colors, text attributes, composable styles, themes, and color palettes, without owning your application's output.

> [!NOTE]
> tint.zig constructs ANSI escape sequences and returns them to the caller. Your application owns all output. The library never prints to stdout/stderr, modifies terminal state, or auto-detects capabilities.

> [!TIP]
> If you find tint.zig useful, please consider giving it a star on GitHub. It helps others discover the project and motivates continued development.

---

<details>
<summary><strong>Features</strong> (click to expand)</summary>

| Feature | Description |
|---------|-------------|
| [**Complete Color Support**](https://muhammad-fiaz.github.io/tint.zig/guide/colors) | ANSI 4-bit, bright ANSI, 256-color, RGB/TrueColor, HEX, HSL, HSV, CMYK, CIE XYZ, CIE Lab |
| [**Explicit Styling**](https://muhammad-fiaz.github.io/tint.zig/guide/styles) | Bold, italic, underline, strikethrough, overline, fraktur, frame, encircle, rapid blink, super/subscript |
| [**Composable Themes**](https://muhammad-fiaz.github.io/tint.zig/guide/themes) | 17 built-in themes (dark, light, dracula, nord, monokai, tokyo_night, gruvbox, solarized, rose_pine, catppuccin, github, one_dark, material, palenight, everforest, kanagawa, cyberdream) |
| [**Color Conversion**](https://muhammad-fiaz.github.io/tint.zig/api/color) | Convert between RGB, HEX, ANSI 256, HSL, HSV, CMYK, CIE XYZ, and CIE Lab |
| [**Color Manipulation**](https://muhammad-fiaz.github.io/tint.zig/api/color) | Lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate, adjust hue |
| [**Color Harmony**](https://muhammad-fiaz.github.io/tint.zig/api/color) | Complementary, analogous, triadic, split-complementary, tetradic, monochromatic |
| [**Color Analysis**](https://muhammad-fiaz.github.io/tint.zig/api/color) | Luminance, contrast ratio, color distance, nearest ANSI 256, is light/dark |
| [**Color Temperature**](https://muhammad-fiaz.github.io/tint.zig/api/color) | Kelvin to RGB conversion (1000K to 40000K) |
| [**Named Colors**](https://muhammad-fiaz.github.io/tint.zig/api/color) | 140+ CSS/X11 named colors as RGB values |
| [**Palettes**](https://muhammad-fiaz.github.io/tint.zig/guide/palettes) | ANSI 16, ANSI 88, ANSI 256, RGB6 cube, grayscale ramp, color ramps, color wheel, warm/cool/earth/pastel/neon subsets |
| [**Gradients**](https://muhammad-fiaz.github.io/tint.zig/examples/gradient) | Multi-stop palette gradients, rainbow hue gradients, and per-character gradient text |
| [**Preset Styles**](https://muhammad-fiaz.github.io/tint.zig/examples/presets) | 17 built-in presets (error, warning, success, info, debug, link, code, header, muted, highlight, strikethrough, blink, reverse, hidden, overlined, framed, encircled) |
| **Zero Dependencies** | Pure Zig with no external dependencies |
| **Client-Owned Output** | The library constructs ANSI codes; your application owns all output |
| **Cross-Platform** | Windows, Linux, macOS, FreeBSD |

</details>

---

<details>
<summary><strong>Prerequisites and Supported Platforms</strong> (click to expand)</summary>

## Prerequisites

Before using `tint.zig`, ensure you have the following:

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Zig** | **0.16.0** (recommended) | Download from [ziglang.org](https://ziglang.org/download/) |
| **Operating System** | Windows 10+, Linux, macOS, FreeBSD | Cross-platform support |

---

## Supported Platforms

`tint.zig` is validated on these architectures:

| Platform | x86_64 (64-bit) | aarch64 (ARM64) |
|----------|-----------------|-----------------|
| **Linux** | Yes | Yes |
| **Windows** | Yes | Yes |
| **macOS** | Yes | Yes (Apple Silicon) |
| **FreeBSD** | Yes | Yes |

### Cross-Compilation

Zig makes cross-compilation easy. Build for any target from any host:

```bash
# Build for Linux ARM64 from Windows
zig build -Dtarget=aarch64-linux

# Build for Windows from Linux
zig build -Dtarget=x86_64-windows

# Build for macOS Apple Silicon from Linux
zig build -Dtarget=aarch64-macos
```

</details>

---

## Installation

### Method 1: Zig Fetch (Recommended)

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig.git
```

### Method 2: Zig Fetch (Tagged Release)

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig.git#v0.0.1
```

### Method 3: Manual `build.zig.zon` Configuration

Add the dependency to your `build.zig.zon` file.

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

### Method 4: Local Source Checkout

Clone the repository locally.

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

### Wire into `build.zig`

After adding the dependency, import the module in your `build.zig`:

```zig
const tint_dep = b.dependency("tint", .{
    .target = target,
    .optimize = optimize,
});
exe.root_module.addImport("tint", tint_dep.module("tint"));
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

The `examples/` directory contains **22 runnable examples** demonstrating all features:

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

To run any example:

```bash
zig build run-basic
zig build run-ansi16
zig build run-bright
zig build run-ansi256
zig build run-rgb
zig build run-hex
zig build run-hsl
zig build run-hsv
zig build run-cmyk
zig build run-color_temperature
zig build run-color_manipulation
zig build run-color_harmony
zig build run-color_analysis
zig build run-styles
zig build run-presets
zig build run-underline_color
zig build run-palettes
zig build run-themes
zig build run-themes_extended
zig build run-gradient
zig build run-composition
zig build run-complete
```

---

## Validation

```bash
# Run all tests
zig build test

# Format source files
zig build fmt

# Run all examples
zig build run-all-examples
```

---

## Design Philosophy

`tint.zig` follows one fundamental rule:

> **Explicit input, explicit color/style representation, correct ANSI/SGR code, returned to the client.**

The library never:
- Prints to stdout/stderr
- Owns the writer
- Modifies terminal state
- Auto-detects capabilities

Your application owns all output.

---

## Validation Checklist

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
- [x] Color harmony (complementary, analogous, triadic, split-complementary, tetradic, monochromatic)
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

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass: `zig build test`
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for full details.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<div align="center">

**[Documentation](https://muhammad-fiaz.github.io/tint.zig/) | [Examples](https://muhammad-fiaz.github.io/tint.zig/examples/) | [API Reference](https://muhammad-fiaz.github.io/tint.zig/api/) | [GitHub](https://github.com/muhammad-fiaz/tint.zig)**

</div>
