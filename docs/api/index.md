---
title: API Reference
description: "Complete tint.zig 0.0.2 API reference: color, style, palette, theme and ansi namespaces with constructors and methods."
keywords: "tint.zig api, zig color library reference, terminal styling api"
---

# API Reference

```text
tint
├── color    colors, spaces, conversion, metrics, interpolation
├── style    composable text styles and presets
├── palette  tables, ramps, gradients, schemes, analysis
├── theme    semantic themes and contrast validation
└── ansi     sequences, resets, capabilities
```

The root exposes only the namespaces plus `tint.version` and `tint.minimumZigVersion` (0.0.2 / 0.17.0).

## Color

```zig
tint.color.rgb/black/white/red/coral/...   // values and constructors
tint.color.ansi4.red                       // base colors as values
tint.color.ansi256.rgb/gray/index          // indexed constructors
tint.color.ansi88.rgb/gray
red.toRgb/red.toHsl/red.toOklab/...        // any space to any space
red.lighten/red.mix/red.mixIn/red.mixHue
red.deltaE2000/red.contrastRatio
red.nearestAnsi256/red.downgrade
tint.color.parse                            // runtime string lookup
```

[Color API](/api/color)

## Style

```zig
tint.style.bold/tint.style.italic/...      // attribute constants
tint.style.fg/tint.style.bg                // color setters
tint.style.err/tint.style.warning/...      // presets
style.merge/style.override/style.without
style.toAnsi/style.reset/style.render
```

[Style API](/api/style)

## Palette

```zig
tint.palette.ansi16/ansi88/ansi256
tint.palette.ramp/gradient/hue
tint.palette.sequential/diverging/categorical
tint.palette.warm/cool/earth/pastel/neon
tint.palette.readability/minContrastRatio/...
```

[Palette API](/api/palette)

## Theme

```zig
tint.theme.dark/.../tint.theme.all
theme.role/theme.styled/theme.contrast/theme.readability/theme.meets
```

[Theme API](/api/theme)

## ANSI

```zig
tint.ansi.trueColor/tint.ansi.indexed/tint.ansi.literal
tint.ansi.render(color, layer, capability)
tint.ansi.reset.all/...
tint.ansi.Capability/tint.ansi.Sequence
```

[ANSI API](/api/ansi)
