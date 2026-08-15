---
layout: home
title: tint.zig
titleTemplate: Color and Styling Library for Zig

hero:
  name: tint.zig
  text: Color and Styling Library for Zig
  tagline: "A fast, minimal, zero dependency terminal color and text styling library for Zig 0.16.0+. Supports ANSI, bright ANSI, 256-color, RGB, HEX, HSL, HSV, CMYK, LAB, XYZ, palettes, themes, and composable styles."
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
  - icon: 
    title: Complete Color Support
    details: "ANSI 4-bit, bright ANSI, 256-color, RGB/TrueColor, HEX, HSL, HSV, CMYK, CIE XYZ, CIE Lab, and 140+ CSS/X11 named colors."
  - icon: 
    title: Explicit Styling
    details: "Bold, italic, underline, strikethrough, overline, fraktur, frame, encircle, rapid blink, super/subscript. Individual reset codes for fine-grained control."
  - icon: 
    title: Composable Themes
    details: "17 built-in themes (dark, light, dracula, nord, monokai, tokyo_night, gruvbox, solarized, rose_pine, catppuccin, github, one_dark, material, palenight, everforest, kanagawa, cyberdream). Create custom themes with Theme.init()."
  - icon: 
    title: Color Conversion
    details: "Convert between RGB, HEX, ANSI 256, HSL, HSV, CMYK, CIE XYZ, and CIE Lab. Color distance, contrast ratio, and nearest ANSI 256 approximation."
  - icon: 
    title: Color Manipulation
    details: "Lighten, darken, saturate, desaturate, invert, grayscale, mix, rotate, adjust hue. Color harmony: complementary, analogous, triadic, split-complementary, tetradic, monochromatic."
  - icon: 
    title: Color Palettes
    details: "ANSI 16, ANSI 88, ANSI 256, RGB6 cube, grayscale ramp, color ramps, color wheel, warm/cool/earth/pastel/neon palette subsets."
  - icon: 
    title: Zero Dependencies
    details: "Pure Zig with no external dependencies. Minimal overhead, compile-time constants, efficient runtime construction. Cross-platform: Windows, Linux, macOS, FreeBSD."
  - icon: 
    title: Client-Owned Output
    details: "The library constructs ANSI codes and returns them. Your application owns all output and I/O. Never prints to stdout/stderr."
---