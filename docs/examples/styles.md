# Styles Example

Attributes, presets, composition, rendering. Run with `zig build run-styles`.

```zig
tint.style.bold.fg(tint.color.cyan);
tint.style.err(tint.color.red);
tint.style.warning(tint.color.yellow);

base.merge(.{ .italic = true });
base.override(.{ .italic = true });
base.without(tint.style.bold);
base.reset();                        // minimal undo sequence

var buffer: [64]u8 = undefined;
style.render(&buffer, "hello");
```
