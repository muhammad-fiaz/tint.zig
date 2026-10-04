---
title: Themes
description: "Use 17 built-in themes or build custom ones with semantic roles, then validate contrast and readability."
keywords: "zig themes, terminal themes, dracula, tokyo night, theme contrast, semantic colors"
---

# Themes

A theme is plain data: a name plus a color for every semantic role. There is no global current theme and nothing is auto-detected — the client selects the value it wants and passes it around like any other value.

## Built-in Themes

Seventeen ready-made themes, from editor classics to modern schemes. `all` holds every one in presentation order for iteration:

```zig
tint.theme.dark; tint.theme.light; tint.theme.dracula; tint.theme.nord;
tint.theme.monokai; tint.theme.tokyoNight; tint.theme.gruvbox;
tint.theme.solarized; tint.theme.rosePine; tint.theme.catppuccin;
tint.theme.github; tint.theme.oneDark; tint.theme.material;
tint.theme.palenight; tint.theme.everforest; tint.theme.kanagawa;
tint.theme.cyberdream;

tint.theme.all;
```

## Roles

Ten semantic roles cover every color a terminal UI needs. `role` looks a role up on a theme; `err` is used because `error` is a Zig primitive type name:

```zig
theme.role(.primary);
theme.role(.secondary);
theme.role(.success);
theme.role(.warning);
theme.role(.err);
theme.role(.info);
theme.role(.text);
theme.role(.muted);
theme.role(.background);
theme.role(.surface);
```

## Custom Themes

Build your own with `Theme.create`. `background` and `surface` are optional and fall back to `text` and `muted`, but every built-in theme ships explicit values:

```zig
const custom = tint.theme.Theme.create("custom", .{
    .primary = tint.color.hex(0x6366F1),
    .secondary = tint.color.hex(0x8B5CF6),
    .success = tint.color.hex(0x10B981),
    .warning = tint.color.hex(0xF59E0B),
    .err = tint.color.hex(0xEF4444),
    .info = tint.color.hex(0x3B82F6),
    .text = tint.color.hex(0xE5E7EB),
    .muted = tint.color.hex(0x6B7280),
    .background = tint.color.hex(0x1F2937),
    .surface = tint.color.hex(0x374151),
});
```

## Styles and Validation

`styled` turns a role into a foreground style ready for merging. `contrast` computes the WCAG ratio between two roles, `readability` grades it, and `meets` checks every foreground role against the background at once:

```zig
theme.styled(.err);                        // Style with the role as foreground
theme.contrast(.text, .background);        // WCAG ratio, 1.0...21.0
theme.readability(.muted, .background);    // fail/large/aa/aaa
theme.meets(.aa);                          // true when all roles pass
```
