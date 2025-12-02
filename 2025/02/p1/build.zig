const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mod = b.addModule("02", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
    });
    const exe = b.addExecutable(.{
        .root_module = mod,
        .name = "aoc",
    });

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

}
