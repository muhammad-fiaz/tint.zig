---
layout: home
title: Terminal Colors, Styles & Themes for Zig
titleTemplate: :title | tint.zig
description: "tint.zig is a fast, minimal, zero-dependency terminal color and text styling library for Zig 0.17.0. Colors as values, composable styles, palettes, themes, allocation-free ANSI."
keywords: "tint.zig, zig terminal colors, text styling, ansi, palettes, themes, rgb, truecolor"
hero:
  name: tint.zig
  text: Color and Styling Library for Zig
  tagline: "A fast, minimal, zero-dependency terminal color and text styling library for Zig 0.17.0. Colors as values, composable styles, palettes, themes, and allocation-free ANSI sequences."
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
    title: Colors as Values
    details: "ANSI 4-bit, ANSI 88, ANSI 256, RGB, HEX, HSL, HSV, CMYK, XYZ, Lab, LCh, OKLab, OKLCH, Kelvin, and 148 named colors. Any space converts to any other."
  - icon:
    title: Explicit Styling
    details: "Bold, dim, italic, underline, blink, reverse, hidden, strikethrough, overline, fraktur, frame, encircle, super/subscript. Merge, override, and subtract styles."
  - icon:
    title: Composable Themes
    details: "17 built-in themes with semantic roles and contrast validation. Select explicitly; no global state."
  - icon:
    title: Color Science
    details: "WCAG contrast, CIE76/94/2000 and OKLab distance, perceptual interpolation with explicit hue paths, OKLab quantization."
  - icon:
    title: Palettes
    details: "xterm-faithful tables, caller-owned ramps, gradients, sequential, diverging and categorical schemes, harmony buffers, readability checks."
  - icon:
    title: Capabilities
    details: "Render for none, ansi16, ansi256 or trueColor. Deterministic downgrade; nothing is ever auto-detected."
  - icon:
    title: Zero Dependencies
    details: "Pure Zig. Value-returned sequences, caller-owned buffers, no thread-local state, no allocation."
  - icon:
    title: Client-Owned Output
    details: "The library builds escape sequences and hands them back. Your application owns all output and I/O."
---
