local opt = vim.opt
opt.number = true
opt.rnu = true
opt.relativenumber = true
opt.hidden = true

opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.wrap = false
opt.colorcolumn = '120'
opt.splitright = true

opt.updatetime=200
opt.shortmess:append('c')
opt.shortmess:remove('F')
opt.signcolumn='yes'

opt.backspace= {'indent', 'eol', 'start'}

opt.showmatch = true

opt.completeopt = {'menu', 'fuzzy', 'noselect'}

opt.swapfile = false

-- vim.cmd('nnoremap <SPACE> <nop>')
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('deps-lazy')
require('keybinds')

opt.background = 'light'
opt.termguicolors = true
vim.cmd("colorscheme dayfox")
