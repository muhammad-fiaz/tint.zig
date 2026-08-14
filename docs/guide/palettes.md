# Palettes

tint.zig provides access to standard color palettes.

## ANSI 16 Palette

```zig
const colors = tint.palette.ansi16;
// 16 AnsiRgb values
```

## ANSI 256 Palette

```zig
const colors = tint.palette.ansi256;
// 256 AnsiRgb values
```

## RGB Cube Helper

Convert 6x6x6 coordinates to ANSI 256 index:

```zig
const result = tint.palette.rgb6(5, 0, 0);
// result.index = 196 (ANSI 256 index for red)
tint.fg(tint.ansi256(result.index));
```

## Grayscale Helper

Access grayscale ramp (indices 232-255):

```zig
const result = tint.palette.gray(12);
// result.index = 244 (ANSI 256 index for gray)
tint.fg(tint.ansi256(result.index));
```
