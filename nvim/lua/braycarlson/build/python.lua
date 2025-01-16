local function build()
    local current = vim.fn.expand('%:p:h')
    local file = vim.fn.expand('%:p')

    vim.api.nvim_command('botright new')
    vim.api.nvim_command('resize 10')

    local command

    if string.find(current, 'viking') and not string.find(current, 'script') then
        command = vim.g.python .. ' -u ' .. vim.fn.expand('%:p:h') .. '/run.py'
    else
        command = vim.g.python .. ' -u ' .. file
    end

    local env = {
        PYTHONIOENCODING = 'utf8',
        PYTHONDONTWRITEBYTECODE = '1'
    }

    local buffer = vim.fn.termopen(command, {env = env})

    vim.fn.jobwait({vim.fn.getbufvar(buffer, '&channel')})
end

return build
