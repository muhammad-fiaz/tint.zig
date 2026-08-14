# Color Temperature

Kelvin temperature describes the color appearance of light sources from warm (orange) to cool (blue).

## Creating Kelvin Colors

```zig
const tint = @import("tint");

// Warm light (candle, incandescent)
const warm = tint.kelvin(2700);

// Daylight
const daylight = tint.kelvin(6500);

// Cool blue sky
const cool = tint.kelvin(10000);
```

## Common Temperatures

| Kelvin | Description |
|--------|-------------|
| 1000K | Candle light |
| 2000K | Warm white |
| 2700K | Incandescent |
| 3000K | Halogen |
| 4000K | Fluorescent |
| 5000K | Direct sunlight |
| 6500K | Cloudy daylight |
| 8000K | Light blue sky |
| 10000K | Blue sky |
| 20000K | Deep blue sky |

## Temperature to RGB

```zig
const rgb = tint.Color.temperatureToRgb(6500);
std.debug.print("RGB: ({d},{d},{d})\n", .{ rgb.r, rgb.g, rgb.b });
```

## Running

```bash
zig build run-color_temperature
```

## Source

See [`examples/color_temperature.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/color_temperature.zig) for the complete example.
