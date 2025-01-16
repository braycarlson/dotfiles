-- Set leader to comma
vim.g.mapleader = ','

-- The character encoding in Neovim
vim.opt.encoding = 'utf-8'

vim.g.loaded_netrw = 1

vim.g.loaded_netrwPlugin = 1

-- Do not make a backup before overwriting a file
vim.opt.backup = false

-- Do not make a backup before overwriting a file
vim.opt.writebackup = false

-- Do not use a swap file (which allows you to recover changes in case of a crash)
vim.opt.swapfile = false

-- Store 'x' amount of commands and search patterns
vim.opt.history = 1000

-- Allow incremental searching; showing new results for each key press.
vim.opt.incsearch = true

-- Enable write to file before running specific commands
vim.opt.autowrite = true

-- Set the maximum limit of folds
vim.opt.foldnestmax = 3

-- Disable fold by default
vim.opt.foldenable = false

-- A buffer is hidden when it is abandoned
vim.opt.hidden = true

-- The time in milliseconds that a swap file is written to disk
vim.opt.updatetime = 300

-- When and how to draw the signcolumn
vim.opt.signcolumn = 'yes'

-- Use the system clipboard
vim.opt.clipboard = 'unnamedplus'

vim.o.whichwrap = vim.o.whichwrap .. '<,>,h,l,[,]'

-- Use the current line's indentation when starting a new line
vim.opt.autoindent = true

-- Enable automatic C program indenting
vim.opt.cindent = true

-- Enable spell check
vim.opt.spell = true

-- Set shift width
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Show filename in window title
vim.opt.title = true

vim.opt.number = true

vim.opt.relativenumber = true

-- Define backup directory
vim.opt.backupdir = vim.g.backup
vim.opt.backupskip = vim.g.backup
vim.opt.directory = vim.g.backup
vim.opt.undodir = vim.g.backup

vim.cmd('autocmd BufEnter * silent! lcd %:p:h')
