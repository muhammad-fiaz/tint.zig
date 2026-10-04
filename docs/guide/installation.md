---
title: Installation
description: "Install tint.zig 0.0.2 with zig fetch, manual build.zig.zon config, or a local checkout. Requires Zig 0.17.0."
keywords: "install tint.zig, zig fetch dependency, build.zig.zon, zig 0.17.0 setup"
---

# Installation

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Zig** | **0.17.0** | Download from [ziglang.org](https://ziglang.org/download/) |
| **Operating System** | Windows 10+, Linux, macOS, FreeBSD | No OS-specific code |

`tint.zig` 0.0.2 requires Zig 0.17.0 or newer and fails to compile on older toolchains. The previous stable release, 0.0.1, targeted Zig 0.16.0.

---

## Method 1: Zig Fetch (Recommended)

**Stable release (0.0.2):**

```bash
zig fetch --save https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/0.0.2.tar.gz
```

**Development branch:**

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig.git
```

## Method 2: Manual `build.zig.zon` Configuration

**Stable release:**

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/0.0.2.tar.gz",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

**Development branch:**

```zig
.dependencies = .{
    .tint = .{
        .url = "git+https://github.com/muhammad-fiaz/tint.zig.git",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

## Method 3: Local Source Checkout

```bash
git clone https://github.com/muhammad-fiaz/tint.zig.git
cd tint.zig
zig build
```

```zig
.dependencies = .{
    .tint = .{
        .path = "../tint.zig",
    },
},
```

---

## Configure build.zig

```zig
const tint_dep = b.dependency("tint", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("tint", tint_dep.module("tint"));
```

---

## Supported Platforms

| Platform | x86_64 | aarch64 | x86 |
|----------|--------|---------|-----|
| **Linux** | Yes | Yes | Yes |
| **Windows** | Yes | Yes | Yes |
| **macOS** | Yes | Yes (Apple Silicon) | — |
| **FreeBSD** | Yes | Yes | Yes |

### Cross-Compilation

```bash
zig build -Dtarget=aarch64-linux
zig build -Dtarget=x86_64-windows
zig build -Dtarget=aarch64-macos
zig build -Dtarget=x86-windows
```

---

## Validation

```bash
zig build test
zig build
zig fmt --check .
zig build run-all-examples
```
