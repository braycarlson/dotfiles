vim.keymap.set(
    'v',
    '<Leader>c',
    '"+y <Esc>',
    {}
)

vim.keymap.set(
    'v',
    '<Leader>p',
    '"*p',
    {}
)

vim.keymap.set(
    'v',
    '>>',
    '<Nop>',
    {}
)

vim.keymap.set(
    'v',
    '<<',
    '<Nop>',
    {}
)

vim.keymap.set(
    'v',
    '<Tab>',
    '>><Esc>gv',
    {}
)

vim.keymap.set(
    'v',
    '<S-Tab>',
    '<<<Esc>gv',
    {}
)

vim.keymap.set(
    'v',
    'J',
    ':m ">+1<CR>gv=gv'
)

vim.keymap.set(
    'v',
    'K',
    ':m "<-2<CR>gv=gv'
)
