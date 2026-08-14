# API Reference

tint.zig provides a comprehensive API for terminal color and text styling.

## Modules

| Module | Description |
|--------|-------------|
| `tint` | Main module — foreground, background, underline, styles, constants |
| `color` | Color types and conversions (RGB, HEX, ANSI 256, HSL, HSV) |
| `style` | Style composition and ANSI sequence generation |
| `palette` | ANSI 16, ANSI 256, RGB cube, and grayscale palettes |
| `theme` | Theme construction and built-in themes |

## Quick Reference

### Colors

```zig
tint.fg(.{ .ansi4 = .red })                    // ANSI 4-bit foreground
tint.bg(.{ .ansi4 = .blue })                   // ANSI 4-bit background
tint.fg(tint.rgb(255, 0, 0))                   // RGB foreground
tint.fg(tint.hex(0xFF0000))                     // HEX foreground
tint.fg(tint.ansi256(196))                      // ANSI 256 foreground
tint.underline(tint.rgb(255, 0, 0))            // Underline color
```

### Styles

```zig
const s = tint.style(.{
    .fg = tint.hex(0xEF4444),
    .bold = true,
    .underline = true,
});
std.debug.print("{s}text{s}\n", .{ s.toAnsi(), tint.reset });
```

### Palettes

```zig
tint.palette.ansi16[i]                           // ANSI 16 color
tint.palette.ansi256[i]                          // ANSI 256 color
tint.palette.rgb6(r, g, b)                       // RGB cube
tint.palette.gray(level)                         // Grayscale
```

### Themes

```zig
tint.themes.dark_theme.primary                   // Dark theme primary
tint.themes.light_theme.err                      // Light theme error
```

## Detailed API

- [Color API](/api/color)
- [Style API](/api/style)
- [Palette API](/api/palette)
- [Theme API](/api/theme)
