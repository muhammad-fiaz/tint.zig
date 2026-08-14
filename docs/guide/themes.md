# Themes

tint.zig provides explicit theme support without global state.

## Built-in Themes

16 built-in themes:

```zig
const dark = tint.themes.dark_theme;
const light = tint.themes.light_theme;
const dracula = tint.themes.dracula_theme;
const nord = tint.themes.nord_theme;
const monokai = tint.themes.monokai_theme;
const tokyo_night = tint.themes.tokyo_night_theme;
const gruvbox = tint.themes.gruvbox_theme;
const solarized = tint.themes.solarized_theme;
const rose_pine = tint.themes.rose_pine_theme;
const catppuccin = tint.themes.catppuccin_theme;
const github = tint.themes.github_theme;
const one_dark = tint.themes.one_dark_theme;
const material = tint.themes.material_theme;
const palenight = tint.themes.palenight_theme;
const everforest = tint.themes.everforest_theme;
const kanagawa = tint.themes.kanagawa_theme;
const cyberdream = tint.themes.cyberdream_theme;
```

## Theme Structure

```zig
pub const Theme = struct {
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,        // "err" not "error" (reserved keyword)
    info: Color,
    text: Color,
    muted: Color,
};
```

## Custom Themes

```zig
const my_theme = tint.Theme.init(
    "custom",
    tint.hex(0x7C3AED),  // primary
    tint.hex(0x06B6D4),  // secondary
    tint.hex(0x22C55E),  // success
    tint.hex(0xF59E0B),  // warning
    tint.hex(0xEF4444),  // err
    tint.hex(0x3B82F6),  // info
    tint.hex(0xE5E7EB),  // text
    tint.hex(0x6B7280),  // muted
);

std.debug.print("{s}Error: {s}{s}\n", .{
    tint.fg(my_theme.err),
    tint.style(.{ .bold = true }).toAnsi(),
    tint.reset,
});
```

## Theme Switching

Switch themes by selecting different data:

```zig
var active_theme = dark_theme;

// Later...
active_theme = light_theme;

std.debug.print("{s}Primary color{s}\n", .{
    tint.fg(active_theme.primary),
    tint.reset,
});
```

No global `setTheme()` or auto-detection — you control the selection.
