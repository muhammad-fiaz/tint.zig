# Style API

## Types

### Style

```zig
pub const Style = struct {
    fg: ?Color = null,
    bg: ?Color = null,
    underline_color: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
};
```

### StyleOptions

```zig
pub const StyleOptions = struct {
    fg: ?Color = null,
    bg: ?Color = null,
    underline_color: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
};
```

## Functions

### tint.style

```zig
pub fn style(opts: StyleOptions) Style
```

Creates a composable style with the given options.

## Methods

### Style.init

```zig
pub fn init(opts: StyleOptions) Style
```

Creates a new Style with the given options.

### Style.with

```zig
pub fn with(self: Style, opts: StyleOptions) Style
```

Creates a new Style based on this one with the given overrides. Boolean fields are OR'd together.

### Style.toAnsi

```zig
pub fn toAnsi(self: Style) []const u8
```

Generates the complete ANSI escape sequence for this style.
