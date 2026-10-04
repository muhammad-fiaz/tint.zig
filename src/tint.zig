//! tint.zig: terminal colour and text styling.
//!
//! tint.zig builds SGR escape sequences and hands them back. It never prints,
//! never owns a writer and never touches terminal state.

const std = @import("std");
const testing = std.testing;
const builtin = @import("builtin");

pub const ansi = @import("ansi.zig");
pub const color = @import("color.zig");
pub const palette = @import("palette.zig");
pub const style = @import("style.zig");
pub const theme = @import("theme.zig");

/// This library's version.
pub const version = "0.0.2";
/// The oldest Zig release this library builds and tests against.
pub const minimumZigVersion = "0.17.0";

comptime {
    const required = std.SemanticVersion.parse(minimumZigVersion) catch unreachable;
    if (std.SemanticVersion.order(builtin.zig_version, required) == .lt) {
        @compileError("tint.zig " ++ version ++ " needs Zig " ++ minimumZigVersion ++ " or newer");
    }
}

test "version metadata" {
    try testing.expectEqualStrings("0.0.2", version);
    try testing.expectEqualStrings("0.17.0", minimumZigVersion);
    _ = std.SemanticVersion.parse(version) catch @panic("version must parse");
}

test "namespaced rendering" {
    try testing.expectEqualStrings("\x1b[31m", color.ansi4.red.fg().slice());
    try testing.expectEqualStrings("\x1b[41m", color.ansi4.red.bg().slice());
    try testing.expectEqualStrings("\x1b[58;2;255;100;20m", color.rgb(255, 100, 20).underline().slice());
    try testing.expectEqualStrings("\x1b[38;2;255;0;0m", color.red.fg().slice());
}

test "namespaces compose like client code" {
    const errStyle = style.err(color.red);
    const title = style.bold.fg(color.hex(0x7C3AED));
    try testing.expectEqualStrings("\x1b[38;2;255;0;0;1m", errStyle.toAnsi().slice());
    try testing.expectEqualStrings("\x1b[38;2;124;58;237;1m", title.toAnsi().slice());

    const tokyo = theme.tokyoNight;
    try testing.expect(tokyo.contrast(.text, .background) > 5);

    var ramp: [8]color.Rgb = undefined;
    palette.ramp(&ramp, color.red.toRgb(), color.blue.toRgb());
    try testing.expectEqual(color.red.toRgb(), ramp[0]);
    try testing.expectEqual(color.blue.toRgb(), ramp[7]);
}

test {
    testing.refAllDecls(@This());
    testing.refAllDecls(ansi);
    testing.refAllDecls(color);
    testing.refAllDecls(palette);
    testing.refAllDecls(style);
    testing.refAllDecls(theme);
}
