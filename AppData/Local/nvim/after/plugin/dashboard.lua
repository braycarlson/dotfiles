local dashboard = require('dashboard')

dashboard.setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        project = {
            enable = true,
        action = function(path)
        vim.cmd('Files ' .. path)
            end,
    },
        shortcut = {
            {
                desc = '󰊳 Update',
                group = '@property',
                action = ':Lazy update',
                key = 'u'
            },
        {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Personal',
                group = 'Label',
                action = 'Files ' .. vim.g.personal,
                key = 'p',
            },
        {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Work',
                group = 'Label',
                action = 'Files ' .. vim.g.work,
                key = 'w',
            },
        {
                desc = ' dotfile',
                group = 'Number',
                action = 'Files ' .. vim.g.nvim,
                key = 'd',
            },
        },
        footer = {},
    },
})
