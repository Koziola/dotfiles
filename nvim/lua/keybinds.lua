local map = require('keymap')
local nnoremap = map.nnoremap
local vnoremap = map.vnoremap
local inoremap = map.inoremap
local xnoremap = map.xnoremap
local nmap = map.nmap
local tnoremap = map.tnoremap

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

-- Lsp Stuff
nmap('gd', ':lua vim.lsp.buf.definition()<CR>')
nmap('gi', ':lua vim.lsp.buf.implementation()<CR>')
nmap('<leader>k', ':lua vim.lsp.buf.signature_help()<CR>')
nmap('<leader>h', ':lua vim.lsp.buf.hover()<CR>')
nmap('<leader>r', ':lua vim.lsp.buf.references()<CR>')
nmap('<leader>rn', ':lua vim.lsp.buf.rename()<CR>')
nmap('<leader>ac', ':lua vim.lsp.buf.code_action()<CR>')
nmap('<leader>sd', ':lua vim.diagnostic.open_float()<CR>')

nmap('<leader>xx', '<cmd>TroubleToggle<CR>')
nmap('<leader>xq', '<cmd>TroubleToggle quickfix<CR>')

-- Use esc to escape terminal mode
tnoremap('<S-z>', '<C-\\><C-n>')
