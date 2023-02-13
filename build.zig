const std = @import("std");
const version = std.mem.trim(u8, @embedFile("version"), "\n");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const lua_src = "lua-" ++ version ++ "/src/";

    const exe = b.addExecutable("lua", lua_src ++ "lua.c");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibC();
    exe.addIncludePath(lua_src);

    const exe_luac = b.addExecutable("luac", lua_src ++ "luac.c");
    exe_luac.setTarget(target);
    exe_luac.setBuildMode(mode);
    exe_luac.linkLibC();
    exe_luac.addIncludePath(lua_src);

    // exe.addCSourceFile("src/ltestlib.c", &c_flags);
    // exe_luac.addCSourceFile("src/ltestlib.c", &c_flags);

    const testlib = b.addStaticLibrary("testlib", "src/ltestlib.zig");
    testlib.setTarget(target);
    testlib.setBuildMode(mode);
    testlib.linkLibC();
    testlib.addIncludePath(lua_src);

    exe.linkLibrary(testlib);
    exe_luac.linkLibrary(testlib);

    const lua_c_files = [_][]const u8{
        "lapi.c",
        "lauxlib.c",
        "lbaselib.c",
        "lcode.c",
        "lcorolib.c",
        "lctype.c",
        "ldblib.c",
        "ldebug.c",
        "ldo.c",
        "ldump.c",
        "lfunc.c",
        "lgc.c",
        "linit.c",
        "liolib.c",
        "llex.c",
        "lmathlib.c",
        "lmem.c",
        "loadlib.c",
        "lobject.c",
        "lopcodes.c",
        "loslib.c",
        "lparser.c",
        "lstate.c",
        "lstring.c",
        "lstrlib.c",
        "ltable.c",
        "ltablib.c",
        "ltm.c",
        "lundump.c",
        "lutf8lib.c",
        "lvm.c",
        "lzio.c",
    };

    const c_flags = [_][]const u8{
        "-std=c99",
    };

    inline for (lua_c_files) |c_file| {
        exe.addCSourceFile(lua_src ++ c_file, &c_flags);
        exe_luac.addCSourceFile(lua_src ++ c_file, &c_flags);
    }

    exe.setOutputDir(".");
    exe_luac.setOutputDir(".");

    exe.install();
    exe_luac.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
