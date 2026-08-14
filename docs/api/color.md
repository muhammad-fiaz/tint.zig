# Color API

## Types

### RgbColor

```zig
pub const RgbColor = struct {
    r: u8,
    g: u8,
    b: u8,
};
```

### HexColor

```zig
pub const HexColor = struct {
    value: u24,
};
```

### Ansi256Color

```zig
pub const Ansi256Color = struct {
    index: u8,
};
```

### HslColor

```zig
pub const HslColor = struct {
    h: u16,  // 0-359
    s: u8,   // 0-100
    l: u8,   // 0-100
};
```

### HsvColor

```zig
pub const HsvColor = struct {
    h: u16,  // 0-359
    s: u8,   // 0-100
    v: u8,   // 0-100
};
```

### CmykColor

```zig
pub const CmykColor = struct {
    c: u8,   // 0-100
    m: u8,   // 0-100
    y: u8,   // 0-100
    k: u8,   // 0-100
};
```

### XyzColor

```zig
pub const XyzColor = struct {
    x: f64,
    y: f64,
    z: f64,
};
```

### LabColor

```zig
pub const LabColor = struct {
    l: f64,      // Lightness
    a: f64,      // Green-red axis
    b_val: f64,  // Blue-yellow axis
};
```

### Ansi4

```zig
pub const Ansi4 = enum {
    black, red, green, yellow, blue, magenta, cyan, white,
    bright_black, bright_red, bright_green, bright_yellow,
    bright_blue, bright_magenta, bright_cyan, bright_white,
    default,
};
```

### Color

```zig
pub const Color = union(enum) {
    ansi4: Ansi4,
    ansi256: Ansi256Color,
    rgb: RgbColor,
    hex: HexColor,
    hsl: HslColor,
    hsv: HsvColor,
};
```

## Functions

### RgbColor.init

```zig
pub fn init(r: u8, g: u8, b: u8) RgbColor
```

### HexColor.init

```zig
pub fn init(hex_string: []const u8) !HexColor
```

Parses "#FF0000", "FF0000", "#F00", or "F00".

### HexColor.fromInt

```zig
pub fn fromInt(value: u24) HexColor
```

### Ansi256Color.init

```zig
pub fn init(index: u8) Ansi256Color
```

### HslColor.init

```zig
pub fn init(h: u16, s: u8, l: u8) HslColor
```

Wraps hue at 360.

### HsvColor.init

```zig
pub fn init(h: u16, s: u8, v: u8) HsvColor
```

Wraps hue at 360.

### CmykColor.init

```zig
pub fn init(c: u8, m: u8, y: u8, k: u8) CmykColor
```

### CmykColor.fromRgb

```zig
pub fn fromRgb(rgb: RgbColor) CmykColor
```

### XyzColor.init

```zig
pub fn init(x: f64, y: f64, z: f64) XyzColor
```

### XyzColor.fromRgb

```zig
pub fn fromRgb(rgb: RgbColor) XyzColor
```

### LabColor.init

```zig
pub fn init(l: f64, a: f64, b_val: f64) LabColor
```

### LabColor.fromXyz

```zig
pub fn fromXyz(xyz: XyzColor) LabColor
```

### LabColor.distance

```zig
pub fn distance(self: LabColor, other: LabColor) f64
```

CIE76 color distance.

## Color Methods

### toFg / toBg / toUnderline

```zig
pub fn toFg(self: Color) []const u8
pub fn toBg(self: Color) []const u8
pub fn toUnderline(self: Color) []const u8
```

### toRgb / toHex / toHsl / toHsv / toCmyk / toXyz / toLab

```zig
pub fn toRgb(self: Color) RgbColor
pub fn toHex(self: Color) u24
pub fn toHsl(self: Color) HslColor
pub fn toHsv(self: Color) HsvColor
pub fn toCmyk(self: Color) CmykColor
pub fn toXyz(self: Color) XyzColor
pub fn toLab(self: Color) LabColor
```

### luminance

```zig
pub fn luminance(self: Color) f64
```

Relative luminance (0.0-1.0).

### lighten / darken / saturate / desaturate

```zig
pub fn lighten(self: Color, amount: f64) Color
pub fn darken(self: Color, amount: f64) Color
pub fn saturate(self: Color, amount: f64) Color
pub fn desaturate(self: Color, amount: f64) Color
```

### invert / grayscale / mix

```zig
pub fn invert(self: Color) Color
pub fn grayscale(self: Color) Color
pub fn mix(self: Color, other: Color, ratio: f64) Color
```

### rotate / adjustHue

```zig
pub fn rotate(self: Color, degrees: u16) Color
pub fn adjustHue(self: Color, degrees: i32) Color
```

### complementary / analogous / triadic / splitComplementary / tetradic

```zig
pub fn complementary(self: Color) Color
pub fn analogous(self: Color) [2]Color
pub fn triadic(self: Color) [2]Color
pub fn splitComplementary(self: Color) [2]Color
pub fn tetradic(self: Color) [3]Color
```

### isLight / isDark

```zig
pub fn isLight(self: Color) bool
pub fn isDark(self: Color) bool
```

### colorDistance / contrastRatio

```zig
pub fn colorDistance(self: Color, other: Color) f64
pub fn contrastRatio(self: Color, other: Color) f64
```

### lerp

```zig
pub fn lerp(c1: Color, c2: Color, t: f64) Color
```

### nearestAnsi256

```zig
pub fn nearestAnsi256(self: Color) u8
```

### kelvin / temperatureToRgb

```zig
pub fn kelvin(temp: u16) Color
pub fn temperatureToRgb(temp: u16) RgbColor
```

Color temperature in Kelvin (1000-40000).

### fade / blend

```zig
pub fn fade(self: Color, amount: f64) Color
pub fn blend(self: Color, other: Color, ratio: f64) Color
```

Fade a color toward gray (0.0 = gray, 1.0 = original). Blend is an alias for mix.

### saturateTo / lightenTo

```zig
pub fn saturateTo(self: Color, target: u8) Color
pub fn lightenTo(self: Color, target: u8) Color
```

Set saturation or lightness to a specific value (0-100).

### grayscaleLuminance / mixHsl

```zig
pub fn grayscaleLuminance(self: Color) Color
pub fn mixHsl(self: Color, other: Color, ratio: f64) Color
```

Grayscale using perceptual luminance. Mix two colors in HSL space.

### monochromatic

```zig
pub fn monochromatic(self: Color, count: u8) [8]Color
```

Returns up to 8 monochromatic variations of the color (varying lightness).

