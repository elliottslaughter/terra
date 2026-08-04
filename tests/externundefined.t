-- Calling a function that was declared extern but never defined used to bind the call to
-- address zero and kill the process with a segfault. It should be a catchable Lua error
-- raised when we JIT the code, naming the symbol that could not be found.

local ffi = require 'ffi'

local missing = "terra_test_this_symbol_does_not_exist"

-- 1. Referenced from a Terra function. The error surfaces when the caller is compiled.
local undefined = terralib.externfunction(missing, {} -> int)
local terra callsundefined()
    return undefined()
end

local success, msg = pcall(callsundefined)
assert(not success, "expected calling an undefined extern function to fail")
assert(msg:match(missing), "expected the error to name the missing symbol, got: " .. msg)

-- 2. Invoked directly from Lua. This goes down a different path in the JIT, which used to
-- abort the process through report_fatal_error rather than raising a Lua error.
local undefined2 = terralib.externfunction(missing .. "_2", {} -> int)
local success2, msg2 = pcall(undefined2)
assert(not success2, "expected invoking an undefined extern function to fail")
assert(msg2:match(missing .. "_2"),
       "expected the error to name the missing symbol, got: " .. msg2)

-- 3. The failure is recoverable: we are still running, and the compiler still works.
local terra addtwo(a : int, b : int)
    return a + b
end
assert(addtwo(3, 4) == 7)

-- 4. An extern function that *is* defined still resolves normally.
local strlen = terralib.externfunction("strlen", {rawstring} -> uint64)
local terra usestrlen()
    return strlen("hello")
end
assert(usestrlen() == 5)

-- 5. A symbol that only shows up after terralib.linklibrary must not be rejected early:
-- the check happens when we JIT, not when the extern is declared.
local libname = (ffi.os == "Windows" and "externundefined.dll" or "externundefined.so")
local args = {}
if ffi.os == "Windows" then
    args = { "/IMPLIB:externundefined.lib", "/EXPORT:externundefined_later" }
end
terra externundefined_later(a : int)
    return a * 2
end
terralib.saveobj(libname, { externundefined_later = externundefined_later }, args)

local later = terralib.externfunction("externundefined_later", {int} -> int)
terralib.linklibrary("./" .. libname)
assert(later(21) == 42)

-- 6. terralib.saveobj must still be able to leave a symbol undefined, since it is the
-- job of whatever links the object later to supply it.
local deferred = terralib.externfunction(missing .. "_3", {} -> int)
local terra usesdeferred()
    return deferred()
end
assert(pcall(terralib.saveobj, "externundefined.o", "object",
             { usesdeferred = usesdeferred }),
       "saveobj must tolerate symbols that are resolved at link time")

print("done")
