# Colors

Everything is a `tint.color.Color` value. Construct it, convert it, mix it, render it.

## Construction

```zig
tint.color.rgb(255, 100, 20)
tint.color.hex(0xFF6600)
tint.color.hsl(24, 100, 53)
tint.color.hsv(24, 100, 100)
tint.color.cmyk(0, 60, 100, 0)
tint.color.kelvin(2700)
tint.color.ansi4.red
tint.color.ansi256.rgb(5, 0, 0)
tint.color.ansi256.gray(12)
tint.color.ansi88.rgb(3, 2, 1)
tint.color.red
tint.color.rebeccaPurple
```

Percentages (`hsl`, `hsv`, `cmyk`) must be in `0...100`; out-of-range literals are compile errors. Hues wrap at 360. Kelvin must be in `1000...40000`.

## Named Colors

148 CSS/X11 colors as values. Multi-word names are camelCase:

```zig
tint.color.coral
tint.color.teal
tint.color.mediumPurple
tint.color.lightSalmon
```

For runtime strings (flags, config files), use `parse`. It accepts hex strings and names, ignoring case and underscores:

```zig
tint.color.parse("rebeccaPurple") // same as "rebecca_purple"
tint.color.parse("#ff6600")
tint.color.parse("0xFF6600")
```

## Hex Strings

```zig
tint.color.Hex.parse("#FF6600")
tint.color.Hex.parse("F60")
tint.color.Hex.parse("0xFF6600")
```

`#RGBA` and `#RRGGBBAA` forms are accepted; the alpha digits are validated and discarded because SGR has no transparency. Read them separately with `Hex.opacity` when the value itself matters.

## Conversion

Any space converts to any other:

```zig
const c = tint.color.hex(0xFF6600);
c.toRgb(); c.toHex(); c.toHsl(); c.toHsv(); c.toCmyk();
c.toXyz(); c.toLab(); c.toLch(); c.toOklab(); c.toOklch();
```

## Metrics

```zig
c.luminance();
c.contrastRatio(other);   // WCAG, 1.0 to 21.0
c.deltaE76(other);
c.deltaE94(other);
c.deltaE2000(other);      // perceptual standard
c.oklabDistance(other);   // cheap perceptual stand-in
c.isLight();
c.isDark();
```

## Manipulation

```zig
c.lighten(0.2); c.darken(0.2);
c.saturate(0.2); c.desaturate(0.2);
c.withLightness(50); c.withSaturation(80);
c.invert(); c.grayscale(); c.grayscaleLuminance();
c.fade(0.4);
c.rotate(90); c.adjustHue(-30);
```

Amounts are fractions clamped to `0.0...1.0`. Absolute setters take `u8` percentages.

## Interpolation

```zig
red.mix(blue, 0.5);                          // sRGB
red.mixIn(blue, 0.5, .oklab);                // rgb/hsl/hsv/lab/lch/oklab/oklch
red.mixHue(blue, 0.5, .shorter);             // shorter/longer/increasing/decreasing
```

Hue-based spaces take the short way around by default; `mixHue` makes the path explicit.

## Harmony

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

```zig
c.nearestAnsi256();   // OKLab distance
c.nearestAnsi16();
c.downgrade(.ansi256);
tint.ansi.render(c, .foreground, .ansi16);
```

Capabilities are explicit: `none`, `ansi16`, `ansi256`, `trueColor`. Nothing is auto-detected.
