vim.opt.fileformat = 'unix'

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cmdheight = 2

vim.opt.mouse = 'a'

vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.history = 1000
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = {
    trail = '·',
    nbsp = '␣',
    space = '⋅',
    tab = '•••',
    eol = '↴',
}

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 5

vim.opt.foldenable = true
vim.opt.foldcolumn = 'auto'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevel = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.fillchars = {
    eob = ' ',
    fold = ' ',
    foldopen = '',
    foldsep = ' ',
    foldclose = '',
}
vim.opt.statuscolumn = '%=%{v:relnum?v:relnum:v:lnum} %s%C '
vim.opt.conceallevel = 2

vim.opt.hlsearch = true
