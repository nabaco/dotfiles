-----------------------------------
--       Plugin Management       --
-----------------------------------

if vim.fn.argc() > 0 then
    vim.keymap.set('n', "<leader>s", "<CMD>Lazy load alpha-nvim <BAR> Alpha<CR>")
end

-- Plugins declaration.
return {
    -- Packer can manage itself
    { 'folke/lazy.nvim', cmd = 'LazySync' },

    -- Some help with the key mappings
    -- supplies proper lua commands similar to vim's commands for mapping
    -- Which Key (similar to Emacs' plugin) supplies help pop-ups to remind of key bindings
    -- NOTE: I'm placing it on top, as to be able to use it in configuration scripts of other plugins
    { 'b0o/mapx.nvim',   dependencies = 'folke/which-key.nvim' },

    -- Add some additional text objects and attack them
    {'wellle/targets.vim', event='VeryLazy'},

    -- Incerement numbers intelligently
    {
        'monaqa/dial.nvim',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "b0o/mapx.nvim"
        },
        keys = { '<c-a>', '<c-x>' },
        config = function()
            require('dial-config')
        end
    },

    -- Reposition cursor in the last position upon file reopening
    'farmergreg/vim-lastplace',

    --if vim.fn.has("Win32") then
    --    { 'Shougo/vimproc.vim', run='nmake'},
    --end
    { 'skywind3000/asyncrun.vim', cmd = 'AsyncRun' },

    -- Vim Rooter - needed for all the git plugins to work correctly,
    -- in a multi-repo environment
    { 'airblade/vim-rooter',      cmd = 'Rooter' },
    {
        'aymericbeaumet/vim-symlink',
        dependencies = {
            'moll/vim-bbye',
        },
        event = 'VeryLazy',
    },

    -- Puts all vim navigation keys on drugs! f,t etc..
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                char = {
                    jump_labels = true
                }
            }
        },
        -- stylua: ignore
        keys = {
            --     { "s", mode = { "n", "x", "o" }, function() require('flash').jump() end, desc = "Flash" },
            { "<leader>c", mode = { "n", "x", "o" }, function() require('flash').treesitter() end, desc = "Flash Treesitter" },
            -- { "r", mode = "o", function() require('flash').remote() end, desc = "Remote Flash" },
            -- { "R", mode = { "o", "x" }, function() require('flash').treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>",     mode = { "c" },           function() require('flash').toggle() end,     desc = "Toggle Flash Search" },
        },
    },

    -- Ultimate fuzzy search + Multi-entry selection UI.
    {
        -- 'junegunn/fzf.vim',
        'ibhagwan/fzf-lua',
        dependencies = {
            {
                'junegunn/fzf',
                build = function()
                    if vim.fn.empty(vim.fn.glob('/usr/bin/fzf')) > 0 then
                        -- Binary is installed through package manager.
                        vim.fn["fzf#install"]()
                    end
                end,
            },
        },
        config = function()
            require('fzf-lua').setup()
            require('fzf-lua').setup_fzfvim_cmds() -- backward compatability
        end,
        cmd = {
            "FzfLua",
            "FZF",
            "Files",
            "GFiles",
            "Buffers",
            "Colors",
            "Ag",
            "Rg",
            "RG",
            "Lines",
            "BLines",
            "Tags",
            "BTags",
            "Changes",
            "Marks",
            "Jumps",
            "Windows",
            "Locate",
            "History",
            "Snippets",
            "Commits",
            "BCommits",
            "Commands",
            "Maps",
            "Helptags",
            "Filetypes",
        }
    },
    {
        -- Peek into registers ", @, <C-R>
        'junegunn/vim-peekaboo',
        keys = { "\"", "@" },
        event = "InsertEnter",
    },
    { 'kevinhwang91/nvim-bqf', ft = 'qf' }, -- Quickfix buffer improvements

    -- Alternative file contents search
    {
        'mileszs/ack.vim',
        cmd = { "Ack", "AckAdd", "AckFile", "AckHelp", "AckWindow", "AckFromSearch" },
    },
    { 'romainl/vim-cool',      keys = "/" }, -- Remove search highlighting when not required

    -- TreeSitter
    {
        'nvim-treesitter/nvim-treesitter',
        -- ft = {'c', 'bash', 'python', 'rust', 'markdown', 'lua', 'nix', 'yaml', 'vimdoc'},
        event = 'VeryLazy',
        build = ':TSUpdate',
        dependencies = {
            -- Automatically add 'end' in languages like lua
            'RRethy/nvim-treesitter-endwise',
            -- TODO: Configure text objects
            -- {'nvim-treesitter/nvim-treesitter-textobjects'},
        },
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                -- One of "all", or a list of languages
                ensure_installed = { "c", "lua", "markdown", "markdown_inline", "python", "nix", "rust", "bash", "yaml", "vimdoc" },
                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,
                auto_install = false,
                ignore_install = {},
                modules = {},
                highlight = { enable = true },
                endwise = { enable = true }, -- Autocomplete 'end' in lua and such
            })
        end,
    },
    {
        'Wansmer/treesj',
        keys = { '<space>m', '<space>j', '<space>s' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
    },

    -- File browsing
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require('nvim-tree').setup {
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
            }
            vim.g.nvim_tree_quit_on_open = 1
            vim.g.nvim_tree_disable_window_picker = 1
            vim.g.nvim_tree_respect_buf_cwd = 1
            --  Close nvim/tab if NvimTree is the last one open
            vim.o.confirm = true
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
                pattern = "NvimTree_*",
                callback = function()
                    local layout = vim.api.nvim_call_function("winlayout", {})
                    if layout[1] == "leaf" and
                        vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and
                        layout[3] == nil
                   then
                        vim.cmd("confirm quit")
                    end
                end
            })
        end,
        cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' }
    },

    -- Visualize undo history
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
    },

    -- A - for switching between source and header files
    { 'vim-scripts/a.vim',              cmd = 'A' },

    -- Remove extraneous whitespace when edit mode is exited
    { 'thirtythreeforty/lessspace.vim', event = "InsertEnter" },

    -- Sandwich text between things
    {
        'machakann/vim-sandwich',
        keys = {
            { "sr", mode = { 'n', 'x' } },
            { "sa", mode = { 'n', 'x' } },
            { "sd", mode = { 'n', 'x' } }
        },
    },

    -- Tpope's plugins, because he requires a special place :)
    'tpope/vim-repeat', --Enable repeating supported plugin maps with .
    {
        --Unix commands from Vim
        'tpope/vim-eunuch',
        cmd = {
            "Remove",
            "Unlink",
            "Delete",
            "Copy",
            "Duplicate",
            "Move",
            "Rename",
            "Chmod",
            "Mkdir",
            "Mkdir",
            "Cfind",
            "Lfind",
            "Clocate",
            "Llocate",
            "SudoEdit",
            "SudoWrite",
            "Wall",
        },
    },
    -- TODO: Check what's my current state with sessions
    -- It appears I don't need that since Startify does the same
    --'tpope/obsession', --Vim session management
    {
        'numToStr/Comment.nvim', -- Commenting powers, includes blocks and not only lines
        event = 'VeryLazy',
        config = function()
            require('Comment').setup()
        end
    },

    -- External App Integrations
    -- TODO: API documentation
    -- 'KabbAmine/zeavim.vim',

    -- The ultimate cheat sheet
    -- NOTE: Re-consider given current AI integrations
    { 'dbeniamine/cheat.sh-vim',                        lazy = true },

    -- TODO: Read GNU Info from vim
    -- 'alx741/vinfo',
    -- {'HiPhish/info.vim', cmd = 'Info'},

    -- Highlight headlines in Markdown files
    {
        'lukas-reineke/headlines.nvim',
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
        ft = 'markdown',
    },

    -- Language specific plugins
    { 'kovetskiy/sxhkd-vim',                            ft = 'sxhkd' },
    { 'chrisbra/csv.vim',                               ft = 'csv' },
    { 'vhdirk/vim-cmake',                               ft = 'cmake' },
    { 'vim-pandoc/vim-pandoc',                          ft = 'markdown' }, -- Utilities, not syntax
    { 'vim-pandoc/vim-pandoc-syntax',                   ft = 'markdown' },
    { 'kergoth/vim-bitbake',                            ft = 'bitbake' },
    { 'https://codeberg.org/Dokana/vim-systemd-syntax', branch = 'trunk',   ft = 'systemd' },
    { 'cespare/vim-toml',                               ft = 'toml' },
    { 'tmux-plugins/vim-tmux',                          ft = 'tmux' },
    { 'mfukar/robotframework-vim',                      ft = 'robot' },
    { 'coddingtonbear/confluencewiki.vim',              ft = 'confluencewiki' },
    { 'aklt/plantuml-syntax',                           ft = 'plantuml' },
    { 'scrooloose/vim-slumlord',                        ft = 'plantuml' }, -- Preview

    -- When reading logfiles with Ansi Escape codes dumped in them,
    -- conceal the escape code and show the text with the proper color
    { 'powerman/vim-plugin-AnsiEsc',                    ft = 'log' },
    { 'MTDL9/vim-log-highlighting',                     ft = 'log' },

    -- Utilities for builtin terminal
    {
        'voldikss/vim-floaterm',
        cmd = 'FloatermNew',
        config = function()
            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = "floaterm",
                command = "set norelativenumber nonumber",
            })
        end,
        keys = {
            {
                "<leader>gl",
                function()
                    vim.cmd.FloatermNew({
                        "--height=0.9",
                        "--width=0.9",
                        "--wintype=float",
                        "--name=lazygit",
                        "--autoclose=2",
                        "lazygit",
                    })
                end,
                desc = "LazyGit"
            },
            {
                --Pop-up terminal quake style
                "<leader>`",
                function()
                    if vim.fn["floaterm#terminal#get_bufnr"]("quake") < 0 then
                        vim.cmd.FloatermNew({
                            "--height=0.3",
                            "--wintype=split",
                            "--name=quake",
                            "--autoclose=2",
                            "--title=Quake",
                            "--position=bottom"
                        })
                    else
                        vim.cmd.FloatermToggle("quake")
                    end
                end,
                mode = { 'n', 'i', 't' },
                desc = "Quake terminal"
            }
        }
    },

    -- Highlight and present TODOs and such
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        event = 'VeryLazy',
    },

    -- Eye Candy
    {
        'sainnhe/gruvbox-material',
        priority = 1000,
        config = function()
        end,
    },
   -- { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = {}},
    { 'nvim-lualine/lualine.nvim' },

    -- Color colorcodes
    {
        'norcalli/nvim-colorizer.lua',
        event = 'VeryLazy',
        config = true,
        ft = { 'lua', 'markdown', 'html', 'php', 'python', 'vim', 'css', 'javascript' },
    },

    -- Color brackets
    {
        'junegunn/rainbow_parentheses.vim',
        event = 'VeryLazy',
        config = function()
            vim.g['rainbow#max_level'] = 16
            vim.g['rainbow#pairs'] = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
            vim.cmd [[RainbowParentheses]]
        end,
    },

    -- Highlight same words as under cursor
    { 'RRethy/vim-illuminate',    event = 'VeryLazy' },
}
