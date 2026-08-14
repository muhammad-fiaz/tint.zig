---
layout: home
title: tint.zig
titleTemplate: Terminal Color and Styling Library for Zig

hero:
  name: tint.zig
  text: Terminal Color and Styling Library for Zig
  tagline: A comprehensive, explicit terminal color and text styling library supporting ANSI, bright ANSI, 256-color, RGB, HEX, palettes, themes, and composable styles.
  image:
    src: /android-chrome-512x512.png
    alt: tint.zig
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: API Reference
      link: /api/
    - theme: alt
      text: GitHub
      link: https://github.com/muhammad-fiaz/tint.zig

features:
  - icon: 🎨
    title: Complete Color Support
    details: ANSI 4-bit, bright ANSI, 256-color, RGB/TrueColor, HEX, HSL, HSV — all in one unified API.
  - icon: ✨
    title: Explicit Styling
    details: Bold, italic, underline, strikethrough, overline, and more. Individual reset codes for fine-grained control.
  - icon: 🎭
    title: Composable Themes
    details: Create, compose, and switch themes explicitly. No global state, no auto-detection — you decide.
  - icon: 🔄
    title: Color Conversion
    details: Convert between RGB, HEX, ANSI 256, HSL, and HSV. Approximate conversions are clearly documented.
  - icon: 📦
    title: Zero Dependencies
    details: Pure Zig with no external dependencies. Minimal overhead, compile-time constants, efficient runtime construction.
  - icon: 🖼️
    title: Client-Owned Output
    details: The library constructs ANSI codes and returns them. Your application owns all output and I/O.
---
