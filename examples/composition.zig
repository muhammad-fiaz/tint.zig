const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    // Style composition
    std.debug.print("=== Style Composition ===\n", .{});

    // Base style
    const error_style = tint.style(.{
        .fg = tint.hex(0xEF4444),
        .bold = true,
    });

    // Extended style
    const warning_style = error_style.with(.{
        .fg = tint.hex(0xF59E0B),
        .underline = true,
    });

    // Another style
    const info_style = tint.style(.{
        .fg = tint.hex(0x3B82F6),
        .italic = true,
    });

    std.debug.print("{s}Error message{s}\n", .{ error_style.toAnsi(), tint.reset });
    std.debug.print("{s}Warning message{s}\n", .{ warning_style.toAnsi(), tint.reset });
    std.debug.print("{s}Info message{s}\n", .{ info_style.toAnsi(), tint.reset });

    // Complex styles
    std.debug.print("\n=== Complex Styles ===\n", .{});
    const title_style = tint.style(.{
        .fg = tint.hex(0x7C3AED),
        .bold = true,
        .underline = true,
    });

    const code_style = tint.style(.{
        .fg = tint.hex(0x22C55E),
        .bg = tint.hex(0x1a1a2e),
    });

    std.debug.print("{s}Section Title{s}\n", .{ title_style.toAnsi(), tint.reset });
    std.debug.print("{s}const x = 42;{s}\n", .{ code_style.toAnsi(), tint.reset });
}
