# Color API

## Types

### Color

Unified color representation supporting all color formats.

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

### Ansi4

```zig
pub const Ansi4 = enum {
    black, red, green, yellow, blue, magenta, cyan, white,
    bright_black, bright_red, bright_green, bright_yellow,
    bright_blue, bright_magenta, bright_cyan, bright_white,
    default,
};
```

### RgbColor

```zig
pub const RgbColor = struct { r: u8, g: u8, b: u8 };
```

### HexColor

```zig
pub const HexColor = struct { value: u24 };
```

### Ansi256Color

```zig
pub const Ansi256Color = struct { index: u8 };
```

### HslColor

```zig
pub const HslColor = struct { h: u16, s: u8, l: u8 };
```

### HsvColor

```zig
pub const HsvColor = struct { h: u16, s: u8, v: u8 };
```

## Functions

### tint.rgb

```zig
pub fn rgb(r: u8, g: u8, b: u8) Color
```

Creates an RGB color from 8-bit channel values.

### tint.hex

```zig
pub fn hex(value: u24) Color
```

Creates a HEX color from a 24-bit integer (0xRRGGBB).

### tint.ansi256

```zig
pub fn ansi256(index: u8) Color
```

Creates an ANSI 256-color from an index (0-255).

### tint.hsl

```zig
pub fn hsl(h: u16, s: u8, l: u8) Color
```

Creates an HSL color. Hue wraps at 360.

### tint.hsv

```zig
pub fn hsv(h: u16, s: u8, v: u8) Color
```

Creates an HSV color. Hue wraps at 360.

## Methods

### Color.toRgb

```zig
pub fn toRgb(self: Color) RgbColor
```

Converts any color to RGB.

### Color.toFg

```zig
pub fn toFg(self: Color) []const u8
```

Generates foreground ANSI escape sequence.

### Color.toBg

```zig
pub fn toBg(self: Color) []const u8
```

Generates background ANSI escape sequence.

### Color.toUnderline

```zig
pub fn toUnderline(self: Color) []const u8
```

Generates underline color ANSI escape sequence (SGR 58).

### Color Manipulation

```zig
color.lighten(0.2)    // Lighten by 20%
color.darken(0.2)     // Darken by 20%
color.saturate(0.2)   // Saturate by 20%
color.desaturate(0.2) // Desaturate by 20%
color.invert()        // RGB complement
color.grayscale()     // Convert to grayscale
color.mix(other, 0.5) // Mix 50% with another color
```

## Named Colors

CSS/X11-style named colors as RGB values (140+ colors):

```zig
tint.named.red       // RgbColor{ .r = 255, .g = 0, .b = 0 }
tint.named.coral     // RgbColor{ .r = 255, .g = 127, .b = 80 }
tint.named.teal      // RgbColor{ .r = 0, .g = 128, .b = 128 }
tint.named.gold      // RgbColor{ .r = 255, .g = 215, .b = 0 }
```

See the full list in the source code.
