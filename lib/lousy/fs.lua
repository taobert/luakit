--- lousy.fs library.
--
--- Filesystem utility functions
--
-- These functions provide some useful filesystem-related actions not already provided by lua's `os` or `io` modules.
-- Versions of `exists` and `mkdir` previously existed in lousy.util.
--
-- @module lousy.fs
-- @author Tao Nelson <taobert@gmail.com>
-- @author Aidan Holm <aidanholm@gmail.com>
-- @author Mason Larobina <mason.larobina@gmail.com>
-- @copyright 2021 Tao Nelson <taobert@gmail.com>
-- @copyright 2017 Aidan Holm <aidanholm@gmail.com>
-- @copyright 2010 Mason Larobina <mason.larobina@gmail.com>

local _M = {}



-- @tparam boolean asrt Whether returned function should call assert on it's arguments
-- @return function A function which returns it's argument, having asserted it first or not depending on ast.
local mkassert = function(asrt)
    return asrt and function(...) return assert(...) end     or     function(...) return ... end
end


--- Check if a file exists and is readable.
-- @tparam string f The file path.
-- @treturn boolean `true` if the file exists and is readable.
_M.exists = function (f)
    assert(type(f) == "string", "invalid path")
    local fh = io.open(f)
    if fh then
        fh:close()
        return f
    end
end

--- Create a directory.
-- @tparam string dir The directory.
-- @treturn number The status code returned by `mkdir`; 0 indicates success.
-- mkdir calls `mkdir -p` and so  it will create any parent directories needed.
-- It also returns true if the directory was successfully created,
-- _or_ if it already existed (even if it is non-writable).
function _M.mkdir(dir, ast)
    local asrt = mkassert(ast)
    return asrt(os.execute(string.format("mkdir -p %q",  dir)))
end


--- Return directory listing.
-- @tparam string dir The directory.
-- @tparam bool ast Assert that dir exists.
-- @treturn function A closure which contains the list of files etc. inside dir
--                   and returns each in turn on successive calls.
_M.ls = function (dir, ast)
    local asrt = mkassert(ast)
    -- avoid ls printing error when dir is absent
    if not asrt(_M.exists(dir)) then return function () return nil end end
    return io.popen("ls "..dir):lines()
end



return _M

-- vim: et:sw=4:ts=8:sts=4:tw=80
