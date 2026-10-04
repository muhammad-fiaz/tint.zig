---
title: Color API
description: "Color API reference: Rgb, Hex, Hsl, Hsv, Cmyk, Xyz, Lab, Lch, Oklab, Oklch, Ansi4, Ansi256, conversion, metrics and interpolation."
keywords: "zig color api, rgb hsl hsv, xyz lab oklab, deltaE, color conversion reference"
---

# Color API

## Types

Concise names inside the `color` namespace — the namespace provides the context, so names never repeat it:

```zig
pub const Rgb = struct { r: u8, g: u8, b: u8 };
pub const Hex = struct { value: u24 };
pub const Hsl = struct { h: u16, s: u8, l: u8 };
pub const Hsv = struct { h: u16, s: u8, v: u8 };
pub const Cmyk = struct { c: u8, m: u8, y: u8, k: u8 };
pub const Xyz = struct { x: f64, y: f64, z: f64 };
pub const Lab = struct { l: f64, a: f64, b: f64 };
pub const Lch = struct { l: f64, c: f64, h: f64 };
pub const Oklab = struct { l: f64, a: f64, b: f64 };
pub const Oklch = struct { l: f64, c: f64, h: f64 };
pub const Ansi256 = struct { index: u8 };
pub const Color = union(enum) { ansi4, ansi256, rgb, hex, hsl, hsv };
```

`Ansi4` is the 17-value enum of base colors plus `default`. `Space` selects an interpolation space; `HuePath` selects how hue interpolation walks the circle.

## Constructors

Each representation has one constructor. Validated inputs fail fast: out-of-range literals are compile errors, runtime values panic in safe builds:

```zig
tint.color.rgb(r, g, b)       // 24-bit
tint.color.hex(0xRRGGBB)      // integer
tint.color.hsl(h, s, l)       // hue wraps, s/l in 0...100
tint.color.hsv(h, s, v)
tint.color.cmyk(c, m, y, k)   // each in 0...100
tint.color.kelvin(2700)       // 1000...40000
tint.color.ansi256.index(196)
tint.color.ansi256.rgb(5, 0, 0)
tint.color.ansi256.gray(12)
tint.color.ansi88.rgb(3, 2, 1)
tint.color.ansi88.gray(7)
tint.color.parse(text)        // hex string or name, null when invalid
```

`fromRgb`, `fromHex`, `fromHsl`, `fromHsv`, `fromLab`, `fromLch`, `fromOklab` and `fromOklch` wrap space values as `Color`.

## Named Colors

148 CSS/X11 colors as values (`tint.color.red`, `tint.color.rebeccaPurple`). `tint.color.names` lists the snake_case spellings that `parse` accepts.

## Conversion

Every `Color` converts to every space. `toString` formats `#rrggbb`:

```zig
toRgb/toHex/toHsl/toHsv/toCmyk/toXyz/toLab/toLch/toOklab/toOklch
```

Space types convert through `fromRgb`/`toRgb` pairs plus direct `fromXyz`/`toXyz`, `fromLab`/`toLab` and `fromOklab`/`toOklab` pairs.

## Metrics

```zig
luminance()                   // WCAG relative, 0.0...1.0
contrastRatio(other)          // 1.0...21.0
deltaE76/deltaE94/deltaE2000  // CIE distances, increasing accuracy
oklabDistance(other)          // cheap perceptual distance
isLight()/isDark()
nearestAnsi256()              // OKLab search over the 256 palette
nearestAnsi16()               // OKLab search over the base colors
downgrade(capability)         // map onto what the terminal shows
```

## Manipulation

Relative adjustments take clamped fractions; absolute setters take `u8` percentages; hue rotation wraps in both directions:

```zig
lighten/darken/saturate/desaturate
withLightness/withSaturation
invert/grayscale/grayscaleLuminance
fade                          // toward mid grey
rotate/adjustHue
complementary/analogous/triadic/splitComplementary/tetradic
monochromatic(out)            // white-to-black ramp into a caller buffer
```

## Interpolation

```zig
mix(other, ratio)                       // sRGB blend
mixIn(other, ratio, space)              // rgb/hsl/hsv/lab/lch/oklab/oklch
mixHue(other, ratio, path)              // shorter/longer/increasing/decreasing
```

## Rendering

```zig
color.fg()/color.bg()/color.underline() // ansi.Sequence values
tint.ansi.render(color, layer, capability)
```
