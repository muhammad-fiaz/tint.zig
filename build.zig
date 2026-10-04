const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tint_mod = b.addModule("tint", .{
        .root_source_file = b.path("src/tint.zig"),
    });

    // Each example covers a distinct corner of the public API.
    const examples = [_][]const u8{
        "basic",
        "ansi",
        "ansi256",
        "colorspaces",
        "manipulation",
        "analysis",
        "styles",
        "palettes",
        "gradient",
        "themes",
        "capability",
        "complete",
    };

    const run_all_examples = b.step("run-all-examples", "Run every example in sequence");

    inline for (examples) |name| {
        const exe = b.addExecutable(.{
            .name = name,
            .root_module = b.createModule(.{
                .root_source_file = b.path("examples/" ++ name ++ ".zig"),
                .target = target,
                .optimize = optimize,
            }),
        });
        exe.root_module.addImport("tint", tint_mod);

        const install_exe = b.addInstallArtifact(exe, .{});
        b.step("example-" ++ name, "Build the " ++ name ++ " example").dependOn(&install_exe.step);

        const run_exe = b.addRunArtifact(exe);
        run_exe.step.dependOn(&install_exe.step);
        run_exe.addPassthruArgs();
        b.step("run-" ++ name, "Run the " ++ name ++ " example").dependOn(&run_exe.step);

        run_all_examples.dependOn(&run_exe.step);
    }

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tint.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const test_step = b.step("test", "Run the unit tests");
    const builtin = @import("builtin");
    if (target.result.os.tag == builtin.os.tag and target.result.cpu.arch == builtin.cpu.arch) {
        test_step.dependOn(&b.addRunArtifact(tests).step);
    } else {
        test_step.dependOn(&b.addInstallArtifact(tests, .{}).step);
    }

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

    const docs_obj = b.addObject(.{
        .name = "tint",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tint.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.step("docs", "Generate and install the Zigdoc documentation").dependOn(
        &b.addInstallDirectory(.{
            .source_dir = docs_obj.getEmittedDocs(),
            .install_dir = .prefix,
            .install_subdir = "docs",
        }).step,
    );

    const test_all = b.step("test-all", "Run the unit tests and every example");
    test_all.dependOn(test_step);
    test_all.dependOn(run_all_examples);
}
