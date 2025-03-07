local setline_to_sets = function(line)
  -- second means it uses the second form as documented in vim
  local _, second = line:find('^set? ')
  if second then
    line = line:sub(second + 1)
  end
  local iter = function(str, i)
    local sep = i
    while sep == i or sep ~= nil and str:sub(sep - 1, sep) == '\\:' do
      sep = str:find('[: ]', sep + 1)
    end
    if (second and sep == nil) or (not second and i >= #str) then
      return nil
    elseif not second and sep == nil then
      sep = #str + 1
    end
    return sep + 1, str:sub(i, sep - 1):gsub('\\:', ':')
  end
  return iter, line, 1
end

local line_to_vim_settings = function(line)
  local find_end = function(str, pat)
    return select(2, str:find(pat))
  end
  local modeline_start = find_end(line, '[ \t]vim?:%s?')
    or find_end(line, '[ \t]ex?:%s?')
  if modeline_start then
    local vim_settings = {}
    for _, set in setline_to_sets(line:sub(modeline_start + 1)) do
      local equals = set:find('=')
      if equals then
        vim_settings[set:sub(1, equals - 1)] = set:sub(equals + 1)
      else
        local no = set:match('^no')
        vim_settings[no and set:sub(3) or set] = not no
      end
    end
    return vim_settings
  end
  return nil
end

local vim_settings_to_vis_options = function(vim_settings)
  local syntax = nil
  local options = {}
  for k, v in pairs(vim_settings) do
    if k == 'colorcolumn' or k == 'cc' then
      options.colorcolumn = tonumber(v)
    elseif k == 'expandtab' or k == 'et' then
      options.expandtab = v
    elseif k == 'filetype' or k == 'ft' then
      syntax = v
    elseif k == 'number' or k == 'nu' then
      options.numbers = tonumber(v)
    elseif k == 'tabstop' or k == 'ts' or k == 'shiftwidth' or k == 'sw' then
      options.tabwidth = tonumber(v)
    end
  end
  return options, syntax
end

return {
  line_to_vim_settings = line_to_vim_settings,
  get_pairs_for = function(lines)
    local tenlines = lines
    if #lines > 10 then
      tenlines = {
        lines[1],
        lines[2],
        lines[3],
        lines[4],
        lines[5],
        lines[#lines - 4],
        lines[#lines - 3],
        lines[#lines - 2],
        lines[#lines - 1],
        lines[#lines - 0],
      }
    end
    for _, line in ipairs(tenlines) do
      local vim_settings = line_to_vim_settings(line)
      if vim_settings then
        return vim_settings_to_vis_options(vim_settings)
      end
    end
    return {}
  end,
}
