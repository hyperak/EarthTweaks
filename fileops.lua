-- http://lua-users.org/wiki/FileInputOutput

-- Find the length of a file
--   filename: file name
-- returns
--   len: length of file
--   asserts on error

_G.fs = {}

function fs.length(filename)
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end

-- Return true if file exists and is readable.
function fs.exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

-- Guarded seek.
-- Same as file:seek except throws string
-- on error.
-- Requires Lua 5.1.
function seek(fh, ...)
  assert(fh:seek(...))
end

-- Read an entire file.
function fs.read(filename)
  local fh = assert(io.open(filename, "rb"))
  local contents = assert(fh:read("*a")) -- "a" in Lua 5.3; "*a" in Lua 5.1 and 5.2
  fh:close()
  return contents
end

-- Write a string to a file.
function fs.write(filename, contents)
  local fh = assert(io.open(filename, "wb"))
  fh:write(contents)
  fh:flush()
  fh:close()
end

-- Read, process file contents, write.
function fs.modify(filename, modify_func)
  local contents = readall(filename)
  contents = modify_func(contents)
  write(filename, contents)
end