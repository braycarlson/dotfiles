vim.g.os = (vim.fn.has('win16') == 1 or vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and 'Windows' or 'Linux'

if vim.g.os == 'Windows' then
    vim.g.profile = vim.fn.getenv('USERPROFILE')
    vim.g.home = vim.fn.getenv('LOCALAPPDATA')
    vim.g.appdata = vim.fn.getenv('APPDATA')

    vim.g.activate = vim.fn.getcwd()
    vim.g.parent = vim.fn.getcwd()
    vim.g.python_version = '3.13.0'
    vim.g.pyenv = vim.g.profile .. '/.pyenv/pyenv-win/versions/' .. vim.g.python_version .. '/python.exe'
    vim.g.python = vim.g.pyenv
    vim.g.python3_host_prog = vim.g.pyenv
    vim.g.reader = vim.g.home .. '/SumatraPDF/SumatraPDF.exe'
    vim.o.shell = 'cmd.exe'
    vim.g.terminal = 'alacritty'

    if vim.g.profile == 'Brayden' then
       vim.g.code = 'E:/code'
    else
       vim.g.code = vim.g.profile .. '/Documents/code'
    end

    vim.g.work = vim.g.code .. '/work'
    vim.g.personal = vim.g.code .. '/personal'

    vim.g.alacritty = vim.g.appdata .. '/alacritty'
    vim.g.nvim = vim.g.home .. '/nvim'
    vim.g.sublime_text = vim.g.appdata .. '/Sublime Text/Packages/User'

    vim.g.backup = vim.g.nvim .. '/tmp'
    vim.g.init = vim.g.nvim .. '/init.vim'
else
    vim.g.home = vim.fn.getenv('HOME')

    vim.g.alacritty = vim.g.home .. '/.config/alacritty'
    vim.g.nvim = vim.g.home .. '/.config/nvim'
    vim.g.sublime_text = vim.g.home .. '/.config/sublime-text-4/Packages/User'
end

_G.environment = {activate = '', parent = '', python = ''}

function walk(path)
    local parent = path

    if _G.environment.parent ~= '' and parent:find(_G.environment.parent, 1, true) == 1 then
        print('Reusing: ' .. _G.environment.python)
        return _G.environment.python, _G.environment.activate, _G.environment.parent
    end

    while parent do
        local activate
        local python

        if vim.g.os == 'windows' then
            activate = parent .. '/.venv/Scripts/activate.bat'
            python = parent .. '/.venv/Scripts/python.exe'
        else
            activate = parent .. '/.venv/bin/activate'
            python = parent .. '/.venv/bin/python'
        end

        if vim.loop.fs_stat(python) then
            print('Activating: ' .. python)
            _G.environment.activate = activate
            _G.environment.parent = parent
            _G.environment.python = python
            return python, activate, parent
        end

        local root = vim.fn.fnamemodify(parent, ':h')

        if root == parent then
            break
        end

        parent = root
    end

    print('No venv found')
    return nil, nil, nil
end

function set_python()
    local python, activate, parent = walk(vim.fn.expand('%:p:h'))

    if python == nil or activate == nil or parent == nil then
        parent = vim.g.parent
        python = vim.g.python
        activate = vim.g.activate
    end

    vim.g.activate = activate
    vim.g.parent = parent
    vim.g.python3_host_prog = python
    vim.g.python_host_prog = python
    vim.g.python = python

    vim.fn.setenv('PYTHONPATH', parent)
end

function autochdir()
    local buffer = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buffer)
    local parent = vim.fn.fnamemodify(name, ':h')

    vim.cmd('cd ' .. parent)

    vim.keymap.set(
        'n',
        '<Leader>t',
        function()
            local cmd = vim.g.terminal .. ' --working-directory "' .. parent .. '"'
            print(cmd)
            vim.fn.jobstart(cmd, { detach = false })
        end,
        { noremap = true, silent = true }
    )
end

vim.api.nvim_command('autocmd BufEnter * lua autochdir()')

vim.api.nvim_exec([[
    augroup python
       autocmd!
       autocmd BufEnter *.py lua set_python()
    augroup END
]], false)
