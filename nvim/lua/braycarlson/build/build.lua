function build()
    if vim.bo.filetype == 'python' then
        local python = require('braycarlson.build.python')
        python()
    elseif vim.bo.filetype == 'tex' then
        local latex = require('braycarlson.build.latex')
        latex()
    else
        print('No build system configured for ' .. vim.bo.filetype)
    end
end

vim.keymap.set(
    'n',
    '<C-b>',
    ':lua build()<CR>',
    {noremap = true, silent = true}
)
