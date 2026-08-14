# Preset Styles

tint.zig includes 17 built-in preset styles for common use cases.

## Available Presets

| Preset | Description |
|--------|-------------|
| `err_style` | Error messages (bold red) |
| `warning` | Warning messages (bold yellow) |
| `success` | Success messages (bold green) |
| `info` | Information messages (cyan) |
| `debug` | Debug output (dim gray) |
| `link` | Hyperlinks (underlined blue) |
| `code` | Inline code (with background) |
| `header` | Section headers (bold underlined) |
| `muted` | Muted/secondary text (dim) |
| `highlight` | Highlighted text (bold with background) |
| `strikethrough_text` | Deleted text (strikethrough) |
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

// Strikethrough
const del = tint.presets.strikethrough_text(.{ .ansi4 = .red });
std.debug.print("{s}Deleted text{s}\n", .{ del.toAnsi(), tint.reset });

// Framed
const frame = tint.presets.framed(.{ .ansi4 = .blue });
std.debug.print("{s}Framed text{s}\n", .{ frame.toAnsi(), tint.reset });
```

## Running

```bash
zig build run-presets
```

## Source

```zig
const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const err = tint.presets.err_style(.{ .ansi4 = .red });
    std.debug.print("{s}Error: Something went wrong!{s}\n", .{ err.toAnsi(), tint.reset });

    const warn = tint.presets.warning(.{ .ansi4 = .yellow });
    std.debug.print("{s}Warning: Check your input.{s}\n", .{ warn.toAnsi(), tint.reset });

    const strike = tint.presets.strikethrough_text(.{ .ansi4 = .red });
    std.debug.print("{s}Deleted text{s}\n", .{ strike.toAnsi(), tint.reset });

    const framed = tint.presets.framed(.{ .ansi4 = .blue });
    std.debug.print("{s}Framed text{s}\n", .{ framed.toAnsi(), tint.reset });
}
```
