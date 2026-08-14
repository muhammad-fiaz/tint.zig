# Installation

## Method 1: zig fetch (Recommended)

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig
```

## Method 2: zig fetch with git tag

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig#v0.0.1
```

## Method 3: Manual build.zig.zon

Add tint.zig as a dependency in your `build.zig.zon`:

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...",
    },
},
```

## Method 4: Local clone

```bash
git clone https://github.com/muhammad-fiaz/tint.zig.git
```

Then reference the local path in your `build.zig.zon`:

```zig
.dependencies = .{
    .tint = .{
        .path = "../tint.zig",
    },
},
```

## Wire it into your build.zig

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "my_app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tint = b.dependency("tint", .{});
    exe.root_module.addImport("tint", tint.module("tint"));

    b.installArtifact(exe);
}
```

## Requirements

- Zig 0.16.0 or later
- No external dependencies
