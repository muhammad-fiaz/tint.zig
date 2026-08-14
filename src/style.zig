const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const Color = color.Color;

const NUM_STYLE_BUFS = 4;
threadlocal var style_bufs: [NUM_STYLE_BUFS][256]u8 = undefined;
threadlocal var style_buf_idx: usize = 0;

fn nextStyleBuf() *[256]u8 {
    const b = &style_bufs[style_buf_idx % NUM_STYLE_BUFS];
    style_buf_idx +%= 1;
    return b;
}

pub const StyleOptions = struct {
    fg: ?Color = null,
    bg: ?Color = null,
    underline_color: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
    fraktur: bool = false,
    frame: bool = false,
    encircle: bool = false,
    rapid_blink: bool = false,
    super_script: bool = false,
    sub_script: bool = false,
};

pub const Style = struct {
    fg: ?Color = null,
    bg: ?Color = null,
    underline_color: ?Color = null,
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    strikethrough: bool = false,
    overline: bool = false,
    fraktur: bool = false,
    frame: bool = false,
    encircle: bool = false,
    rapid_blink: bool = false,
    super_script: bool = false,
    sub_script: bool = false,

    pub fn init(opts: StyleOptions) Style {
        return .{
            .fg = opts.fg,
            .bg = opts.bg,
            .underline_color = opts.underline_color,
            .bold = opts.bold,
            .dim = opts.dim,
            .italic = opts.italic,
            .underline = opts.underline,
            .blink = opts.blink,
            .reverse = opts.reverse,
            .hidden = opts.hidden,
            .strikethrough = opts.strikethrough,
            .overline = opts.overline,
            .fraktur = opts.fraktur,
            .frame = opts.frame,
            .encircle = opts.encircle,
            .rapid_blink = opts.rapid_blink,
            .super_script = opts.super_script,
            .sub_script = opts.sub_script,
        };
    }

    pub fn with(self: Style, opts: StyleOptions) Style {
        return .{
            .fg = if (opts.fg) |f| f else self.fg,
            .bg = if (opts.bg) |b| b else self.bg,
            .underline_color = if (opts.underline_color) |u| u else self.underline_color,
            .bold = self.bold or opts.bold,
            .dim = self.dim or opts.dim,
            .italic = self.italic or opts.italic,
            .underline = self.underline or opts.underline,
            .blink = self.blink or opts.blink,
            .reverse = self.reverse or opts.reverse,
            .hidden = self.hidden or opts.hidden,
            .strikethrough = self.strikethrough or opts.strikethrough,
            .overline = self.overline or opts.overline,
            .fraktur = self.fraktur or opts.fraktur,
            .frame = self.frame or opts.frame,
            .encircle = self.encircle or opts.encircle,
            .rapid_blink = self.rapid_blink or opts.rapid_blink,
            .super_script = self.super_script or opts.super_script,
            .sub_script = self.sub_script or opts.sub_script,
        };
    }

    pub fn withFg(self: Style, c: Color) Style {
        return .{
            .fg = c,
            .bg = self.bg,
            .underline_color = self.underline_color,
            .bold = self.bold,
            .dim = self.dim,
            .italic = self.italic,
            .underline = self.underline,
            .blink = self.blink,
            .reverse = self.reverse,
            .hidden = self.hidden,
            .strikethrough = self.strikethrough,
            .overline = self.overline,
            .fraktur = self.fraktur,
            .frame = self.frame,
            .encircle = self.encircle,
            .rapid_blink = self.rapid_blink,
            .super_script = self.super_script,
            .sub_script = self.sub_script,
        };
    }

    pub fn withBg(self: Style, c: Color) Style {
        return .{
            .fg = self.fg,
            .bg = c,
            .underline_color = self.underline_color,
            .bold = self.bold,
            .dim = self.dim,
            .italic = self.italic,
            .underline = self.underline,
            .blink = self.blink,
            .reverse = self.reverse,
            .hidden = self.hidden,
            .strikethrough = self.strikethrough,
            .overline = self.overline,
            .fraktur = self.fraktur,
            .frame = self.frame,
            .encircle = self.encircle,
            .rapid_blink = self.rapid_blink,
            .super_script = self.super_script,
            .sub_script = self.sub_script,
        };
    }

    pub fn withUnderline(self: Style, c: Color) Style {
        return .{
            .fg = self.fg,
            .bg = self.bg,
            .underline_color = c,
            .bold = self.bold,
            .dim = self.dim,
            .italic = self.italic,
            .underline = self.underline,
            .blink = self.blink,
            .reverse = self.reverse,
            .hidden = self.hidden,
            .strikethrough = self.strikethrough,
            .overline = self.overline,
            .fraktur = self.fraktur,
            .frame = self.frame,
            .encircle = self.encircle,
            .rapid_blink = self.rapid_blink,
            .super_script = self.super_script,
            .sub_script = self.sub_script,
        };
    }

    pub fn compose(a: Style, b: Style) Style {
        return .{
            .fg = if (b.fg) |f| f else a.fg,
            .bg = if (b.bg) |bg| bg else a.bg,
            .underline_color = if (b.underline_color) |u| u else a.underline_color,
            .bold = a.bold or b.bold,
            .dim = a.dim or b.dim,
            .italic = a.italic or b.italic,
            .underline = a.underline or b.underline,
            .blink = a.blink or b.blink,
            .reverse = a.reverse or b.reverse,
            .hidden = a.hidden or b.hidden,
            .strikethrough = a.strikethrough or b.strikethrough,
            .overline = a.overline or b.overline,
            .fraktur = a.fraktur or b.fraktur,
            .frame = a.frame or b.frame,
            .encircle = a.encircle or b.encircle,
            .rapid_blink = a.rapid_blink or b.rapid_blink,
            .super_script = a.super_script or b.super_script,
            .sub_script = a.sub_script or b.sub_script,
        };
    }

    pub fn toAnsi(self: Style) []const u8 {
        const buf_ptr = nextStyleBuf();
        var pos: usize = 0;

        const write_str = struct {
            fn write(b: []u8, p: *usize, s: []const u8) void {
                for (s) |c| {
                    if (p.* < b.len) {
                        b[p.*] = c;
                        p.* += 1;
                    }
                }
            }
        };

        write_str.write(buf_ptr, &pos, "\x1b[");

        var first = true;

        if (self.fg) |f| {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            const fg_str = f.toFg();
            write_str.write(buf_ptr, &pos, fg_str[2 .. fg_str.len - 1]);
        }

        if (self.bg) |b| {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            const bg_str = b.toBg();
            write_str.write(buf_ptr, &pos, bg_str[2 .. bg_str.len - 1]);
        }

        if (self.underline_color) |u| {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            const u_str = u.toUnderline();
            write_str.write(buf_ptr, &pos, u_str[2 .. u_str.len - 1]);
        }

        if (self.bold) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "1");
        }

        if (self.dim) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "2");
        }

        if (self.italic) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "3");
        }

        if (self.underline) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "4");
        }

        if (self.blink) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "5");
        }

        if (self.rapid_blink) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "6");
        }

        if (self.reverse) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "7");
        }

        if (self.hidden) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "8");
        }

        if (self.strikethrough) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "9");
        }

        if (self.super_script) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "73");
        }

        if (self.sub_script) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "74");
        }

        if (self.fraktur) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "20");
        }

        if (self.overline) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "53");
        }

        if (self.frame) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "51");
        }

        if (self.encircle) {
            if (!first) write_str.write(buf_ptr, &pos, ";");
            first = false;
            write_str.write(buf_ptr, &pos, "52");
        }

        write_str.write(buf_ptr, &pos, "m");

        return buf_ptr[0..pos];
    }
};

pub const presets = struct {
    pub fn err_style(fg: Color) Style {
        return Style.init(.{ .fg = fg, .bold = true });
    }

    pub fn warning(fg: Color) Style {
        return Style.init(.{ .fg = fg, .bold = true });
    }

    pub fn success(fg: Color) Style {
        return Style.init(.{ .fg = fg, .bold = true });
    }

    pub fn info(fg: Color) Style {
        return Style.init(.{ .fg = fg });
    }

    pub fn debug(fg: Color) Style {
        return Style.init(.{ .fg = fg, .dim = true });
    }

    pub fn link(fg: Color) Style {
        return Style.init(.{ .fg = fg, .underline = true });
    }

    pub fn code(fg: Color, bg: Color) Style {
        return Style.init(.{ .fg = fg, .bg = bg });
    }

    pub fn header(fg: Color) Style {
        return Style.init(.{ .fg = fg, .bold = true, .underline = true });
    }

    pub fn muted(fg: Color) Style {
        return Style.init(.{ .fg = fg, .dim = true });
    }

    pub fn highlight(fg: Color, bg: Color) Style {
        return Style.init(.{ .fg = fg, .bg = bg, .bold = true });
    }

    pub fn strikethrough_text(fg: Color) Style {
        return Style.init(.{ .fg = fg, .strikethrough = true });
    }

    pub fn blink_text(fg: Color) Style {
        return Style.init(.{ .fg = fg, .blink = true });
    }

    pub fn reverse_text(fg: Color) Style {
        return Style.init(.{ .fg = fg, .reverse = true });
    }

    pub fn hidden_text(fg: Color) Style {
        return Style.init(.{ .fg = fg, .hidden = true });
    }

    pub fn overlined(fg: Color) Style {
        return Style.init(.{ .fg = fg, .overline = true });
    }

    pub fn framed(fg: Color) Style {
        return Style.init(.{ .fg = fg, .frame = true });
    }

    pub fn encircled(fg: Color) Style {
        return Style.init(.{ .fg = fg, .encircle = true });
    }
};

test "Style init" {
    const s = Style.init(.{ .bold = true });
    try testing.expect(s.bold);
    try testing.expect(!s.italic);
}

test "Style with" {
    const base = Style.init(.{ .bold = true });
    const ext = base.with(.{ .underline = true });
    try testing.expect(ext.bold);
    try testing.expect(ext.underline);
    try testing.expect(!ext.italic);
}

test "Style toAnsi" {
    const s = Style.init(.{ .fg = .{ .ansi4 = .red }, .bold = true });
    const ansi = s.toAnsi();
    try testing.expect(ansi.len > 0);
}

test "Style toAnsi with bg" {
    const s = Style.init(.{ .fg = .{ .ansi4 = .red }, .bg = .{ .ansi4 = .blue } });
    const ansi = s.toAnsi();
    try testing.expect(ansi.len > 0);
}

test "Style withFg" {
    const s = Style.init(.{ .bold = true });
    const s2 = s.withFg(.{ .ansi4 = .red });
    try testing.expect(s2.bold);
    try testing.expectEqual(@as(?Color, .{ .ansi4 = .red }), s2.fg);
}

test "Style withBg" {
    const s = Style.init(.{ .bold = true });
    const s2 = s.withBg(.{ .ansi4 = .blue });
    try testing.expect(s2.bold);
    try testing.expectEqual(@as(?Color, .{ .ansi4 = .blue }), s2.bg);
}

test "Style withUnderline" {
    const s = Style.init(.{ .bold = true });
    const s2 = s.withUnderline(.{ .ansi4 = .green });
    try testing.expect(s2.bold);
    try testing.expectEqual(@as(?Color, .{ .ansi4 = .green }), s2.underline_color);
}

test "Style compose" {
    const s1 = Style.init(.{ .bold = true, .fg = .{ .ansi4 = .red } });
    const s2 = Style.init(.{ .italic = true, .bg = .{ .ansi4 = .blue } });
    const composed = Style.compose(s1, s2);
    try testing.expect(composed.bold);
    try testing.expect(composed.italic);
    try testing.expectEqual(@as(?Color, .{ .ansi4 = .blue }), composed.bg);
}

test "Style presets" {
    _ = presets.err_style(.{ .ansi4 = .red });
    _ = presets.warning(.{ .ansi4 = .yellow });
    _ = presets.success(.{ .ansi4 = .green });
    _ = presets.info(.{ .ansi4 = .cyan });
    _ = presets.debug(.{ .ansi4 = .bright_black });
    _ = presets.link(.{ .ansi4 = .blue });
    _ = presets.code(.{ .ansi4 = .white }, .{ .ansi4 = .black });
    _ = presets.header(.{ .ansi4 = .bright_white });
    _ = presets.muted(.{ .ansi4 = .bright_black });
    _ = presets.highlight(.{ .ansi4 = .black }, .{ .ansi4 = .yellow });
    _ = presets.strikethrough_text(.{ .ansi4 = .red });
    _ = presets.blink_text(.{ .ansi4 = .yellow });
    _ = presets.reverse_text(.{ .ansi4 = .cyan });
    _ = presets.hidden_text(.{ .ansi4 = .white });
    _ = presets.overlined(.{ .ansi4 = .green });
    _ = presets.framed(.{ .ansi4 = .blue });
    _ = presets.encircled(.{ .ansi4 = .magenta });
}

test "Style with new attributes" {
    const s = Style.init(.{
        .fraktur = true,
        .frame = true,
        .encircle = true,
        .rapid_blink = true,
        .super_script = true,
        .sub_script = true,
    });
    try testing.expect(s.fraktur);
    try testing.expect(s.frame);
    try testing.expect(s.encircle);
    try testing.expect(s.rapid_blink);
    try testing.expect(s.super_script);
    try testing.expect(s.sub_script);
}
