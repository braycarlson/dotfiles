require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'go', 'json', 'latex', 'lua', 'python', 'query', 'rust', 'vim', 'vimdoc'},

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
