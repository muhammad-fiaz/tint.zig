# Palettes Example

Tables, ramps, schemes, checks. Run with `zig build run-palettes`.

```zig
tint.palette.ansi16; tint.palette.ansi88; tint.palette.ansi256;

var ramp: [24]tint.color.Rgb = undefined;
tint.palette.ramp(&ramp, black, white);
tint.palette.gradient(&multi, &stops);
tint.palette.hue(&wheel);
tint.palette.sequential(&seq, 210);
tint.palette.diverging(&div, .{ 0, 220 });
tint.palette.categorical(&cat);

tint.palette.warm; // cool/earth/pastel/neon
tint.palette.minContrastRatio(&colors);
```
