
local function load_notes(note_list)
    local notes = {}
    for note in string.gmatch(note_list, "%S+") do
        table.insert(notes, note)
    end
    return notes
end

local function get_note(note_name)
    local file = io.open(string.format("build/%s.meta", note_name), "r")
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

local function compare_note_dates(a, b)
    return a.last_edit > b.last_edit
end

function Pandoc(doc)
    doc.meta["main_class"] = "html-main-page"
    doc.meta["front_page"] = true

    local notes = {}
    local note_names = load_notes(doc.meta["note_list"])
    for index, note in ipairs(note_names) do
        table.insert(notes, get_note(note))
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

        table.insert(out_list, pandoc.Para(string.format("%s...", note.preview)))

        local out = pandoc.MetaBlocks(out_list)
        output:insert(pandoc.MetaMap({link=string.format("/notes/%s.html", note.note_name), note=out}))
    end

    doc.meta["notes"] = output
    return pandoc.Pandoc(doc.blocks, doc.meta)
end
