# Contributing to tint.zig

Thank you for your interest in contributing to tint.zig!

## Requirements

- Zig 0.17.0 or later
- No external dependencies

## Development

### Building

```bash
zig build
```

### Running Tests

```bash
zig build test
```

### Formatting

```bash
zig fmt .
```

Check formatting without rewriting:

```bash
zig fmt --check .
```

### Running Examples

```bash
zig build run-basic
zig build run-complete
zig build run-all-examples
```

### Cross-Compilation

The library is pure Zig with no OS-specific code. Verify a target builds:

```bash
zig build -Dtarget=aarch64-linux
zig build -Dtarget=x86_64-windows
zig build -Dtarget=aarch64-macos
```

## Code Quality

- Follow existing code style and naming (camelCase public API)
- Add tests for new features at the bottom of the relevant source file
- Update documentation and examples for API changes
- Keep the library zero-dependency and allocation-free
- Do not introduce global mutable state

## Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `zig fmt`, `zig build` and `zig build test`
5. Submit a pull request

## Issues

Report issues at [GitHub Issues](https://github.com/muhammad-fiaz/tint.zig/issues).

For security issues, see [SECURITY.md](SECURITY.md) and report privately.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
