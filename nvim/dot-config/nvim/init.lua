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
vim.opt.mouse = 'n'

--  Open split the sane way
vim.opt.splitright = true
vim.opt.splitbelow = true

--  Hide buffer when closed
vim.opt.hidden = true

--  Vimdiff to open vertical splits
--  I don't understand how can anyone work otherwise
vim.opt.diffopt = vim.opt.diffopt + 'vertical'

--  Start scrolling three lines before the horizontal window border
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 10

--  Show matching brackets
vim.opt.showmatch = true

--  Persist the undo tree for each file
vim.opt.undofile = true

--  Highlight edge column
vim.opt.colorcolumn = '100'
vim.opt.cursorline = true
--  Let plugins show effects after 500ms, not 4s
--vim.opt.updatetime=500
--  Show whitespaces
vim.opt.listchars = { tab = '| ', space = '·', trail = '·', extends = '·', precedes = '·', nbsp = '·', eol = '¬' }

--  Indentation options
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

--  Vim folds
vim.opt.foldmethod = 'marker'
vim.opt.foldlevel = 0

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
-- Preview some commands (:g/:s/:v)
vim.opt.inccommand = "split"

--  Enable per project .vimrc
vim.opt.exrc = true
vim.opt.secure = true

--  Don't load default filetypes.vim on startup, for speed
vim.g.do_filetype_lua = true
-- A value of 0 for this variable disables filetype.vim.
-- A value of 1 disables both filetype.vim and filetype.lua (which you probably don’t want).
-- vim.g.did_load_filetypes = false

--  Integrate RipGrep
if vim.fn.executable('rg') then
    vim.opt.grepprg = "rg --with-filename --no-heading $* /dev/null"
end

--  Tags magic {{{2

vim.opt.tags = './tags,**5/tags,tags;~'
--                          ^ in working dir, or parents
--                    ^ in any subfolder of working dir
--            ^ sibling of open file
-- }}}

local highlight_yank = vim.api.nvim_create_augroup('highlight_yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
        group = highlight_yank,
        pattern = "*",
        callback = function() vim.highlight.on_yank({ timeout = '1000' }) end,
    }
)

--  Vim's built in AutoComplete configuration {{{2
--  Don't let autocomplete affect usual typing habits
vim.opt.completeopt = 'menuone,noinsert,noselect'
--                   |        |          ^ Don't select anything in the menu
--                   |        |            without my interaction
--                   |        ^ Don't insert text without my interaction
--                   |          Strongly affects the typing experience
--                   ^ Open a menu even if there is only one
--                     completion candidate. Usefull for the
--                     extra about the completion candidate
-- 2}}}
-- 1}}} General Vim config

-- Attempt for a minimal config, for faster short edits
check_minimal = function(plugin)
    local whitelist = {
        "gruvbox-material",
        "lualine.nvim",
        "mapx.nvim",
        "which-key.nvim"
    }
    if vim.g.minimal ~= nil then
        print(plugin.name)
        for _, plug in ipairs(whitelist) do
            if plugin.name == plug then
                return true
            end
        end
        return false
    end
    return true
end

-- Bring up the plugins after NeoVim's general configuration was done
-- version: use latest stable verion, override with setting to false for a specific plugin
-- cond: to load only specific plugins for a minimal config for faster startup
require("lazy").setup("plugins", { defaults = { version = "*", cond = check_minimal } })

-- Colors setups
vim.cmd.colorscheme('gruvbox-material')
require('lualine').setup {
    options = { theme = 'gruvbox-material' },
}

-- """""" Key Mappings and custom commands """""" {{{1

-- While initialiazing into the local m variable is not strictily required,
-- as I can use the "global = true" argument, but it makes the config more explicit
-- in terms of where the function came from, and removes lua-language-server errors
local m = require('mapx').setup({ whichkey = true })

-- Not required as mapx above does that, but leaving for reference
-- require('which-key').setup({})

-- For kernel development
m.cmdbang("Kernel", function() vim.cmd.source(vim.api.nvim_list_runtime_paths()[1] .. "/linux-kernel.vim") end)

-- Vim's background transparency
local transparency = function()
    if not vim.g.transparency_on then
        vim.cmd.highlight({ "normal", "guibg=none" })
        vim.cmd.highlight({ "nontext", "guibg=none" })
        vim.cmd.highlight({ "normal", "ctermbg=none" })
        vim.cmd.highlight({ "nontext", "ctermbg=none" })
        vim.g.transparency_on = true
    else
        -- normal         xxx ctermfg=223 ctermbg=234 guifg=#d4be98 guibg=#1d2021
        -- nontext        xxx ctermfg=239 guifg=#504945
        vim.cmd.highlight({ "normal", "guibg=#1d2021" })
        vim.cmd.highlight({ "normal", "ctermbg=223" })
        vim.cmd.highlight({ "nontext", "guibg=none" })
        vim.cmd.highlight({ "nontext", "ctermbg=239" })
        vim.g.transparency_on = false
    end
end
m.cmdbang("Transparent", transparency)

-- Allow more shell-like editing in ':' mode
m.cnoremap('<C-A>', '<Home>')
-- Happens way too many times
m.cmdbang('W', 'update')
-- Search and replace word under cursor
m.nnoremap('<leader>rr', ":%s/<c-r><c-w>//g<left><left>", "Search and replace")
-- Show full path, not relative
m.nnoremap('<c-g>', function() print(vim.fn.expand('%:p')) end, "Show current file's full path")

--  Quickfix bindings
m.nnoremap(']q', '<CMD>cnext<CR>', "Next quickfix entry")
m.nnoremap(']Q', '<CMD>clast<CR>', "Last quickfix entry")
m.nnoremap('[q', '<CMD>cprevious<CR>', "Previous quickfix entry")
m.nnoremap('[Q', '<CMD>cfirst<CR>', "First quickfix entry")
m.nnoremap('<Leader>q', '<CMD>cclose<CR>', "Close quickfix window")
m.nnoremap('qq', '<CMD>copen<CR>', "Open quickfix window")

--  Insert date/time
m.inoremap('<leader>d', '<C-r>=strftime("%a %d.%m.%Y %H:%M")<CR>')
m.inoremap('<leader>D', '<C-r>=strftime("%d.%m.%y")<CR>')

--  Turn off search highlight
m.nnoremap('<Leader>/', '<CMD>noh<CR>')

--  Spellchecking Bindings
m.inoremap('<m-f>', '<C-G>u<Esc>[s1z=`]a<C-G>u', "Fix spelling")
m.nnoremap('<m-f>', '[s1z=<c-o>', "Fix spelling")
m.nnoremap('<F3>', '<CMD>setlocal spell! spelllang=en<CR>', "Toggle spellcheck")

--  Toggle whitespaces
m.nnoremap('<F2>', '<CMD>set list! <CR>', "Toggle whitespaces")
--  real make
m.nnoremap('<silent> <F5>', '<CMD>make<CR><CR><CR>', "Make")
--  GNUism, for building recursively
m.nnoremap('<silent> <s-F5>', '<CMD>make -w<CR><CR><CR>', "GNU Make")
--  Toggle the tags bar
m.nnoremap('<F8>', '<CMD>Lspsaga outline<CR>', "Tagbar")

--  Tags in previw/split window
m.nnoremap('<C-w><C-]>', '<C-w>}', "Preview tag")
m.nnoremap('<C-w>}', '<C-w><C-]>', "Open tag in split")

--  Compile file (Markdown, LaTeX, etc)
--  TODO: Auto-recognize build system
--  TODO: Move to file specific spec
m.nnoremap('<silent> <F6>', '<CMD>!compiler %<CR>', "Compile file")

if vim.g.minimal ~= nil then
    m.inoremap('<silent><expr><tab>', 'pumvisible() ? "<c-n>" : "<tab>"')
    m.inoremap('<silent><expr><s-tab>', 'pumvisible() ? "<c-p>" : "<s-tab>"')
end

--  }}} Key mappings
