# Gradient Example

Per-character gradient text from interpolation primitives. Run with `zig build run-gradient`.

```zig
from.mix(to, t);                    // two-stop text
red.mixHue(blue, t, .shorter);      // hue sweep
tint.color.kelvin(temp);            // temperature sweep
tint.palette.gradient(&table, &stops);
base.fg(blended).toAnsi();          // style-composed gradient
```
