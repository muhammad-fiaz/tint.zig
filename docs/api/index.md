# API Reference

tint.zig provides a minimal, direct API for terminal color and text styling.

## Modules

| Module | Description |
|--------|-------------|
| `tint` | Main module — colors, styles, palettes, themes |
| `color` | Color types and conversions (RGB, HEX, ANSI 256, HSL, HSV, CMYK, XYZ, Lab) |
| `style` | Style composition, presets, and ANSI sequence generation |
| `palette` | ANSI 16, ANSI 88, ANSI 256, RGB cube, grayscale, ramps, color wheel |
| `theme` | Theme construction and 17 built-in themes |

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
tint.fg88(10)                                    // ANSI 88 foreground
tint.bg88(10)                                    // ANSI 88 background
tint.named_color("red")                          // Named color by string
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

### Individual Reset Constants

```zig
tint.reset_bold            // Reset bold only
tint.reset_dim             // Reset dim only
tint.reset_italic          // Reset italic only
tint.reset_underline       // Reset underline only
tint.reset_blink           // Reset blink only
tint.reset_rapid_blink     // Reset rapid blink only
tint.reset_reverse         // Reset reverse only
tint.reset_hidden          // Reset hidden only
tint.reset_strikethrough   // Reset strikethrough only
tint.reset_overline        // Reset overline only
tint.reset_fraktur         // Reset fraktur only
tint.reset_frame           // Reset frame only
tint.reset_encircle        // Reset encircle only
tint.reset_super_script    // Reset super script only
tint.reset_sub_script      // Reset sub script only
```

### Palettes

```zig
tint.palette.ansi16[i]                           // ANSI 16 color
tint.palette.ansi88[i]                           // ANSI 88 color
tint.palette.ansi256[i]                          // ANSI 256 color
tint.palette.rgb6(r, g, b)                       // RGB cube
tint.palette.rgb8(r, g, b)                       // 88-color cube
tint.palette.gray(level)                         // Grayscale (256)
tint.palette.gray88(level)                       // Grayscale (88)
tint.palette.ramp(start, end, steps)             // Color ramp
tint.palette.gradient(c1, c2, c3, steps)        // 3-color gradient
tint.palette.multiGradient(stops, steps)         // Multi-stop gradient
tint.palette.hueGradient(steps)                  // Rainbow gradient
tint.palette.colorWheel(steps)                   // Hue wheel
tint.palette.warm_palette                        // Warm colors
tint.palette.cool_palette                        // Cool colors
tint.palette.earth_palette                       // Earth tones
tint.palette.pastel_palette                      // Pastel colors
tint.palette.neon_palette                        // Neon colors
```

### Color Operations

```zig
// Methods on Color type
some_color.fade(amount)                          // Fade toward gray (0.0=gray, 1.0=original)
some_color.blend(other, ratio)                   // Blend two colors (alias for mix)
some_color.grayscaleLuminance()                  // Perceptual luminance grayscale
some_color.saturateTo(target)                    // Set saturation to exact value (0-100)
some_color.lightenTo(target)                     // Set lightness to exact value (0-100)
some_color.mixHsl(other, ratio)                  // Mix two colors in HSL space
```

### Themes

```zig
tint.themes.dark_theme.primary                   // Dark theme primary
tint.themes.light_theme.err                      // Light theme error
tint.themes.dracula_theme                        // Dracula theme
tint.themes.nord_theme                           // Nord theme
tint.themes.monokai_theme                        // Monokai theme
tint.themes.tokyo_night_theme                    // Tokyo Night theme
tint.themes.gruvbox_theme                        // Gruvbox theme
tint.themes.solarized_theme                      // Solarized theme
tint.themes.rose_pine_theme                      // Rose Pine theme
tint.themes.catppuccin_theme                     // Catppuccin theme
tint.themes.github_theme                         // GitHub theme
tint.themes.one_dark_theme                       // One Dark theme
tint.themes.material_theme                       // Material theme
tint.themes.palenight_theme                      // Palenight theme
tint.themes.everforest_theme                     // Everforest theme
tint.themes.kanagawa_theme                       // Kanagawa theme
tint.themes.cyberdream_theme                     // Cyberdream theme
```

### Color Methods (on Color)

```zig
some_color.distance(other)                       // CIE76 color distance
some_color.contrastRatio(other)                  // WCAG contrast ratio
some_color.isLight()                             // Check if color is light
some_color.isDark()                              // Check if color is dark
some_color.complementary()                       // Complementary color
some_color.analogous()                           // Analogous colors
some_color.triadic()                             // Triadic colors
some_color.splitComplementary()                  // Split complementary
some_color.tetradic()                            // Tetradic colors
some_color.monochromatic(count)                  // Monochromatic palette
Color.lerp(c1, c2, t)                            // Linear interpolation
some_color.nearestAnsi256()                      // Nearest ANSI 256 index
some_color.lighten(amount)                       // Lighten color
some_color.darken(amount)                        // Darken color
some_color.saturate(amount)                      // Saturate color
some_color.desaturate(amount)                    // Desaturate color
some_color.invert()                              // Invert color
some_color.grayscale()                           // Convert to grayscale
some_color.mix(other, ratio)                     // Mix two colors
some_color.rotate(degrees)                       // Rotate hue
some_color.adjustHue(degrees)                    // Adjust hue (signed)
```

## Detailed API

- [Color API](/api/color)
- [Style API](/api/style)
- [Palette API](/api/palette)
- [Theme API](/api/theme)
