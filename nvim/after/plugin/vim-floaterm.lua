local map = require('keymap')
local nmap = map.nmap
local tnoremap = map.tnoremap

nmap('<leader>tt', ':FloatermNew!')
nmap('<leader>th', ':FloatermToggle')
nmap('<leader>tp', ':FloatermPrev')
nmap('<leader>tn', ':FloatermNext')
nmap('<leader>tk', ':FloatermKill')

tnoremap('<S-z', '<C-\\><C-n>')

