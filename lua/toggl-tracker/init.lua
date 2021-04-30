json = require "json"

local function isempty(s)
    return s == nil or s == ''
end

function concatTable(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]  
    end
    return t1
end

function timeFromDuration(time)
    local days = math.floor(time/86400)
    local hours = math.floor((time % 86400)/3600) 
    local minutes = math.floor((time % 3600)/60)
    local seconds = math.floor((time % 60))
    return string.format("%d:%02d:%02d:%02d",days,hours,minutes,seconds)
end

function matchStringToLen(str, len)
    print(str)
    if string.len(str) > len then
       return str
    end
    while string.len(str) < len do
        str = str .. " "  
    end
    return str
end

local function getLatestTimeEntries(bufh)
    local api_key = vim.g["toggl_api_key"]
    local request = string.format("curl -s -u %s:api_token -X GET https://api.track.toggl.com/api/v8/time_entries", api_key)
    local result = vim.fn.systemlist(request)

    if result[1] ~= '' and result[1] ~= nil then
        local json = json.decode(result[1])
        local json_rev = {}

        local longest_str = 0
        for i=1, #json do
            table.insert(json_rev, json[#json + 1 -i])
            if longest_str < string.len(json[i].description) then
                longest_str = string.len(json[i].description)
            end
        end

        local tbl = {}
        time = json_rev[1].duration + os.time(os.date("!*t"))
        table.insert(tbl, "  "..matchStringToLen(json_rev[1].description, longest_str) .. "\t\t\t" .. timeFromDuration(time))
        for i = 2, #json_rev do
            table.insert(tbl, "  "..matchStringToLen(json_rev[i].description, longest_str) .. "\t\t\t" .. timeFromDuration(json_rev[i].duration))
        end

        return tbl
    end   
end

local function createFloatingWindow()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    bufh = vim.api.nvim_create_buf(false, true)
    -- vim.api.nvim_buf_set_option(buf, "buftype", "prompt")

    local win_height = math.ceil(height * 0.4 - 4)
    local win_width = math.ceil(width * 0.3)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2 )

    local winid = vim.api.nvim_open_win(bufh, true, {
        style = "minimal",
        relative = "editor",
        border = "single",
        width = win_width,
        height = win_height,
        col = col,
        row = row,
    })

    -- a = getCurrentTimer(bufh)
    b = getLatestTimeEntries(bufh)

    -- r = concatTable(a,b)

    vim.api.nvim_buf_set_lines(bufh, 0, -1, false, b)
    vim.api.nvim_buf_set_option(bufh, 'modifiable', true)       
end


local function onResize()
    local stats = vim.api.nvim_list_uis()[1]
    local width = stats.width
    local height = stats.height
end

return {
    createFloatingWindow = createFloatingWindow
}
