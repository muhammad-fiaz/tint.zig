# Styles

A `Style` is plain data: colors plus attributes, rendered as one sequence.

## Building Styles

```zig
tint.style.bold
tint.style.italic
tint.style.fg(tint.color.cyan)
tint.style.bg(tint.color.black)

tint.style.bold.fg(tint.color.cyan)
tint.style.Style{ .bold = true, .underline = true }
```

## Attributes

`bold`, `dim`, `italic`, `underline`, `blink`, `rapidBlink`, `reverse`, `hidden`, `strikethrough`, `overline`, `fraktur`, `frame`, `encircle`, `superScript`, `subScript`, with `foreground`, `background` and `underlineColor` colors.

Fraktur, frame, encircle, super/subscript and rapid blink are not part of ECMA-48 and only some terminals honor them.

## Composition

Three explicit operations:

```zig
base.merge(.{ .italic = true });      // union: set fields add on
base.override(.{ .italic = true });   // replace: colors (even null) and flags win
base.without(tint.style.bold);        // subtract: listed fields are removed
```

`merge` never clears; `override` with an empty style clears colors. Neither modifies the receiver.

## Rendering

```zig
const sequence = style.toAnsi();   // ansi.Sequence value
style.reset();                     // minimal undo sequence, empty when unset

var buffer: [64]u8 = undefined;
const text = try style.render(&buffer, "hello");  // styled + trailing reset
```

## Presets

```zig
tint.style.err(red); tint.style.warning(yellow); tint.style.success(green);
tint.style.info(cyan); tint.style.debug(gray); tint.style.link(blue);
tint.style.code(white, black); tint.style.header(white);
tint.style.muted(gray); tint.style.highlight(black, yellow);
```

Attribute-only combinations are constants (`tint.style.bold`), so only meaningful combinations are functions.

## Resets

```zig
tint.ansi.reset.all;         // clears everything
tint.ansi.reset.bold;        // SGR 22, also clears dim
tint.ansi.reset.italic;      // SGR 23, also clears fraktur
tint.ansi.reset.foreground;  // SGR 39
```

Several attributes share a reset because ECMA-48 pairs them.
