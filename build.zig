const std = @import("std");

const c17_flags = &.{"-std=c17"};
const project_flags = &.{
    "-std=c17",
    "-Wall",
    "-Wextra",
    "-Wpedantic",
    "-Werror",
    "-Wshadow",
    "-Wstrict-prototypes",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const module_options: std.Build.Module.CreateOptions = .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    };

    // To build another vendored C library, copy this block before the app block.
    // Give the module and library new names. List the library's .c files.
    // If its own sources need a header directory, call addIncludePath on its module.
    const cjson_module = b.createModule(module_options);
    cjson_module.addCSourceFiles(.{
        .files = &.{"third_party/cjson/cJSON.c"},
        .flags = c17_flags,
    });
    const cjson = b.addLibrary(.{
        .name = "cjson",
        .linkage = .static,
        .root_module = cjson_module,
    });

    const app = b.createModule(module_options);
    // List new application .c files here. Put shared sources in the test list too.
    app.addCSourceFiles(.{
        .files = &.{ "src/main.c", "src/math_utils.c" },
        .flags = project_flags,
    });
    // Add each header directory here. Use the directory that matches your #include paths.
    // Add the same directory to compile_flags.txt so clangd can find its headers.
    app.addIncludePath(b.path("include"));
    app.addIncludePath(b.path("third_party/cjson"));

    // Link each vendored library here. Add its public header directory above.
    app.linkLibrary(cjson);

    // Link an installed library here, for example:
    // app.linkSystemLibrary("sdl3", .{ .use_pkg_config = .force });
    // app.linkSystemLibrary("sdl3-image", .{ .use_pkg_config = .force });
    // If it uses pkg-config, use its package name and .{ .use_pkg_config = .force }.
    // For a library in a custom directory, add its path with app.addLibraryPath.

    const exe = b.addExecutable(.{ .name = "c-build-zig", .root_module = app });
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    run.addPassthruArgs();
    b.step("run", "Build and run the program").dependOn(&run.step);

    // List the tests and the project sources they call. Give this module its own
    // include paths and link any libraries that the tests use.
    const test_module = b.createModule(module_options);
    test_module.addCSourceFiles(.{
        .files = &.{ "tests/test_math_utils.c", "src/math_utils.c" },
        .flags = project_flags,
    });
    test_module.addCSourceFiles(.{
        .files = &.{"third_party/unity/unity.c"},
        .flags = c17_flags,
    });
    test_module.addIncludePath(b.path("include"));
    test_module.addIncludePath(b.path("third_party/unity"));

    const tests = b.addExecutable(.{ .name = "test_math_utils", .root_module = test_module });
    const run_tests = b.addRunArtifact(tests);
    run_tests.stdio = .inherit;
    b.step("test", "Build and run the C tests").dependOn(&run_tests.step);
}
