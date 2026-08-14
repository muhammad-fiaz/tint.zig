# Styles

tint.zig provides composable text styles.

## Style Composition

Create styles with the `style` function:

```zig
const error_style = tint.style(.{
    .fg = tint.hex(0xEF4444),
    .bold = true,
});

std.debug.print("{s}Error message{s}\n", .{
    error_style.toAnsi(),
    tint.reset,
});
```

## Style Options

| Option | Type | Description |
|--------|------|-------------|
| `fg` | `?Color` | Foreground color |
| `bg` | `?Color` | Background color |
| `underline_color` | `?Color` | Underline color |
| `bold` | `bool` | Bold text (SGR 1) |
| `dim` | `bool` | Dim text (SGR 2) |
| `italic` | `bool` | Italic text (SGR 3) |
| `underline` | `bool` | Underlined text (SGR 4) |
| `blink` | `bool` | Blinking text (SGR 5) |
| `reverse` | `bool` | Reversed text (SGR 7) |
| `hidden` | `bool` | Hidden text (SGR 8) |
| `strikethrough` | `bool` | Strikethrough text (SGR 9) |
| `overline` | `bool` | Overlined text (SGR 53) |

## Extending Styles

Use `.with()` to create extended styles:

```zig
const base = tint.style(.{
    .fg = .{ .ansi4 = .green },
    .bold = true,
});

const warning = base.with(.{
    .underline = true,
});
```

## Individual Resets

```zig
tint.reset_bold           // SGR 22
tint.reset_italic         // SGR 23
tint.reset_underline      // SGR 24
tint.reset_blink          // SGR 25
tint.reset_reverse        // SGR 27
tint.reset_hidden         // SGR 28
tint.reset_strikethrough  // SGR 29
tint.reset_overline       // SGR 55
tint.reset_fg             // SGR 39
tint.reset_bg             // SGR 49
tint.reset_underline_color // SGR 59
```

## Full Reset

```zig
tint.reset  // SGR 0 - clears all attributes
```
