# Styles

`tint.zig` provides composable text styles for terminal output.

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
| `rapid_blink` | `bool` | Rapid blink (SGR 6) |
| `reverse` | `bool` | Reversed text (SGR 7) |
| `hidden` | `bool` | Hidden text (SGR 8) |
| `strikethrough` | `bool` | Strikethrough text (SGR 9) |
| `super_script` | `bool` | Superscript (SGR 73) |
| `sub_script` | `bool` | Subscript (SGR 74) |
| `fraktur` | `bool` | Fraktur/Gothic (SGR 20) |
| `overline` | `bool` | Overlined text (SGR 53) |
| `frame` | `bool` | Framed text (SGR 51) |
| `encircle` | `bool` | Encircled text (SGR 52) |

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

## Convenience Methods

```zig
const s = tint.style(.{ .bold = true });
const with_fg = s.withFg(.{ .ansi4 = .red });      // Set foreground
const with_bg = s.withBg(.{ .ansi4 = .blue });      // Set background
const with_ul = s.withUnderline(.{ .ansi4 = .green }); // Set underline color
```

## Style Composition

Merge two styles with `compose()`:

```zig
const s1 = tint.style(.{ .bold = true, .fg = .{ .ansi4 = .red } });
const s2 = tint.style(.{ .italic = true, .bg = .{ .ansi4 = .blue } });
const composed = tint.Style.compose(s1, s2);
// Result: bold=true, italic=true, fg=red, bg=blue
```

## Preset Styles

17 built-in presets:

| Preset | Description |
|--------|-------------|
| `err_style` | Bold red for errors |
| `warning` | Bold yellow for warnings |
| `success` | Bold green for success |
| `info` | Normal cyan for info |
| `debug` | Dim gray for debug |
| `link` | Underlined blue for links |
| `code` | White on black for code |
| `header` | Bold underlined for headers |
| `muted` | Dim for muted text |
| `highlight` | Bold black on yellow for highlights |
| `strikethrough` | Strikethrough text |
| `blink` | Blinking text |
| `reverse` | Reversed colors |
| `hidden` | Hidden text |
| `overlined` | Overlined text |
| `framed` | Framed text |
| `encircled` | Encircled text |

```zig
const err = tint.presets.err_style(.{ .ansi4 = .red });    // Bold red
const warn = tint.presets.warning(.{ .ansi4 = .yellow });  // Bold yellow
const ok = tint.presets.success(.{ .ansi4 = .green });     // Bold green
const info = tint.presets.info(.{ .ansi4 = .cyan });       // Normal cyan
const debug = tint.presets.debug(.{ .ansi4 = .bright_black }); // Dim gray
const link = tint.presets.link(.{ .ansi4 = .blue });       // Underlined blue
const code = tint.presets.code(.{ .ansi4 = .white }, .{ .ansi4 = .black }); // White on black
const hdr = tint.presets.header(.{ .ansi4 = .bright_white }); // Bold underlined
const muted = tint.presets.muted(.{ .ansi4 = .bright_black }); // Dim
const hl = tint.presets.highlight(.{ .ansi4 = .black }, .{ .ansi4 = .yellow }); // Bold black on yellow
```

## Individual Resets

```zig
tint.reset_bold           // SGR 22
tint.reset_italic         // SGR 23
tint.reset_underline      // SGR 24
tint.reset_blink          // SGR 25
tint.reset_rapid_blink    // SGR 26
tint.reset_reverse        // SGR 27
tint.reset_hidden         // SGR 28
tint.reset_strikethrough  // SGR 29
tint.reset_overline       // SGR 55
tint.reset_fraktur        // SGR 26
tint.reset_frame          // SGR 54
tint.reset_encircle       // SGR 54
tint.reset_super_script   // SGR 75
tint.reset_sub_script     // SGR 75
tint.reset_fg             // SGR 39
tint.reset_bg             // SGR 49
tint.reset_underline_color // SGR 59
```

## Full Reset

```zig
tint.reset  // SGR 0 - clears all attributes
```
