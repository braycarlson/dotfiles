local get_packer = function()
    local path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path})
        vim.cmd[[packadd packer.nvim]]

        return true
    end

    return false
end

local bootstrap = get_packer()

require('packer').startup(function(use)
    if vim.fn.has('nvim') == 1 then
        use 'wbthomason/packer.nvim'
        use 'andweeb/presence.nvim'
        use 'folke/zen-mode.nvim'

	use {
	    'nvim-treesitter/nvim-treesitter',
	    run = function()
		local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		ts_update()
	    end,
	}
        use {'akinsho/bufferline.nvim', tag = 'v3.*', requires = 'nvim-tree/nvim-web-devicons'}

        use {
            'nvimdev/dashboard-nvim',
            config = function() require('dashboard') end,
        }
    end

    use {
        'junegunn/fzf',
        run = function() vim.fn['fzf#install']() end
    }

    use 'junegunn/fzf.vim'
    use 'morhetz/gruvbox'
    use({ 'rose-pine/neovim', as = 'rose-pine' })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            {
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end
            },
            {'williamboman/mason-lspconfig.nvim'},
            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    use {
	'lukas-reineke/indent-blankline.nvim',
	config = function()
	    require('indent_blankline').setup {
		char = '│',
		show_trailing_blankline_indent = false,
		show_current_context = true,
		show_current_context_start = true,
	    }
	end
    }
end)

