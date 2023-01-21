local meta_tools = require("tools/meta_tools")

local function load_notes(note_list)
    local notes = {}
    for note in string.gmatch(note_list, "%S+") do
        table.insert(notes, note)
    end
    return notes
end

local function compare_note_dates(a, b)
    return a.last_edit > b.last_edit
end

function Pandoc(doc)
    doc.meta["main_class"] = "html-main-page"
    doc.meta["front_page"] = true

    local notes = {}
    local note_names = load_notes(doc.meta["note_list"])
    for index, note in ipairs(note_names) do
        table.insert(notes, meta_tools.get_note(note))
    end

    table.sort(notes, compare_note_dates)

    local output = pandoc.MetaList({})
    for index,note in ipairs(notes) do
        local out_list = {}

        if note["cover_image"] ~= nil then
            local image = pandoc.RawBlock("html", string.format("<img src=\"%s\">", note.cover_image))
            table.insert(out_list, image)
        end

        local header = pandoc.Header(2, note.title)
        table.insert(out_list, header)

        if note["cover_image"] == nil then
            table.insert(out_list, pandoc.Para(string.format("%s...", note.long_preview)))
        else
            table.insert(out_list, pandoc.Para(string.format("%s...", note.preview)))
        end

        local out = pandoc.MetaBlocks(out_list)
        output:insert(pandoc.MetaMap({link=string.format("/notes/%s.html", note.note_name), note=out}))
    end

    doc.meta["notes"] = output
    return pandoc.Pandoc(doc.blocks, doc.meta)
end
