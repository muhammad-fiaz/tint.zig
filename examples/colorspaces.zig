const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Construction ===\n", .{});
    const samples = .{
        tint.color.rgb(255, 100, 20),
        tint.color.hex(0xFF6600),
        tint.color.hsl(24, 100, 53),
        tint.color.hsv(24, 100, 100),
        tint.color.cmyk(0, 60, 100, 0),
        tint.color.kelvin(2700),
        tint.color.rebeccaPurple,
    };
    inline for (samples) |c| {
        std.debug.print("{s}##{s} #{s}\n", .{ c.fg().slice(), reset, c.toRgb().toString() });
    }

    std.debug.print("\n=== Any space to any space ===\n", .{});
    const source = tint.color.hex(0xFF6600);
    std.debug.print("rgb  {d}, {d}, {d}\n", .{ source.toRgb().r, source.toRgb().g, source.toRgb().b });
    std.debug.print("hex  #{x:0>6}\n", .{source.toHex().value});
    std.debug.print("hsl  {d}, {d}, {d}\n", .{ source.toHsl().h, source.toHsl().s, source.toHsl().l });
    std.debug.print("hsv  {d}, {d}, {d}\n", .{ source.toHsv().h, source.toHsv().s, source.toHsv().v });
    std.debug.print("cmyk {d}, {d}, {d}, {d}\n", .{
        source.toCmyk().c, source.toCmyk().m, source.toCmyk().y, source.toCmyk().k,
    });
    const xyz = source.toXyz();
    std.debug.print("xyz  {d:.4}, {d:.4}, {d:.4}\n", .{ xyz.x, xyz.y, xyz.z });
    const lab = source.toLab();
    std.debug.print("lab  {d:.2}, {d:.2}, {d:.2}\n", .{ lab.l, lab.a, lab.b });
    const lch = source.toLch();
    std.debug.print("lch  {d:.2}, {d:.2}, {d:.2}\n", .{ lch.l, lch.c, lch.h });
    const oklab = source.toOklab();
    std.debug.print("oklab {d:.4}, {d:.4}, {d:.4}\n", .{ oklab.l, oklab.a, oklab.b });
    const oklch = source.toOklch();
    std.debug.print("oklch {d:.4}, {d:.4}, {d:.2}\n", .{ oklch.l, oklch.c, oklch.h });

    std.debug.print("\n=== Parsing strings ===\n", .{});
    const texts = .{ "#FF6600", "0xFF6600", "#F60", "rebeccaPurple", "REBECCA_PURPLE", "navy" };
    inline for (texts) |text| {
        if (tint.color.parse(text)) |c| {
            std.debug.print("{s}##{s} {s:<16} -> #{s}\n", .{ c.fg().slice(), reset, text, c.toRgb().toString() });
        } else {
            std.debug.print("   {s:<16} -> invalid\n", .{text});
        }
    }

    std.debug.print("\n=== Hex with alpha ===\n", .{});
    for ([_][]const u8{ "#FF660080", "#F608", "#FF6600" }) |text| {
        const parsed = tint.color.Hex.parse(text) catch continue;
        const opacity = tint.color.Hex.opacity(text) catch continue;
        const c = tint.color.fromHex(parsed);
        std.debug.print("{s}##{s} {s:<10} opacity {d}\n", .{
            c.fg().slice(), reset, text, opacity,
        });
    }
}
