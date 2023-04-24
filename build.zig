const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    // const readlineLib = b.addStaticLibrary("readline", "")

    const exe = b.addExecutable("main", "main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibC();
    exe.addIncludePath("/opt/homebrew/opt/readline/include");
    exe.addLibraryPath("/opt/homebrew/opt/readline/lib");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("readline");
    // exe.linkSystemLibrary("readline");
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
