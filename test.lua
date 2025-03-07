local core = dofile(
  (debug.getinfo(1, 'S').source:sub(2):match('(.*/)') or '') .. 'core.lua'
)

local compare_table = function(a, b, fail)
  local keys = {}
  local same = true
  for k in pairs(a) do
    table.insert(keys, k)
  end
  for k in pairs(b) do
    if keys[k] == nil then
      table.insert(keys, k)
    end
  end
  for _, k in ipairs(keys) do
    if a[k] ~= b[k] then
      same = false
      if fail ~= nil then
        fail(k, a[k], b[k])
      end
    end
  end
  return same
end

local testmodeline = function(modeline, expected)
  local vim_settings = core.line_to_vim_settings(modeline)
  compare_table(vim_settings, expected, function(k, a, b)
    error(
      modeline
        .. ': '
        .. k
        .. ' output '
        .. tostring(a)
        .. ' does not match expected '
        .. tostring(b)
    )
  end)
end

testmodeline(' vi:noai:sw=3 ts=6 ', { ai = false, sw = '3', ts = '6' })
testmodeline(' vi:noai sw=3 ts=6 ', { ai = false, sw = '3', ts = '6' })
testmodeline('/* vim: set ai tw=75: */', { ai = true, tw = '75' })
testmodeline('# vim: set expandtab:', { expandtab = true })
testmodeline('# vim: se noexpandtab:', { expandtab = false })
testmodeline('// vim: noai:ts=4:sw=4', { ai = false, sw = '4', ts = '4' })
testmodeline('/* vim: set noai sw=4: */', { ai = false, sw = '4' })
--backslashes are doubled for lua in the following test
testmodeline('/* vi:set dir=c\\:\\tmp: */', { dir = 'c:\\tmp' })
