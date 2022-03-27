local map = require('keymap')
local nmap = map.nmap

require ('fzf-lua').setup{
  fzf_opts = {
    ['--layout'] = 'reverse-list',
  },
  keymap = {
    fzf = {
      ['ctrl-d'] = 'half-page-down',
      ['ctrl-u'] = 'half-page-up',
    }
  }
}

nmap('<C-p>', "<cmd>lua require('fzf-lua').files()<CR>")
