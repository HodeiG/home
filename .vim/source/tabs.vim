""""""""""""""""""" TABS CONFIGURATION """""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabs methods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When a tab is closed with \":q\", it won't close the buffer (it is still
" available. You can see the available buffers with \":ls\". So, in order to
" make the tabs work correclty, rather than closing the tab, the actual buffer
" has to be closed \":bd\".
"
"nnoremap  tc        :q!<cr>
nnoremap  tc        :bd!<cr>
"nnoremap  tq        :q<cr>
nnoremap  tq        :bd<cr>
nnoremap  ta        :qa<cr>
nnoremap  tw        :w<cr>
nnoremap  tp        :tabp<cr>
nnoremap  tn        :tabn<cr>
nnoremap  to        :tabnew<cr>
nnoremap  td        :tabclose<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle between tabs
" http://stackoverflow.com/questions/2119754/switch-to-last-active-tab-in-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lasttab = 1
nnoremap tt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Modify tabs colors
"
" http://stackoverflow.com/questions/7238113/customising-the-colours-of-vims-tab-bar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:hi TabLineFill ctermfg=Black ctermbg=Black 
:hi TabLine ctermfg=White ctermbg=Black
:hi TabLineSel ctermfg=Blue  ctermbg=White cterm=bold
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mofidy the label of the tabs, specially to show the tab number
"
" http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui')
  set guioptions-=e
endif
if exists("+showtabline")
  function MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let s .= i . ':'
      let s .= winnr . '/' . tabpagewinnr(i,'$')
      let s .= ' %*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      if getbufvar(i, "&modified")
        let s .= '*'
      endif
      if getbufvar(i, "&modifiable")==0
        let s .= '-'    
      endif
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif
:hi TabLineFill ctermbg=270
