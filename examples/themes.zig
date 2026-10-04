const std = @import("std");
const tint = @import("tint");

pub fn main() void {
    const reset = tint.ansi.reset.all;

    std.debug.print("=== Every built-in theme ===\n\n", .{});
    for (tint.theme.all) |theme| {
        std.debug.print("  {s}\n", .{theme.name});
        for ([_]tint.theme.Role{ .primary, .secondary, .success, .warning, .err, .info }) |role| {
            std.debug.print("    {s}## {s:<10}{s} contrast {d:>5.2}\n", .{
                theme.role(role).fg().slice(),     @tagName(role), reset,
                theme.contrast(role, .background),
            });
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("=== A custom theme ===\n", .{});
    const custom = tint.theme.Theme.create("custom", .{
        .primary = tint.color.hex(0x6366F1),
        .secondary = tint.color.hex(0x8B5CF6),
        .success = tint.color.hex(0x10B981),
        .warning = tint.color.hex(0xF59E0B),
        .err = tint.color.hex(0xEF4444),
        .info = tint.color.hex(0x3B82F6),
        .text = tint.color.hex(0xE5E7EB),
        .muted = tint.color.hex(0x6B7280),
        .background = tint.color.hex(0x1F2937),
        .surface = tint.color.hex(0x374151),
    });
    std.debug.print("{s}## custom primary{s}\n", .{ custom.role(.primary).fg().slice(), reset });
    std.debug.print("{s}## custom err{s}\n", .{ custom.role(.err).fg().slice(), reset });

    std.debug.print("\n=== Themes as message styles ===\n", .{});
    for ([_]tint.theme.Theme{ tint.theme.tokyoNight, tint.theme.dracula }) |theme| {
        const errStyle = theme.styled(.err).merge(tint.style.bold);
        std.debug.print("{s}error in {s}{s}\n", .{ errStyle.toAnsi().slice(), theme.name, reset });
        std.debug.print("{s}muted in {s}{s}\n", .{
            theme.styled(.muted).toAnsi().slice(), theme.name, reset,
        });
    }

    std.debug.print("\n=== Readability grades ===\n", .{});
    for ([_]tint.theme.Theme{ tint.theme.dark, tint.theme.light }) |theme| {
        std.debug.print("  {s}: text={s} muted={s} err={s}\n", .{
            theme.name,
            @tagName(theme.readability(.text, .background)),
            @tagName(theme.readability(.muted, .background)),
            @tagName(theme.readability(.err, .background)),
        });
    }
}
