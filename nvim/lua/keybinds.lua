local map = require('keymap')
local nnoremap = map.nnoremap
local vnoremap = map.vnoremap
local inoremap = map.inoremap
local xnoremap = map.xnoremap
local nmap = map.nmap

-- Close the current buffer, but keep the window open (requires vim-bufkill
-- extension)
nmap('<leader>d', ':bd<CR>')

-- List all open buffers
nmap('<leader>bb', ':buffers<CR>')

-- Open init.lua for editing
nmap('<leader>ev', ':e ~/.config/nvim/init.lua<CR>')

-- Tab navigation
nmap('<C-j>', 'gt')
nmap('<C-k>', 'gT')
