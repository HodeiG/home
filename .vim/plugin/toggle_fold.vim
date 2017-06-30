let g:fold_all=1
function! ToggleSyntax()
   if exists("g:fold_all")
      execute "normal :zO"
   else
      syntax enable
   endif
   execute "normal n"
endfunction

nmap <silent>  ;s  :call ToggleSyntax()<CR>

function! UnFoldOneLevel()
	try
		if foldlevel('.') > 0 && foldclosed('.') == -1
			execute "normal zc"
		else
			execute "normal zo"
		endif
	catch
		echo "No fold found"
	endtry
endfunction

function! UnFoldRecursively()
	try
		if foldlevel('.') > 0 && foldclosed('.') == -1
			execute "normal zC"
		else
			execute "normal zO"
		endif
	catch
		echo "No fold found"
	endtry
endfunction
function! UnFoldAll()
	try
		if foldlevel('.') > 0 && foldclosed('.') == -1
			execute "normal zM"
		else
			execute "normal zR"
		endif
	catch
		echo "No fold found"
	endtry
endfunction
