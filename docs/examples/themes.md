# Themes Example

Built-in themes, custom themes, roles, validation. Run with `zig build run-themes`.

```zig
tint.theme.tokyoNight;
tint.theme.all;   // all 17

const custom = tint.theme.Theme.create("custom", .{
    .primary = ..., .err = ..., .text = ..., .muted = ...,
    .background = ..., .surface = ...,
});

theme.role(.primary);
theme.styled(.err).merge(tint.style.bold);
theme.contrast(.text, .background);
theme.readability(.muted, .background);
```
