# Palette API

## Constants

### ansi16

```zig
pub const ansi16 = [16]AnsiRgb{ ... };
```

Standard ANSI 16-color palette as RGB values.

### ansi16_names

```zig
pub const ansi16_names = [16][]const u8{ ... };
```

Names for the ANSI 16-color palette.

### ansi88

```zig
pub const ansi88 = [88]AnsiRgb{ ... };
```

Full ANSI 88-color palette as RGB values (comptime-generated). Includes 16 standard colors, 8x8x8 color cube (indices 16-79), and 8 grayscale ramp (indices 80-87).

### ansi88_names

```zig
pub const ansi88_names = [88][]const u8{ ... };
```

Names for the ANSI 88-color palette.

### ansi256

```zig
pub const ansi256 = [256]AnsiRgb{ ... };
```

Full ANSI 256-color palette as RGB values (comptime-generated).

## Types

### AnsiRgb

```zig
pub const AnsiRgb = struct {
    r: u8,
    g: u8,
    b: u8,
};
```

## Functions

### rgb6

```zig
pub fn rgb6(r: u8, g: u8, b: u8) struct { index: u8 }
```

Creates an ANSI 256 color from 6x6x6 RGB cube coordinates.

- `r`, `g`, `b` must be in range 0-5
- Returns the ANSI 256 index (16-231)

### rgb8

```zig
pub fn rgb8(r: u8, g: u8, b: u8) struct { index: u8 }
```

Creates an ANSI 88 color from 8x8x8 RGB cube coordinates.

- `r`, `g`, `b` must be in range 0-7
- Returns the ANSI 88 index (16-79)

### gray

```zig
pub fn gray(level: u8) struct { index: u8 }
```

Creates an ANSI 256 grayscale color.

- `level` must be in range 0-23 (maps to indices 232-255)
- Returns the ANSI 256 index

### gray88

```zig
pub fn gray88(level: u8) struct { index: u8 }
```

Creates an ANSI 88 grayscale color.

- `level` must be in range 0-7 (maps to indices 80-87)
- Returns the ANSI 88 index

### ramp

```zig
pub fn ramp(start: RgbColor, end: RgbColor, steps: u8) [256]RgbColor
```

Generates a linear color interpolation between two colors.

### gradient

```zig
pub fn gradient(c1: RgbColor, c2: RgbColor, c3: RgbColor, steps: u8) [256]RgbColor
```

Generates a three-color gradient.

### multiGradient

```zig
pub fn multiGradient(stops: []const RgbColor, steps: u8) [256]RgbColor
```

Generates a multi-stop gradient between an array of color stops. Interpolates linearly between consecutive stops.

### hueGradient

```zig
pub fn hueGradient(steps: u8) [256]RgbColor
```

Generates a rainbow gradient by rotating through the full hue range in HSL space.

### colorWheel

```zig
pub fn colorWheel(steps: u8) [256]RgbColor
```

Generates a full hue rainbow.

## Palette Subsets

### warm_palette

```zig
pub const warm_palette = [8]RgbColor{ ... };
```

8 warm colors (reds, oranges, yellows).

### cool_palette

```zig
pub const cool_palette = [8]RgbColor{ ... };
```

8 cool colors (blues, cyans, teals).

### earth_palette

```zig
pub const earth_palette = [8]RgbColor{ ... };
```

8 earth tones (browns, tans).

### pastel_palette

```zig
pub const pastel_palette = [8]RgbColor{ ... };
```

8 pastel colors.

### neon_palette

```zig
pub const neon_palette = [8]RgbColor{ ... };
```

8 neon/bright colors.
