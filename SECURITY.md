# Security Policy

## Supported Versions

Security fixes are applied to actively supported releases of `tint.zig`.

| Version | Supported          |
| ------- | ------------------ |
| 0.0.2   | Yes                |
| 0.0.1   | No                 |

`tint.zig` 0.0.2 targets Zig 0.17.0. Users should upgrade to the latest supported release to receive available security fixes and important correctness improvements.

Older releases may depend on previous Zig versions and are not guaranteed to receive security fixes.

## Reporting a Vulnerability

If you discover a security vulnerability in `tint.zig`, please report it privately rather than opening a public issue.

**Email:** contact@muhammadfiaz.com

Include:

- A clear description of the vulnerability
- The affected version
- The Zig version used
- Steps to reproduce the issue
- A minimal reproduction case, if available
- The expected and actual behavior
- Any relevant platform or target information

Please avoid including sensitive information that is not necessary to reproduce or understand the vulnerability.

## Disclosure Process

Security reports will be reviewed and investigated as soon as reasonably possible.

When a vulnerability is confirmed, the project may:

1. Investigate and reproduce the issue.
2. Determine the affected versions and severity.
3. Develop and test a fix.
4. Release an updated version when appropriate.
5. Document the security impact and required upgrade steps.

Public disclosure should be coordinated with the project maintainers so users have an opportunity to update before details are broadly published.

## Security Considerations

`tint.zig` is a zero-dependency terminal color and text styling library. It constructs ANSI/SGR escape sequences and returns them to the caller. The library does not own application output, write to stdout or stderr, modify terminal state, or automatically detect terminal capabilities.

Applications remain responsible for deciding where and how generated escape sequences are written.

Security issues involving application-specific output handling, terminal configuration, or untrusted data passed into an application using `tint.zig` should also be evaluated in the context of the consuming application.

## Supported Environment

The supported release targets Zig 0.17.0 and the platforms documented by the project.

Security reports should include the Zig version, target architecture, operating system, and relevant build configuration when these details may affect reproduction.

## Contact

For private vulnerability reports, use the security contact or private reporting mechanism provided by the project repository.

Please do not disclose an unpatched security vulnerability publicly before coordinating with the maintainers.
