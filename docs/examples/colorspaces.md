# Colorspaces Example

Any space to any space, plus parsing. Run with `zig build run-colorspaces`.

```zig
const c = tint.color.hex(0xFF6600);
c.toRgb(); c.toHsl(); c.toOklab(); c.toLab();

tint.color.parse("#ff6600");
tint.color.parse("rebeccaPurple");
tint.color.Hex.parse("#FF660080");  // alpha validated, discarded
```
