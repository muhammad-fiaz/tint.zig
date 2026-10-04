# Theme API

## Theme

```zig
pub const Theme = struct {
    name: []const u8,
    primary: Color,
    secondary: Color,
    success: Color,
    warning: Color,
    err: Color,   // `error` is a Zig primitive, so the role is `err`
    info: Color,
    text: Color,
    muted: Color,
    background: Color,
    surface: Color,
};
```

## Construction

```zig
tint.theme.Theme.create("custom", .{
    .primary = ..., .secondary = ..., .success = ..., .warning = ...,
    .err = ..., .info = ..., .text = ..., .muted = ...,
    .background = ...,  // optional, falls back to text
    .surface = ...,     // optional, falls back to muted
});
```

## Built-in Themes

```zig
tint.theme.dark; tint.theme.light; tint.theme.dracula; tint.theme.nord;
tint.theme.monokai; tint.theme.tokyoNight; tint.theme.gruvbox;
tint.theme.solarized; tint.theme.rosePine; tint.theme.catppuccin;
tint.theme.github; tint.theme.oneDark; tint.theme.material;
tint.theme.palenight; tint.theme.everforest; tint.theme.kanagawa;
tint.theme.cyberdream; tint.theme.all;
```

## Roles and Validation

```zig
tint.theme.Role;   // primary/secondary/success/warning/err/info/text/muted/background/surface
theme.role(.primary);
theme.styled(.err);
theme.contrast(.text, .background);
theme.readability(.muted, .background);
theme.meets(.aa);
```
