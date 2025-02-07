local M = {}

vim.o.virtualedit = 'onemore'
vim.g.extra_column = false

function M.move_word_right()
    local lnum = vim.fn.line('.')
    local col = vim.fn.col('.')
    local line = vim.fn.getline(lnum)
    local len = #line

    if col > len then
        vim.cmd('normal! j0')
        vim.g.extra_column = false
        return
    elseif col == len then
        if not vim.g.extra_column then
            vim.fn.cursor(lnum, col + 1)
            vim.g.extra_column = true
        else
            vim.cmd('normal! j0')
            vim.g.extra_column = false
        end
        return
    end

    vim.g.extra_column = false

    vim.cmd('normal! e')

    lnum = vim.fn.line('.')
    col = vim.fn.col('.')
    line = vim.fn.getline(lnum)
    len = #line

    if col < len then
        vim.fn.cursor(lnum, col + 1)
    elseif col == len then
        vim.fn.cursor(lnum, col + 1)
        vim.g.extra_column = true
    end
end

function M.move_word_left()
    local lnum = vim.fn.line('.')
    local col = vim.fn.col('.')
    local line = vim.fn.getline(lnum)

    if col == 1 then
        if lnum > 1 then
            local prev_line = vim.fn.getline(lnum - 1)
            local prev_len = #prev_line
            vim.fn.cursor(lnum - 1, prev_len + 1)
            vim.g.extra_column = true
        end
        return
    end

    if vim.g.extra_column then
        vim.g.extra_column = false
    end

    vim.cmd('normal! h')

    lnum = vim.fn.line('.')
    col = vim.fn.col('.')
    line = vim.fn.getline(lnum)

    if col > 1 and line:sub(col, col):match('[%p%s]') then
        while col > 1 and line:sub(col, col):match('[%p%s]') do
            vim.cmd('normal! h')
            col = vim.fn.col('.')
        end

        vim.cmd('normal! l')
    else
        vim.cmd('normal! b')

        lnum = vim.fn.line('.')
        col = vim.fn.col('.')

        if col > 1 then
            vim.fn.cursor(lnum, col - 1)
        else
            vim.g.extra_column = true
        end
    end
end

return M
