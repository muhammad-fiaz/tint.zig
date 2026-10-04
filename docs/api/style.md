# Style API

## Style

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

```zig
tint.style.bold; tint.style.dim; tint.style.italic; ...
tint.style.fg(color); tint.style.bg(color); tint.style.underlineColor(color);
tint.style.Style{ .bold = true, .foreground = tint.color.red };
```

## Composition

```zig
style.merge(other)        // union: set colors replace, flags combine
style.override(other)     // replace: colors (even null) and flags win
style.without(attrs)      // subtract: listed fields are removed
style.fg(color)           // fluent: bold.fg(red)
style.bg(color)
style.withUnderlineColor(color)
style.withoutForeground()
style.withoutBackground()
style.withoutUnderlineColor()
style.isEmpty()
Style.eql(a, b)
```

## Rendering

```zig
style.toAnsi()            // ansi.Sequence value
style.reset()             // minimal undo sequence, empty when unset
style.render(&buffer, text) // styled text + trailing reset, caller buffer
```

## Presets

```zig
tint.style.err/warning/success/info/debug/link/code/header/muted/highlight
```

Only semantic combinations are functions; bare attributes are constants.
