# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in tint.zig, please report it responsibly.

**Email:** contact@muhammadfiaz.com

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## Response

- Acknowledgment within 48 hours
- Assessment within 1 week
- Fix and release timeline communicated promptly

## Scope

tint.zig is a terminal color and styling library. It constructs ANSI escape sequences and does not:
- Handle network connections
- Process untrusted input beyond color values
- Access the filesystem
- Execute system commands

## Best Practices

When using tint.zig in your project:
- Never embed secrets in color values
- Validate user-provided color inputs
- Use compile-time constants where possible

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.0.1   | Yes       |

Always use the latest version of tint.zig.
