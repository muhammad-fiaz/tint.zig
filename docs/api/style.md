---
title: Style API
description: "Style API reference: Style values, attribute constants, presets, merge, override, rendering and reset sequences."
keywords: "zig style api, terminal text style, ansi sgr reference, style composition"
---

# Style API

## Style

One struct doubles as the value and its own options, so there is a single type to learn. Every field defaults to unset, making `Style{}` a valid no-op style:

```zig
pub const Style = struct {
    foreground: ?Color = null,
    background: ?Color = null,
    underlineColor: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    rapidBlink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
    fraktur: bool = false,
    frame: bool = false,
    encircle: bool = false,
    superScript: bool = false,
    subScript: bool = false,
};
```

## Constants and Constructors

Single attributes are constants; colors come from `fg`, `bg` and `underlineColor`; anything else is a struct literal. The `fg`/`bg` methods chain after any style:

```zig
tint.style.bold; tint.style.dim; tint.style.italic; ...
tint.style.fg(color); tint.style.bg(color); tint.style.underlineColor(color);
tint.style.bold.fg(tint.color.cyan);
tint.style.Style{ .bold = true, .foreground = tint.color.red };
```

## Composition

`merge` unions two styles without ever clearing; `override` lets the right side replace everything including clearing colors with `null`; `without` subtracts exactly the listed fields. All three return new values:

```zig
style.merge(other)
style.override(other)
style.without(attrs)
style.fg(color)
style.bg(color)
style.withUnderlineColor(color)
style.withoutForeground()
style.withoutBackground()
style.withoutUnderlineColor()
style.isEmpty()
Style.eql(a, b)
```

## Rendering

`toAnsi` returns the complete sequence as a value. `reset` returns the minimal undo sequence for exactly what is set. `render` writes styled text plus a trailing full reset into a caller buffer and fails with `BufferTooSmall` instead of truncating:

```zig
style.toAnsi()
style.reset()
style.render(&buffer, text)
```

## Presets

Only semantic combinations are functions; every bare attribute already exists as a constant, so each idea has exactly one spelling:

```zig
tint.style.err/warning/success/info/debug/link/code/header/muted/highlight
```
