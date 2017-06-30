"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatic Autocomplete (for all characters and digits)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Info: h: ins-completion
" Usage: Use j and k to move around the menu
" 	 But this way is not possible to insert k or j characters.
" 	 So, use <C-E> to close the menu and type k or j
" <C-X><C-N> Autocompletion keyword in the current file
" <C-X><C-I> Autocompletion keyword in the current and included files
" <C-P> Go back one word (to no select anythin in the beggining)
function! Automatic_autocomplete(action)
    let ret_value=""
    if pumvisible()
        "Check for j and k to move into the menu"
        "if a:action == 'j' return "\<C-N>" elseif a:action == 'k' return "\<C-P>" endif
        "In this case we add <C-Y> to use the item that has been select and close the menu.
        let ret_value="\<C-Y>"
    endif
    " match: de (def), cl (class), im (import)
    " 	 if (if conditions), wh (while)
    "let m=match(getline('.'),'^\s*\(de\|cl\|im\|if\|wh\)')
    "if m==-1
        "If it is not the first word in the line use Local AC"
        let ret_value.=a:action."\<C-X>\<C-N>\<C-P>"
    "else
        "If it is the first word in the line use Line AC"
    "	let ret_value.=a:action."\<C-X>\<C-L>\<C-N>"
    "endif
    return ret_value
endfunction

"let mchars=[46,95]
"for i in range(48,57) + range(65,90) + range(97,122) + mchars
    "let c = nr2char(i)
    "exec "inoremap <silent>".c." <C-R>=Automatic_autocomplete('".c."')<CR>"
"endfor
"Space has to be added like this because it uses a special name."
"inoremap <space> <C-R>=Automatic_autocomplete(' ')<CR>
" Use Enter to select item"
inoremap <expr> <CR> pumvisible()?"\<C-y>":"\<C-g>u\<CR>"
