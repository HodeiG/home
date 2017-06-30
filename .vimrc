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

set tags=tags; " CTAGS ISSUE (http://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks)
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

set ignorecase " Ignore case when searching

set cpoptions+=ces$ " Add a dolar at the end of a string when editing it.

set autoindent " When a new line is started it gets the same indent as the previous line

set wildmenu " When opening a file using :e show a list of files

set infercase "When using completion in insert mode no ignorecase

set synmaxcol=200 "When using long xml lines, it goes slow the highlighting. This way vim will go faster

set listchars=eol:$,tab:>>,trail:- "http://stackoverflow.com/questions/903934/unable-to-make-gray-eol-character-by-vimrc
hi NonText ctermfg=7 guifg=gray
hi SpecialKey ctermfg=7 guifg=gray

set list

set incsearch

set hidden " Unable to undo after changing between buffers

filetype on "Set automatic filetype detection to on

filetype plugin on
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
" Source escape
if $USER == 'wome'
    :so $HOME/.vim/source/escape_n.vim
else
    :so $HOME/.vim/source/escape_semicolon.vim
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Some global mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap , :
" Jump to the last modified line and column
nnoremap '. `.
" http://stackoverflow.com/questions/235839/how-do-i-indent-multiple-lines-quickly-in-vi
nnoremap  p ]p
" Break new line / opposite of join line (J)
nnoremap <c-j> i<Enter><Esc>
" vim search don't jump http://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap  * :keepjumps normal! mi*`i<CR>
" go to the first word and select it
nmap 0w 0w*
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search and replace methods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
"http://stackoverflow.com/questions/1497958/how-to-use-vim-registers
" http://vim.wikia.com/wiki/Search_and_replace
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Substitute using the word under the cursor, yanked values
" deleted values and text written in insert-mode
nnoremap <c-b>w :%s/<c-r><c-w>/<c-r><c-w>/gc<Left><Left><Left>
nnoremap <c-b>y :%s/<c-r>0/<c-r>0/gc<Left><Left><Left>
nnoremap <c-b>d :%s/<c-r>"/<c-r>"/gc<Left><Left><Left>
nnoremap <c-b>i :%s/<c-r>./<c-r>./gc<Left><Left><Left>
vnoremap <c-b> "hy:%s/<c-r>h/<c-r>h/gc<Left><Left><Left>
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
" Plugin: python_fold
" Description: Open and close folds.
" Open recursively
nnoremap <space><space> :call UnFoldRecursively()<CR>
" Open all
nnoremap <space>a :call UnFoldAll()<CR>
" One level
nnoremap <space>1 :call UnFoldOneLevel()<CR>
" Open recursively
" nnoremap <space>r :call UnFoldRecursively()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: NERTTree
" Description: Opens a menu to look for files to open.
nnoremap <F2> :NERDTreeToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: TlistToggle
" Description: Opens a menu which lists all the functions
" and classes
nnoremap <F3> :TlistToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: Indent Guides
" Web: http://www.vim.org/scripts/script.php?script_id=3361
nnoremap <F4> :IndentGuidesToggle<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: Toggle paste without autoindent
" - Start insert mode.
" - Press F6 (toggles the 'paste' option on) or (:set paste)
" - Use your terminal to paste text from the clipboard.
" - Press F6 (toggles the 'paste' option off) or (:set nopaste)
" set pastetoggle=F6
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: pydiction
" Usage: In insert mode use TAB to complete a word.
let g:pydiction_location = '~/.vim/dictionary/py-dict'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: pythoncomplete
" Usage: <c-x><c-o>
" Info: :h i_Ctrl-X
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://blog.motane.lu/2009/05/25/vim-and-python/

" Keep cursor position when switching buffers
if v:version >= 700
    au BufLeave * let b:winview = winsaveview()
    au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif
"pyfile $HOME/.vim/plugin/py_plugin.py
" tc) explanation
" Move to the previous buffer and then 'buffeer delete alternate file'
" http://stackoverflow.com/questions/4465095/vim-delete-buffer-without-losing-the-split-window
nnoremap tw :w<cr>
nnoremap tq :bd<cr>
nnoremap tc :bd!<cr>
nnoremap tt :buffer#<cr>
nnoremap tl :ls<cr>:b<left>
nnoremap tn :bnext<cr>
nnoremap tp :bprevious<cr>
nnoremap to <c-w>f 
"Use gf to open the file under curson into a new buffer

" Create global variable for find_pattern, so we don't have to specify it every time
let g:find_pattern='*'

"nnoremap t1 :call Ack("-Hn","")<left><left>
"nnoremap t0 :exe 'normal "ayiw' \| echo <c-r>=@a<cr>
"nnoremap  t0 :exe 'normal "ayiw' \| exe ":call Test({'find_opts': '. -type f -path', 'grep_opts': '-Hn', 'grep_pattern': '".@a"', 'find_pattern': '<c-r>=g:find_pattern<cr>'})"
"nnoremap  t" :exe 'normal ""yiw' \| :exe 't0'
nnoremap t1 :call Ack2({'find_opts': '. -type f -path', 'grep_opts': '-Hn', 'find_pattern': '<c-r>=g:find_pattern<cr>', 'grep_pattern': ''})<left><left><left>
"nnoremap t2 :call Ack_cursor("-Hn")<CR>
"nnoremap t2 :call Ack_cursor2({'find_opts': '. -type f -path', 'grep_opts': '-Hn'})
"nnoremap  t2 :exe 'normal "ayiw' \| exe ":call Ack2({'find_opts': '. -type f -path', 'grep_opts': '-Hn', 'grep_pattern': '".@a"', 'find_pattern': '<c-r>=g:find_pattern<cr>'})"
nnoremap t2 :echo "Deprecated"<cr>
"nnoremap t3 :call Ack_yvalue("-Hn")<CR>
"nnoremap t3 :call Ack_yvalue2({'find_opts': '. -type f -path', 'grep_opts': '-Hn'})
nnoremap t3 :call Ack2({'find_opts': '. -type f -path', 'grep_opts': '-Hn', 'find_pattern': '<c-r>=g:find_pattern<cr>', 'grep_pattern': '<c-r>=@"<cr>'})
"nnoremap t4 :call Find("")<left><left>
nnoremap t4 :call Find2({'find_opts': '. -type f -path', 'find_pattern': '*'})<left><left><left>
"nnoremap t5 :call Find_cursor()<CR>
nnoremap t5 :echo "Deprecated"<cr>
"nnoremap t6 :call Find_yvalue()<CR
nnoremap t6 :call Find2({'find_opts': '. -type f -path', 'find_pattern': '<c-r>=@"<cr>'})
nnoremap t7 :call Rcs_status()<CR>
nnoremap tb :call Rcs_blame()<CR>
nnoremap te :execute 'edit' expand('%:p:h')<cr>
"nnoremap te :tab split+Ex<CR>


"nnoremap tv :call Vimdiff()<CR>
"nnoremap tm :exe ":!svn diff --diff-cmd=meld %"<CR>
"nnoremap tl :exe ":!ln -sf $(readlink -f %) ~/src/fiddler2/"<CR>

" ack functions
"nnoremap t1 :python py_thread(ack,["-a -i",""])<left><left><left>
"nnoremap t2 :python py_thread(ack_cursor,["-a -i"])<CR>
"nnoremap t3 :python py_thread(ack_yvalue,["-a -i"])<CR>
" find functions
"nnoremap t4 :python py_thread(find,[""])<left><left><left>
"nnoremap t5 :python py_thread(find_cursor)<CR>
"nnoremap t6 :python py_thread(find_yvalue)<CR>
" svn functions
"nnoremap t7 :python py_thread(svn_status)<CR>
"nnoremap tb :python py_thread(svn_blame)<CR>
"nnoremap tm :python py_thread(svn_meld)<CR>
"nnoremap tl :python py_thread(svn_log)<CR>
"nnoremap  t0 :call Open()<CR>
"nnoremap t0 <C-W>gF<CR>
"nnoremap  <C-W>t0 <C-W>gF<CR>
"nnoremap te :tab split+Ex<CR>
"http://stackoverflow.com/questions/2414626/vim-unsaved-buffer-warning
nnoremap <F5> :exe ":set hidden \| :Ex"<CR>

set runtimepath+=~/.vim/bundle/jshint2.vim/