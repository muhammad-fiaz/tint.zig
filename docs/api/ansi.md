# ANSI API

Terminal encoding. Sequences are values: copyable, stable, allocation-free, no thread-local state.

## Sequences

```zig
tint.ansi.Sequence;          // bytes + len, .slice() reads the bytes
tint.ansi.maxSequenceLen;     // 96, compile-time checked
tint.ansi.Layer;             // foreground/background/underline
tint.ansi.trueColor(layer, r, g, b);
tint.ansi.indexed(layer, index);
tint.ansi.literal(params);   // error.TooLong when params do not fit
sequence.slice();
sequence.eql(&other);
sequence.withReset();        // sequence followed by a full reset
```

## Rendering

```zig
tint.ansi.render(color, layer, capability);
tint.ansi.Capability;  // none/ansi16/ansi256/trueColor
```

The capability is always explicit. Nothing is auto-detected. `.none` degrades to the terminal default for the layer.

## Resets

Shared resets follow ECMA-48 pairing (SGR 22 clears bold and dim, SGR 23 clears italic and fraktur, and so on):

```zig
tint.ansi.reset.all;
tint.ansi.reset.bold; tint.ansi.reset.dim;
tint.ansi.reset.italic; tint.ansi.reset.fraktur;
tint.ansi.reset.underline;
tint.ansi.reset.blink; tint.ansi.reset.rapidBlink;
tint.ansi.reset.reverse; tint.ansi.reset.hidden;
tint.ansi.reset.strikethrough;
tint.ansi.reset.frame; tint.ansi.reset.encircle;
tint.ansi.reset.overline;
tint.ansi.reset.superScript; tint.ansi.reset.subScript;
tint.ansi.reset.foreground; tint.ansi.reset.background;
tint.ansi.reset.underlineColor;
```
