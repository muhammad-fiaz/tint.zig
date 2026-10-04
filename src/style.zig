//! Composable text styles. A `Style` is plain data: build it, merge it, render
//! it. Fraktur, frame, encircle, super/subscript and rapid blink are not part
//! of ECMA-48 and only some terminals honour them.

const std = @import("std");
const testing = std.testing;
const ansi = @import("ansi.zig");
const color = @import("color.zig");

/// A set of SGR parameters rendered as one sequence. Every field defaults to
/// unset, so `Style{}` is a valid no-op style.
pub const Style = struct {
    foreground: ?color.Color = null,
    background: ?color.Color = null,
    underlineColor: ?color.Color = null,

    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    rapidBlink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
    fraktur: bool = false,
    frame: bool = false,
    encircle: bool = false,
    superScript: bool = false,
    subScript: bool = false,

    /// Union of both styles. Set colours replace, set attributes combine.
    /// Neither side is modified.
    pub fn merge(self: Style, other: Style) Style {
        var result = self;
        const style_fields = @typeInfo(Style).@"struct";
        inline for (style_fields.field_names, style_fields.field_types) |name, FieldType| {
            switch (@typeInfo(FieldType)) {
                .optional => {
                    if (@field(other, name)) |value| @field(result, name) = value;
                },
                .bool => @field(result, name) = @field(result, name) or @field(other, name),
                else => @compileError("Style.merge does not support " ++ @typeName(FieldType)),
            }
        }
        return result;
    }

    /// `other` wins outright: its colours replace (null clears) and its
    /// booleans replace. Use `merge` to combine instead.
    pub fn override(self: Style, other: Style) Style {
        var result = self;
        const style_fields = @typeInfo(Style).@"struct";
        inline for (style_fields.field_names, style_fields.field_types) |name, FieldType| {
            switch (@typeInfo(FieldType)) {
                .optional => @field(result, name) = @field(other, name),
                .bool => @field(result, name) = @field(other, name),
                else => @compileError("Style.override does not support " ++ @typeName(FieldType)),
            }
        }
        return result;
    }

    /// Removes the set fields of `attrs` from this style.
    pub fn without(self: Style, attrs: Style) Style {
        var result = self;
        const style_fields = @typeInfo(Style).@"struct";
        inline for (style_fields.field_names, style_fields.field_types) |name, FieldType| {
            switch (@typeInfo(FieldType)) {
                .optional => {
                    if (@field(attrs, name) != null) @field(result, name) = null;
                },
                .bool => {
                    if (@field(attrs, name)) @field(result, name) = false;
                },
                else => @compileError("Style.without does not support " ++ @typeName(FieldType)),
            }
        }
        return result;
    }

    /// A copy with `value` as the foreground colour. Chains: `bold.fg(red)`.
    pub fn fg(self: Style, value: color.Color) Style {
        return self.merge(.{ .foreground = value });
    }

    /// A copy with `value` as the background colour. Chains: `bold.bg(blue)`.
    pub fn bg(self: Style, value: color.Color) Style {
        return self.merge(.{ .background = value });
    }

    pub fn withUnderlineColor(self: Style, value: color.Color) Style {
        return self.merge(.{ .underlineColor = value });
    }

    pub fn withoutForeground(self: Style) Style {
        var result = self;
        result.foreground = null;
        return result;
    }

    pub fn withoutBackground(self: Style) Style {
        var result = self;
        result.background = null;
        return result;
    }

    pub fn withoutUnderlineColor(self: Style) Style {
        var result = self;
        result.underlineColor = null;
        return result;
    }

    /// True when nothing is set.
    pub fn isEmpty(self: Style) bool {
        return std.meta.eql(self, Style{});
    }

    pub fn eql(a: Style, b: Style) bool {
        return std.meta.eql(a, b);
    }

    /// The complete `ESC[...m` sequence for this style.
    pub fn toAnsi(self: Style) ansi.Sequence {
        var sequence: ansi.Sequence = .{};
        var writer = std.Io.Writer.fixed(&sequence.bytes);
        writer.writeAll(ansi.escape) catch unreachable;

        var first = true;
        if (self.foreground) |value| {
            writeSeparator(&writer, &first);
            writeColor(&writer, .foreground, value);
        }
        if (self.background) |value| {
            writeSeparator(&writer, &first);
            writeColor(&writer, .background, value);
        }
        if (self.underlineColor) |value| {
            writeSeparator(&writer, &first);
            writeColor(&writer, .underline, value);
        }

        const attributes = [_]struct { enabled: bool, params: []const u8 }{
            .{ .enabled = self.bold, .params = "1" },
            .{ .enabled = self.dim, .params = "2" },
            .{ .enabled = self.italic, .params = "3" },
            .{ .enabled = self.underline, .params = "4" },
            .{ .enabled = self.blink, .params = "5" },
            .{ .enabled = self.rapidBlink, .params = "6" },
            .{ .enabled = self.reverse, .params = "7" },
            .{ .enabled = self.hidden, .params = "8" },
            .{ .enabled = self.strikethrough, .params = "9" },
            .{ .enabled = self.superScript, .params = "73" },
            .{ .enabled = self.subScript, .params = "74" },
            .{ .enabled = self.fraktur, .params = "20" },
            .{ .enabled = self.overline, .params = "53" },
            .{ .enabled = self.frame, .params = "51" },
            .{ .enabled = self.encircle, .params = "52" },
        };
        for (attributes) |attribute| {
            if (!attribute.enabled) continue;
            writeSeparator(&writer, &first);
            writer.writeAll(attribute.params) catch unreachable;
        }

        writer.writeAll(ansi.terminator) catch unreachable;
        sequence.len = @intCast(writer.buffered().len);
        return sequence;
    }

    /// The minimal sequence that undoes this style. Empty when nothing is set.
    pub fn reset(self: Style) ansi.Sequence {
        var sequence: ansi.Sequence = .{};
        if (self.isEmpty()) return sequence;

        var writer = std.Io.Writer.fixed(&sequence.bytes);
        writer.writeAll(ansi.escape) catch unreachable;

        var first = true;
        if (self.foreground != null) {
            writeSeparator(&writer, &first);
            writer.writeAll("39") catch unreachable;
        }
        if (self.background != null) {
            writeSeparator(&writer, &first);
            writer.writeAll("49") catch unreachable;
        }
        if (self.underlineColor != null) {
            writeSeparator(&writer, &first);
            writer.writeAll("59") catch unreachable;
        }
        const resets = [_]struct { enabled: bool, params: []const u8 }{
            .{ .enabled = self.bold or self.dim, .params = "22" },
            .{ .enabled = self.italic or self.fraktur, .params = "23" },
            .{ .enabled = self.underline, .params = "24" },
            .{ .enabled = self.blink or self.rapidBlink, .params = "25" },
            .{ .enabled = self.reverse, .params = "27" },
            .{ .enabled = self.hidden, .params = "28" },
            .{ .enabled = self.strikethrough, .params = "29" },
            .{ .enabled = self.superScript or self.subScript, .params = "75" },
            .{ .enabled = self.overline, .params = "53" },
            .{ .enabled = self.frame or self.encircle, .params = "54" },
        };
        for (resets) |entry| {
            if (!entry.enabled) continue;
            writeSeparator(&writer, &first);
            writer.writeAll(entry.params) catch unreachable;
        }

        writer.writeAll(ansi.terminator) catch unreachable;
        sequence.len = @intCast(writer.buffered().len);
        return sequence;
    }

    /// Wraps `text` in this style and a trailing full reset. Needs room for
    /// the style sequence, `text` and `ESC[0m`.
    pub fn render(self: Style, buffer: []u8, text: []const u8) error{BufferTooSmall}![]const u8 {
        const head = self.toAnsi();
        const tail = ansi.reset.all;
        if (buffer.len < head.slice().len + text.len + tail.len) return error.BufferTooSmall;
        var pos: usize = 0;
        @memcpy(buffer[pos..][0..head.slice().len], head.slice());
        pos += head.slice().len;
        @memcpy(buffer[pos..][0..text.len], text);
        pos += text.len;
        @memcpy(buffer[pos..][0..tail.len], tail);
        pos += tail.len;
        return buffer[0..pos];
    }
};

fn writeSeparator(writer: *std.Io.Writer, first: *bool) void {
    if (first.*) {
        first.* = false;
    } else {
        writer.writeAll(";") catch unreachable;
    }
}

fn writeColor(writer: *std.Io.Writer, layer: ansi.Layer, value: color.Color) void {
    switch (value) {
        .ansi4 => |a| {
            writer.writeAll(color.ansi4Params(layer, a)) catch unreachable;
        },
        .ansi256 => |a| {
            writer.print("{d};5;{d}", .{ layerCode(layer), a.index }) catch unreachable;
        },
        .rgb => |c| {
            writer.print("{d};2;{d};{d};{d}", .{ layerCode(layer), c.r, c.g, c.b }) catch unreachable;
        },
        .hex => |c| writeColor(writer, layer, .{ .rgb = c.toRgb() }),
        .hsl => |c| writeColor(writer, layer, .{ .rgb = c.toRgb() }),
        .hsv => |c| writeColor(writer, layer, .{ .rgb = c.toRgb() }),
    }
}

fn layerCode(layer: ansi.Layer) u8 {
    return switch (layer) {
        .foreground => 38,
        .background => 48,
        .underline => 58,
    };
}

/// One attribute on its own. Combine with struct literals or `merge`.
pub const bold: Style = .{ .bold = true };
pub const dim: Style = .{ .dim = true };
pub const italic: Style = .{ .italic = true };
pub const underline: Style = .{ .underline = true };
pub const blink: Style = .{ .blink = true };
pub const rapidBlink: Style = .{ .rapidBlink = true };
pub const reverse: Style = .{ .reverse = true };
pub const hidden: Style = .{ .hidden = true };
pub const strikethrough: Style = .{ .strikethrough = true };
pub const overline: Style = .{ .overline = true };
pub const fraktur: Style = .{ .fraktur = true };
pub const frame: Style = .{ .frame = true };
pub const encircle: Style = .{ .encircle = true };
pub const superScript: Style = .{ .superScript = true };
pub const subScript: Style = .{ .subScript = true };

/// A style with only a foreground colour.
pub fn fg(value: color.Color) Style {
    return .{ .foreground = value };
}

/// A style with only a background colour.
pub fn bg(value: color.Color) Style {
    return .{ .background = value };
}

/// A style with only an underline colour.
pub fn underlineColor(value: color.Color) Style {
    return .{ .underlineColor = value };
}

/// Ready-made styles. Attribute-only variants live next to this namespace as
/// constants, so only combinations with a semantic meaning are functions.
pub fn err(value: color.Color) Style {
    return .{ .foreground = value, .bold = true };
}

pub fn warning(value: color.Color) Style {
    return .{ .foreground = value, .bold = true };
}

pub fn success(value: color.Color) Style {
    return .{ .foreground = value, .bold = true };
}

pub fn info(value: color.Color) Style {
    return .{ .foreground = value };
}

pub fn debug(value: color.Color) Style {
    return .{ .foreground = value, .dim = true };
}

pub fn link(value: color.Color) Style {
    return .{ .foreground = value, .underline = true };
}

pub fn code(value: color.Color, background: color.Color) Style {
    return .{ .foreground = value, .background = background };
}

pub fn header(value: color.Color) Style {
    return .{ .foreground = value, .bold = true, .underline = true };
}

pub fn muted(value: color.Color) Style {
    return .{ .foreground = value, .dim = true };
}

pub fn highlight(value: color.Color, background: color.Color) Style {
    return .{ .foreground = value, .background = background, .bold = true };
}

test "empty style is a bare terminator" {
    const rendered = (Style{}).toAnsi();
    try testing.expectEqualStrings("\x1b[m", rendered.slice());
    try testing.expect((Style{}).isEmpty());
    try testing.expect(!bold.isEmpty());
}

test "single attributes render their SGR parameter" {
    try testing.expectEqualStrings("\x1b[1m", bold.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[2m", dim.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[3m", italic.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[4m", underline.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[5m", blink.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[6m", rapidBlink.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[7m", reverse.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[8m", hidden.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[9m", strikethrough.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[73m", superScript.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[74m", subScript.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[20m", fraktur.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[53m", overline.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[51m", frame.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[52m", encircle.toAnsi().slice());
}

test "colours join with semicolons in layer order" {
    try testing.expectEqualStrings("\x1b[31m", fg(.{ .ansi4 = .red }).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[44m", bg(.{ .ansi4 = .blue }).toAnsi().slice());
    try testing.expectEqualStrings(
        "\x1b[31;44m",
        fg(.{ .ansi4 = .red }).merge(bg(.{ .ansi4 = .blue })).toAnsi().slice(),
    );
    try testing.expectEqualStrings(
        "\x1b[38;2;255;0;0;48;2;0;0;255;58;2;1;2;3m",
        fg(.{ .rgb = .init(255, 0, 0) })
            .merge(bg(.{ .rgb = .init(0, 0, 255) }))
            .merge(underlineColor(.{ .rgb = .init(1, 2, 3) }))
            .toAnsi()
            .slice(),
    );
}

test "colours precede attributes" {
    try testing.expectEqualStrings("\x1b[31;44;1;3m", (Style{
        .foreground = .{ .ansi4 = .red },
        .background = .{ .ansi4 = .blue },
        .bold = true,
        .italic = true,
    }).toAnsi().slice());
}

test "merge, override and without" {
    const base = Style{ .foreground = .{ .ansi4 = .red }, .bold = true };

    const merged = base.merge(.{ .underline = true });
    try testing.expect(merged.bold and merged.underline);
    try testing.expectEqual(base.foreground, merged.foreground);
    try testing.expect(!base.underline);
    try testing.expectEqual(base, base.merge(.{}));

    const recoloured = base.merge(.{ .foreground = .{ .ansi4 = .green } });
    try testing.expectEqual(color.Color{ .ansi4 = .green }, recoloured.foreground.?);

    const cleared = base.override(.{ .italic = true });
    try testing.expect(cleared.foreground == null);
    try testing.expect(!cleared.bold);
    try testing.expect(cleared.italic);
    try testing.expectEqual(base, base.override(base));

    const stripped = base.without(.{ .bold = true, .foreground = .{ .ansi4 = .black } });
    try testing.expect(!stripped.bold);
    try testing.expect(stripped.foreground == null);
    try testing.expect(base.bold);
    try testing.expectEqual(base, base.without(.{}));
}

test "colour setters" {
    const base = bold;
    try testing.expectEqual(color.Color{ .ansi4 = .red }, base.fg(.{ .ansi4 = .red }).foreground.?);
    try testing.expectEqual(color.Color{ .ansi4 = .blue }, base.bg(.{ .ansi4 = .blue }).background.?);
    try testing.expectEqual(color.Color{ .ansi4 = .green }, base.withUnderlineColor(.{ .ansi4 = .green }).underlineColor.?);
    try testing.expect(base.fg(.{ .ansi4 = .red }).bold);
    try testing.expect(base.withoutForeground().foreground == null);
    try testing.expect(base.withoutBackground().background == null);
    try testing.expect(base.withoutUnderlineColor().underlineColor == null);
}

test "equality" {
    try testing.expect(Style.eql(bold, .{ .bold = true }));
    try testing.expect(!Style.eql(bold, italic));
    try testing.expect(!Style.eql(fg(.{ .ansi4 = .red }), fg(.{ .ansi4 = .blue })));
}

test "longest sequence stays in bounds" {
    const longest = Style{
        .foreground = .{ .rgb = .init(255, 255, 255) },
        .background = .{ .rgb = .init(255, 255, 255) },
        .underlineColor = .{ .rgb = .init(255, 255, 255) },
        .bold = true,
        .dim = true,
        .italic = true,
        .underline = true,
        .blink = true,
        .rapidBlink = true,
        .reverse = true,
        .hidden = true,
        .strikethrough = true,
        .overline = true,
        .fraktur = true,
        .frame = true,
        .encircle = true,
        .superScript = true,
        .subScript = true,
    };
    try testing.expectEqualStrings(
        "\x1b[38;2;255;255;255;48;2;255;255;255;58;2;255;255;255;1;2;3;4;5;6;7;8;9;73;74;20;53;51;52m",
        longest.toAnsi().slice(),
    );
}

test "reset only resets what is set" {
    const nothing = (Style{}).reset();
    try testing.expectEqual(@as(usize, 0), nothing.slice().len);
    try testing.expectEqualStrings("\x1b[22m", bold.reset().slice());
    try testing.expectEqualStrings("\x1b[22m", dim.reset().slice());
    try testing.expectEqualStrings("\x1b[23m", italic.merge(fraktur).reset().slice());
    try testing.expectEqualStrings("\x1b[24m", underline.reset().slice());
    try testing.expectEqualStrings("\x1b[39;49;59m", fg(.{ .ansi4 = .red })
        .merge(bg(.{ .ansi4 = .blue }))
        .merge(underlineColor(.{ .ansi4 = .green }))
        .reset()
        .slice());
    try testing.expectEqualStrings(
        "\x1b[39;22;25;27;28;29;75;53;54m",
        fg(.{ .ansi4 = .red })
            .merge(bold)
            .merge(blink)
            .merge(reverse)
            .merge(hidden)
            .merge(strikethrough)
            .merge(superScript)
            .merge(overline)
            .merge(frame)
            .reset()
            .slice(),
    );
}

test "render wraps text and resets" {
    var buffer: [64]u8 = undefined;
    const styled = try bold.merge(fg(.{ .ansi4 = .red })).render(&buffer, "hi");
    try testing.expectEqualStrings("\x1b[31;1mhi\x1b[0m", styled);

    try testing.expectError(error.BufferTooSmall, bold.render(buffer[0..3], "hi"));
    try testing.expectError(error.BufferTooSmall, bold.render(&.{}, ""));
}

test "presets" {
    const red: color.Color = .{ .ansi4 = .red };
    const yellow: color.Color = .{ .ansi4 = .yellow };
    const green: color.Color = .{ .ansi4 = .green };
    const gray: color.Color = .{ .ansi4 = .brightBlack };

    try testing.expectEqualStrings("\x1b[31;1m", err(red).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[33;1m", warning(yellow).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[32;1m", success(green).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[36m", info(.{ .ansi4 = .cyan }).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[90;2m", debug(gray).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[34;4m", link(.{ .ansi4 = .blue }).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[37;40m", code(.{ .ansi4 = .white }, .{ .ansi4 = .black }).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[97;1;4m", header(.{ .ansi4 = .brightWhite }).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[90;2m", muted(gray).toAnsi().slice());
    try testing.expectEqualStrings("\x1b[30;43;1m", highlight(.{ .ansi4 = .black }, yellow).toAnsi().slice());
}

test {
    testing.refAllDecls(@This());
}
