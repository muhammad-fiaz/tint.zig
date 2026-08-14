# Preset Styles

tint.zig includes 17 built-in preset styles for common use cases.

## Available Presets

| Preset | Description |
|--------|-------------|
| `err_style` | Error messages (red) |
| `warning` | Warning messages (yellow) |
| `success` | Success messages (green) |
| `info` | Information messages (cyan) |
| `debug` | Debug output (gray) |
| `link` | Hyperlinks (blue) |
| `code` | Inline code |
| `header` | Section headers |
| `muted` | Muted/secondary text |
| `highlight` | Highlighted text |
| `strikethrough_text` | Deleted text |
| `blink_text` | Blinking text |
| `reverse_text` | Reverse video |
| `hidden_text` | Hidden text |
| `overlined` | Overlined text |
| `framed` | Framed text |
| `encircled` | Encircled text |

## Usage

```zig
const tint = @import("tint");

// Error style
const err = tint.presets.err_style(.{ .ansi4 = .red });
std.debug.print("{s}Error!{s}\n", .{ err.toAnsi(), tint.reset });

// Warning with custom color
const warn = tint.presets.warning(.{ .hex = 0xFFAA00 });
std.debug.print("{s}Warning!{s}\n", .{ warn.toAnsi(), tint.reset });

// Code style with background
const code = tint.presets.code(
    .{ .ansi4 = .white },
    .{ .ansi4 = .black },
);
std.debug.print("{s} code {s}\n", .{ code.toAnsi(), tint.reset });
```

## Running

```bash
zig build run-presets
```

## Source

See [`examples/presets.zig`](https://github.com/muhammad-fiaz/tint.zig/blob/main/examples/presets.zig) for the complete example.
