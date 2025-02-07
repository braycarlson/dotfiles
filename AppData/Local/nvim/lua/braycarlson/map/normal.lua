local buffer = require("braycarlson.buffer")
local movement = require("braycarlson.movement")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = buffer.trim_whitespace,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = buffer.convert_tab_to_space,
})

vim.keymap.set(
    'x',
    '<Leader>p',
    '\'_dP'
)

vim.keymap.set(
    'n',
    'j',
    'gj',
    {}
)

vim.keymap.set(
    'n',
    'k',
    'gk',
    {}
)

vim.keymap.set(
    'n',
    '<Down>',
    'gj',
    { noremap = true, silent = true }
)

vim.keymap.set(
    'n',
    '<Up>',
    'gk',
    { noremap = true, silent = true }
)

vim.keymap.set(
    'n',
    '<C-Right>',
    'w',
    {}
)

vim.keymap.set(
    'n',
    '<C-Left>',
    'b',
    {}
)

vim.keymap.set(
    'n',
    '<C-Up>',
    'gk',
    {}
)

vim.keymap.set(
    'n',
    '<C-Down>',
    'gj',
    {}
)

vim.keymap.set(
    'n',
    'J',
    'mzJ`z'
)

vim.keymap.set(
    'n',
    '<C-d>',
    '<C-d>zz'
)

vim.keymap.set(
    'n',
    '<C-u>',
    '<C-u>zz'
)

vim.keymap.set(
    'n',
    'n',
    'nzzzv'
)

vim.keymap.set(
    'n',
    'N',
    'Nzzzv'
)

vim.keymap.set(
    'n',
    'Q',
    '<Nop>', {}
)

vim.keymap.set(
    'n',
    '<C-l>',
    '<Nop>',
    {}
)

vim.keymap.set(
    'n',
    '<Enter>',
    'o <Esc>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>n',
    ':enew<CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader><Leader>',
    '<C-^>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>o',
    ':only<CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>s',
    ':write<CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader><F5>',
    ':so %<CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>e',
    [[:silent !start explorer /select,%:p<CR>]],
    {}
)

vim.keymap.set(
    'n',
    '<Leader>v',
    ':vnew <CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>h',
    ':new <CR>',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>w',
    '<C-w><C-w>',
    {}
)

vim.keymap.set(
    'n',
    '>>',
    '<Nop>',
    {}
)

vim.keymap.set(
    'n',
    '<<',
    '<Nop>',
    {}
)

vim.keymap.set(
    'n',
    '<Tab>',
    '>>',
    {}
)

vim.keymap.set(
    'n',
    '<S-Tab>',
    '<<',
    {}
)

vim.keymap.set(
    'n',
    '<MiddleMouse>',
    '<LeftMouse>',
    {}
)

vim.keymap.set(
    'n',
    '<2-MiddleMouse>',
    '<LeftMouse>',
    {}
)

vim.keymap.set(
    'n',
    '<3-MiddleMouse>',
    '<LeftMouse>',
    {}
)

vim.keymap.set(
    'n',
    '<4-MiddleMouse>',
    '<LeftMouse>',
    {}
)

vim.keymap.set(
    'n',
    '<C-x>',
    '"+x',
    {}
)

vim.keymap.set(
    'n',
    '<C-a>',
    'ggVG',
    {}
)

vim.keymap.set(
    'n',
    '<Leader>x',
    buffer.switch_to_previous_or_dashboard,
    { noremap = true, silent = true }
)

vim.keymap.set(
    'n',
    '<C-Right>',
    movement.move_word_right,
    { noremap = true, silent = true }
)

vim.keymap.set(
    'n',
    '<C-Left>',
    movement.move_word_left,
    { noremap = true, silent = true }
)
