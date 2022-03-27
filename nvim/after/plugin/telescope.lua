local map = require('keymap')
local nmap = map.nmap
-- This is slow af for big repositories.  Using fzf-lua instead.
--nmap('<C-p>', ':Telescope find_files<CR>')
nmap('<leader>rg', ':Telescope live_grep<CR>')
nmap('<leader>bb', ':Telescope buffers<CR>')

--Configure esc to close the picker window.
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    path_display = {"smart"},
    file_ignore_patterns = {"build/*", "env/*", "release-info/*"}
  }
}
