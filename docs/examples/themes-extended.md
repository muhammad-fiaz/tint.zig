# Themes Extended

All 17 built-in themes with their color palettes.

## Available Themes

| Theme | Constant |
|-------|----------|
| `dark` | `tint.themes.dark_theme` |
| `light` | `tint.themes.light_theme` |
| `dracula` | `tint.themes.dracula_theme` |
| `nord` | `tint.themes.nord_theme` |
| `monokai` | `tint.themes.monokai_theme` |
| `tokyo_night` | `tint.themes.tokyo_night_theme` |
| `gruvbox` | `tint.themes.gruvbox_theme` |
| `solarized` | `tint.themes.solarized_theme` |
| `rose_pine` | `tint.themes.rose_pine_theme` |
| `catppuccin` | `tint.themes.catppuccin_theme` |
| `github` | `tint.themes.github_theme` |
| `one_dark` | `tint.themes.one_dark_theme` |
| `material` | `tint.themes.material_theme` |
| `palenight` | `tint.themes.palenight_theme` |
| `everforest` | `tint.themes.everforest_theme` |
| `kanagawa` | `tint.themes.kanagawa_theme` |
| `cyberdream` | `tint.themes.cyberdream_theme` |

## Theme Structure

Each theme provides colors for:

| Property | Description |
|----------|-------------|
| `primary` | Primary color |
| `secondary` | Secondary color |
| `success` | Success messages |
| `warning` | Warning messages |
| `err` | Error messages |
| `info` | Information messages |
| `text` | Default text color |
| `muted` | Muted/secondary text |
| `background` | Background color |
| `surface` | Surface color |

## Usage

```zig
const tint = @import("tint");

// Use Tokyo Night theme
const tokyo = tint.themes.tokyo_night_theme;
std.debug.print("{s}Error!{s}\n", .{
    tint.fg(tokyo.err),
    tint.reset,
});

// Use Gruvbox
const gruvbox = tint.themes.gruvbox_theme;
std.debug.print("{s}Success!{s}\n", .{
    tint.fg(gruvbox.success),
    tint.reset,
});

// Create a custom theme with background/surface
const custom = tint.Theme{
    .name = "custom",
    .primary = tint.hex(0x6366F1),
    .secondary = tint.hex(0x8B5CF6),
    .success = tint.hex(0x10B981),
    .warning = tint.hex(0xF59E0B),
    .err = tint.hex(0xEF4444),
    .info = tint.hex(0x3B82F6),
    .text = tint.hex(0xE5E7EB),
    .muted = tint.hex(0x6B7280),
    .background = tint.hex(0x1F2937),
    .surface = tint.hex(0x374151),
};
```

## Running

```bash
zig build run-themes_extended
```

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    std.debug.print("=== All Built-in Themes ===\n\n", .{});
    const themes = [_]struct { name: []const u8, theme: tint.Theme }{
        .{ .name = "dark", .theme = tint.themes.dark_theme },
        .{ .name = "light", .theme = tint.themes.light_theme },
        .{ .name = "dracula", .theme = tint.themes.dracula_theme },
        .{ .name = "nord", .theme = tint.themes.nord_theme },
        // ... all 17 themes
    };
    for (themes) |t| {
        std.debug.print("--- {s} ---\n", .{t.name});
        std.debug.print("{s}Primary{s} | {s}Error{s}\n", .{
            tint.fg(t.theme.primary), tint.reset,
            tint.fg(t.theme.err), tint.reset,
        });
    }
}
```
