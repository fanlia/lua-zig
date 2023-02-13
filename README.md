# lua-zig
lua in zig

## how

```sh
sh download-lua.sh
zig build
./lua
```

## extend test lib

```lua
require('test').add1(2.1)
-- 3.1
```

- src/ltestlib.c
- src/ltestlib.zig

## todo?

- rewrite lua by zig step by step
