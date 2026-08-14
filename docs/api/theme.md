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
    background: Color,
    surface: Color,
};
```

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

Creates a new Theme with the given colors. `background` defaults to `text`, `surface` defaults to `muted`.

### Theme.initWithBackground

```zig
pub fn initWithBackground(
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,
    info: Color,
    text: Color,
    muted: Color,
    background: Color,
    surface: Color,
) Theme
```

Creates a new Theme with explicit `background` and `surface` colors.

## Built-in Themes

### dark_theme

Default dark theme with indigo primary, green success, red error.

### light_theme

Default light theme.

### dracula_theme

Dracula color scheme.

### nord_theme

Nord color scheme.

### monokai_theme

Monokai color scheme.

### tokyo_night_theme

Tokyo Night color scheme.

### gruvbox_theme

Gruvbox color scheme.

### solarized_theme

Solarized color scheme.

### rose_pine_theme

Rose Pine color scheme.

### catppuccin_theme

Catppuccin color scheme.

### github_theme

GitHub color scheme.

### one_dark_theme

One Dark color scheme.

### material_theme

Material color scheme.

### palenight_theme

Palenight color scheme.

### everforest_theme

Everforest color scheme.

### kanagawa_theme

Kanagawa color scheme.

### cyberdream_theme

Cyberdream color scheme.
