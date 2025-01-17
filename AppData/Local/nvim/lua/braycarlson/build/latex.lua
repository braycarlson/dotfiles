local function build()
    local platform = os.getenv('OS')

    local current = vim.fn.expand('%:p:h')
    local tex = vim.fn.expand('%:p')
    local pdf = vim.fn.expand('%:p:r') .. '.pdf'

    vim.api.nvim_command('botright new')
    vim.api.nvim_command('resize 10')

    local buffer = vim.fn.termopen('latexmk -shell-escape -f -halt-on-error -interaction=nonstopmode -pdf ' .. tex)
    vim.fn.jobwait({vim.fn.getbufvar(buffer, '&channel')})

    vim.loop.spawn(
        vim.g.reader,
        {args = {pdf}},

        function(code)
            if code ~= 0 then
                print('Failed to open PDF')
            else
                if vim.g.os == 'Windows' then
                    os.execute('del /S /Q ' .. current .. '\\*.aux')
                    os.execute('del /S /Q ' .. current .. '\\*.fls')
                    os.execute('del /S /Q ' .. current .. '\\*.fdb_latexmk')
                    os.execute('del /S /Q ' .. current .. '\\*.out')
                    os.execute('del /S /Q ' .. current .. '\\*.log')
                else
                    os.execute('find ' .. current .. ' -name "*.aux" -delete')
                    os.execute('find ' .. current .. ' -name "*.fls" -delete')
                    os.execute('find ' .. current .. ' -name "*.fdb_latexmk" -delete')
                    os.execute('find ' .. current .. ' -name "*.out" -delete')
                    os.execute('find ' .. current .. ' -name "*.log" -delete')
                end
            end
        end
    )
end

return build
