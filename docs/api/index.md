# API Reference

tint.zig provides a minimal, direct API for terminal color and text styling.

## Modules

| Module | Description |
|--------|-------------|
| `tint` | Main module — colors, styles, palettes, themes |
| `color` | Color types and conversions (RGB, HEX, ANSI 256, HSL, HSV, CMYK, XYZ, Lab) |
| `style` | Style composition, presets, and ANSI sequence generation |
| `palette` | ANSI 16, ANSI 256, RGB cube, grayscale, ramps, gradients, color wheel |
| `theme` | Theme construction and 16 built-in themes |

## Quick Reference

### Colors

```zig
tint.fg(.{ .ansi4 = .red })                    // ANSI 4-bit foreground
tint.bg(.{ .ansi4 = .blue })                   // ANSI 4-bit background
tint.fg(tint.rgb(255, 0, 0))                   // RGB foreground
tint.fg(tint.hex(0xFF0000))                     // HEX foreground
tint.fg(tint.ansi256(196))                      // ANSI 256 foreground
tint.fg(tint.hsl(0, 100, 50))                   // HSL foreground
tint.fg(tint.hsv(0, 100, 100))                  // HSV foreground
tint.fg(tint.cmyk(0, 100, 100, 0))             // CMYK foreground
tint.fg(tint.kelvin(2700))                      // Color temperature
tint.underline(tint.rgb(255, 0, 0))            // Underline color

// Convenience functions
tint.fgRgb(255, 0, 0)                           // RGB foreground
tint.bgRgb(0, 255, 0)                           // RGB background
tint.fgHex(0xFF0000)                             // HEX foreground
tint.bgHex(0x00FF00)                             // HEX background
tint.fg256(196)                                  // ANSI 256 foreground
tint.bg256(196)                                  // ANSI 256 background
```

### Styles

```zig
const s = tint.style(.{
    .fg = tint.hex(0xEF4444),
    .bold = true,
    .underline = true,
});
std.debug.print("{s}text{s}\n", .{ s.toAnsi(), tint.reset });

// Preset styles
const err = tint.presets.err_style(.{ .ansi4 = .red });
const warn = tint.presets.warning(.{ .ansi4 = .yellow });
const link = tint.presets.link(.{ .ansi4 = .blue });
```

### Palettes

```zig
tint.palette.ansi16[i]                           // ANSI 16 color
tint.palette.ansi256[i]                          // ANSI 256 color
tint.palette.rgb6(r, g, b)                       // RGB cube
tint.palette.gray(level)                         // Grayscale
tint.palette.ramp(start, end, steps)             // Color ramp
tint.palette.gradient(c1, c2, c3, steps)        // 3-color gradient
tint.palette.multiGradient(stops, steps)         // Multi-stop gradient
tint.palette.hueGradient(steps)                  // Rainbow gradient
tint.palette.colorWheel(steps)                   // Hue wheel
tint.palette.warm_palette                        // Warm colors
tint.palette.cool_palette                        // Cool colors
```

### Gradient Text

```zig
tint.fgGradient(text, colors)                    // Foreground gradient text
tint.bgGradient(text, colors)                    // Background gradient text
```

Apply per-character foreground or background gradient. Supports 2+ color stops with smooth interpolation. Returns `[]const u8` from threadlocal buffers.

### Color Operations

```zig
color.fade(amount)                               // Fade toward gray (0.0=gray, 1.0=original)
color.blend(other, ratio)                        // Blend two colors (alias for mix)
color.grayscaleLuminance()                       // Perceptual luminance grayscale
color.saturateTo(target)                         // Set saturation to exact value (0-100)
color.lightenTo(target)                          // Set lightness to exact value (0-100)
color.mixHsl(other, ratio)                       // Mix two colors in HSL space
```

### Themes

```zig
tint.themes.dark_theme.primary                   // Dark theme primary
tint.themes.light_theme.err                      // Light theme error
tint.themes.dracula_theme                        // Dracula theme
tint.themes.tokyo_night_theme                    // Tokyo Night theme
tint.themes.gruvbox_theme                        // Gruvbox theme
tint.themes.solarized_theme                      // Solarized theme
tint.themes.rose_pine_theme                      // Rose Pine theme
tint.themes.catppuccin_theme                     // Catppuccin theme
tint.themes.github_theme                         // GitHub theme
```

### Color Methods (on Color)

```zig
color.distance(other)                            // CIE76 color distance
color.contrastRatio(other)                       // WCAG contrast ratio
color.isLight()                                  // Check if color is light
color.isDark()                                   // Check if color is dark
color.complementary()                            // Complementary color
color.analogous()                                // Analogous colors
color.triadic()                                  // Triadic colors
color.splitComplementary()                       // Split complementary
color.tetradic()                                 // Tetradic colors
Color.lerp(c1, c2, t)                            // Linear interpolation
color.nearestAnsi256()                           // Nearest ANSI 256 index
color.lighten(amount)                            // Lighten color
color.darken(amount)                             // Darken color
color.saturate(amount)                           // Saturate color
color.desaturate(amount)                         // Desaturate color
color.invert()                                   // Invert color
color.grayscale()                                // Convert to grayscale
color.mix(other, ratio)                          // Mix two colors
color.rotate(degrees)                            // Rotate hue
```

## Detailed API

- [Color API](/api/color)
- [Style API](/api/style)
- [Palette API](/api/palette)
- [Theme API](/api/theme)
