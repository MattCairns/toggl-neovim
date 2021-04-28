local function getDataTest(bufh)
    local result = vim.fn.systemlist('ls -lah')
    for k,v in pairs(result) do
        result[k] = '  '..result[k]
    end
    vim.api.nvim_buf_set_lines(bufh, 0, -1, false, result)
end

local function createFloatingWindow()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    bufh = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local scaling_factor = 0.4
    local win_height = math.ceil(height * scaling_factor - 4)
    local win_width = math.ceil(width * scaling_factor)

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
    print(width, height)
end

return {
    createFloatingWindow = createFloatingWindow
}
