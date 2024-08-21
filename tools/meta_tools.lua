local meta_tools = {}

function meta_tools.file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function meta_tools.read_link_file(name)
    local f = io.open(name, 'r')
    if f ~= nil then
        local output = {}
        for line in f:lines() do
            table.insert(output, line)
        end
        f:close()
        return output
    else
        return {}
    end
end

function meta_tools.write_link_file(name, links)
    local f = io.open(name, 'w')
    for i,v in ipairs(links) do
        f:write(string.format("%s\n", v))
    end
    f:close()
end

function meta_tools.get_note(note_name)
    local build_root = PANDOC_WRITER_OPTIONS.variables["build_root"]
    local file = io.open(string.format("%s/%s.meta", build_root, note_name), "r")
    local note = {}

    for line in file:lines() do
        local sep = string.find(line, ",")
        local index = string.sub(line, 1, sep-1)
        local content = string.sub(line, sep+1, -1)

        note[index] = content
    end

    note["note_name"] = note_name

    file:close()
    return note
end

return meta_tools
