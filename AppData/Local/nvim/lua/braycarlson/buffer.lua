local M = {}

function M.switch_to_previous_or_dashboard()
    local current = vim.api.nvim_get_current_buf()
    local previous = vim.fn.bufnr('#')

    if previous == -1 or previous == 0 or current == previous then
        vim.cmd('Dashboard')

        vim.schedule(function()
            vim.api.nvim_buf_delete(current, { force = true })
        end)
    else
        vim.api.nvim_set_current_buf(previous)
        vim.api.nvim_buf_delete(current, { force = true })
    end
end

function M.trim_whitespace()
    local line = vim.fn.line('.')
    local column = vim.fn.col('.')
    local is_highlighted = vim.o.hlsearch

    vim.o.hlsearch = false
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.cursor(line, column)
    vim.o.hlsearch = is_highlighted
end

function M.convert_tab_to_space()
    local view = vim.fn.winsaveview()

    vim.cmd("set expandtab")
    vim.cmd("silent! retab")

    vim.fn.winrestview(view)
end

return M
