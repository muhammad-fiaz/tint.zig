---
title: Styles
description: "Compose terminal text styles with tint.zig: attributes, presets, merge, override, rendering and SGR resets."
keywords: "zig text styles, terminal styling, bold italic underline, ansi attributes, style composition"
---

# Styles

A `Style` is plain data — foreground, background and underline colors plus text attributes — rendered as a single SGR sequence. Styles never print and never hold state; combining them always produces a new value.

## Building Styles

Single attributes are ready-made constants. Colors come from `fg`, `bg` and `underlineColor` constructors, and anything can be written as a struct literal:

```zig
tint.style.bold
tint.style.italic
tint.style.fg(tint.color.cyan)
tint.style.bg(tint.color.black)

tint.style.bold.fg(tint.color.cyan)
tint.style.Style{ .bold = true, .underline = true }
```

Available attributes: `bold`, `dim`, `italic`, `underline`, `blink`, `rapidBlink`, `reverse`, `hidden`, `strikethrough`, `overline`, `fraktur`, `frame`, `encircle`, `superScript`, `subScript`, with `foreground`, `background` and `underlineColor` colors.

Fraktur, frame, encircle, super/subscript and rapid blink are not part of ECMA-48 and only some terminals honor them.

## Composition

Three explicit operations cover every combination. `merge` unions two styles (set colors replace, flags combine), `override` lets the right side win outright (even `null` clears a color), and `without` subtracts the listed fields. None modifies the receiver:

```zig
base.merge(.{ .italic = true });
base.override(.{ .italic = true });
base.without(tint.style.bold);
base.fg(color);   // fluent foreground setter, chains after any style
base.bg(color);   // fluent background setter
```

## Rendering

`toAnsi` returns the complete sequence as an `ansi.Sequence` value. `reset` returns the minimal undo sequence for exactly what is set (empty when nothing is set). `render` wraps text with the style and a trailing full reset into a caller buffer:

```zig
const sequence = style.toAnsi();
style.reset();

var buffer: [64]u8 = undefined;
const text = try style.render(&buffer, "hello");
```

## Presets

Semantic combinations are functions; bare attributes are constants, so there is exactly one way to write each:

```zig
tint.style.err(red); tint.style.warning(yellow); tint.style.success(green);
tint.style.info(cyan); tint.style.debug(gray); tint.style.link(blue);
tint.style.code(white, black); tint.style.header(white);
tint.style.muted(gray); tint.style.highlight(black, yellow);
```

## Resets

```zig
tint.ansi.reset.all;         // clears everything
tint.ansi.reset.bold;        // SGR 22, also clears dim
tint.ansi.reset.italic;      // SGR 23, also clears fraktur
tint.ansi.reset.foreground;  // SGR 39
```

Several attributes share a reset because ECMA-48 pairs them; see the [ANSI reference](/api/ansi) for the full list.
