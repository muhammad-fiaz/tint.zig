# Palette API

## Constants

### ansi16

```zig
pub const ansi16 = [16]AnsiRgb{ ... };
```

Standard ANSI 16-color palette as RGB values.

### ansi256

```zig
pub const ansi256 = [256]AnsiRgb{ ... };
```

Full ANSI 256-color palette as RGB values.

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

### gray

```zig
pub fn gray(level: u8) struct { index: u8 }
```

Creates an ANSI 256 grayscale color.

- `level` must be in range 0-23 (maps to indices 232-255)
- Returns the ANSI 256 index
