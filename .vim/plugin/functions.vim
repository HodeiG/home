"Open new buffer (new tab deprecated)
function! New_File(split_vertical)
    "exe ":tabnew"
    let tmp_file = "/tmp/myvimbuffer"
    " Check if the tmp file was already opened in a buffer.
    "   - If it was and the current window is the tmp file reuse it.
    "   - If it is not, open the buffer on a new window
    " If the tmp file wasn't opened at all, create it.
    if bufwinnr(tmp_file) > 0
        exe "let a:current_buffer_name=@%"
        if tmp_file != a:current_buffer_name
            exe ":sb ".tmp_file
        endif
    else
        if a:split_vertical
            exe ":vnew ".tmp_file
        else
            exe ":new ".tmp_file
        endif
    endif
    exe "normal u"
    exe "normal 0gg"
    exe "normal dG"
    exe ":w"
endfunction
function! Ack(grep_options,grep_pattern)
    let find_pattern = input("Find path pattern (case-insensitive): ","*")
    "exe ":tabnew"
    call New_File(0)
    let cmd=":0r!find . -type f -ipath \"".find_pattern."\" -exec /bin/grep ".a:grep_options." \"".a:grep_pattern."\" {} \\; | cut -c1-230"
    redraw | echo cmd
    exe cmd
    exe ":set ignorecase"
    exe "call search(\'".a:grep_pattern."\')"
    exe "call matchadd('Search',\'".a:grep_pattern."\')"
    exe "normal 0gg00"
endfunction
function! Ack2(params)
    let g:find_pattern = a:params['find_pattern']
    call New_File(0)
    let cmd=':0r!find '.a:params['find_opts'].
        \ ' "'.a:params['find_pattern'].'" '.
        \ '-exec /bin/grep '.a:params['grep_opts'].
        \ ' "'.a:params['grep_pattern'].'" {} \; | cut -c1-230'
    redraw | echo cmd
    exe cmd
    exe ":set ignorecase"
    exe "call search(\'".a:params['grep_pattern']."\')"
    exe "call matchadd('Search',\'".a:params['grep_pattern']."\')"
    exe "normal 0gg00"
endfunction
function! Test2(vertical)
    echo a:vertical
    if a:vertical
        echo "aaa"
    else
        echo "bbb"
    endif
endfunction

function! Test(params)
    echo a:0
    let text=""
    echo a:params['find_opts']
    echo a:params['grep_opts']
    echo a:params['find_pattern']
    let g:find_pattern = a:params['find_pattern']
    echo a:params['grep_pattern']
    let a:params['x'] = 5
    echo a:params['x']
    echo "aadfasdf ".a:params['find_pattern'].
         \ "abbbbbb"
endfunction
function! Find(value)
    "exe ":tabnew"
    call New_File(0)
    exe ":0r! find . -type f -iname \'*".a:value."\'*"
    "exe "normal 0gg"
    exe ":set ignorecase"
    exe "call search(\'".a:value."\')"
    exe "call matchadd('Search',\'".a:value."\')"
    exe "normal 0gg00"
endfunction
function! Find2(params)
    call New_File(0)
    let cmd=':0r!find '.a:params['find_opts'].
        \ ' "'.a:params['find_pattern'].'"'
    redraw | echo cmd
    exe cmd
    exe ":set ignorecase"
    exe "call search(\'".a:params['find_pattern']."\')"
    exe "call matchadd('Search',\'".a:params['find_pattern']."\')"
    exe "normal 0gg00"
endfunction
" Use cursors current position word for the ack
function! Ack_cursor(params)
    exe "normal yiw"
    exe "let a:ack_val=@\""
    call Ack(a:params,a:ack_val)
endfunction
function! Ack_cursor2(params)
    exe "normal yiw"
    exe 'let a:params["grep_pattern"]=@"'
    let a:params['find_pattern'] = input("Find pattern: ", g:find_pattern)
    call Ack2(a:params)
endfunction
" Use copied value for the ack
function! Ack_yvalue(params)
    exe "let a:ack_val=@\""
    call Ack(a:params,a:ack_val)
endfunction
function! Ack_yvalue2(params)
    exe "let a:ack_val=@\""
    let a:params['find_pattern'] = input("Find pattern: ", g:find_pattern)
    call Ack2(a:params)
endfunction
" Use cursors current position word for Find
function! Find_cursor()
    exe "normal yiw"
    exe "let a:ack_val=@\""
    call Find(a:ack_val)
endfunction
" Use copied value for Find
function! Find_yvalue()
    exe "let a:ack_val=@\""
    call Find(a:ack_val)
endfunction

function! Open()
    " Save old copyed value to restore it at the end
    exe "let @c=@\""
    " If charachter : is found...
    if (match(getline('.'),":")>-1) 
        " @a = File
        exec "normal 0\"ayt:" 
        " @b = Line
        exec "normal f:w\"byw"
        exe ":tabnew"
        "Open file @a
        exe ":e ".@a 
        "Go to line @b
        exec "normal ".@b."gg"
    " If charachter : is not found...
    else
        exec "normal 0\"ayW" 
        exe ":tabnew"
        exe ":e ".@a 
    endif
    exe "let @\"=@c"
endfunction

function! Vimdiff()
    exec "let a:file=expand('%:p')"
    echom a:file
    exe ":tabe ".a:file
    exe ":vnew"
    exe "silent :r! svn cat -r HEAD ".a:file
    exe ":diffthis"
    exe ":wincmd w"
    exe ":diffthis"
    exec "normal 0gg"
endfunction
" Revision Control System status
function! Rcs_status()
    let git=system('git rev-parse --get-dir &> /dev/null; echo $?')
    let svn=system('svn info &> /dev/null; echo $?')
    if git != 0 && svn != 0
        echo "Folder not under a Revision Control System (git/svn)"
        return
    endif
    call New_File(0)
    if git == 0
        exe ":0r! echo '-- NO-CACHED --'"
        exe ":r! git diff --relative --name-only | awk '{print $1 \":0:\"}' "
        exe ":r! echo '-- CACHED --'"
        exe ":r! git diff --relative --name-status --cached | awk '{print $2 \":0: \" $1}' "
        exe ":r! echo '-- COMMITTED --'"
        exe ":r! git show --relative --name-status --pretty=\"format:\" | awk '{print $2 \":0:\" $1}' "
    endif
    if svn == 0
        exe ":0r! svn status | grep ^[MCADR] | awk '{print $2 \":0:\" $1}' "
    endif
    " Go to the first line
    exe "normal 0gg"
    return
endfunction
" Revision Control System status
function! Rcs_blame()
    let git=system('git rev-parse --get-dir &> /dev/null; echo $?')
    let svn=system('svn info &> /dev/null; echo $?')
    let filename=expand('%:p')
    if git != 0 && svn != 0
        echo "Folder not under a Revision Control System (git/svn)"
        return
    endif
    call New_File(1)
    if git == 0
        exe ":0r!git blame -l ".filename
    endif
    if svn == 0
        exe ":0r!svn blame ".filename
    endif
    " Go to the first line
    exe "normal 0gg" 
endfunction
