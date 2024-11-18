local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.toggle_term()
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    if filetype == 'fzf' then
	   return t"<Esc>"
    else
	   return t"<C-\\><C-n>"
    end
end

vim.keymap.set(
    't',
    '<Esc>',
    'v:lua.toggle_term()',
    { expr = true, silent = true }
)
