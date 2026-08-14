# Theme API

## Types

### Theme

```zig
pub const Theme = struct {
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,        // Note: "err" not "error" (reserved keyword in Zig)
    info: Color,
    text: Color,
    muted: Color,
};
```

## Constants

### dark_theme

```zig
pub const dark_theme = Theme{ ... };
```

Default dark theme with indigo primary, green success, red error.

### light_theme

```zig
pub const light_theme = Theme{ ... };
```

Default light theme.

### dracula_theme

```zig
pub const dracula_theme = Theme{ ... };
```

Dracula color scheme.

### nord_theme

```zig
pub const nord_theme = Theme{ ... };
```

Nord color scheme.

### monokai_theme

```zig
pub const monokai_theme = Theme{ ... };
```

Monokai color scheme.

## Functions

### Theme.init

```zig
pub fn init(
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,
    info: Color,
    text: Color,
    muted: Color,
) Theme
```

Creates a new Theme with the given colors.
