-----------------------------------
--       Main Config File        --
-----------------------------------

-- Automatically bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Load lazy.nvim. It will take control from there
-- Plugins are defined and configured in lua/plugins/*
-- notice the lazy.setup() called after Vim's native configuration
vim.opt.rtp:prepend(lazypath)

-- Should make neovim load faster
-- NOTE: Unsure whether this is required with lazy.nvim
vim.loader.enable()

-- """""" General Vim Config """""""{{{1

-- Disable Ruby, NodJS and Perl providers as I don't use them
-- Removes warnings in :checkhealth, and possibly makes neovim load faster
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Not really required, removes warnings in :checkhealth
vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

-- For proper color support
vim.opt.termguicolors = true

--  Highlight embedded lua code
vim.g.vimsyn_embed = 'l'

--  Set environment variable to be able to start vim in :terminal
--  Requires: "pip3 install neovim-remote"
-- vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'
vim.env.GIT_EDITOR = 'nvr --remote'
vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername


--  Sync clipboards with system
--vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'

--  Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

--  Enable mouse, but in normal mode
vim.opt.mouse='n'

--  Open split the sane way
vim.opt.splitright=true
vim.opt.splitbelow=true

--  Hide buffer when closed
vim.opt.hidden=true

--  Vimdiff to open vertical splits
--  I don't understand how can anyone work otherwise
vim.opt.diffopt = vim.opt.diffopt + 'vertical'

--  Start scrolling three lines before the horizontal window border
vim.opt.scrolloff=3
vim.opt.sidescrolloff=10

--  Show matching brackets
vim.opt.showmatch = true

--  persist the undo tree for each file
vim.opt.undofile=true

--  Highlight edge column
vim.opt.colorcolumn='100'
vim.opt.cursorline = true
--  Let plugins show effects after 500ms, not 4s
--vim.opt.updatetime=500
--  Show whitespaces
vim.opt.listchars = {tab = '| ', space = '·', trail = '·', extends = '·', precedes = '·', nbsp = '·', eol = '¬'}

--  Indentation options
vim.opt.tabstop=4
vim.opt.expandtab=true
vim.opt.softtabstop=4
vim.opt.shiftwidth=4

--  Vim folds
vim.opt.foldmethod='marker'
vim.opt.foldlevel=1

--  save the file when switch buffers, make it etc.
vim.opt.autowriteall = true

--  Ignore common files
--  Important not to have code related directories, as it affects native LSP's
--  root directory search pattern
vim.opt.wildignore = vim.opt.wildignore + '*.so,*.swp,*.zip,*.o,*.la'

--  Case-insensitive search
vim.opt.wildignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

--  Enable per project .vimrc
vim.opt.exrc = true
vim.opt.secure = true

--  Don't load default filetypes.vim on startup, for speed
vim.g.do_filetype_lua = true
-- A value of 0 for this variable disables filetype.vim.
-- A value of 1 disables both filetype.vim and filetype.lua (which you probably don’t want).
vim.g.did_load_filetypes = false

--  Integrate RipGrep
if vim.fn.executable('rg') then
    vim.opt.grepprg="rg --with-filename --no-heading $* /dev/null"
end

--  Tags magic {{{2

vim.opt.tags='./tags,**5/tags,tags;~'
--                          ^ in working dir, or parents
--                    ^ in any subfolder of working dir
--            ^ sibling of open file
-- }}}

vim.cmd[[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout='1000'})
    augroup END
]]

vim.cmd[[
    augroup autoreconf
        autocmd!
        autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd
        autocmd BufWritePost *init.vim source ~/.config/nvim/init.vim
        " autocmd BufWritePost *init.lua source <afile> -- Not required with Lazi.nvim
        autocmd BufWritePost *bspwmrc !bspc wm -r
        autocmd BufWritePost *picom.conf !pkill -x picom && picom -b
        autocmd BufWritePost *mpd.conf !mpd --kill && mpd
        autocmd BufWritePost *termite/config !killall -USR1 termite
        autocmd BufWritePost *qtile/config.py !qtile-cmd -o cmd -f restart > /dev/null 2&>1
    augroup END
]]

--  Vim's built in AutoComplete configuration {{{2
--  Don't let autocomplete affect usual typing habits
vim.opt.completeopt='menuone,noinsert,noselect'
--                   |        |          ^ Don't select anything in the menu
--                   |        |            without my interaction
--                   |        ^ Don't insert text without my interaction
--                   |          Strongly affects the typing experience
--                   ^ Open a menu even if there is only one
--                     completion candidate. Usefull for the
--                     extra about the completion candidate
-- 2}}}
-- 1}}}

-- Bring up the plugins after NeoVim's general configuration was done
require("lazy").setup("plugins")

-- """""" Plugins Configuration """"""{{{1

-- Statusbar configuration
require'lualine'.setup{
    options = { theme = 'gruvbox-material' },
    sections = { lualine_c = {'filename', 'b:vista_nearest_method_or_function'} }
}

vim.filetype.add({
  extension = {
    bbappend = "bitbake",
    bbclass = "bitbake",
    bb = "bitbake",
  }
})

--  Git plugins configuration

--  Vimagit config
--  Go straight into insert mode when committing
vim.cmd('autocmd User VimagitEnterCommit startinsert')

--  Vim Rooter Config
vim.g.rooter_manual_only = 1 --  Improves Vim startup time
vim.cmd('autocmd BufEnter * Rooter') --  Still autochange the directory
vim.g.rooter_silent_chdir = 1
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.rooter_resolve_links = 1
vim.g.rooter_patterns = {'compile_commands.json', '.git', 'Cargo.toml'}

--  Ack config
vim.g.ackprg = 'rg --vimgrep --smart-case'
vim.g.ackhighlight = 1
--  Auto close the Quickfix list after pressing '<enter>' on a list item
vim.g.ack_autoclose = 1
--  Any empty ack search will search for the word the cursor is on
vim.g.ack_use_cword_for_empty_search = 1
--  Don't jump to first match
--[[ TODO: Need to move this to minimal config or to vimrc
cnoreabbrev Ack Ack!
command! -nargs=1 Nack Ack! "<args>" $NOTES/**
command! -nargs=1 Note e $NOTES/Scratch/<args>.md
command! Scratch exe "e $NOTES/Scratch/".strftime("%F-%H%M%S").".md"
]]

--  FZF Config
-- let $FZF_DEFAULT_COMMAND = 'ag -g ""'
-- let $FZF_DEFAULT_COMMAND = 'fd --type file'
-- let $FZF_DEFAULT_COMMAND = 'rg --files -g ""'

--  Pandoc configuration
vim.g['pandoc#command#custom_open']='zathura'
vim.g['pandoc#command#prefer_pdf']=1
vim.g['pandoc#command#autoexec_command']="Pandoc! pdf"
vim.g['pandoc#completion#bib#mode']='citeproc'

--  PlantUML path
vim.g.plantuml_executable_script='java -jar $NFS/plantuml.jar'

-- For kernel development
vim.api.nvim_create_user_command("Kernel", "source "..vim.api.nvim_list_runtime_paths()[1].."/linux-kernel.vim", {})

-- """""" Key Mappings """""" {{{1

if not vim.g.mapx then
    mapx = require'mapx'.setup{ global = true, whichkey = true }
    -- When sourcing this file a second time, Neovim throws an error on the line above.
    -- Seems like mapx tries to map again all of its commands and finds a conflict (with itself).
    -- This is a workaround to run above line only once in a running Neovim instance.
    vim.g.mapx = 1
end

require("which-key").setup{}

nnoremap('<Leader>n', ':NvimTreeToggle<CR>', "File explorer")
nnoremap('<Leader>v', ':NvimTreeFindFile<CR>', "Current file in file explorer")

--  Quickfix bindings
nnoremap(']q', ':cnext<cr>')
nnoremap(']Q', ':clast<cr>')
nnoremap('[q', ':cprevious<cr>')
nnoremap('[Q', ':cfirst<cr>')
nnoremap('<Leader>q', ':ccl<cr>')

--  }}}

--  }}}

nnoremap('<Leader>wn', ':Nack<space>')
nnoremap('<Leader>ww', ':FZF $NOTES<cr>')

--  Insert date/time
inoremap('<leader>d', '<C-r>=strftime("%a %d.%m.%Y %H:%M")<cr>')
inoremap('<leader>D', '<C-r>=strftime("%d.%m.%y")<cr>')


map(',', '<Plug>(easymotion-prefix)')

--  Turn off search highlight
nnoremap('<Leader>/', ':noh<cr>')

--  FZF bindings
nnoremap('<Leader><cr>', '<CMD>Buffers<CR>')
nnoremap('<Leader>f', '<CMD>Files<CR>')
nnoremap('<Leader>t', '<CMD>Tags<CR>')
nnoremap('<Leader>T', '<CMD>BTags<CR>')
nnoremap('<Leader>M', '<CMD>FzfLua git_commits --no-mergres<CR>')
nnoremap('<Leader>m', '<CMD>FzfLua git_bcommits --no-mergres<CR>')

--  Start a Git command
nnoremap('<Leader>gg', ':Git<Space>')
nnoremap('<Leader>gs', ':Git status<CR>')
nnoremap('<Leader>gv', ':Magit<CR>')
-- nnoremap('<Leader>gcm', ':Git commit<CR>')
nnoremap('<Leader>gd', ':Git diff<CR>')
nnoremap('<Leader>gc', ':Gdiffsplit<CR>')
nnoremap('<Leader>gb', ':MerginalToggle<CR>')

--  Spellchecking Bindings
inoremap('<m-f>', '<C-G>u<Esc>[s1z=`]a<C-G>u')
nnoremap('<m-f>', '[s1z=<c-o>')

--  Toggle whitespaces
nnoremap('<F2>', ':set list! <CR>')
--  Toggle spell checking
nnoremap('<F3>', ':setlocal spell! spelllang=en<CR>')
--  real make
nnoremap('<silent> <F5>', ':make<cr><cr><cr>')
--  GNUism, for building recursively
nnoremap('<silent> <s-F5>', ':make -w<cr><cr><cr>')
--  Toggle the tags bar
nnoremap('<F8>', ':Vista!!<CR>')

--  Ctags in previw/split window
nnoremap('<C-w><C-]>', '<C-w>}')
nnoremap('<C-w>}', '<C-w><C-]>')

--  Nuake Bindings
nnoremap('<Leader>`', ':Nuake<CR>')
inoremap('<Leader>`', '<C-\\><C-n>:Nuake<CR>')
tnoremap('<Leader>`', '<C-\\><C-n>:Nuake<CR>')

--  Compile file (Markdown, LaTeX, etc)
--  TODO: Auto-recognize build system
nnoremap('<silent> <F6>', ':!compiler %<cr>')

--inoremap('<silent><expr><tab>', 'pumvisible() ? "<c-n>" : "<tab>"')
--inoremap('<silent><expr><s-tab>', 'pumvisible() ? "<c-p>" : "<s-tab>"')
--  }}}
