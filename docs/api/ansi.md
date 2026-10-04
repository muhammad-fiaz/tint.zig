---
title: ANSI API
description: "ANSI API reference: value-based escape sequences, layers, capabilities, rendering and SGR reset constants."
keywords: "zig ansi api, sgr escape sequences, ansi reset codes, terminal capability"
---

# ANSI API

Terminal encoding. Sequences are values with inline bytes: copying copies the bytes, keeping the value keeps them valid, and no thread can observe another thread's sequences. There is no shared buffer, no thread-local state, and no allocation.

## Sequences

`maxSequenceLen` (96) covers the longest sequence the library emits — a full style — and is enforced by a compile-time check:

```zig
tint.ansi.Sequence;          // bytes + len, read with .slice()
tint.ansi.maxSequenceLen;
tint.ansi.Layer;             // foreground/background/underline
tint.ansi.trueColor(layer, r, g, b);
tint.ansi.indexed(layer, index);
tint.ansi.literal(params);   // error.TooLong when params do not fit
sequence.slice();
sequence.eql(&other);
sequence.withReset();        // sequence followed by a full reset
```

`literal` fails instead of truncating, so oversized input can never silently corrupt output.

## Rendering

`render` downgrades the color to exactly the stated capability and encodes it. The capability is always explicit — `none`, `ansi16`, `ansi256`, `trueColor` — and nothing is ever auto-detected:

```zig
tint.ansi.render(color, layer, capability);
tint.ansi.Capability;
```

`.none` degrades to the terminal default for the layer.

## Resets

Shared resets follow ECMA-48 pairing: SGR 22 clears bold and dim together, SGR 23 clears italic and fraktur, SGR 25 clears blink and rapid blink, SGR 54 clears framed and encircled, SGR 75 clears super- and subscript:

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
