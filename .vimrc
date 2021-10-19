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

" filetype plugin indent on
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set colorcolumn=120
set splitright
" sets cwd to whatever file is in view.  Better omni-completion
" set autochdir

" Coc-nvim github settings
set updatetime=250
set shortmess+=c
set signcolumn=yes


" Allow backspace to remove indent and move between lines
set backspace=indent,eol,start

set showmatch

"set the color scheme
set background=dark
colorscheme base16-gruvbox-dark-soft
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

"FZF-VIM
"-------
" fzf file fuzzy search that respects .gitignore
" If in git directory, show only files that are committed, staged, or unstaged
" else use regular :Files
"nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

"GIT-FUGITIVE
"------------
"map leader-g to open git status window
map <leader>g :Gstatus<CR>

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
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

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

"COC-NVIM CONFIGURATION
"----------------------
"fun! InitCoc()
  "" Use <c-space> to trigger completion.
  "imap <silent><expr><C-space> coc#refresh()
  "" Use <cr> to confirm completion
  ""imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  ""imap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  ""inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              ""\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  "" Remap keys for gotos
  "nmap <silent> gd <Plug>(coc-definition)
  "nmap <silent> <Leader>r <Plug>(coc-references)
  "" Use K to show documentation in preview window
  "nmap <silent> K :call <SID>show_documentation()<CR>

  "function! s:show_documentation()
   "if (index(['vim','help'], &filetype) >= 0)
      "execute 'h '.expand('<cword>')
    "else
      "call CocAction('doHover')
    "endif
  "endfunction

  "" Renamp for rename current word
  "nmap <leader>rn <Plug>(coc-rename)
  "" Remap for do codeAction of current line
  "nmap <leader>ac  <Plug>(coc-codeaction)
  "" Fix autofix problem of current line
  "nmap <leader>qf  <Plug>(coc-fix-current)

  "" Format selected regions
  "xmap <leader>f  <Plug>(coc-format-selected)
  "nmap <leader>f  <Plug>(coc-format-selected)
  "autocmd CursorHold * silent call CocActionAsync('highlight')
"endfun

"fun! SetWorkspaceFolders() abort
  "" Only set g:WorkspaceFolders if it is not already set
  ""if exists("g:WorkspaceFolders") | return | endif
  "if executable("findup")
      "let l:ws_dir = trim(system("cd '" . expand("%:h") . "' && findup packageInfo"))
      "" Bemol conveniently generates a '$WS_DIR/.bemol/ws_root_folders' file, so let's leverage it
      "let l:folders_file = l:ws_dir . "/.bemol/ws_root_folders"
      "if filereadable(l:folders_file)
          "let l:ws_folders = readfile(l:folders_file)
          "let g:WorkspaceFolders = filter(l:ws_folders, "isdirectory(v:val)")
      "endif
  "endif
"endfun


lua << EOF
jdtls_setup = function()
    local root_dir = require('jdtls.setup').find_root({'packageInfo'}, 'Config')
    local home = os.getenv('HOME')
    local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ':p:h:t')

    local ws_folders_lsp = {}
    local ws_folders_jdtls = {}
    if root_dir then
        local file = io.open(root_dir .. "/.bemol/ws_root_folders", "r");
        if file then
            for line in file:lines() do
                table.insert(ws_folders_lsp, line);
                table.insert(ws_folders_jdtls, string.format("file://%s", line))
            end
            file:close()
        end
    end

    local config = {
        on_attach = on_attach,
        cmd = {'java-lsp.sh', eclipse_workspace},
        root_dir = root_dir,
        init_options = {
            workspaceFolders = ws_folders_jdtls,
        },
    }

    require('jdtls').start_or_attach(config)

    for _,line in ipairs(ws_folders_lsp) do
        vim.lsp.buf.add_workspace_folder(line)
    end
end
EOF

lua << EOF
metals_setup = function()
  local root_dir = require('jdtls.setup').find_root({'packageInfo'}, 'Config')
  local home = os.getenv('HOME')
  local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ':p:h:t')

  local ws_folders_lsp = {}
  local ws_folders_metals = {}
  if root_dir then
      local file = io.open(root_dir .. "/.bemol/ws_root_folders", "r");
      if file then
          for line in file:lines() do
              table.insert(ws_folders_lsp, line);
              table.insert(ws_folders_metals, string.format("file://%s", line))
          end
          file:close()
      end
  end

  metals_config = require'metals'.bare_config
  metals_config.settings = {
     showImplicitArguments = true,
  }
  metals_config.init_options = {
    workspaceFolders = ws_folders_metals,
  }

  require('metals').initialize_or_attach(metals_config)
  for _,line in ipairs(ws_folders_lsp) do
      vim.lsp.buf.add_workspace_folder(line)
  end
end
EOF

augroup lsp
    autocmd!
    autocmd FileType java luado jdtls_setup()
    autocmd FileType scala,sbt luado metals_setup()
augroup end

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
  "autocmd FileType java,javascript,javascriptreact,python,typescript,typescriptreact,scala :call InitCoc()
  "autocmd FileType java,python,scala :call InitCoc()
"augroup END


"augroup CocWS
  "autocmd!
  "autocmd FileType java :call SetWorkspaceFolders() :call SetWorkspaceFoldersLua()
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

if filereadable(expand("~/.vim/plugged/nvim-compe/plugin/compe.vim"))
  let g:compe = {}
  let g:compe.enabled = v:true
  let g:compe.autocomplete = v:true
  let g:compe.debug = v:false
  let g:compe.min_length = 1
  let g:compe.preselect = 'enable'
  let g:compe.throttle_time = 80
  let g:compe.source_timeout = 200
  let g:compe.resolve_timeout = 800
  let g:compe.incomplete_delay = 400
  let g:compe.max_abbr_width = 100
  let g:compe.max_kind_width = 100
  let g:compe.max_menu_width = 100
  let g:compe.documentation = v:true

  let g:compe.source = {}
  let g:compe.source.path = v:true
  let g:compe.source.buffer = v:true
  let g:compe.source.calc = v:true
  let g:compe.source.nvim_lsp = v:true
  let g:compe.source.nvim_lua = v:true

  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR>')
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
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
    let g:test#custom_runners = {'Java': ["braziltest"]}
    "let g:test#enabled_runners = ["java#braziltest"]
    let g:test#java#runner = "braziltest"
    "let test#java#maventest#executable = "brazil-build test"
    let g:test#strategy = "neovim"
endif
