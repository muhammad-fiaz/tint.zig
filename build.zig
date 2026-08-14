const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tint_mod = b.addModule("tint", .{
        .root_source_file = b.path("src/tint.zig"),
    });

    const examples = [_]struct { name: []const u8, path: []const u8 }{
        .{ .name = "basic", .path = "examples/basic.zig" },
        .{ .name = "ansi16", .path = "examples/ansi16.zig" },
        .{ .name = "bright", .path = "examples/bright.zig" },
        .{ .name = "ansi256", .path = "examples/ansi256.zig" },
        .{ .name = "rgb", .path = "examples/rgb.zig" },
        .{ .name = "hex", .path = "examples/hex.zig" },
        .{ .name = "hsl", .path = "examples/hsl.zig" },
        .{ .name = "hsv", .path = "examples/hsv.zig" },
        .{ .name = "cmyk", .path = "examples/cmyk.zig" },
        .{ .name = "color_temperature", .path = "examples/color_temperature.zig" },
        .{ .name = "color_manipulation", .path = "examples/color_manipulation.zig" },
        .{ .name = "color_harmony", .path = "examples/color_harmony.zig" },
        .{ .name = "color_analysis", .path = "examples/color_analysis.zig" },
        .{ .name = "styles", .path = "examples/styles.zig" },
        .{ .name = "presets", .path = "examples/presets.zig" },
        .{ .name = "underline_color", .path = "examples/underline_color.zig" },
        .{ .name = "palettes", .path = "examples/palettes.zig" },
        .{ .name = "themes", .path = "examples/themes.zig" },
        .{ .name = "themes_extended", .path = "examples/themes_extended.zig" },
        .{ .name = "gradient", .path = "examples/gradient.zig" },
        .{ .name = "composition", .path = "examples/composition.zig" },
        .{ .name = "complete", .path = "examples/complete.zig" },
    };

    const run_all_examples = b.step("run-all-examples", "Run all examples sequentially");
    var previous_run_step: ?*std.Build.Step = null;

    inline for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.path),
                .target = target,
                .optimize = optimize,
            }),
        });
        exe.root_module.addImport("tint", tint_mod);

        const install_exe = b.addInstallArtifact(exe, .{});
        const example_step = b.step("example-" ++ example.name, "Build " ++ example.name ++ " example");
        example_step.dependOn(&install_exe.step);

        const run_exe = b.addRunArtifact(exe);
        run_exe.step.dependOn(&install_exe.step);
        if (b.args) |args| run_exe.addArgs(args);
        const run_step = b.step("run-" ++ example.name, "Run " ++ example.name ++ " example");
        run_step.dependOn(&run_exe.step);

        const run_all_exe = b.addRunArtifact(exe);
        if (previous_run_step) |prev| {
            run_all_exe.step.dependOn(prev);
        }
        previous_run_step = &run_all_exe.step;
    }

    if (previous_run_step) |last| {
        run_all_examples.dependOn(last);
    }

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tint.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run unit tests");

    const builtin = @import("builtin");
    if (target.result.os.tag == builtin.os.tag and target.result.cpu.arch == builtin.cpu.arch) {
        test_step.dependOn(&run_tests.step);
    } else {
        const install_tests = b.addInstallArtifact(tests, .{});
        test_step.dependOn(&install_tests.step);
    }

    const docs_step = b.step("docs", "Generate documentation");
    const docs_obj = b.addObject(.{
        .name = "tint",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tint.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    const install_docs = b.addInstallDirectory(.{
        .source_dir = docs_obj.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);

    const test_all_step = b.step("test-all", "Run all tests and examples");
    test_all_step.dependOn(test_step);
    test_all_step.dependOn(run_all_examples);

    const lib = b.addLibrary(.{
        .name = "tint",
        .linkage = .static,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tint.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(lib);

    const fmt = b.addFmt(.{
        .paths = &.{
            "src",
            "examples",
        },
    });
    const fmt_step = b.step("fmt", "Format source code");
    fmt_step.dependOn(&fmt.step);
}
