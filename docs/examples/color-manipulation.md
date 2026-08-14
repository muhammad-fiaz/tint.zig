# Color Manipulation

tint.zig provides functions to modify colors dynamically.

## Lighten / Darken

```zig
const base = tint.rgb(100, 150, 200);

// Lighten by percentage
const lighter = base.lighten(0.2); // 20% lighter

// Darken by percentage
const darker = base.darken(0.2); // 20% darker
```

## Saturate / Desaturate

```zig
const base = tint.rgb(100, 150, 200);

// Increase saturation
const saturated = base.saturate(0.3);

// Decrease saturation
const desaturated = base.desaturate(0.3);

// Convert to grayscale
const gray = base.grayscale();
```

## Invert

```zig
const base = tint.rgb(100, 150, 200);
const inverted = base.invert(); // RGB(155, 105, 55)
```

## Mix

```zig
const red = tint.rgb(255, 0, 0);
const blue = tint.rgb(0, 0, 255);

// Mix with weight (0.0 = all red, 1.0 = all blue)
const purple = red.mix(blue, 0.5);
```

## Rotate Hue

```zig
const red = tint.hsl(0, 100, 50);

// Rotate hue by degrees
const rotated = red.rotate(60); // Shifts toward yellow
```

## Lerp (Linear Interpolate)

```zig
const red = tint.rgb(255, 0, 0);
const blue = tint.rgb(0, 0, 255);

// Interpolate between two colors
const mid = tint.Color.lerp(red, blue, 0.5);
```

## Running

```bash
zig build run-color_manipulation
```

## Source

See [`examples/color_manipulation.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/color_manipulation.zig) for the complete example.
