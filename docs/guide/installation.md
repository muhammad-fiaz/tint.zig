# Installation

## Prerequisites

Before using `tint.zig`, ensure you have the following:

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Zig** | **0.16.0** (recommended) | Download from [ziglang.org](https://ziglang.org/download/) |
| **Operating System** | Windows 10+, Linux, macOS, FreeBSD | Cross-platform support |

---

## Installation Methods

### Method 1: Zig Fetch (Recommended)

**Stable Release (v0.0.1):**

```bash
zig fetch --save https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz
```

**Development Branch:**

```bash
zig fetch --save git+https://github.com/muhammad-fiaz/tint.zig.git
```

### Method 2: Manual `build.zig.zon` Configuration

Add the dependency to your `build.zig.zon` file.

**Stable Release:**

```zig
.dependencies = .{
    .tint = .{
        .url = "https://github.com/muhammad-fiaz/tint.zig/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

**Development Branch:**

```zig
.dependencies = .{
    .tint = .{
        .url = "git+https://github.com/muhammad-fiaz/tint.zig.git",
        .hash = "...", // Run `zig fetch --save <url>` to generate the hash.
    },
},
```

### Method 3: Local Source Checkout

Clone the repository locally.

```bash
git clone https://github.com/muhammad-fiaz/tint.zig.git
cd tint.zig
zig build
```

To use a local checkout from another project, add a path dependency to your `build.zig.zon`:

```zig
.dependencies = .{
    .tint = .{
        .path = "../tint.zig",
    },
},
```

---

## Configure build.zig

Then add it to your `build.zig`:

```zig
const tint_dep = b.dependency("tint", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("tint", tint_dep.module("tint"));
```

---

## Supported Platforms

`tint.zig` is validated on these architectures:

| Platform | x86_64 (64-bit) | aarch64 (ARM64) |
|----------|-----------------|-----------------|
| **Linux** | Yes | Yes |
| **Windows** | Yes | Yes |
| **macOS** | Yes | Yes (Apple Silicon) |
| **FreeBSD** | Yes | Yes |

### Cross-Compilation

Zig makes cross-compilation easy. Build for any target from any host:

```bash
# Build for Linux ARM64 from Windows
zig build -Dtarget=aarch64-linux

# Build for Windows from Linux
zig build -Dtarget=x86_64-windows

# Build for macOS Apple Silicon from Linux
zig build -Dtarget=aarch64-macos
```

---

## Validation

```bash
# Run all tests
zig build test

# Format source files
zig build fmt

# Run all examples
zig build run-all-examples
```
