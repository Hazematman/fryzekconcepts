local pipe = pandoc.pipe
local stringify = (require 'pandoc.utils').stringify
local meta_tools = require("tools/meta_tools")

local meta = PANDOC_DOCUMENT.meta
local preview = ""
local long_preview = ""
local internal_links = {}
local max_string_length = 100
local max_long_string_length = 500

local function append_str(buf, s, max_length)
    if (#buf + #s) < max_length then
        buf = buf .. s
    end

    return buf
end

local function item_in_table(table, item)
    local inside = false
    for i,v in ipairs(table) do
        if v == item then
            inside = true
            break
        end
    end

    return inside
end

local function get_filename(file)
    return file:match("^.+/(.+)$")
end

local function get_input_file()
    local file = PANDOC_STATE.input_files[1]
    file = get_filename(file)
    file = string.gsub(file, ".md", "")
    return file
end

function Doc(body, metadata, variables)
    local input_file = get_input_file()

    -- Write out link file for table
    for i,v in ipairs(internal_links) do
        local markdown_file = "./notes/" .. v .. ".md"
        local link_file = "./build/" .. v .. ".links"

        -- check if markdown version of the file exists
        if meta_tools.file_exists(markdown_file) then
            links = meta_tools.read_link_file(link_file) 
            if not item_in_table(links, input_file) then
                table.insert(links, input_file)
            end

            meta_tools.write_link_file(link_file, links)
        else
            io.stderr:write(string.format("Linking to non-existant file '%s'\n", v))
        end
    end

    local values = {}
    local output = ""
    for k,v in pairs(meta) do
        values[k] = stringify(v)
    end

    values["preview"] = preview
    values["long_preview"] = long_preview
    for k,v in pairs(values) do
        output = output .. string.format("%s,%s\n", k, v)
    end

    return output
end

function Header(s)
    preview = append_str(preview, " - ", max_string_length)
    long_preview = append_str(long_preview, " - ", max_long_string_length)
    return ""
end

function Str(s)
    preview = append_str(preview, s, max_string_length)
    long_preview = append_str(long_preview, s, max_long_string_length)
    return ""
end

function Space()
    preview = append_str(preview, " ", max_long_string_length)
    long_preview = append_str(long_preview, " ", max_long_string_length)
    return ""
end

function SoftBreak()
    return Space()
end

function LineBreak()
    return Space()
end

function Link(s, tgt, tit, attr)
    if not string.find(tgt, "://") then
        -- Check if link is already found elsewhere in document
        local value_found = false
        for index, value in ipairs(internal_links) do
            if value == tgt then value_found = true end
        end

        if not value_found then
            table.insert(internal_links, tgt)
        end
    end
    return ""
end


-- Ignore functions we haven't implemented as we don't need them
local meta = {}
meta.__index =
  function(_, key)
    return function() return '' end
  end
setmetatable(_G, meta)
