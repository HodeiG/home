" This file is useless currently.
" I keep it here because it might be useful in the future
command! -nargs=1 MyPluginDoSomething python do_something('<args>') - See more at: http://blog.motane.lu/2009/05/25/vim-and-python/#sthash.X0H3pLVe.dpuf
function! Testpy(param1)
python << EOF
import time, vim, sys
from threading import Thread

def threadf():
    time.sleep(5)
    print "aa"

thread = Thread( target = threadf )
thread.start()
EOF
endfunction
