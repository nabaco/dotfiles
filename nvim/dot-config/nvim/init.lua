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
require("lazy").setup(
    "plugins",
    {
        defaults = {
            version = "*",
            cond = check_minimal,
        },
        performance = {
            rtp = {
                disabled_plugins = {
                    "editorconfig",
                    "gzip",
                    -- "matchit",
                    -- "matchparen",
                    "netrwPlugin",
                    "spellfile",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            }
        }
    }
)

-- Colors setups
vim.cmd.colorscheme('gruvbox-material')
require('lualine').setup {
    options = { theme = 'gruvbox-material' },
}

-- """""" Key Mappings and custom commands """""" {{{1

-- For kernel development
vim.api.nvim_create_user_command("Kernel",
    function() vim.cmd.source(
        vim.api.nvim_list_runtime_paths()[1] .. "/linux-kernel.vim"
    ) end, {})

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
vim.api.nvim_create_user_command("Transparent", transparency, {})

local function nnoremap(...) vim.keymap.set('n', ...) end
local function inoremap(...) vim.keymap.set('i', ...) end
local function vnoremap(...) vim.keymap.set('v', ...) end
local function xnoremap(...) vim.keymap.set('x', ...) end
local function cnoremap(...) vim.keymap.set('c', ...) end
local function onoremap(...) vim.keymap.set('o', ...) end

-- Allow more shell-like editing in ':' mode
cnoremap('<C-A>', '<Home>')
-- Happens way too many times
vim.api.nvim_create_user_command('W', 'update', {})
-- Search and replace word under cursor
nnoremap('<leader>rr', ":%s/<c-r><c-w>//g<left><left>", { desc = "Search and replace" })
-- Show full path, not relative
nnoremap('<c-g>', function() print(vim.fn.expand('%:p')) end, { desc = "Show current file's full path" })

--  Quickfix bindings
nnoremap(']q', '<CMD>cnext<CR>', { desc = "Next quickfix entry" })
nnoremap(']Q', '<CMD>clast<CR>', { desc = "Last quickfix entry" })
nnoremap('[q', '<CMD>cprevious<CR>', { desc = "Previous quickfix entry" })
nnoremap('[Q', '<CMD>cfirst<CR>', { desc = "First quickfix entry" })
nnoremap('<Leader>q', '<CMD>cclose<CR>', { desc = "Close quickfix window" })
nnoremap('qq', '<CMD>copen<CR>', { desc = "Open quickfix window" })

--  Insert date/time
inoremap('<leader>d', '<C-r>=strftime("%a %d.%m.%Y %H:%M")<CR>')
inoremap('<leader>D', '<C-r>=strftime("%d.%m.%y")<CR>')

--  Turn off search highlight
nnoremap('<Leader>/', '<CMD>noh<CR>')

--  Spellchecking Bindings
inoremap('<m-f>', '<C-G>u<Esc>[s1z=`]a<C-G>u', { desc = "Fix spelling" })
nnoremap('<m-f>', '[s1z=<c-o>', { desc = "Fix spelling" })
nnoremap('<F3>', '<CMD>setlocal spell! spelllang=en<CR>', { desc = "Toggle spellcheck" })

--  Toggle whitespaces
nnoremap('<F2>', '<CMD>set list! <CR>', { desc = "Toggle whitespaces" })
--  real make
nnoremap('<silent> <F5>', '<CMD>make<CR><CR><CR>', { desc = "Make" })
--  GNUism, for building recursively
nnoremap('<silent> <s-F5>', '<CMD>make -w<CR><CR><CR>', { desc = "GNU Make" })
--  Toggle the tags bar
nnoremap('<F8>', '<CMD>Lspsaga outline<CR>', { desc = "Tagbar" })

--  Tags in previw/split window
nnoremap('<C-w><C-]>', '<C-w>}', { desc = "Preview tag" })
nnoremap('<C-w>}', '<C-w><C-]>', { desc = "Open tag in split" })

--  Compile file (Markdown, LaTeX, etc)
--  TODO: Auto-recognize build system
--  TODO: Move to file specific spec
nnoremap('<silent> <F6>', '<CMD>!compiler %<CR>', { desc = "Compile file" })

if vim.g.minimal ~= nil then
    inoremap('<silent><expr><tab>', 'pumvisible() ? "<c-n>" : "<tab>"')
    inoremap('<silent><expr><s-tab>', 'pumvisible() ? "<c-p>" : "<s-tab>"')
end

--  }}} Key mappings
