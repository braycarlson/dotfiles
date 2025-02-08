local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- nvim-qt/ginit.lua
    { "equalsraf/neovim-gui-shim" },

    -- General Plugins
    { "andweeb/presence.nvim" },
    { "folke/zen-mode.nvim" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Dashboard
    {
        "nvimdev/dashboard-nvim",
        config = function()
            require("dashboard")
        end,
    },

    -- FZF
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
    },

    { "junegunn/fzf.vim" },

    -- Colorschemes
    -- {
    --     "morhetz/gruvbox",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.g.gruvbox_bold = 0
    --         vim.g.gruvbox_italic = 0
    --         vim.g.gruvbox_italicize_comments = 0
    --         vim.g.gruvbox_italicize_strings = 0
    --         vim.g.gruvbox_contrast_dark = "medium"
    --         vim.opt.termguicolors = true
    --         vim.cmd("colorscheme gruvbox")
    --     end,
    -- },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "main",
                disable_italics = true,
            })
            vim.opt.termguicolors = true
            vim.cmd("colorscheme rose-pine")
        end,
    },

    -- LSP and Autocompletion
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            { "williamboman/mason.nvim", build = ":MasonUpdate" },
            { "williamboman/mason-lspconfig.nvim" },
            { "neovim/nvim-lspconfig" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
        },
    },
})
