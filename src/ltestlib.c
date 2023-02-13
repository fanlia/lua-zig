
#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

static int add1 (lua_State *L) {
    lua_pushnumber(L, (luaL_checknumber(L, 1) + 1));
    return 1;
}

static const luaL_Reg testlib[] = {
    {"add1", add1},
    {NULL, NULL}
};

LUAMOD_API int luaopen_test (lua_State *L) {
    luaL_newlib(L, testlib);
    return 1;
}
