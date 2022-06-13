" Call the .vimrc.plug file
source ~/.vimrc.plug


"VANILLA VIM SETTINGS
"-------------------

" Set compatibility to Vim only
set nocompatible
set number relativenumber
set nu rnu

" Allow hidden buffers (buffers that haven't been saved)
set hidden

set guicursor

" filetype plugin indent on
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set colorcolumn=120
set splitright

" Coc-nvim github settings
set updatetime=200
set shortmess+=c
set shortmess-=F
set signcolumn=yes

" Allow backspace to remove indent and move between lines
set backspace=indent,eol,start

set showmatch

"set the color scheme
set background=dark
"colorscheme base16-gruvbox-dark-soft
colorscheme base16-tomorrow-night
set termguicolors

" Set leader key to spacebar vim
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" Keymap to go to previous buffer
" Note: the <CR> in the keymaps inserts a carriage return, which in most cases
" actually executes the command
map <leader><TAB> :bp<CR>

" Close the current buffer
map <leader>d :bd<CR>

" Close the current buffer, but keep the window open (requires vim-bufkill
" extension)
map <leader>D :BD<CR>

" List all open buffers
map <leader>bb :buffers<CR>

" Reload the current buffer from the file system
map <leader>r :e<CR>

" Open vimrc for editing
map <leader>ev :e ~/.vimrc<CR>

" <C-^> is to hop back to the last buffer.  Since it's also a mosh shortcut,
" rebinding it to <C-b> which is also more ergonomic.
map <C-b> <C-^>

"Swap file location
set directory^=$HOME/.vim/swap//

"PLUGIN CONFIGURATION
"--------------------

" Keymap to open NERDTree
map <leader>ft :NERDTreeToggle<CR>
" Keymap to open NERDTree with the current file automatically selected.
map <leader>fT :NERDTreeFind<CR>
" Focus NERDTree
map <leader>t :NERDTreeFocus<CR>
let NERDTREEIGNORE = ['/*.git*', '.DS_STORE']
let NERDTreeShowHidden=1

"GIT-FUGITIVE
"------------
"map leader-g to open git status window
map <leader>g :Git<CR>

"ALE CONFIG
"----------
let g:ale_linters = { 'java': []}
let g:ale_set_highlights = 0
let g:ale_set_signs = 1
let g:ale_sign_error = '✘'
let g:ale_sign_style_error = 'E'
let g:ale_sign_style_warning = 'W'

"PRETTIER_CONFIG
"---------------
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

"FLOATING TERMINAL WINDOW CONFIG
"-------------------------------
if filereadable(expand("~/.vim/plugged/vim-floaterm/plugin/floaterm.vim"))
   nmap <leader>tt :FloatermNew! fish<CR>
   nmap <leader>th :FloatermToggle<CR>
   nmap <leader>tp :FloatermPrev<CR>
   nmap <leader>tn :FloatermNext<CR>
   nmap <leader>tk :FloatermKill<CR>
   "Use esc to escape terminal mode
   tnoremap <S-z> <C-\><C-n>
endif

"AIRLINE CONFIG
if filereadable(expand("~/.vim/plugged/vim-airline/plugin/airline.vim"))
  let g:airline_theme = "bubblegum"
  let g:airline_section_y = ""
  let g:airline_section_warning = ""
  let g:airline_section_z = ""
  let g:airline_skip_empty_sections = 1
endif

"fun! InitVimGo()
  "" Renamp for rename current word
  "nmap <leader>rn <Plug>(go-rename)
  "" Automatically import things
  "nmap <leader>i <Plug>(go-imports)
  "" Describe selected syntax
  ""imap <leader>, <Plug>(go-info)
  "nmap <leader>, <Plug>(go-info)
  "nmap <leader>r <Plug>(go-referrers)
  "let g:go_imports_autosave = 1
  "let g:go_doc_popup_window = 1
  "inoremap <C-space> <C-x><C-o>
  "set noshowmode
"endfun

" Choose completion engine
"augroup LSP
  "autocmd!
  "autocmd FileType go :call InitVimGo()
"augroup END


"NEOVIM LSP CLIENT CONFIG
"------------------------
if filereadable(expand("~/.vim/plugged/nvim-lspconfig/plugin/lspconfig.vim"))
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
  "let g:completion_enable_auto_popup = 0
  lua vim.lsp.set_log_level("info")
lua <<EOF
  lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    on_attach=require'completion'.on_attach,
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
EOF

  lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }

  "imap <silent> <C-Space> <Plug>(completion_trigger)
  "imap <tab> <Plug>(completion_smart_tab)
  nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nmap gi :lua vim.lsp.buf.implementation()<CR>
  nmap <leader>k :lua vim.lsp.buf.signature_help()<CR>
  nmap <silent> <leader>r :lua vim.lsp.buf.references()<CR>
  nmap <leader>rn :lua vim.lsp.buf.rename()<CR>
  nmap <leader>h :lua vim.lsp.buf.document_highlight()<CR>
  nmap <leader>ac :lua vim.lsp.buf.code_action()<CR>
  nmap <leader>sd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  nmap <leader>wl :lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
  set completeopt=menuone,noinsert,noselect

endif

if filereadable(expand("~/.vim/plugged/nvim-cmp/plugin/cmp.lua"))
  lua << EOF
  local cmp = require'cmp'
  cmp.setup({
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
   -- require('lspconfig')['jdtls'].setup {
         -- capabilities = capabilities
         -- }
EOF

endif

if filereadable(expand("~/.vim/plugged/nvim-jdtls/plugin/nvim_jdtls.vim"))
  nnoremap <leader>ac <Cmd>lua require('jdtls').code_action()<CR>
  vnoremap <leader>ac <Esc><Cmd>lua require('jdtls').code_action(true)<CR>
endif

"TELESCOPE CONFIG
"----------------
if filereadable(expand("~/.vim/plugged/telescope.nvim/plugin/telescope.vim"))
  nnoremap <C-p> :lua require'telescope.builtin'.find_files{}<cr>
  nnoremap <leader>rg <cmd>Telescope live_grep<cr>
  nnoremap <leader>bb <cmd>Telescope buffers<cr>
  "Configure esc to close the picker window.
  lua << EOF
  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close
        },
      },
      path_display = {"shorten"},
      file_ignore_patterns = {"build/*", "env/*", "release-info/*"}
    }
  }
EOF
endif

"TREESITTER CONFIG
"-----------------
if filereadable(expand("~/.vim/plugged/nvim-treesitter/plugin/nvim-treesitter.vim"))
    lua << EOF
        require'nvim-treesitter.configs'.setup {
        -- Modules and its options go here
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        }
EOF
endif

if filereadable(expand("~/.vim/plugged/vimspector/plugin/vimspector.vim"))
  nnoremap <leader>c :call vimspector#Continue()<cr>
  nnoremap <leader>i :call vimspector#StepInto()<cr>
  nnoremap <leader>o :call vimspector#StepOver()<cr>
  nnoremap <leader>u :call vimspector#StepOut()<cr>
  nnoremap <leader>q :VimspectorReset<cr>
  nnoremap <leader>tb :call vimspector#ToggleBreakpoint()<cr>
endif

if filereadable(expand("~/.vim/plugged/vim-test/plugin/test.vim"))
    let g:test#strategy = "floaterm"
endif

if filereadable(expand("~/.vim/plugged/feline.nvim/USAGE.md"))
    lua require('feline').setup()
endif

if filereadable(expand("~/.vim/plugged/vim-test/plugin/test.vim"))
    let g:test#strategy = "floaterm"
endif
