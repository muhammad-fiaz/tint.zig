# Palettes

Tables mirror xterm so previews match what terminals show. Generators write into caller buffers and never allocate.

## Tables

```zig
tint.palette.ansi16;    // [16]Rgb
tint.palette.ansi88;    // [88]Rgb, xterm layout
tint.palette.ansi256;   // [256]Rgb
tint.palette.ansi16Names;
tint.palette.ansi88Names;
```

## Indexed Constructors

```zig
tint.color.ansi256.rgb(5, 0, 0);  // 6x6x6 cube
tint.color.ansi256.gray(12);      // grayscale ramp
tint.color.ansi256.index(196);    // arbitrary index
tint.color.ansi88.rgb(3, 2, 1);   // 4x4x4 cube
tint.color.ansi88.gray(7);
```

## Generators

```zig
var ramp: [24]tint.color.Rgb = undefined;
tint.palette.ramp(&ramp, black, white);

var multi: [48]tint.color.Rgb = undefined;
tint.palette.gradient(&multi, &stops);

var wheel: [72]tint.color.Rgb = undefined;
tint.palette.hue(&wheel);

var seq: [12]tint.color.Rgb = undefined;
tint.palette.sequential(&seq, 210);       // one hue, light to dark
tint.palette.diverging(&div, .{ 0, 220 });
tint.palette.categorical(&cat);           // distinct hues
```

First and last elements are exactly the ends. Empty and single-element buffers are safe no-ops (a single slot holds the start color).

## Harmony Schemes

```zig
var out: [4]tint.color.Color = undefined;
const used = tint.palette.tetradic(&out, base);  // returns what was written
```

Also `complementary`, `analogous`, `triadic`, `splitComplementary`.

## Subsets

```zig
tint.palette.warm; tint.palette.cool; tint.palette.earth;
tint.palette.pastel; tint.palette.neon;
```

## Analysis

```zig
tint.palette.readability(fg, bg);       // fail/large/aa/aaa
tint.palette.minContrastRatio(&colors);
tint.palette.maxContrastRatio(&colors);
tint.palette.hasDuplicates(&colors);
tint.palette.closestPair(&colors);      // smallest CIEDE2000 gap
tint.palette.isMonotonicLuminance(&colors);
```
