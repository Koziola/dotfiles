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
colorscheme gruvbox
"colorscheme base16-tomorrow-night
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

" Tab navigation - wonder why 'C-[' and 'C-]' don't work...
nnoremap <C-j> gt 
nnoremap <C-k> gT

"Swap file location
set directory^=$HOME/.vim/swap//

"=======================================
"PLUGIN CONFIGURATION
"=======================================

"NERDTREE
"--------
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
if isdirectory(expand("~/.vim/plugged/vim-floaterm"))
   nmap <leader>tt :FloatermNew! fish<CR>
   nmap <leader>th :FloatermToggle<CR>
   nmap <leader>tp :FloatermPrev<CR>
   nmap <leader>tn :FloatermNext<CR>
   nmap <leader>tk :FloatermKill<CR>
   "Use esc to escape terminal mode
   tnoremap <S-z> <C-\><C-n>
endif

"AIRLINE CONFIG
if isdirectory(expand("~/.vim/plugged/vim-airline"))
  let g:airline_theme = "bubblegum"
  let g:airline_section_y = ""
  let g:airline_section_warning = ""
  let g:airline_section_z = ""
  let g:airline_skip_empty_sections = 1
endif

"NEOVIM LSP CLIENT CONFIG
"------------------------
if isdirectory(expand('~/.vim/plugged/nvim-lspconfig'))
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
  "let g:completion_enable_auto_popup = 0
lua <<EOF
  vim.lsp.set_log_level('info')
  lspconfig = require 'lspconfig'
  completion = require 'cmp_nvim_lsp'
  lsp_status = require 'lsp-status'
  null_ls = require 'null-ls'
  require('trouble').setup()

  local completion_capabilities = completion.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local custom_capabilities = {}
  table.insert(custom_capabilities, lsp_status.capabilities)
  table.insert(custom_capabilities, completion_capabilities)

  local custom_on_attach = function(client)
    -- completion.on_attach(client)
    lsp_status.on_attach(client)
  end

  lspconfig.gopls.setup {
    on_attach=custom_on_attach,
    capabilities=custom_capabilities,
    cmd = {'gopls', 'serve'},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
  lspconfig.tsserver.setup {
    cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
    filetypes = { "typescript", "typescriptreact", "typescript.tsx"},
    init_options = {
      maxTsServerMemory = "8192", -- 8gb of RAM to the lsp server
    },
    on_attach=function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      -- on_attach(client, bufnr)
      custom_on_attach(client, bufnr)
    end,
    capabilities=custom_capabilities
  }
  -- lspconfig.tsserver.setup{coq.lsp_ensure_capabilities()}

  null_ls.setup{
      sources = {
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.formatting.prettier
      },
      on_attach=on_attach
  }
EOF

  "imap <silent> <C-Space> <Plug>(completion_trigger)
  "imap <tab> <Plug>(completion_smart_tab)
  nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nmap gi :lua vim.lsp.buf.implementation()<CR>
  nmap <leader>k :lua vim.lsp.buf.signature_help()<CR>
  nmap <leader>h :lua vim.lsp.buf.hover()<CR>
  nmap <silent> <leader>r :lua vim.lsp.buf.references()<CR>
  nmap <leader>rn :lua vim.lsp.buf.rename()<CR>
  nmap <leader>h :lua vim.lsp.buf.hover()<CR>
  nmap <leader>ac :lua vim.lsp.buf.code_action()<CR>
  nmap <leader>sd :lua vim.diagnostic.open_float()<CR>
  nmap <leader>wl :lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
  set completeopt=menuone,noinsert,noselect

  nnoremap <leader>xx <cmd>TroubleToggle<cr>
  nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>

endif

"if isdirectory(expand("~/.vim/plugged/null-ls.nvim"))
  "lua << EOF
  "local null_ls = require('null-ls')
  "null_ls.setup({
    "sources = {
      "null_ls.builtins.formatting.prettier,
      "null_ls.builtins.diagnostics.eslint,
      "null_ls.builtins.code_actions.eslint,
      "null_ls.builtins.completion.spell,
    "},
  "})
"EOF
"end

if isdirectory(expand("~/.vim/plugged/nvim-cmp"))
  lua << EOF
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
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
      ['<C-n>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {"i", "s"}),
      ['<C-p>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {"i", "s"}),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    }, {
      { name = 'path' }
    })
  })


  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'buffer'}})
  })
EOF
endif

"TELESCOPE CONFIG
"----------------
if isdirectory(expand("~/.vim/plugged/telescope.nvim"))
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
if isdirectory(expand("~/.vim/plugged/nvim-treesitter"))
    lua << EOF
        require'nvim-treesitter.configs'.setup {
        -- Modules and its options go here
        highlight = { enable = true },
        incremental_selection = { enable = true },
        -- textobjects = { enable = true },
        indent = { enable = true },
        }
EOF
endif

if isdirectory(expand("~/.vim/plugged/vimspector"))
  nnoremap <leader>c :call vimspector#Continue()<cr>
  nnoremap <leader>i :call vimspector#StepInto()<cr>
  nnoremap <leader>o :call vimspector#StepOver()<cr>
  nnoremap <leader>u :call vimspector#StepOut()<cr>
  nnoremap <leader>q :VimspectorReset<cr>
  nnoremap <leader>tb :call vimspector#ToggleBreakpoint()<cr>
endif

if isdirectory(expand("~/.vim/plugged/feline.nvim"))
  lua << EOF
  local lsp_status = require('lsp-status')

  lsp_status.config {
    indicator_errors = "E",
    indicator_warnings = "W",
    indicator_info = "i",
    indicator_hint = "?",
    indicator_ok = "OK",
    current_function = false,
  }

  local components = {
      -- left, middle, right sections
      active = {{}, {}, {}},
      inactive = {{}, {}, {}}
  }

  local vim_mode_component = {
    provider = 'vi_mode',
    hl = function()
    return {
        name = require('feline.providers.vi_mode').get_mode_highlight_name(),
        fg = require('feline.providers.vi_mode').get_mode_color(),
        style = 'bold'
    }
    end,
  }

  local file_info_component = {
    provider = {
        name = 'file_info',
        opts = {
            type = 'full-path'
        }
    },
    short_provider = {
        name = 'file_info',
        opts = {
            type = 'short-path'
        }
    }
  }

  local lsp_client_component = {
    provider = function()
      lsp_status.register_progress()
      return lsp_status.status()
    end
  }

  table.insert(components.active[1], vim_mode_component)
  table.insert(components.active[1], file_info_component)
  table.insert(components.active[3], lsp_client_component)

  table.insert(components.inactive[1], file_info_component)

  require('feline').setup({
    components = components
  })
EOF
endif

if isdirectory(expand("~/.vim/plugged/vim-test"))
  let g:test#strategy = "neovim"
endif

if filereadable(expand("~/.vim/plugged/vim-test/plugin/test.vim"))
  nmap <silent> <leader>T :TestNearest<CR>
  nmap <silent> <leader>t :TestFile<CR>
  nmap <silent> <leader>l :TestLast<CR>

  " don't clear the screen and lose test run results
  let g:test#preserve_screen = 1

  let test#custom_runners = { 'ruby': ['payserver'], 'javascript': ['payserver'] }
  let test#enabled_runners = ['ruby#payserver', 'javascript#payserver']
endif

if filereadable(expand("~/.vim/plugged/fzf.vim/README.md"))
  nnoremap <C-p> :GFiles<CR>
endif

if filereadable(expand("~/.vim/plugged/nvim-lspconfig-stripe/README.md"))
  lua << EOF
  lspconfig = require ("lspconfig")
  require("lspconfig_stripe")
  -- local coq = require "coq"
  lspconfig.payserver_sorbet.setup({})
  -- lspconfig.payserver_sorbet.setup(coq.lsp_ensure_capabilities({}))
EOF
endif

if filereadable(expand("~/.vim/plugged/ack.vim/README.md"))
  let g:ackprg = 'rg --vimgrep --smart-case'
  nnoremap <leader>rg :Ack!<Space>
  " Any empty ack search will search for the work the cursor is on
  let g:ack_use_cword_for_empty_search = 1
  " Don't jump to first match
  cnoreabbrev Ack Ack!
endif

if filereadable(expand("~/.vim/plugged/indent-blankline.nvim/README.md"))
  lua << EOF
  require("indent_blankline").setup {
    char = "",
    -- context_char = "║",
    context_char = "|",
    show_current_context = true,
    space_char_blankline = " ",
    use_treesitter = true,
  }
EOF
  highlight IndentBlanklineContextChar guifg=#656565 gui=nocombine
endif
