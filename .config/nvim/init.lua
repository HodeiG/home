vim.keymap.set('n', 'tw', ':w<CR>')
vim.keymap.set('n', 'tq', ':bd<cr>')
vim.keymap.set('n', 'tc', ':bd!<cr>')
vim.keymap.set('n', 'tt', ':buffer#<cr>') -- Swap between buffers
vim.keymap.set('n', 'ts', ':Files<CR>') -- FZF: Look for files
vim.keymap.set('n', 'tl', ':Buffer<CR>') -- FZF: Find file in buffer
vim.keymap.set('n', 'th', ':History:<CR>') -- FZF: Command history
-- FZF: Grep with ripgrep
-- The below shortcut is using the FZF original grep call:
-- @param1: The ripgrep command which uses '--' to find for a literal.
--          '--' can be replaced for '-w' to search for a exact word.
-- @param2: The preview option
--
-- As the user input must go 26 character to the left, an easy way to do it
-- is to open the Find Mode (<C-F>) to see all the commands, move 26 chars to
-- the left (26<Left>) and finally exit the Find Mode to go back to the Command
-- prompt (<C-c>). Unfortunately the Find Mode stays opened, but it is a nice
-- shortcut. See https://vi.stackexchange.com/a/21043
vim.keymap.set('n', 'tg', ':call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ", fzf#vim#with_preview())<C-F>26<Left><C-c>')
vim.keymap.set('n', 'tn', ':bnext<cr>')  -- Move to the next buffer
vim.keymap.set('n', 'tp', ':bprevious<cr>')  -- Move to the previous buffer
vim.keymap.set('n', 'to', '<c-w>f')
vim.keymap.set('n', 'te', ':execute \'edit\' expand(\'%:p:h\')<cr>')
vim.keymap.set('i', ',,', '<C-c><right>')  -- Quick scape
vim.keymap.set('n', '\'.', '`.') -- Jump to the last modified line and column
vim.keymap.set('n', 'p', ']p') -- https://stackoverflow.com/a/235841
vim.keymap.set('n', '<C-j>', ']p') -- https://stackoverflow.com/a/235841
-- Break new line / opposite of join line (J)
vim.keymap.set('n', '<c-j>', 'i<Enter><Esc>')
-- vim search don't jump http://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
vim.keymap.set('n', '*', ':keepjumps normal! mi*`i<CR>')
-- ^: jump to the first non-blank character of the line
vim.keymap.set('n', '0w', '0^*N')
-- go to the first word and select it
-- Escape from terminal mode
vim.keymap.set('t', ',,', '<C-\\><C-n>')
-- Move to the next tag
vim.keymap.set('n', '<leader><]>', ':tag<CR>')

-- Git related keybinding
vim.keymap.set('n', 'gb', ':Git blame<CR>')
vim.keymap.set('n', 'gd', ':Git diff<CR>')
--vim.keymap.set('n', 'gl', ':GcLog<CR>')
vim.keymap.set('n', 'gn', ':cnext<CR>')
vim.keymap.set('n', 'gp', ':cprev<CR>')


vim.wo.number = true          -- Numbers
vim.wo.relativenumber = true  -- Relative numbers

-- Highlight suspicious characters
vim.opt.listchars = {eol = '$', tab = ">>", trail = "•"}
vim.opt.list = true

-- Set colorcolumn to 80 characters
vim.opt.colorcolumn = "80"

-- File formatting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 79
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.fileformat = unix
vim.opt.fileformats = unix
vim.opt.autoindent =true  -- automatically indent
vim.opt.textwidth = 79
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- => Search and replace methods
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
--http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
--http://stackoverflow.com/questions/1497958/how-to-use-vim-registers
-- http://vim.wikia.com/wiki/Search_and_replace
-- http://vim.wikia.com/wiki/Search_for_visually_selected_text
-- Substitute using the word under the cursor, yanked values
-- deleted values and text written in insert-mode
vim.keymap.set('n', '<c-s>w', ':%s/<c-r><c-w>/<c-r><c-w>/gc<Left><Left><Left>')
vim.keymap.set('n', '<c-s>y', ':%s/<c-r>0/<c-r>0/gc<Left><Left><Left>')
vim.keymap.set('n', '<c-s>d', ':%s/<c-r>"/<c-r>"/gc<Left><Left><Left>')
vim.keymap.set('n', '<c-s>i', ':%s/<c-r>./<c-r>./gc<Left><Left><Left>')
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- => Substitute methods
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- Substitute current word using yanked values
-- deleted values and text written in insert-mode
-- Uses black hole register("_) so "" register will not change
vim.keymap.set('n', 'sy', 'viw"0p')
vim.keymap.set('n', 'sd', '"_diwP')
vim.keymap.set('n', 'si', 'viw".P')
-- Swap 2 words
vim.keymap.set('n', 'sw', '"qdiwdwep"qp')
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- => Find methods
--""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
-- Find yanked values deleted values and text written in
-- insert-mode
-- Use * character to find the word under the cursor
vim.keymap.set('n', '<c-f>y', '/<c-r>0')
vim.keymap.set('n', '<c-f>d', '/<c-r>"')
vim.keymap.set('n', '<c-f>i', '/<c-r>.')
-- Find the strings selected in visual mode
vim.keymap.set('v', '<c-f>', '"hy/<c-r>h')

-- FZF: global variable
-- See: https://github.com/junegunn/fzf/issues/238#issuecomment-104315812
-- See: https://neovim.io/doc/user/lua-guide.html (Vim commands: vim.cmd)
vim.cmd([[let $FZF_DEFAULT_OPTS = '--bind "ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up,ctrl-u:page-up,ctrl-d:page-down" --layout reverse --border']])

-- Enable markdown.pandoc
vim.cmd('autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc')
vim.cmd('let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "bash=sh", "sh", "yaml", "json", "vim", "lua", "javascript", "typescript", "html", "css", "scss", "sql", "rust", "go", "c", "cpp", "java", "php", "ruby", "perl", "r", "haskell", "swift", "scala", "erlang", "clojure", "ocaml", "racket", "scheme", "lisp", "dart", "julia", "lua", "typescriptreact", "javascriptreact", "rust"]')

-- require("ai-chat.nvim/lua/ai-cha")
-- -- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "junegunn/fzf" },
    { "junegunn/fzf.vim"},
    { "github/copilot.vim"},
    { "vim-pandoc/vim-pandoc-syntax"},
    {
        "tpope/vim-fugitive",
        keys={
            {"gl", ":GcLog<CR>", desc="Git log"},
            {"gb", ":Git blame<CR>", desc="Git blame"},
            {"gd", ":Git diff<CR>", desc="Git diff"},
            {"gn", ":cnext<CR>", desc="Move to the next log commit"},
            {"gp", ":cprev<CR>", desc="Move to the prev log commit"},
        }
    },
    { "scrooloose/nerdcommenter" },
    { "easymotion/vim-easymotion" },
    { 'z0rzi/ai-chat.nvim',
        config = function()
            require('ai-chat').setup {}
        end,
    },
    {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
})
