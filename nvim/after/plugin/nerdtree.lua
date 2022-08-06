local map = require('keymap')
local nmap = map.nmap
-- NERDTree
nmap('<leader>ft', ':NERDTreeToggle<CR>')
nmap('<leader>fT', ':NERDTreeFind<CR>')
nmap('<leader>t', ':NERDTreeFocus<CR>')

vim.g.NERDTREEIGNORE = {'/*.git*', '.DS_STORE'}
vim.g.NERDTreeShowHidden = 1
