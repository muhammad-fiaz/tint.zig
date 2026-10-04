# Palette API

## Tables

```zig
tint.palette.ansi16;      // [16]Rgb
tint.palette.ansi88;      // [88]Rgb
tint.palette.ansi256;     // [256]Rgb
tint.palette.ansi16Names; // [16][]const u8
tint.palette.ansi88Names; // [88][]const u8
```

## Generators

Every generator writes into a caller buffer. Empty buffers are no-ops; single slots hold the start color; ends are exact.

```zig
tint.palette.ramp(&out, start, end);
tint.palette.gradient(&out, &stops);
tint.palette.hue(&out);
tint.palette.sequential(&out, hue);
tint.palette.diverging(&out, .{ hueA, hueB });
tint.palette.categorical(&out);
```

## Harmony Schemes

Each writes up to `out.len` colors and returns what was written:

```zig
tint.palette.complementary(&out, base);
tint.palette.analogous(&out, base);
tint.palette.triadic(&out, base);
tint.palette.tetradic(&out, base);
tint.palette.splitComplementary(&out, base);
```

## Subsets

```zig
tint.palette.warm; tint.palette.cool; tint.palette.earth;
tint.palette.pastel; tint.palette.neon;
```

## Analysis

```zig
tint.palette.Readability;              // fail/large/aa/aaa
tint.palette.readability(fg, bg);
tint.palette.minContrastRatio(&colors); // needs 2+
tint.palette.maxContrastRatio(&colors); // needs 2+
tint.palette.hasDuplicates(&colors);
tint.palette.closestPair(&colors);      // smallest CIEDE2000 gap, needs 2+
tint.palette.isMonotonicLuminance(&colors);
```
