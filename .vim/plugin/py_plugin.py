import os
import time, vim, sys, commands
from threading import Thread
from cStringIO import StringIO

def get_ack_command():
    (exit, output) = commands.getstatusoutput( "which ack" )
    if exit == 0:
        return "ack"
    return "ack-grep"

ACK_CMD = get_ack_command()

"""
FUNCTIONS
"""
def delete_first_line():
    vim.command("normal 0gg")
    vim.command("normal dd")

def get_setting_state( setting ):
    return vim.eval( "&%s" % (setting))

def set_setting_state( setting , enable ):
    if enable == 1:
        vim.command("set %s!" % (setting))
    else:
        vim.command("set %s" % (setting))

"""
FIND
"""
def find( pattern ):
    cmd = 'find . -iname "*%s*"' % ( pattern )
    (exit, output) = commands.getstatusoutput( cmd )
    vim.command("tabnew")
    vim.current.buffer.append(StringIO(output).readlines())
    delete_first_line()
    #old_ignorecase = get_setting_state("ignorecase")
    if cmd.find("-i") > -1: # If ignorecase is enabled
        vim.command("set ignorecase")
    vim.command("call search(\'%s\')" % (pattern) )
    vim.command("call matchadd('Search',\'%s\')" % (pattern) )
    vim.command("set hidden") # Using this, vim won't ask to save this file.
    #set_setting_state( "ignorecase", old_ignorecase )

def find_yvalue():
    pattern = vim.eval("@\"")
    find( pattern )

def find_cursor():
    vim.command("normal yiw")
    find_yvalue()

"""
ACK a.k.a. GREP
"""
def ack( ack_parameters, pattern ):
    global ACK_CMD 
    cmd = '%s %s "%s" | cut -c1-230' % ( ACK_CMD, ack_parameters, pattern )
    (exit, output) = commands.getstatusoutput( cmd )
    vim.command("tabnew")
    if output:
        vim.current.buffer.append(StringIO(output).readlines())
    delete_first_line()
    #old_ignorecase = get_setting_state("ignorecase")
    if ack_parameters.find("-i") > -1: # If ignorecase is enabled
        vim.command("set ignorecase")
    vim.command("call search(\'%s\')" % (pattern) )
    vim.command("call matchadd('Search',\'%s\')" % (pattern) )
    vim.command("set hidden") # Using this, vim won't ask to save this file.
    #set_setting_state( "ignorecase", old_ignorecase )

def ack_yvalue( ack_parameters ):
    pattern = vim.eval("@\"")
    ack( ack_parameters, pattern )

def ack_cursor( ack_parameters ):
    vim.command("normal yiw")
    ack_yvalue( ack_parameters )


"""
SVN STUFF
"""
def svn_status():
    cmd = 'svn status | grep ^[MCADR] | awk \'{print $2 ":0 " $1}\'' # e.g.: pom.xml:0 M
    (exit, output) = commands.getstatusoutput( cmd )
    vim.command("tabnew")
    vim.current.buffer.append(StringIO(output).readlines())
    delete_first_line()

def svn_blame():
    filename = vim.eval("expand('%:p')")
    cmd = "svn blame %s" % ( filename )
    print cmd
    (exit, output) = commands.getstatusoutput( cmd )
    vim.command("tabnew")
    vim.current.buffer.append(StringIO(output).readlines())
    delete_first_line()

def svn_meld():
    filename = vim.eval("expand('%:p')")
    cmd = "svn diff --diff-cmd=meld %s" % ( filename )
    (exit, output) = commands.getstatusoutput( cmd )

# Using the number under the cursor, display the svn log
def svn_log():
    vim.command("normal yiw")
    try:
        revisonNumber = vim.eval("@\"")
        revisonNumber = int( revisonNumber )
        cmd = "svn log -v -c %s" % ( revisonNumber )
        (exit, output) = commands.getstatusoutput( cmd )
        vim.command("tabnew")
        vim.current.buffer.append(StringIO(output).readlines())
        delete_first_line()
    except ValueError:
        print "'%s' not a valid revision number." % ( revisonNumber )

"""
THREADS
"""
def py_thread(func,args=[]):
    thread = Thread( target = func , args = args )
    thread.start()
