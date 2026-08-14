# Themes Extended

All 17 built-in themes with their color palettes.

## Available Themes

| Theme | Style |
|-------|-------|
| `dark` | Default dark theme |
| `light` | Default light theme |
| `dracula` | Dracula color scheme |
| `nord` | Nord color scheme |
| `monokai` | Monokai color scheme |
| `tokyo_night` | Tokyo Night color scheme |
| `gruvbox` | Gruvbox color scheme |
| `solarized` | Solarized color scheme |
| `rose_pine` | Rose Pine color scheme |
| `catppuccin` | Catppuccin color scheme |
| `github` | GitHub color scheme |
| `one_dark` | One Dark color scheme |
| `material` | Material color scheme |
| `palenight` | Palenight color scheme |
| `everforest` | Everforest color scheme |
| `kanagawa` | Kanagawa color scheme |
| `cyberdream` | Cyberdream color scheme |

## Theme Structure

Each theme provides colors for:

| Property | Description |
|----------|-------------|
| `fg` | Default foreground |
| `bg` | Default background |
| `comment` | Comments |
| `keyword` | Keywords |
| `string` | Strings |
| `number` | Numbers |
| `function_name` | Function names |
| `variable` | Variables |
| `type` | Types |
| `operator` | Operators |
| `err_style` | Errors |
| `warning` | Warnings |
| `success` | Success |
| `info` | Information |
| `accent` | Accent color |
| `muted` | Muted text |

## Usage

```zig
const tint = @import("tint");

// Use Tokyo Night theme
const tokyo = tint.themes.tokyo_night;
std.debug.print("{s}Error!{s}\n", .{
    tint.fg(tokyo.err_style),
    tint.reset,
});

// Use Gruvbox
const gruvbox = tint.themes.gruvbox;
std.debug.print("{s}Success!{s}\n", .{
    tint.fg(gruvbox.success),
    tint.reset,
});
```

## Running

```bash
zig build run-themes_extended
```

## Source

See [`examples/themes_extended.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/themes_extended.zig) for the complete example.
