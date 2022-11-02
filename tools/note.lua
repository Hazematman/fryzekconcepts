local stringify = (require 'pandoc.utils').stringify

local status_map = {"seadling", "budding", "evergreen"}

function Pandoc(doc)
    doc.meta["front_page"] = false

    local status = stringify(doc.meta["status"])
    local status_name = status_map[tonumber(status)]
    local text = pandoc.Para(status_name)
    local image = pandoc.RawBlock("html", string.format("<img src=\"/assets/%s.svg\">", status_name))

    local div = pandoc.Div({image, text})
    div.classes = {"plant-status"}

    local status_info = pandoc.MetaBlocks(div)
    doc.meta["note_status"] = status_info
    return pandoc.Pandoc(doc.blocks, doc.meta)
end
