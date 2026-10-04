# Themes

A theme is plain data with semantic roles. There is no global current theme: select the value and pass it around.

## Built-in Themes

```zig
tint.theme.dark; tint.theme.light; tint.theme.dracula; tint.theme.nord;
tint.theme.monokai; tint.theme.tokyoNight; tint.theme.gruvbox;
tint.theme.solarized; tint.theme.rosePine; tint.theme.catppuccin;
tint.theme.github; tint.theme.oneDark; tint.theme.material;
tint.theme.palenight; tint.theme.everforest; tint.theme.kanagawa;
tint.theme.cyberdream;

tint.theme.all;  // all 17, in presentation order
```

## Roles

```zig
theme.role(.primary);
theme.role(.secondary);
theme.role(.success);
theme.role(.warning);
theme.role(.err);       // `error` is a Zig primitive, so the role is `err`
theme.role(.info);
theme.role(.text);
theme.role(.muted);
theme.role(.background);
theme.role(.surface);
```

## Custom Themes

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

`background` and `surface` fall back to `text` and `muted`, but every built-in theme ships explicit values.

## Styles and Validation

```zig
theme.styled(.err);                        // Style with the role as foreground
theme.contrast(.text, .background);        // WCAG ratio
theme.readability(.muted, .background);    // fail/large/aa/aaa
theme.meets(.aa);                          // every foreground role on background
```
