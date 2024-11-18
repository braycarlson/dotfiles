vim.api.nvim_set_keymap(
    'n',
    '<Leader>d',
    ':Files ' .. vim.g.code .. '<CR>',
    {noremap = true}
)

vim.api.nvim_set_keymap(
    'n',
    '<Leader>f',
    ':Files ' .. vim.fn.expand('%:p:h') .. '<CR>',
    {noremap = true}
)

vim.api.nvim_set_keymap(
    'n',
    '<Leader>i',
    ':Files ' .. vim.g.home .. '/nvim' .. '<CR>',
    {noremap = true}
)

vim.api.nvim_set_keymap(
    'n',
    '<Leader>b',
    ':Buffers<CR>',
    {}
)

vim.api.nvim_set_keymap(
    'n',
    '<Leader>l',
    ':Lines<CR>',
    {}
)

if vim.fn.executable('rg') == 1 then
    vim.opt.grepprg = 'rg --no-heading --with-filename --line-number --column --smart-case'

    local ignore = {
	'__pycache__',
	'__init__.py',
	'_minted-*/',
	'*.egg-info/',
	'.git/',
	'.idea/',
	'.vscode/',
	'node_modules/',
	'.venv/',
	'venv/',
	'dist/',
	'coverage/',
	'build/',
	'target/',
	'*.log',
	'*.bak',
	'*.aux',
	'*.dvi',
	'*.fls',
	'*.out',
	'*.csv',
	'*.pdf',
	'*.pkl',
	'*.pickle',
	'*.ipynb',
	'*.dll',
	'*.srt',
	'*.png',
	'*.psd',
	'*.ora',
	'*.drawio',
	'*.jpg',
	'*.jpeg',
	'*.svg',
	'*.flac',
	'*.mp3',
	'*.mp4',
	'*.mkv',
	'*.wmv',
	'*.ts',
	'*.wav',
	'*.exe',
	'*.7z',
	'*.bat',
	'*.zip',
	'*.xlsx',
	'.DS_Store',
	'.Trash*/',
	'*.class',
	'*.lock',
	'*.pyc',
	'*.swp',
	'*.swo',
	'*.swn',
	'*.tmp',
	'*.iml',
	'*.db',
	'*.gem'
    }

    local ignore = vim.fn.join(vim.tbl_map(function(item)
        return string.format('--glob "!%s"', item)
    end, ignore), ' ')

    vim.fn.setenv('FZF_DEFAULT_COMMAND', 'rg --files --hidden --follow --no-ignore-vcs ' .. ignore)

    if not vim.fn.exists(':Rg') then
        vim.cmd('command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!')
        vim.api.nvim_set_keymap('n', '\\', ':Rg<SPACE>', {noremap = true})
    end
end

if vim.fn.has('nvim') and not vim.g.fzf_layout then
    vim.cmd([[
        autocmd! FileType
        autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
    ]])
end
