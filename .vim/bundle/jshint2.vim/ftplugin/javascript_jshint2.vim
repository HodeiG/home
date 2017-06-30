" Javascript filetype plugin for running JSHint
" Language:     Javascript (ft=javascript)
" Maintainer:   Hodei Goncalves
" Version:      Vim 7 (may work with lower Vim versions, but not tested)
"
au BufNewFile,BufRead *.js set filetype=javascript

" Add mappings, unless the user didn't want this.
" The default mapping is registered under to <F7> by default, unless the user
" remapped it already (or a mapping exists already for <F7>)
if !exists("no_plugin_maps")
    if !hasmapto('JSHint')
        noremap <buffer> <F7> :JSHint<CR>
    endif
endif
