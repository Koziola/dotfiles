" Call the .vimrc.plug file
source ~/.vimrc.plug


"VANILLA VIM SETTINGS
"-------------------

" Set compatibility to Vim only
set nocompatible
set number

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
let mapleader=" "

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
map <C-p> :Files<CR>

"map leader-g to open git status window
map <leader>g :Gstatus<CR>

""COC-NVIM CONFIGURATION
""----------------------
"" Use <c-space> to trigger completion.
"inoremap <silent><expr><C-c> coc#refresh()
"" Use <cr> to confirm completion
"" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gr <Plug>(coc-references)
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


"YCM Configuration
"-----------------
set rtp+=~/.vim/plugged/youcompleteme
nnoremap <silent>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>ac :YcmCompleter FixIt<CR>
nnoremap <silent> <Leader>k :YcmCompleter GetDoc<CR>
nnoremap <silent> <Leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <silent> <Leader>rn :YcmCompleter RefactorRename
" Turn off automatic completion (need to use Ctrl-space to trigger it)
"let g:ycm_auto_trigger=0
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
