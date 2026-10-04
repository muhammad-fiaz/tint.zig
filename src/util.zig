//! Shared scalar helpers for the colour math in `color.zig` and `palette.zig`.

const std = @import("std");
const testing = std.testing;

/// Clamps a floating point channel to `0...255` and rounds to nearest.
pub fn channel(value: f64) u8 {
    return @intFromFloat(@round(std.math.clamp(value, 0, 255)));
}

/// Linear blend of two integers at `t` in `0.0...1.0`.
pub fn mixInt(from: u8, to: u8, t: f64) u8 {
    const a: f64 = @floatFromInt(from);
    const b: f64 = @floatFromInt(to);
    return channel(a * (1.0 - t) + b * t);
}

/// Linear blend of two floats at `t`.
pub fn mixFloat(from: f64, to: f64, t: f64) f64 {
    return from * (1.0 - t) + to * t;
}

/// Wraps a hue angle into `0...360`.
pub fn wrapHue(hue: f64) f64 {
    return @mod(hue, 360.0);
}

test "channel clamps and rounds" {
    try testing.expectEqual(@as(u8, 0), channel(-1));
    try testing.expectEqual(@as(u8, 0), channel(0));
    try testing.expectEqual(@as(u8, 128), channel(127.9));
    try testing.expectEqual(@as(u8, 128), channel(127.5));
    try testing.expectEqual(@as(u8, 127), channel(127.4));
    try testing.expectEqual(@as(u8, 255), channel(255));
    try testing.expectEqual(@as(u8, 255), channel(1000));
}

test "mixing" {
    try testing.expectEqual(@as(u8, 0), mixInt(0, 255, 0));
    try testing.expectEqual(@as(u8, 255), mixInt(0, 255, 1));
    try testing.expectEqual(@as(u8, 128), mixInt(0, 255, 0.5));
    try testing.expectApproxEqAbs(@as(f64, 25), mixFloat(0, 100, 0.25), 0.0001);
}

test "hue wrapping" {
    try testing.expectApproxEqAbs(@as(f64, 10), wrapHue(370), 0.0001);
    try testing.expectApproxEqAbs(@as(f64, 350), wrapHue(-10), 0.0001);
    try testing.expectApproxEqAbs(@as(f64, 0), wrapHue(360), 0.0001);
}
