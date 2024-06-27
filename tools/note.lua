local stringify = require('pandoc.utils').stringify
local text = require('text')
local meta_tools = require("tools/meta_tools")

local status_map = {"seedling", "budding", "evergreen"}

function Link(link)
    if not string.find(link.target, "://") then
        local note = meta_tools.get_note(link.target)
        local text = note["title"]
        if string.len(stringify(link.content)) ~= 0 then
            text = link.content
        end
        return {pandoc.Link(text, "/notes/"..link.target..".html")}
    else
        return link
    end
end

function Image(image)
    if not string.find(image.src, "://") then
        local s_begin, s_end = string.find(image.src, "youtube:")
        if s_begin ~= nil then
            local url = "https://www.youtube.com/embed/" .. string.sub(image.src, s_end+1, -1)
            local video = pandoc.RawInline("html", string.format("<div class=\"youtube-video\"><iframe src=\"%s\"></iframe></div>", url))
            return {video}
        end
    else
        return image
    end
end

function Pandoc(doc)
    doc.meta["main_class"] = "html-note-page"
    doc.meta["main_container"] = "main-container"
    doc.meta["front_page"] = false

    local status = stringify(doc.meta["status"])
    local status_name = status_map[tonumber(status)]
    local text = pandoc.Para(status_name)
    local image = pandoc.RawBlock("html", string.format("<img src=\"/assets/%s.svg\">", status_name))

    local status_div = pandoc.Div({text})
    status_div.classes = {"plant-status-text"}
    local div = pandoc.Div({image, status_div})
    div.classes = {"plant-status"}

    local status_info = pandoc.MetaBlocks(div)
    doc.meta["note_status"] = status_info
    return pandoc.Pandoc(doc.blocks, doc.meta)
end
