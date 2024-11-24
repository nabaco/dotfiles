-----------------------------------
--       Plugin Management       --
-----------------------------------

-- Plugins declaration.
return {
    -- Lazy can manage itself
    { 'folke/lazy.nvim',          cmd = 'LazySync' },

    -- Which Key (similar to Emacs' plugin) supplies help pop-ups to remind of key bindings
    -- NOTE: I'm placing it on top, as to be able to use it in configuration scripts of other plugins
    { 'folke/which-key.nvim' },

    -- Add some additional text objects and attack them
    { 'wellle/targets.vim',       event = 'VeryLazy' },

    -- Reposition cursor in the last position upon file reopening
    { 'farmergreg/vim-lastplace' },

    -- Run scripts async from neovim - I'm not sure whether it is really needed
    -- given neovim's built in job support
    { 'skywind3000/asyncrun.vim', cmd = 'AsyncRun' },

    -- Vim Rooter - needed for all the git plugins to work correctly,
    -- in a multi-repo environment
    {
        'airblade/vim-rooter',
        cmd = 'Rooter',
        init = function()
            --  Vim Rooter Config
            vim.g.rooter_manual_only = 1         --  Improves Vim startup time
            vim.cmd('autocmd BufEnter * Rooter') --  Still autochange the directory
            vim.g.rooter_silent_chdir = 1
            vim.g.rooter_change_directory_for_non_project_files = 'current'
            vim.g.rooter_resolve_links = 1
            vim.g.rooter_patterns = { 'compile_commands.json', '.git', 'Cargo.toml' }
        end
    },

    -- Follow a symlink and change CWD to the final location
    -- Helps a lot with symlinked dotfiles and git support
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
            -- When starting a search, flash adds labels next to matches,
            -- by finding all potential matches to the search pattern in the current visible window,
            -- and adding labels with letters that are not in those matches. Issue starts if
            -- the search is fuzzy, which it is with 'cmp', so this resolves the issue.
            search = {
                mode = "fuzzy"
            },
            modes = {
                char = {
                    -- hide after jump when not using jump labels
                    autohide = true,
                    jump_labels = true,
                    -- When using jump labels, don't use these keys
                    -- This allows using those keys directly after the motion
                    label = { exclude = "hjkliardcsx" },
                },
                search = {
                    enabled = true
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

    -- hop.nvim {{{
    -- hop.nvim is currently disabled in favor of flash, since flash has support for immediate jump
    -- upon search, even though hop has much more functionality, similar to easymotion.
    {
        'smoka7/hop.nvim',
        enabled = false,
        opts = {
            keys = 'etovqpdygfblzhckiuran'
        },
        config = true,
        keys = {
            {
                'f',
                function()
                    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })
                end,
                mode = { 'n', 'x', 'o' }
            },
            {
                'F',
                function()
                    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })
                end,
                mode = { 'n', 'x', 'o' },
            },
            {
                't',
                function()
                    require('hop').hint_char1({
                        direction = require('hop.hint').HintDirection.AFTER_CURSOR,
                        hint_offset = -1,
                    })
                end,
                mode = { 'n', 'x', 'o' },
            },
            {
                'T',
                function()
                    require('hop').hint_char1({
                        direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
                        hint_offset = -1,
                    })
                end,
                mode = { 'n', 'x', 'o' },
            },
            {
                ',w',
                function()
                    require('hop').hint_words({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })
                end,
                mode = { 'n', 'x', 'o' }
            },
            {
                ',b',
                function()
                    require('hop').hint_words({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })
                end,
                mode = { 'n', 'x', 'o' },
            },
        }
    },
    --}}}

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
            { "nvim-tree/nvim-web-devicons" },
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
        },
        keys = {
            { '<leader>rg',   function() vim.cmd.FzfLua("grep_cword") end,                  "RipGrep current word" },
            { '<leader>RG',   function() vim.cmd.FzfLua("grep_cWORD") end,                  "RipGrep current WORD" },
            { '<Leader><CR>', function() vim.cmd.FzfLua("buffers") end,                     "Search open buffers" },
            { '<Leader>f',    function() vim.cmd.FzfLua("files") end,                       "Search files" },
            { '<Leader>t',    function() vim.cmd.FzfLua("lsp_live_workspace_symbols") end,  "Search symbols" },
            { '<Leader>T',    function() vim.cmd.FzfLua("lsp_document_symbols") end,        "Search symbols in document" },
            { '<Leader>M',    function() vim.cmd.FzfLua("git_commits", "--no-merges") end,  "Git commits" },
            { '<Leader>m',    function() vim.cmd.FzfLua("git_bcommits", "--no-merges") end, "Git buffer commits" },
        }
    },

    -- Peek into registers ", @, <C-R>
    {
        'junegunn/vim-peekaboo',
        keys = { "\"", "@" },
        event = "InsertEnter",
    },

    -- Quickfix buffer improvements
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        config = function()
            vim.api.nvim_create_autocmd({ "FileType" }, {
                pattern = "qf",
                command = "nnoremap <buffer><silent> q :cclose<CR>",
            })
        end,
    },

    -- Alternative file contents search
    {
        'mileszs/ack.vim',
        cmd = { "Ack", "AckAdd", "AckFile", "AckHelp", "AckWindow", "AckFromSearch" },
        config = function()
            vim.g.ackprg = 'rg --vimgrep --smart-case'
            vim.g.ackhighlight = 1
            --  Auto close the Quickfix list after pressing '<enter>' on a list item
            vim.g.ack_autoclose = 1
            --  Any empty ack search will search for the word the cursor is on
            vim.g.ack_use_cword_for_empty_search = 1
            --  Don't jump to first match
            vim.cmd.cnoreabbrev("Ack", "Ack!")
            --[[ Leaving this here for reference, currently not used
            command! -nargs=1 Nack Ack! "<args>" $NOTES/**
            command! -nargs=1 Note e $NOTES/Scratch/<args>.md
            command! Scratch exe "e $NOTES/Scratch/".strftime("%F-%H%M%S").".md"
            nnoremap('<Leader>wn', ':Nack<space>')
            nnoremap('<Leader>ww', '<CMD>Files $NOTES<CR>')
            ]]
        end
    },

    -- Remove search highlighting when not required
    {
        -- 'romainl/vim-cool',
        'nvimdev/hlsearch.nvim',
        keys = { "/", "*", "#" },
        -- Calling this manually to enable lazy loading
        config = function()
            require('hlsearch').setup()
            vim.cmd.doautocmd('BufWinEnter')
        end
    },

    -- TreeSitter
    {
        'nvim-treesitter/nvim-treesitter',
        -- ft = { 'c', 'bash', 'python', 'rust', 'markdown', 'lua', 'nix', 'yaml', 'vimdoc' },
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

    -- Toggle, join, and split line semanticly
    {
        'Wansmer/treesj',
        keys = { '<space>m', '<space>j', '<space>s' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
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
    { 'thirtythreeforty/lessspace.vim', event = "InsertLeavePre" },

    -- Sandwich text between things
    {
        'machakann/vim-sandwich',
        keys = {
            { "sr", mode = { 'n', 'x' } },
            { "sa", mode = { 'n', 'x' } },
            { "sd", mode = { 'n', 'x' } }
        },
    },

    --[[ Tpope's plugins, because he requires a special place :) ]]
    -- Enable repeating supported plugin maps with .
    { 'tpope/vim-repeat' },

    --Unix commands from Vim
    {
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
    --{'tpope/obsession'}, --Vim session management

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
    { 'dbeniamine/cheat.sh-vim', lazy = true },

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
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_disable_italic_comment = 0
            vim.g.gruvbox_material_enable_bold = 1
            vim.g.gruvbox_material_ui_contrast = 'high'
        end,
    },

    -- Icons in different plugins
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true, -- loads as a requirement of other plugins
    },

    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        config = function()
            vim.opt.termguicolors = true
            vim.notify = require("notify")
        end
    },

    -- { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = {}},
    { 'nvim-lualine/lualine.nvim' },

    -- Color colorcodes
    {
        'norcalli/nvim-colorizer.lua',
        event = 'VeryLazy',
        config = true,
        -- ft = { 'lua', 'markdown', 'html', 'php', 'python', 'vim', 'css', 'javascript' },
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
    {
        'RRethy/vim-illuminate',
        event = 'VeryLazy',
        -- config = function()
        --     require('vim-illuminate').configure({})
        -- end,
    },
}
