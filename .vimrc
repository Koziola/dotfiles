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
set updatetime=50
set shortmess+=c
set signcolumn=yes


" Allow backspace to remove indent and move between lines
set backspace=indent,eol,start

set showmatch
"set the color scheme
colo gruvbox
set background=dark

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

"FZF-VIM
"-------
" fzf file fuzzy search that respects .gitignore
" If in git directory, show only files that are committed, staged, or unstaged
" else use regular :Files
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

"GIT-FUGITIVE
"------------
"map leader-g to open git status window
map <leader>g :Gstatus<CR>

"ALE CONFIG
"----------
let g:ale_linters = { 'java': []}

"PRETTIER_CONFIG
"---------------
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0

""COC-NVIM CONFIGURATION
""----------------------
"fun! InitCoc()
  "" Use <c-space> to trigger completion.
  "inoremap <silent><expr><C-space> coc#refresh()
  "" Use <cr> to confirm completion
  "inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  "inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  "" Remap keys for gotos
  "nmap <silent> gd <Plug>(coc-definition)
  "nmap <silent> <Leader>r <Plug>(coc-references)
  "" Use K to show documentation in preview window
  "nnoremap <silent> K :call <SID>show_documentation()<CR>

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
"endfun

"fun! InitVimGo() 
  "" Renamp for rename current word
  "nmap <leader>rn <Plug>(go-rename)
  "" Automatically import things
  "nmap <leader>i <Plug>(go-imports)
  "" Describe selected syntax
  ""imap <leader>, <Plug>(go-info)
  "nmap <leader>, <Plug>(go-info)
  "let g:go_imports_autosave = 1
  "let g:go_doc_popup_window = 1
  "inoremap <C-space> <C-x><C-o>
  "set noshowmode
"endfun

"" Choose completion engine
"augroup LSP
  "autocmd!
  "autocmd FileType go :call InitVimGo()
  "autocmd FileType java,typescript,javascript :call InitCoc()
"augroup END

"NEOVIM LSP CLIENT CONFIG
"------------------------
if filereadable(expand("~/.vim/plugged/nvim-lspconfig/plugin/nvim_lsp.vim"))
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
  "let g:completion_enable_auto_popup = 0
  lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
  lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }

  "inoremap <C-v> <Plug>(completion-trigger)
  "inoremap <C-@> <C-Space>
  "imap <silent><expr><C-space> <Plug>(completion-trigger)
  "imap <tab> <Plug>(completion_smart_tab)
  nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nmap gi :lua vim.lsp.buf.implementation()<CR>
  nmap <leader>k :lua vim.lsp.buf.signature_help()<CR>
  nmap <silent> <leader>r :lua vim.lsp.buf.references()<CR>
  nmap <leader>rn :lua vim.lsp.buf.rename()<CR>
  nmap <leader>h :lua vim.lsp.buf.hover()<CR>
  nmap <leader>ac :lua vim.lsp.buf.code_action()<CR>
  nmap <leader>sd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
  set completeopt=menuone,noinsert,noselect
endif
