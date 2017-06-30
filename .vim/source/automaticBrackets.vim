""""""""""""""""""" AUTOMATIC BRACKETS """""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatic brackets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wrap the text until the first space, until end of line
" and normal brackets
function! CharPairMap(open,close) 
    "Pair at the end of Word
    "inoremap (<space> (<Esc>mzEa)<Esc>`za
    exec "inoremap ".a:open."<space> ".a:open."<Esc>mzEa".a:close."<Esc>`za"
    "Pair at the end of Line
    "inoremap (<cr> (<Esc>mz$a)<Esc>`za
    exec "inoremap ".a:open."<cr> ".a:open."<Esc>mz$a".a:close."<Esc>`za"
    "Open Char
    "inoremap (<tab> ()<left>
    exec "inoremap ".a:open."<tab> ".a:open."".a:close."<left>"
endf
call CharPairMap("(",")") 
call CharPairMap("[","]") 
call CharPairMap("{","}") 
"call CharPairMap("\"","\"") 
call CharPairMap("'","'") 
