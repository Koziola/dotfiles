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
set updatetime=300
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

"map fzf to Ctrl-P
"map <C-p> :Files<CR>

" fzf file fuzzy search that respects .gitignore
" If in git directory, show only files that are committed, staged, or unstaged
" else use regular :Files
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

"map leader-g to open git status window
map <leader>g :Gstatus<CR>

"COC-NVIM CONFIGURATION
"----------------------
fun! InitCoc()
  " Use <c-space> to trigger completion.
  inoremap <silent><expr><C-space> coc#refresh()
  " Use <cr> to confirm completion
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> <Leader>r <Plug>(coc-references)
  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
   if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Renamp for rename current word
  nmap <leader>rn <Plug>(coc-rename)
  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Format selected regions
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)
endfun

"syntastic config
let g:syntastic_go_checkers = ['go']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"deoplete config
let g:deoplete#enable_at_startup = 1

fun! InitVimGo() 
  " Renamp for rename current word
  nmap <leader>rn <Plug>(go-rename)
  " Automatically import things
  nmap <leader>i <Plug>(go-imports)

endfun
" Choose completion engine
:call InitCoc()
autocmd FileType go :call InitVimGo()
"autocmd FileType java,ts,js,tsx :call InitCoc()
