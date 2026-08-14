# Colors

tint.zig supports multiple color formats through a unified `Color` type.

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
```

## HEX Colors

```zig
tint.fg(tint.hex(0xFF0000))
tint.fg(tint.hex(0xFF6600))
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

## Named Colors

CSS/X11-style named colors:

```zig
tint.fg(.{ .rgb = tint.named.coral })
tint.fg(.{ .rgb = tint.named.teal })
tint.fg(.{ .rgb = tint.named.gold })
```

## Color Conversion

Convert any color to RGB:

```zig
const c = tint.hex(0xFF6600);
const rgb_val = c.toRgb();
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
```
