local core =
  dofile(debug.getinfo(1, 'S').source:sub(2):match('(.*/)') .. 'core.lua')

local getwinforfile = function(file)
  for win in vis:windows() do
    if win and win.file and win.file.path == file.path then
      return win
    end
  end
end

local apply = function(win)
  local options, syntax = core.get_pairs_for(win.file.lines)
  for k, v in pairs(options) do
    win.options[k] = v
  end
  if syntax then
    win:set_syntax(syntax)
  end
end

vis.events.subscribe(vis.events.FILE_OPEN, function(file)
  local win = getwinforfile(file)
  if not win then
    return
  end
  apply(win)
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  apply(win)
end)
