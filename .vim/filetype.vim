if exists("did_load_filetypes")
	finish
endif
let did_load_filetypes_userafter=1
augroup filetypedetect
	au! BufRead,BufNewFile *.clp setfiletype clips
augroup END
