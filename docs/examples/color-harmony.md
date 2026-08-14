# Color Harmony

Color harmony uses relationships between colors to create aesthetically pleasing combinations.

## Complementary

Colors opposite on the color wheel.

```zig
const red = tint.rgb(255, 0, 0);
const complementary = red.complementary(); // Cyan
```

## Analogous

Colors adjacent on the color wheel.

```zig
const red = tint.rgb(255, 0, 0);
const [lower, upper] = red.analogous(); // Orange and Yellow
```

## Triadic

Three colors equally spaced (120° apart).

```zig
const red = tint.rgb(255, 0, 0);
const [second, third] = red.triadic(); // Green and Blue
```

## Split Complementary

Base color plus two colors adjacent to its complement.

```zig
const red = tint.rgb(255, 0, 0);
const [second, third] = red.splitComplementary();
```

## Tetradic (Square)

Four colors equally spaced (90° apart).

```zig
const red = tint.rgb(255, 0, 0);
const [second, third, fourth] = red.tetradic();
```

## Running

```bash
zig build run-color_harmony
```

## Source

See [`examples/color_harmony.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/color_harmony.zig) for the complete example.
