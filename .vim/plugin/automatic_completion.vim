function! Abutomatic_autocomplete(action)
	let ret_value=""
	if pumvisible()
		"Check for j and k to move into the menu"
		"if a:action == 'j' return "\<C-N>" elseif a:action == 'k' return "\<C-P>" endif
		"In this case we add <C-Y> to use the item that has been select and close the menu.
		let ret_value="\<C-Y>"
	endif
	" match: de (def), cl (class), im (import)
	" 	 if (if conditions), wh (while)
	let m=match(getline('.'),'^\s*\(de\|cl\|im\|if\|wh\)')
	if m==-1
		"If it is not the first word in the line use Local AC"
		let ret_value.=a:action."\<C-X>\<C-N>\<C-P>"
	else
		"If it is the first word in the line use Line AC"
		let ret_value.=a:action."\<C-X>\<C-L>\<C-N>"
	endif
	echo ret_value
endfunction
