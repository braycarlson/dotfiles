-- Set the theme
if vim.go.t_8f ~= nil and vim.go.t_8b ~= nil then
    vim.opt.termguicolors = true
end

-- vim.g.gruvbox_contrast_dark = 'medium'
-- vim.cmd('colorscheme gruvbox')

require('rose-pine').setup({
     variant = 'main',
     disable_italics = true,
})

vim.cmd('colorscheme rose-pine')
