const std = @import("std");
const CrossTarget = @import("std").zig.CrossTarget;
const Builder = std.build.Builder;
const Target = @import("std").Target;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    //const exe = b.addStaticLibrary("timos", "src/main.zig");
    const exe = b.addExecutable("timos", "src/main.zig");
    exe.setTarget(CrossTarget{
        .cpu_arch = .i386,
        .os_tag = .freestanding,
    });
    exe.addAssemblyFile("./src/start.s");
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath("linker.ld");
    exe.setOutputDir("build");

    b.default_step.dependOn(&exe.step);
}
