# Capability Example

The same colors on four terminals. Run with `zig build run-capability`.

```zig
tint.ansi.render(color, .foreground, .trueColor);
tint.ansi.render(color, .foreground, .ansi256);
tint.ansi.render(color, .foreground, .ansi16);
tint.ansi.render(color, .foreground, .none);
```

tint.zig never reads the environment. The caller states the capability; downgrade is deterministic.
