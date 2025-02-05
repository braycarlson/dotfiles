return {
    { "morhetz/gruvbox" },

    {
        "LazyVim/LazyVim",
        opts = {
          colorscheme = "gruvbox",
        },
    },

    {
        "morhetz/gruvbox",
    config = function()
        vim.g.gruvbox_bold = 0
        vim.g.gruvbox_italic = 0
        vim.g.gruvbox_italicize_comments = 0
        vim.g.gruvbox_italicize_strings = 0
        vim.g.gruvbox_contrast_dark = "medium"
        end,
    },

    -- {
    --     "rose-pine/neovim",
    --     config = function()
    --         require("rose-pine").setup({
    --             variant = "main",
    --             disable_italics = true,
    --         })

    --         vim.cmd("colorscheme rose-pine")
    --     end,
    -- },
}
