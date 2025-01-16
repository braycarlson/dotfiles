vim.opt.termguicolors = true

local bufferline = require('bufferline')

bufferline.setup {
    options = {
        enforce_regular_tabs = true,
        always_show_bufferline = true,
	show_buffer_close_icons = false,
        show_close_icon = false,
        close_command = function(bufnum)
            vim.api.nvim_buf_delete(bufnum, { force = true })
        end,
        right_mouse_command = function(bufnum) end,
        offsets = {
            { filetype = "dashboard", text = "Dashboard", text_align = "center" },
        },
    }
}

local function set_bufferline_tab_text()
    vim.api.nvim_set_hl(0, "BufferLineTab", { bold = false, italic = false })
    vim.api.nvim_set_hl(0, "BufferLineBackground", { bold = false, italic = false })

    vim.api.nvim_set_hl(0, "BufferLineTabSelected", { bold = false, italic = false })
    vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bold = false, italic = false })

    vim.api.nvim_set_hl(0, "BufferLineModified", { bold = false, italic = false })
    vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { bold = false, italic = false })
end

set_bufferline_tab_text()


