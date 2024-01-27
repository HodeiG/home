    """""""""""""""""""""""""""""""""""""
" .vimrc (29/06/2013) by hodei
" 
" =============> READ <=============
"
" To set something off try this
" set relativenumber!
"
"""""""""""""""""""""""""""""""""""""
colorscheme candy

" http://stackoverflow.com/questions/1050640/vim-disable-automatic-newline-at-end-of-file
set noeol
set binary
set fileformats+=dos,unix,mac

set nocompatible

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME

syntax enable " Set syntax highlighting to always on

set nobackup

set noswapfile

"set tags=tags; " CTAGS ISSUE (http://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks)
"
" Open in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

set cursorline "highlight current line

set backspace=2 " I don't why, but if I don't put this, I can't delete new lines in insert mode

set completeopt=menuone,preview " muestra menú con opciones de auto completado y su documentación

set hlsearch " To highlight all search matches

set tabpagemax=50 " Maximum number of tabs that will be possible to open.

set relativenumber " Show the relative line number.

set number " This option with the above will also show the current line number as well

" :h cterm-colors
hi LineNr ctermfg=DarkYellow

set ignorecase " Ignore case when searching

set cpoptions+=ces$ " Add a dolar at the end of a string when editing it.

set autoindent " When a new line is started it gets the same indent as the previous line

set wildmenu " When opening a file using :e show a list of files

set infercase "When using completion in insert mode no ignorecase

set synmaxcol=200 "When using long xml lines, it goes slow the highlighting. This way vim will go faster

set wildignore=*.pyc " Ignore pyc files for command-t

" http://stackoverflow.com/questions/903934/unable-to-make-gray-eol-character-by-vimrc
" https://wincent.com/blog/making-vim-highlight-suspicious-characters
" https://codeyarns.com/2011/07/29/vim-chart-of-color-names/
" :h cterm-colors
set listchars=eol:$,tab:>>,trail:•
hi NonText ctermfg=DarkYellow
hi SpecialKey ctermfg=DarkYellow
set list

"Use 'set nolist' to disable special chars
"set nolist

set incsearch

set hidden " Unable to undo after changing between buffers

"filetype on "Set automatic filetype detection to on
filetype off                  " required

" Set colorcolumn to 80 characters
set colorcolumn=80
set textwidth=79

" Disable beep
set visualbell

call plug#begin()


" Plugins
Plug 'scrooloose/nerdtree'      " Load files <F2>
Plug 'scrooloose/nerdcommenter' " Comment out lines <leader>ci
Plug 'airblade/vim-gitgutter'   " Shows git modified lines
" jedi-vim needs vim to be compiled against python3
" The quickest way to get vim compiled with vim is to:
" $ apt-get install vim-nox
" Plugin 'davidhalter/jedi-vim'     " Python auto-complete
Plug 'tpope/vim-fugitive'       " Git commands such as Gblame
Plug 'vim-syntastic/syntastic'  " Python static analysis :w
Plug 'nvie/vim-flake8'          " Python static analysis <F7>
Plug 'rust-lang/rust.vim'       " Rust plugin
Plug 'nathangrigg/vim-beancount'   " Shows git modified lines
Plug 'psf/black'
" https://github.com/junegunn/fzf
" https://github.com/junegunn/fzf.vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required

" Initialize configuration dictionary
" See: https://github.com/junegunn/fzf/issues/238#issuecomment-104315812
let $FZF_DEFAULT_OPTS = '--bind "ctrl-j:down,ctrl-k:up,' .
    \ 'alt-j:preview-down,alt-k:preview-up,' .
    \ 'ctrl-u:page-up,ctrl-d:page-down" ' .
    \ '--layout reverse --border'

filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Source extra configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source tabs configuration
":so $HOME/.vim/source/tabs.vim
" Source automatic brackets
":so $HOME/.vim/source/automaticBrackets.vim
" Source automatic brackets
:so $HOME/.vim/source/statusLine.vim
" Source automatic autocomplete
":so $HOME/.vim/source/automaticAutocomplete.vim
" Source indentation
:so $HOME/.vim/source/indentation.vim
au BufNewFile,BufRead *.py set
    \ tabstop=4
    \ softtabstop=4
    \ shiftwidth=4
    \ textwidth=79
    \ expandtab
    \ autoindent
    \ fileformat=unix
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Some global mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quick scape
inoremap ,, <C-c><right>
" Quick scape from terminal
tnoremap ,, <C-\><C-n>
" Jump to the last modified line and column
nnoremap '. `.
" http://stackoverflow.com/questions/235839/how-do-i-indent-multiple-lines-quickly-in-vi
nnoremap  p ]p
" Break new line / opposite of join line (J)
nnoremap <c-j> i<Enter><Esc>
" vim search don't jump http://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap  * :keepjumps normal! mi*`i<CR>
" go to the first word and select it
" ^: jump to the first non-blank character of the line
nmap 0w 0^*
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and replace methods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
"http://stackoverflow.com/questions/1497958/how-to-use-vim-registers
" http://vim.wikia.com/wiki/Search_and_replace
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Substitute using the word under the cursor, yanked values
" deleted values and text written in insert-mode
nnoremap <c-s>w :%s/<c-r><c-w>/<c-r><c-w>/gc<Left><Left><Left>
nnoremap <c-s>y :%s/<c-r>0/<c-r>0/gc<Left><Left><Left>
nnoremap <c-s>d :%s/<c-r>"/<c-r>"/gc<Left><Left><Left>
nnoremap <c-s>i :%s/<c-r>./<c-r>./gc<Left><Left><Left>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Substitute methods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Substitute current word using yanked values
" deleted values and text written in insert-mode
" Uses black hole register("_) so "" register will not change
nnoremap sy viw"0p
nnoremap sd "_diwP
nnoremap si viw".P
" Swap 2 words
nnoremap sw "qdiwdwep"qp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Find methods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find yanked values deleted values and text written in 
" insert-mode
" Use * character to find the word under the cursor
nnoremap <c-f>y /<c-r>0
nnoremap <c-f>d /<c-r>"
nnoremap <c-f>i /<c-r>.
vnoremap <c-f> "hy/<c-r>h
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: NERTTree
" Description: Opens a menu to look for files to open.
nnoremap <F2> :NERDTreeToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: syntastic
" Description: Syntaxis checking plugin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['prospector']
let g:syntastic_python_checkers = ['python', 'flake8']
" let g:syntastic_python_checkers = ['python', 'flake8', 'pyflakes', 'pylint']
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: nerdcomment
" Description: Plugin to comment out lines
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUST related configurations
let g:rustfmt_autosave = 1

" Keep cursor position when switching buffers
if v:version >= 700
    au BufLeave * let b:winview = winsaveview()
    au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif
"pyfile $HOME/.vim/plugin/py_plugin.py
" tc) explanation
" Move to the previous buffer and then 'buffeer delete alternate file'
" http://stackoverflow.com/questions/4465095/vim-delete-buffer-without-losing-the-split-window
"
" Source buffer utils
:so $HOME/.vim/source/buffer_utils.vim
nnoremap tw :w<cr>
nnoremap tq :bd<cr>
nnoremap tc :bd!<cr>
nnoremap tt :buffer#<cr>
" buffer_utils: List buffers sorted by name
" nnoremap tl :Ls<cr>:b<left>
" FZF: Look for files under current directory
nnoremap ts :Files<CR>
" FZF: Find file in buffer
nnoremap tl :Buffer<CR>
" FZF: Command history
nnoremap th :History:<CR>
" FZF: Grep with ripgrep
" The below shortcut is using the FZF original grep call:
" @param1: The ripgrep command which uses '--' to find for a literal.
"          '--' can be replaced for '-w' to search for a exact word.
" @param2: The preview option
"
" As the user input must go 26 character to the left, an easy way to do it
" is to open the Find Mode (<C-F>) to see all the commands, move 26 chars to
" the left (26<Left>) and finally exit the Find Mode to go back to the Command
" prompt (<C-c>). Unfortunately the Find Mode stays opened, but it is a nice
" shortcut. See https://vi.stackexchange.com/a/21043
nnoremap tg :call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ", fzf#vim#with_preview())<C-F>26<Left><C-c>
nnoremap tn :bnext<cr>
nnoremap tp :bprevious<cr>
nnoremap to <c-w>f
nnoremap td :GcLog<CR>
nnoremap tb :Git blame<CR>
nnoremap t7 :call Rcs_status()<CR>
nnoremap te :execute 'edit' expand('%:p:h')<cr>

" To navigate in the quickfix window (.i.e: GcLog)
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" By default CommandT uses the PmenuSel color group.
" Hence modifying that group to change color. However it would be better if I
" could create a new color group and configure g:CommandTCursorColor
:hi PmenuSel ctermfg=White ctermbg=Blue cterm=Bold guifg=White guibg=DarkBlue gui=Bold
if &term =~ "xterm" || &term =~ "screen"
    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

"Use gf to open the file under curson into a new buffer

" Create global variable for find_pattern, so we don't have to specify it every time
let g:find_pattern='*'
autocmd BufNewFile,BufRead *.py let g:find_pattern='*.py'


"http://stackoverflow.com/questions/2414626/vim-unsaved-buffer-warning
nnoremap <F5> :exe ":set hidden \| :Ex"<CR>

set runtimepath+=~/.vim/bundle/jshint2.vim/