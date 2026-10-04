---
title: Theme API
description: "Theme API reference: Theme values, semantic roles, built-in themes, custom themes and contrast validation."
keywords: "zig theme api, terminal theme, semantic roles, theme contrast validation"
---

# Theme API

## Theme

A named set of semantic colors. `err` is used because `error` is a Zig primitive type name:

```zig
pub const Theme = struct {
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
};
```

## Construction

`Theme.create` takes an options struct. `background` and `surface` are optional and fall back to `text` and `muted`, though every built-in theme ships explicit values:

```zig
tint.theme.Theme.create("custom", .{
    .primary = ..., .secondary = ..., .success = ..., .warning = ...,
    .err = ..., .info = ..., .text = ..., .muted = ...,
    .background = ...,
    .surface = ...,
});
```

## Built-in Themes

Seventeen themes with camelCase identifiers matching their `name` fields; `all` holds every one for iteration:

```zig
tint.theme.dark; tint.theme.light; tint.theme.dracula; tint.theme.nord;
tint.theme.monokai; tint.theme.tokyoNight; tint.theme.gruvbox;
tint.theme.solarized; tint.theme.rosePine; tint.theme.catppuccin;
tint.theme.github; tint.theme.oneDark; tint.theme.material;
tint.theme.palenight; tint.theme.everforest; tint.theme.kanagawa;
tint.theme.cyberdream; tint.theme.all;
```

## Roles and Validation

`role` reads any of the ten semantic roles. `styled` turns a role into a foreground style. `contrast` and `readability` score a pair, and `meets` requires every foreground role to pass a grade against the background:

```zig
tint.theme.Role;
theme.role(.primary);
theme.styled(.err);
theme.contrast(.text, .background);
theme.readability(.muted, .background);
theme.meets(.aa);
```
