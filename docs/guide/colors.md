---
title: Colors
description: "Build, convert, measure and mix terminal colors: RGB, HEX, HSL, HSV, CMYK, XYZ, Lab, OKLab, Kelvin and 148 named colors."
keywords: "zig colors, terminal colors, rgb, hex, hsl, hsv, cmyk, oklab, color conversion, named colors"
---

# Colors

Everything is a `tint.color.Color` value. Construct it, convert it, measure it, mix it, render it — no strings, no metadata pairs.

## Construction

One obvious constructor per representation. Percentages must be in `0...100` (out-of-range literals are compile errors), hues wrap at 360, Kelvin must be in `1000...40000`:

```zig
tint.color.rgb(255, 100, 20)   // 24-bit, channels 0...255
tint.color.hex(0xFF6600)       // from a 0xRRGGBB integer
tint.color.hsl(24, 100, 53)    // hue, saturation, lightness
tint.color.hsv(24, 100, 100)   // hue, saturation, value
tint.color.cmyk(0, 60, 100, 0) // print percentages
tint.color.kelvin(2700)        // color temperature
tint.color.ansi4.red           // base colors as values
tint.color.ansi256.rgb(5, 0, 0)
tint.color.ansi256.gray(12)
tint.color.ansi88.rgb(3, 2, 1)
tint.color.red                 // 148 named colors as values
tint.color.rebeccaPurple
```

## Named Colors

148 CSS/X11 colors as values, including the seven `grey` spellings the CSS standard defines. Multi-word names are camelCase:

```zig
tint.color.coral
tint.color.teal
tint.color.mediumPurple
tint.color.lightSalmon
```

For runtime strings such as CLI flags or config files, use `parse`. It accepts hex strings and names while ignoring case and underscores, and returns `null` for anything invalid:

```zig
tint.color.parse("rebeccaPurple") // same as "rebecca_purple"
tint.color.parse("#ff6600")
tint.color.parse("0xFF6600")
```

## Hex Strings

`Hex.parse` accepts `#RGB`, `#RGBA`, `#RRGGBB` and `#RRGGBBAA` with an optional `#` or `0x` prefix in any letter case, and reports `InvalidHexLength` or `InvalidHexDigit` otherwise:

```zig
tint.color.Hex.parse("#FF6600")
tint.color.Hex.parse("F60")
tint.color.Hex.parse("0xFF6600")
```

Alpha digits are validated and then discarded because SGR has no transparency — keeping them would misrepresent what the terminal draws. Read the alpha itself with `Hex.opacity` when the value matters.

## Conversion

Any space converts to any other through the `Color` hub:

```zig
const c = tint.color.hex(0xFF6600);
c.toRgb(); c.toHex(); c.toHsl(); c.toHsv(); c.toCmyk();
c.toXyz(); c.toLab(); c.toLch(); c.toOklab(); c.toOklch();
```

`toString` formats `#rrggbb`. Whole-percentage spaces (HSL, HSV, CMYK) quantize, so round trips hold within a few steps; exact spaces round-trip exactly.

## Metrics

`luminance` is the WCAG relative value in `0.0...1.0`. `contrastRatio` spans `1.0...21.0`. The delta-E family measures perceptual difference with increasing accuracy and cost; `oklabDistance` is the cheap everyday stand-in:

```zig
c.luminance();
c.contrastRatio(other);
c.deltaE76(other);
c.deltaE94(other);
c.deltaE2000(other);      // perceptual standard
c.oklabDistance(other);
c.isLight();
c.isDark();
```

## Manipulation

Relative adjustments take fractions clamped to `0.0...1.0`; absolute setters take `u8` percentages:

```zig
c.lighten(0.2); c.darken(0.2);
c.saturate(0.2); c.desaturate(0.2);
c.withLightness(50); c.withSaturation(80);
c.invert(); c.grayscale(); c.grayscaleLuminance();
c.fade(0.4);                              // toward mid grey
c.rotate(90); c.adjustHue(-30);          // signed hue rotation
```

## Interpolation

`mix` blends in sRGB. `mixIn` blends in any of `rgb/hsl/hsv/lab/lch/oklab/oklch` — prefer a perceptual space for gradients. `mixHue` walks the OKLCH hue circle along an explicit path instead of always taking the short way:

```zig
red.mix(blue, 0.5);
red.mixIn(blue, 0.5, .oklab);
red.mixHue(blue, 0.5, .shorter);   // shorter/longer/increasing/decreasing
```

## Harmony

Fixed-size schemes plus a caller-buffered monochromatic ramp from white to black at the color's hue:

```zig
c.complementary();
c.analogous();         // [2]Color
c.triadic();           // [2]Color
c.splitComplementary();// [2]Color
c.tetradic();          // [3]Color
var mono: [8]tint.color.Color = undefined;
c.monochromatic(&mono);
```

## Quantization

`nearestAnsi256` searches by OKLab distance, `nearestAnsi16` picks a base color, and `downgrade` maps any color onto what the terminal can display. Capabilities are explicit — `none`, `ansi16`, `ansi256`, `trueColor` — and nothing is auto-detected:

```zig
c.nearestAnsi256();
c.nearestAnsi16();
c.downgrade(.ansi256);
tint.ansi.render(c, .foreground, .ansi16);
```
