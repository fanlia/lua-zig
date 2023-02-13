const lua = @cImport({
    @cInclude("lua.h");
    @cInclude("lualib.h");
    @cInclude("lauxlib.h");
});

pub fn add1(L: ?*lua.lua_State) callconv(.C) c_int {
    lua.lua_pushnumber(L, lua.luaL_checknumber(L, @as(c_int, 1)) + @intToFloat(f64, @as(c_int, 1)));
    return 1;
}

pub const testlib = [_]lua.luaL_Reg{
    lua.luaL_Reg{
        .name = "add1",
        .func = &add1,
    },
    lua.luaL_Reg{
        .name = null,
        .func = null,
    },
};

export fn luaopen_test(L: ?*lua.lua_State) c_int {
    const l = &testlib;

    // lua.luaL_newlib(L, l);
    lua.luaL_checkversion(L);
    lua.lua_createtable(L, 0, l.len);
    lua.luaL_setfuncs(L, l, 0);

    return 1;
}
