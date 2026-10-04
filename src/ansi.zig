//! Terminal encoding: sequences, resets and capabilities.
//!
//! Sequences are returned by value. No shared buffers, no thread-local state,
//! no allocation: a `Sequence` stays valid as long as the caller keeps it.

const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");

/// Introduces an SGR escape sequence. Every sequence this library emits
/// starts with these two bytes (`ESC [`).
pub const escape = "\x1b[";
/// Terminates an SGR escape sequence. Every sequence this library emits ends
/// with this byte.
pub const terminator = "m";

/// Longest sequence tint.zig emits: a full style with three 24-bit colours
/// and every attribute set. Enforced at compile time; see below.
pub const maxSequenceLen = 96;

comptime {
    // A full style: escape, three colour groups, fifteen attributes, terminator.
    if (escape.len + 3 * 17 + 2 + 15 + 17 + terminator.len > maxSequenceLen) {
        @compileError("maxSequenceLen is too small");
    }
}

/// Which colour layer a sequence applies to. Foreground selects the text
/// colour, background the cell behind it, underline the underline colour
/// (SGR `58`, supported by modern terminals).
pub const Layer = enum {
    foreground,
    background,
    underline,

    /// The SGR extended-colour introducer for this layer (38, 48 or 58).
    pub fn code(self: Layer) u8 {
        return switch (self) {
            .foreground => 38,
            .background => 48,
            .underline => 58,
        };
    }
};

/// A finished escape sequence, returned by value.
///
/// A `Sequence` owns its bytes inline: copying it copies the bytes, keeping
/// it keeps them valid, and no thread can observe another thread's sequences.
/// Read the bytes with `slice()`. The value is only meaningful once written
/// to a terminal; the library never writes anything itself.
pub const Sequence = struct {
    bytes: [maxSequenceLen]u8 = @splat(0),
    len: u8 = 0,

    /// The sequence bytes. Valid for as long as this value is alive.
    pub fn slice(self: *const Sequence) []const u8 {
        return self.bytes[0..self.len];
    }

    /// Byte-wise equality of two sequences.
    pub fn eql(a: *const Sequence, b: *const Sequence) bool {
        return std.mem.eql(u8, a.slice(), b.slice());
    }

    /// A copy of this sequence followed by a full reset (`ESC[0m`).
    /// Panics in safe builds if the combined bytes would exceed capacity,
    /// which cannot happen for sequences this library produces.
    pub fn withReset(self: Sequence) Sequence {
        const suffix = escape ++ "0" ++ terminator;
        std.debug.assert(self.len + suffix.len <= maxSequenceLen);
        var result = self;
        @memcpy(result.bytes[self.len..][0..suffix.len], suffix);
        result.len += suffix.len;
        return result;
    }
};

fn wrap(comptime fmt: []const u8, args: anytype) Sequence {
    var sequence: Sequence = .{};
    var writer = std.Io.Writer.fixed(&sequence.bytes);
    writer.print(escape ++ fmt, args) catch unreachable;
    const body = writer.buffered();
    std.debug.assert(body.len + terminator.len <= maxSequenceLen);
    sequence.bytes[body.len] = terminator[0];
    sequence.len = @intCast(body.len + 1);
    return sequence;
}

/// A complete 24-bit sequence, e.g. `ESC[38;2;255;0;0m` for red foreground.
/// `r`, `g` and `b` accept the full `0...255` channel range.
pub fn trueColor(layer: Layer, r: u8, g: u8, b: u8) Sequence {
    return wrap("{d};2;{d};{d};{d}", .{ layer.code(), r, g, b });
}

/// A complete indexed sequence, e.g. `ESC[38;5;196m`. `index` accepts the
/// full `0...255` range; how the terminal interprets it depends on whether
/// it implements the 88- or 256-colour palette.
pub fn indexed(layer: Layer, index: u8) Sequence {
    return wrap("{d};5;{d}", .{ layer.code(), index });
}

/// A complete sequence from already-rendered SGR parameters, e.g. `"31"`
/// becomes `ESC[31m`. Fails with `error.TooLong` when the parameters do not
/// fit the sequence capacity instead of truncating.
pub fn literal(params: []const u8) error{TooLong}!Sequence {
    if (escape.len + params.len + terminator.len > maxSequenceLen) return error.TooLong;
    var result: Sequence = .{};
    @memcpy(result.bytes[0..escape.len], escape);
    @memcpy(result.bytes[escape.len..][0..params.len], params);
    result.bytes[escape.len + params.len] = terminator[0];
    result.len = @intCast(escape.len + params.len + 1);
    return result;
}

/// Renders `c` for `layer` at exactly the given capability.
///
/// The colour is downgraded first (`trueColor` keeps it, `ansi256`/`ansi16`
/// quantize it, `none` becomes the terminal default for the layer), then
/// encoded. Deterministic: the caller states the capability, the library
/// never inspects the environment.
pub fn render(c: color.Color, layer: Layer, capability: Capability) Sequence {
    return c.downgrade(capability).sequence(layer);
}

/// Individual SGR resets. Several attributes share a reset because ECMA-48
/// pairs them: SGR 22 clears bold and dim, SGR 23 clears italic and fraktur,
/// and so on.
pub const reset = struct {
    /// Clears every attribute.
    pub const all = escape ++ "0" ++ terminator;
    /// Clears bold (and dim).
    pub const bold = escape ++ "22" ++ terminator;
    /// Clears dim (and bold).
    pub const dim = escape ++ "22" ++ terminator;
    /// Clears italic (and fraktur).
    pub const italic = escape ++ "23" ++ terminator;
    /// Clears fraktur (and italic).
    pub const fraktur = escape ++ "23" ++ terminator;
    /// Clears underline.
    pub const underline = escape ++ "24" ++ terminator;
    /// Clears blink (and rapid blink).
    pub const blink = escape ++ "25" ++ terminator;
    /// Clears rapid blink (and blink).
    pub const rapidBlink = escape ++ "25" ++ terminator;
    /// Clears reverse video.
    pub const reverse = escape ++ "27" ++ terminator;
    /// Clears hidden text.
    pub const hidden = escape ++ "28" ++ terminator;
    /// Clears strikethrough.
    pub const strikethrough = escape ++ "29" ++ terminator;
    /// Clears framed (and encircled).
    pub const frame = escape ++ "54" ++ terminator;
    /// Clears encircled (and framed).
    pub const encircle = escape ++ "54" ++ terminator;
    /// Clears overline.
    pub const overline = escape ++ "55" ++ terminator;
    /// Clears superscript (and subscript).
    pub const superScript = escape ++ "75" ++ terminator;
    /// Clears subscript (and superscript).
    pub const subScript = escape ++ "75" ++ terminator;
    /// Restores the terminal's default foreground colour.
    pub const foreground = escape ++ "39" ++ terminator;
    /// Restores the terminal's default background colour.
    pub const background = escape ++ "49" ++ terminator;
    /// Restores the terminal's default underline colour.
    pub const underlineColor = escape ++ "59" ++ terminator;
};

/// How much colour a terminal understands. tint.zig never detects this;
/// the caller states it explicitly.
pub const Capability = enum {
    /// No colour: every sequence degrades to the terminal default.
    none,
    /// The 16 base colours.
    ansi16,
    /// The 256-colour palette.
    ansi256,
    /// 24-bit colour.
    trueColor,
};

test "literal sequences" {
    try testing.expectEqualStrings("\x1b[31m", (try literal("31")).slice());
    try testing.expectEqualStrings("\x1b[m", (try literal("")).slice());
    try testing.expectEqualStrings("\x1b[38;5;196m", (try literal("38;5;196")).slice());
    try testing.expectError(error.TooLong, literal("11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"));
}

test "render honours the capability" {
    try testing.expectEqualStrings("\x1b[38;2;200;30;90m", render(color.rgb(200, 30, 90), .foreground, .trueColor).slice());
    try testing.expectEqualStrings("\x1b[39m", render(color.rgb(200, 30, 90), .foreground, .none).slice());
    try testing.expectEqualStrings("\x1b[49m", render(color.rgb(200, 30, 90), .background, .none).slice());
    const downgraded = render(color.rgb(255, 0, 0), .foreground, .ansi256);
    try testing.expect(std.mem.startsWith(u8, downgraded.slice(), "\x1b[38;5;"));
    try testing.expectEqualStrings("\x1b[91m", render(color.rgb(255, 0, 0), .foreground, .ansi16).slice());
}

test "indexed and trueColor sequences" {
    try testing.expectEqualStrings("\x1b[38;5;0m", indexed(.foreground, 0).slice());
    try testing.expectEqualStrings("\x1b[48;5;255m", indexed(.background, 255).slice());
    try testing.expectEqualStrings("\x1b[58;5;208m", indexed(.underline, 208).slice());
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", trueColor(.foreground, 255, 0, 0).slice());
    try testing.expectEqualStrings("\x1b[48;2;0;255;0m", trueColor(.background, 0, 255, 0).slice());
    try testing.expectEqualStrings("\x1b[58;2;1;2;3m", trueColor(.underline, 1, 2, 3).slice());
    try testing.expectEqual(@as(usize, 19), trueColor(.underline, 255, 255, 255).slice().len);
}

test "sequences are values, not shared state" {
    const first = trueColor(.foreground, 1, 2, 3);
    const second = trueColor(.foreground, 4, 5, 6);
    var third = first;
    third.bytes[0] = 'X';
    try testing.expectEqualStrings("\x1b[38;2;1;2;3m", first.slice());
    try testing.expectEqualStrings("\x1b[38;2;4;5;6m", second.slice());
    try testing.expectEqualStrings("X[38;2;1;2;3m", third.slice());
    try testing.expect(first.eql(&first));
    try testing.expect(!first.eql(&second));
}

test "withReset appends a full reset" {
    try testing.expectEqualStrings("\x1b[38;2;1;2;3m\x1b[0m", trueColor(.foreground, 1, 2, 3).withReset().slice());
    try testing.expectEqualStrings("\x1b[m\x1b[0m", (try literal("")).withReset().slice());
}

test "reset constants" {
    try testing.expectEqualStrings("\x1b[0m", reset.all);
    try testing.expectEqualStrings("\x1b[22m", reset.bold);
    try testing.expectEqualStrings("\x1b[22m", reset.dim);
    try testing.expectEqualStrings("\x1b[23m", reset.italic);
    try testing.expectEqualStrings("\x1b[23m", reset.fraktur);
    try testing.expectEqualStrings("\x1b[24m", reset.underline);
    try testing.expectEqualStrings("\x1b[25m", reset.blink);
    try testing.expectEqualStrings("\x1b[25m", reset.rapidBlink);
    try testing.expectEqualStrings("\x1b[27m", reset.reverse);
    try testing.expectEqualStrings("\x1b[28m", reset.hidden);
    try testing.expectEqualStrings("\x1b[29m", reset.strikethrough);
    try testing.expectEqualStrings("\x1b[54m", reset.frame);
    try testing.expectEqualStrings("\x1b[54m", reset.encircle);
    try testing.expectEqualStrings("\x1b[55m", reset.overline);
    try testing.expectEqualStrings("\x1b[75m", reset.superScript);
    try testing.expectEqualStrings("\x1b[75m", reset.subScript);
    try testing.expectEqualStrings("\x1b[39m", reset.foreground);
    try testing.expectEqualStrings("\x1b[49m", reset.background);
    try testing.expectEqualStrings("\x1b[59m", reset.underlineColor);
}

test {
    testing.refAllDecls(@This());
}
