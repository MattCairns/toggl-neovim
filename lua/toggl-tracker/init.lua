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

local function getCurrentTimer(bufh)
    local api_key = vim.g["toggl_api_key"]
    local request = string.format("curl -s -u %s:api_token -X GET https://api.track.toggl.com/api/v8/time_entries/current", api_key)
    local result = vim.fn.systemlist(request)
    if result[1] ~= '' and result[1] ~= nil then
        local json = json.decode(result[1])

        local output = { json.data.description .. " -- " .. json.data.start }

        print(output[1])
        return output
    end
end

local function getLatestTimeEntries(bufh)
    local api_key = vim.g["toggl_api_key"]
    local request = string.format("curl -s -u %s:api_token -X GET https://api.track.toggl.com/api/v8/time_entries", api_key)
    local result = vim.fn.systemlist(request)
    print(result[1])

    for k, v in pairs(result) do
        print(k)
    end

    if result[1] ~= '' and result[1] ~= nil then
        local json = json.decode(result[1])

        return result
    end   
end

local function createFloatingWindow()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    bufh = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

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

    a = getCurrentTimer(bufh)
    b = getLatestTimeEntries(bufh)

    r = concatTable(a,b)

    vim.api.nvim_buf_set_lines(bufh, 0, -1, false, r)
    vim.api.nvim_buf_set_option(bufh, 'modifiable', false)       
end


local function onResize()
    local stats = vim.api.nvim_list_uis()[1]
    local width = stats.width
    local height = stats.height
end

return {
    createFloatingWindow = createFloatingWindow
}
