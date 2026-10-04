# Basic Example

Colors as values. Run with `zig build run-basic`.

```zig
const reset = tint.ansi.reset.all;

tint.color.red.fg().slice();
tint.color.blue.bg().slice();
tint.color.rgb(255, 100, 20).underline().slice();

const colors = .{
    tint.color.coral,
    tint.color.teal,
    tint.color.gold,
};
```
