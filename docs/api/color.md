# Color API

## Types

`Rgb`, `Hex`, `Hsl`, `Hsv`, `Cmyk`, `Xyz`, `Lab`, `Lch`, `Oklab`, `Oklch`, `Ansi4`, `Ansi256`, `Color`, plus `Space` and `HuePath` enums.

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

## Constructors

```zig
tint.color.rgb(r, g, b)       // 24-bit
tint.color.hex(0xRRGGBB)      // integer
tint.color.hsl(h, s, l)       // s/l in 0...100, hue wraps
tint.color.hsv(h, s, v)
tint.color.cmyk(c, m, y, k)   // 0...100 each
tint.color.kelvin(2700)       // 1000...40000
tint.color.ansi256.index(196)
tint.color.ansi256.rgb(5, 0, 0)
tint.color.ansi256.gray(12)
tint.color.ansi88.rgb(3, 2, 1)
tint.color.ansi88.gray(7)
tint.color.parse(text)        // hex string or name, null when invalid
```

Out-of-range literals are compile errors via `std.debug.assert`; runtime values panic in safe builds.

## Named Colors

148 CSS/X11 colors as values: `tint.color.red`, `tint.color.rebeccaPurple`. `tint.color.names` lists the snake_case spellings `parse` accepts.

## Conversion

Every `Color` converts to every space: `toRgb`, `toHex`, `toHsl`, `toHsv`, `toCmyk`, `toXyz`, `toLab`, `toLch`, `toOklab`, `toOklch`, plus `toString` (`#rrggbb`). Space types convert through `fromRgb`/`toRgb` pairs and direct `fromXyz`/`toXyz`, `fromLab`/`toLab`, `fromOklab`/`toOklab` pairs.

## Metrics

```zig
luminance()                   // WCAG relative, 0.0...1.0
contrastRatio(other)          // 1.0...21.0
deltaE76/deltaE94/deltaE2000  // CIE distances
oklabDistance(other)          // cheap perceptual distance
isLight()/isDark()
nearestAnsi256()/nearestAnsi16()
downgrade(capability)
```

## Manipulation

`lighten`, `darken`, `saturate`, `desaturate` (fractions, clamped), `withLightness`, `withSaturation` (absolute `u8`), `invert`, `grayscale`, `grayscaleLuminance`, `fade`, `rotate`, `adjustHue`, `complementary`, `analogous`, `triadic`, `splitComplementary`, `tetradic`, `monochromatic(out)`.

## Interpolation

```zig
mix(other, ratio)                       // sRGB
mixIn(other, ratio, .oklab)             // rgb/hsl/hsv/lab/lch/oklab/oklch
mixHue(other, ratio, .shorter)          // shorter/longer/increasing/decreasing
```

## Rendering

```zig
color.fg()/color.bg()/color.underline() // ansi.Sequence values
tint.ansi.render(color, layer, capability)
```
