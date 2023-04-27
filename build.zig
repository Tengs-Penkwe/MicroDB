const std = @import("std");
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("main", "main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibC();
    switch (@import("builtin").os.tag) {
        .macos => {
            exe.addIncludePath("/opt/homebrew/opt/readline/include");
            exe.addLibraryPath("/opt/homebrew/opt/readline/lib");
        },
        .linux => {
            // exe.addIncludePath("/usr/local/include/readline/include");
            // exe.addLibraryPath("/usr/local/include/readline/lib");
        },
        else => {},
    }
    exe.linkSystemLibrary("readline");
    exe.linkSystemLibrary("curses");
    exe.install();

    const test_obj_step = b.addTest("src/main.zig");
    // setupLinks(test_obj_step);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the main");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&test_obj_step.step);
}
