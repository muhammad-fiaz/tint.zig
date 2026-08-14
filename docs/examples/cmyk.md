# CMYK Colors

CMYK (Cyan, Magenta, Yellow, Key/Black) is a color model used in printing.

## Creating CMYK Colors

```zig
const tint = @import("tint");

// Pure CMYK values (0-100 each)
const cyan = tint.cmyk(100, 0, 0, 0);
const magenta = tint.cmyk(0, 100, 0, 0);
const yellow = tint.cmyk(0, 0, 100, 0);
const black = tint.cmyk(0, 0, 0, 100);

// Mixed colors
const red = tint.cmyk(0, 100, 100, 0);
const green = tint.cmyk(100, 0, 100, 0);
const blue = tint.cmyk(100, 100, 0, 0);
```

## Converting CMYK to RGB

```zig
const cmyk = tint.cmyk(0, 100, 100, 0);
const rgb = cmyk.toRgb();
std.debug.print("RGB: ({d},{d},{d})\n", .{ rgb.r, rgb.g, rgb.b });
```

## Converting RGB to CMYK

```zig
const cmyk = tint.Named.coral.toCmyk();
std.debug.print("CMYK: ({d},{d},{d},{d})\n", .{ cmyk.c, cmyk.m, cmyk.y, cmyk.k });
```

## Running

```bash
zig build run-cmyk
```

## Source

See [`examples/cmyk.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/cmyk.zig) for the complete example.
