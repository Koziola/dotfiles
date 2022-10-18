local map = require('keymap')
local nmap = map.nmap
local tnoremap = map.tnoremap

nmap('<leader>tt', ':FloatermNew!<CR>')
nmap('<leader>th', ':FloatermToggle<CR>')
nmap('<leader>tp', ':FloatermPrev<CR>')
nmap('<leader>tn', ':FloatermNext<CR>')
nmap('<leader>tk', ':FloatermKill<CR>')

tnoremap('<S-z', '<C-\\><C-n>')

