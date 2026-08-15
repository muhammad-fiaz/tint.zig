# Colors

`tint.zig` supports multiple color formats through a unified `Color` type.

## Color Types

| Color Type | Description |
|------------|-------------|
| **ANSI 4-Bit** | Standard terminal colors (16 colors) |
| **Bright ANSI** | Bright variants (8 additional colors) |
| **ANSI 256** | 256-color palette |
| **ANSI 88** | 88-color palette |
| **RGB / TrueColor** | Full 24-bit color |
| **HEX** | Hexadecimal color codes |
| **HSL** | Hue, Saturation, Lightness |
| **HSV** | Hue, Saturation, Value |
| **CMYK** | Cyan, Magenta, Yellow, Key (Black) |
| **CIE XYZ** | CIE 1931 color space |
| **CIE Lab** | CIE L*a*b* color space |
| **Kelvin** | Color temperature (1000K to 40000K) |
| **Named** | 140+ CSS/X11 named colors |

---

## ANSI 4-Bit Colors

Standard terminal colors:

```zig
tint.fg(.{ .ansi4 = .black })     // SGR 30
tint.fg(.{ .ansi4 = .red })       // SGR 31
tint.fg(.{ .ansi4 = .green })     // SGR 32
tint.fg(.{ .ansi4 = .yellow })    // SGR 33
tint.fg(.{ .ansi4 = .blue })      // SGR 34
tint.fg(.{ .ansi4 = .magenta })   // SGR 35
tint.fg(.{ .ansi4 = .cyan })      // SGR 36
tint.fg(.{ .ansi4 = .white })     // SGR 37
```

Background:

```zig
tint.bg(.{ .ansi4 = .red })       // SGR 41
tint.bg(.{ .ansi4 = .blue })      // SGR 44
```

## Bright ANSI Colors

Explicit bright colors (not relying on bold):

```zig
tint.fg(.{ .ansi4 = .bright_black })    // SGR 90
tint.fg(.{ .ansi4 = .bright_red })      // SGR 91
tint.fg(.{ .ansi4 = .bright_green })    // SGR 92
tint.fg(.{ .ansi4 = .bright_yellow })   // SGR 93
tint.fg(.{ .ansi4 = .bright_blue })     // SGR 94
tint.fg(.{ .ansi4 = .bright_magenta })  // SGR 95
tint.fg(.{ .ansi4 = .bright_cyan })     // SGR 96
tint.fg(.{ .ansi4 = .bright_white })    // SGR 97
```

## Default Colors

Reset to terminal defaults:

```zig
tint.fg(.{ .ansi4 = .default })   // SGR 39
tint.bg(.{ .ansi4 = .default })   // SGR 49
```

## ANSI 256 Colors

Full 256-color support:

```zig
tint.fg(tint.ansi256(0))     // Black
tint.fg(tint.ansi256(196))   // Red (cube)
tint.fg(tint.ansi256(208))   // Orange
tint.fg(tint.ansi256(255))   // White (grayscale)
```

### RGB Cube (16-231)

```zig
const color = tint.palette.rgb6(5, 0, 0);  // Red
tint.fg(tint.ansi256(color.index));
```

### Grayscale (232-255)

```zig
const gray = tint.palette.gray(12);
tint.fg(tint.ansi256(gray.index));
```

## RGB / TrueColor

Full 24-bit color:

```zig
tint.fg(tint.rgb(255, 100, 20))
tint.bg(tint.rgb(50, 50, 100))

// Convenience functions
tint.fgRgb(255, 100, 20)
tint.bgRgb(50, 50, 100)
```

## HEX Colors

```zig
tint.fg(tint.hex(0xFF0000))
tint.fg(tint.hex(0xFF6600))

// Convenience functions
tint.fgHex(0xFF0000)
tint.bgHex(0xFF6600)
```

## HSL Colors

```zig
tint.fg(tint.hsl(0, 100, 50))    // Red
tint.fg(tint.hsl(120, 100, 50))  // Green
```

## HSV Colors

```zig
tint.fg(tint.hsv(0, 100, 100))    // Red
tint.fg(tint.hsv(240, 100, 100))  // Blue
```

## CMYK Colors

```zig
tint.fg(tint.cmyk(0, 100, 100, 0))    // Red
tint.fg(tint.cmyk(100, 0, 0, 0))      // Cyan
```

## Color Temperature (Kelvin)

```zig
tint.fg(tint.kelvin(2700))   // Warm candle light
tint.fg(tint.kelvin(6500))   // Cool daylight
tint.fg(tint.kelvin(9300))   // Very cool blue
```

## Named Colors

CSS/X11-style named colors (140+):

```zig
tint.fg(.{ .rgb = tint.Named.coral })
tint.fg(.{ .rgb = tint.Named.teal })
tint.fg(.{ .rgb = tint.Named.gold })
tint.fg(.{ .rgb = tint.Named.medium_purple })
```

## Color Conversion

Convert any color to RGB, HEX, HSL, HSV, CMYK, XYZ, or Lab:

```zig
const c = tint.hex(0xFF6600);
const rgb_val = c.toRgb();       // RgbColor
const hex_val = c.toHex();       // u24
const hsl_val = c.toHsl();       // HslColor
const hsv_val = c.toHsv();       // HsvColor
const cmyk_val = c.toCmyk();     // CmykColor
const xyz_val = c.toXyz();       // XyzColor
const lab_val = c.toLab();       // LabColor
```

## Color Manipulation

```zig
const c = tint.rgb(100, 100, 100);
c.lighten(0.2)     // Lighten by 20%
c.darken(0.2)      // Darken by 20%
c.saturate(0.2)    // Saturate by 20%
c.desaturate(0.2)  // Desaturate by 20%
c.invert()         // RGB complement
c.grayscale()      // Convert to grayscale
c.mix(other, 0.5)  // Mix 50% with another color
c.rotate(180)      // Rotate hue by 180 degrees
c.adjustHue(30)    // Adjust hue by 30 degrees
```

## Color Harmony

```zig
const c = tint.rgb(255, 0, 0);
const comp = c.complementary();       // Opposite color
const analogous = c.analogous();      // Neighboring colors
const triad = c.triadic();            // Three evenly spaced
const split = c.splitComplementary(); // Split complement
const tetrad = c.tetradic();          // Four evenly spaced
const mono = c.monochromatic();       // 8 monochromatic variations
```

## Color Analysis

```zig
const c = tint.rgb(255, 0, 0);
const is_light = c.isLight();         // Check if light
const is_dark = c.isDark();           // Check if dark
const lum = c.luminance();            // Relative luminance (0.0-1.0)
const ratio = c.contrastRatio(other); // WCAG contrast ratio
const dist = c.colorDistance(other);  // CIE76 color distance
const nearest = c.nearestAnsi256();   // Nearest ANSI 256 index
const mid = Color.lerp(c1, c2, 0.5); // Linear interpolation
```
