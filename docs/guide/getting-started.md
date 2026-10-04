# Getting Started

`tint.zig` 0.0.2 is a terminal color and text styling library for Zig 0.17.0. It builds ANSI/SGR escape sequences and returns them as values. Your application owns all output.

## Namespaces

```text
tint
├── color    colors, spaces, conversion, metrics, interpolation
├── style    composable text styles and presets
├── palette  tables, ramps, gradients, schemes, analysis
├── theme    semantic themes and contrast validation
└── ansi     sequences, resets, capabilities
```

## First Program

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("{s}red{s}\n", .{ tint.color.red.fg().slice(), reset });
    std.debug.print("{s}custom{s}\n", .{ tint.color.hex(0xFF6600).fg().slice(), reset });

    const errorStyle = tint.style.bold.fg(tint.color.hex(0xEF4444));
    std.debug.print("{s}bold error{s}\n", .{ errorStyle.toAnsi().slice(), reset });
}
```

Run it with `zig build run-basic` after cloning, or adapt it into your project.

## Colors Are Values

```zig
const red = tint.color.red;
const coral = tint.color.coral;
const custom = tint.color.rgb(255, 100, 20);

const rgb = custom.toRgb();
const hsl = custom.toHsl();
const lighter = custom.lighten(0.2);
const mixed = red.mix(tint.color.blue, 0.5);
```

No strings, no metadata pairs. The value is the color.

## Styles Compose

```zig
const heading = tint.style.bold.fg(tint.color.cyan);
const warning = heading.merge(.{ .underline = true });

std.debug.print("{s}hi{s}\n", .{ heading.toAnsi().slice(), tint.ansi.reset.all });
```

## Capabilities Are Explicit

```zig
const sequence = tint.ansi.render(tint.color.coral, .foreground, .ansi256);
```

tint.zig never inspects the environment. You state `none`, `ansi16`, `ansi256` or `trueColor`.

## Next Steps

- [Installation](/guide/installation)
- [Colors](/guide/colors)
- [Styles](/guide/styles)
- [API Reference](/api/)
