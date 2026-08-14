const std = @import("std");
const testing = std.testing;
const color = @import("color.zig");
const Color = color.Color;

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
        };
    }

    pub fn toAnsi(self: Style) []const u8 {
        var buf: [128]u8 = undefined;
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

        write_str.write(&buf, &pos, "\x1b[");

        var first = true;

        if (self.fg) |f| {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            const fg_str = f.toFg();
            write_str.write(&buf, &pos, fg_str[2 .. fg_str.len - 1]);
        }

        if (self.bg) |b| {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            const bg_str = b.toBg();
            write_str.write(&buf, &pos, bg_str[2 .. bg_str.len - 1]);
        }

        if (self.underline_color) |u| {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            const u_str = u.toUnderline();
            write_str.write(&buf, &pos, u_str[2 .. u_str.len - 1]);
        }

        if (self.bold) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "1");
        }

        if (self.dim) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "2");
        }

        if (self.italic) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "3");
        }

        if (self.underline) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "4");
        }

        if (self.blink) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "5");
        }

        if (self.reverse) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "7");
        }

        if (self.hidden) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "8");
        }

        if (self.strikethrough) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "9");
        }

        if (self.overline) {
            if (!first) write_str.write(&buf, &pos, ";");
            first = false;
            write_str.write(&buf, &pos, "53");
        }

        write_str.write(&buf, &pos, "m");

        return buf[0..pos];
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
