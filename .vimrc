" Call the .vimrc.plug file
source ~/.vimrc.plug


"VANILLA VIM SETTINGS
"-------------------

" Set compatibility to Vim only
set nocompatible
set number

" Allow hidden buffers (buffers that haven't been saved)
set hidden

filetype plugin indent on
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set colorcolumn=80
" sets cwd to whatever file is in view.  Better omni-completion
set autochdir

" Allow backspace to remove indent and move between lines
set backspace=indent,eol,start
" 2 space TAB for YAML files
autocmd Filetype yaml setlocal shiftwidth=2 softtabstop=2 expandtab

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

" List all open buffers
map <leader>bb :buffers<CR>

"Swap file location
set directory^=$HOME/.vim/swap//

"PLUGIN CONFIGURATION
"--------------------

" Keymap to open NERDTree
map <leader>ft :NERDTreeToggle<CR>
" Keymap to open NERDTree with the current file automatically selected.
map <leader>fT :NERDTreeFind<CR>
" Keymap to go to definition
"map <C-b> :YcmCompleter GoTo<CR>

"Ctrl-P definition
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

"map fzf to Ctrl-P
map <C-p> :Files<CR>


"java Lombok support
let $JAVA_TOOL_OPTIONS="-javaagent:/Users/adamkoz/lombok/lombok.jar -Xbootclasspath/p:/Users/adamkoz/lombok/lombok.jar"

"COC-NVIM CONFIGURATION
"----------------------
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
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
