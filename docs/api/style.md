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
    rapid_blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    super_script: bool = false,
    sub_script: bool = false,
    fraktur: bool = false,
    overline: bool = false,
    frame: bool = false,
    encircle: bool = false,
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
    rapid_blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    super_script: bool = false,
    sub_script: bool = false,
    fraktur: bool = false,
    overline: bool = false,
    frame: bool = false,
    encircle: bool = false,
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

### Style.withFg

```zig
pub fn withFg(self: Style, c: Color) Style
```

Creates a new Style with the given foreground color.

### Style.withBg

```zig
pub fn withBg(self: Style, c: Color) Style
```

Creates a new Style with the given background color.

### Style.withUnderline

```zig
pub fn withUnderline(self: Style, c: Color) Style
```

Creates a new Style with the given underline color.

### Style.compose

```zig
pub fn compose(a: Style, b: Style) Style
```

Merges two styles. Style b overrides colors from style a. Boolean fields are OR'd.

### Style.toAnsi

```zig
pub fn toAnsi(self: Style) []const u8
```

Generates the complete ANSI escape sequence for this style.

## Presets

### tint.presets.err_style

```zig
pub fn err_style(fg: Color) Style
```

Bold text with given foreground color.

### tint.presets.warning

```zig
pub fn warning(fg: Color) Style
```

Bold text with given foreground color.

### tint.presets.success

```zig
pub fn success(fg: Color) Style
```

Bold text with given foreground color.

### tint.presets.info

```zig
pub fn info(fg: Color) Style
```

Normal text with given foreground color.

### tint.presets.debug

```zig
pub fn debug(fg: Color) Style
```

Dim text with given foreground color.

### tint.presets.link

```zig
pub fn link(fg: Color) Style
```

Underlined text with given foreground color.

### tint.presets.code

```zig
pub fn code(fg: Color, bg: Color) Style
```

Text with given foreground and background colors.

### tint.presets.header

```zig
pub fn header(fg: Color) Style
```

Bold underlined text with given foreground color.

### tint.presets.muted

```zig
pub fn muted(fg: Color) Style
```

Dim text with given foreground color.

### tint.presets.highlight

```zig
pub fn highlight(fg: Color, bg: Color) Style
```

Bold text with given foreground and background colors.
