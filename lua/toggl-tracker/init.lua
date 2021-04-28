json = require "json"

local function getDataTest(bufh)
    local result = vim.fn.systemlist("curl -s -u fe804de4d159f7d1af977d0183879319:api_token -X GET https://api.track.toggl.com/api/v8/time_entries/current")
    local json = json.decode(result[1])

    local output = { json.data.description .. " -- " .. json.data.start }

    vim.api.nvim_buf_set_lines(bufh, 0, -1, false, output)
    vim.api.nvim_buf_set_option(bufh, 'modifiable', false)
end

local function createFloatingWindow()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    bufh = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local win_height = math.ceil(height * 0.4 - 4)
    local win_width = math.ceil(width * 0.8)

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

    getDataTest(bufh)
end


local function onResize()
    local stats = vim.api.nvim_list_uis()[1]
    local width = stats.width
    local height = stats.height
end

return {
    createFloatingWindow = createFloatingWindow
}
