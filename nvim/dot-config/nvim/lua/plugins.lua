-----------------------------------
--       Plugin Management       --
-----------------------------------

--[[
This file is not included/sourced by default upon Neovim's startup.
It is "require"ed only on the first startup on a new system when packer is not installed yet.
Upon running, packer creates a compiled file, which includes all of the lazy loading info, that
is in Neovim's runtime path and is sourced automatically upon startup. All of the non-optional
plugins are already in the runtime path and are loaded automatically by Neovim's native mechanisms.
So packer is not even required to be part of Neovim in usual use-cases, only when managing the
plugins themselves.
Only corner-case that requires verification is updating plugins without changing this file.
Meaning, what is the behaviour when running "PackerSync" without editing this file?
PackerSync will work due to the lazy-loadin config for packer below.
]]

-- Packer is set as optional, so load it manually.
vim.cmd[[packadd packer.nvim]]

-- Plugins declaration.
-- TODO: Include profiling (passed to the startup function) to try to optimize further
return require('packer').startup({function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt=true, cmd={'Packer*'} }

    -- Startup time improvers
    use 'lewis6991/impatient.nvim' -- To be removed after https://github.com/neovim/neovim/pull/15436
    use 'nathom/filetype.nvim' -- Replaces native filetype.vim for faster startup
    -- TODO: Move all custom filetypes to filetype.setup()
    -- https://github.com/nathom/filetype.nvim

    -- Get used to proper Vim movement
    use 'takac/vim-hardtime'

    -- Add some additional text objects and attack them
    use 'wellle/targets.vim'

    -- Reposition cursor in the last position upon file reopening
    use 'farmergreg/vim-lastplace'

    -- Git support
    use 'tpope/vim-fugitive' --The power of git in vim
    use {'idanarye/vim-merginal', requires='vim-fugitive'} --Branch TUI based on fugitive
    use {'jreybert/vimagit', opt=true, cmd={'Magit', 'MagitOnly'}} --Easier stage/commit workflow
    use 'airblade/vim-gitgutter' --Show changes live + 'hunk/change' text object
    use {'rhysd/git-messenger.vim', opt=true, cmd='GitMessenger', keys='<Leader>gm'} --Git blame in bubbles

    --if vim.fn.has("Win32") then
    --    { 'Shougo/vimproc.vim', run='nmake'}
    --end

    -- Vim Rooter - needed for all the git plugins to work correctly,
    -- in a multi-repo environment
    use 'airblade/vim-rooter'

    -- Puts all vim navigation keys on drugs! f,t,w,b,e etc..
    use 'easymotion/vim-easymotion'

    -- Ultimate fuzzy search + Multi-entry selection UI.
    -- TODO: if fn.empty(fn.glob('/usr/bin/fzf')) > 0 then
    -- Binary is installed through package manager.
    -- Install just the latest plugin without installing FZF itself
    --    'junegunn/fzf'
    -- else
    use {'junegunn/fzf', run=vim.fn["fzf#install()"]}
    --end
    use 'junegunn/fzf.vim'
    use {'junegunn/vim-peekaboo'} -- Peek into registers ", @, <C-R>
    use {'kevinhwang91/nvim-bqf', ft = 'qf'}

    -- Alternative file contents search
    use 'mileszs/ack.vim'
    use {'romainl/vim-cool'}

    -- Language Server Protocol (LSP) Client
    use {
        'neovim/nvim-lspconfig', -- Stock defaults
        --'glepnir/lspsaga.nvim'
        'tami5/lspsaga.nvim', -- prettier tools for LSP commands
        'liuchengxu/vista.vim', -- Sidebar/search for symbols
        'weilbith/nvim-lsp-smag', -- Better integration with nvim's tags tools
        'folke/lua-dev.nvim',--, ft='lua'}
    }
    -- TODO: Setup extra tools as if LSP (shellcheck?)
    use { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' } }


    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        branch='main',
        requires = {
            {'hrsh7th/cmp-nvim-lsp', branch='main'},
            {'hrsh7th/cmp-buffer', branch='main', after='nvim-cmp'},
            -- {'hrsh7th/cmp-cmdline', branch='main', after='nvim-cmp'},
            {'hrsh7th/cmp-path', branch='main', after='nvim-cmp'},
            {'quangnguyen30192/cmp-nvim-ultisnips', branch='main', after='nvim-cmp'},
            {'lukas-reineke/cmp-under-comparator', after='nvim-cmp'}
        },
        -- TODO: Moved configs to a separate lua file, and enable upon event
        --config=[[require('config.cmp')]]
        --event = 'InsertEnter *',
    }
    use 'ray-x/lsp_signature.nvim'
    -- I'm still unsure about the 'trouble' plugin, as I get most out of others.
    -- Might be nice to collect workspace diagnostics.
    use {
        'folke/trouble.nvim',
        config=function()
            require('trouble').setup{}
        end,
        cmd='Trouble',
        opt=true,
    }
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- Automatically add 'end' in languages like lua
    use 'RRethy/nvim-treesitter-endwise'

    -- File browsing
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require'nvim-tree'.setup{auto_close=true}
            vim.g.nvim_tree_quit_on_open = 1
            vim.g.nvim_tree_disable_window_picker = 1
            vim.g.nvim_tree_respect_buf_cwd = 1
        end,
        opt=true,
        cmd={'NvimTree*'}
    }

    -- Visualize undo history
    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
    }
    -- Ranger file manager integration
    use {'kevinhwang91/rnvimr', run='make sync'}

    -- A - for switching between source and header files
    use 'vim-scripts/a.vim'

    -- UltiSnips
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'

    -- Remove extraneous whitespace when edit mode is exited
    use 'thirtythreeforty/lessspace.vim'

    -- Bracket completion
    use 'windwp/nvim-autopairs'

    -- Tpope's plugins
    use 'tpope/vim-surround' --surround vim
    use 'tpope/vim-repeat' --Enable repeating supported plugin maps with .
    use 'tpope/vim-eunuch' --Unix commands from Vim
    -- It appears I don't need that since Startify does the same
    --'tpope/obsession' --Vim session management
    use {
        'numToStr/Comment.nvim', -- Commenting powers, includes blocks and not only lines
        config = function()
            require('Comment').setup()
        end
    }
    -- Imporve % for if..else and such
    -- Does Neovim need this? I think Neovim has it built in
    --'adelarsq/vim-matchit'
    --'andymass/vim-matchup''

    -- Some help with the key mappings
    -- supplies proper lua commands similar to vim's commands for mapping
    -- Which Key (similar to Emacs' plugin) supplies help pop-ups to remind of key bindings
    use {'b0o/mapx.nvim', requires='folke/which-key.nvim'}

    -- External App Integration
    -- API documentation
    -- TODO: 'KabbAmine/zeavim.vim'
    -- The ultimate cheat sheet
    use 'dbeniamine/cheat.sh-vim'
    -- Read GNU Info from vim
    --'alx741/vinfo'
    -- TODO: 'HiPhish/info.vim', {'on' : 'Info'}

    -- Notes, to-do, etc
    use 'vimwiki/vimwiki'
    use 'vimwiki/utils'
    use {
        'lukas-reineke/headlines.nvim',
        config = function()
            require('headlines').setup()
        end,
    }

    -- Task Warrior integration
    use 'tools-life/taskwiki'
    use 'farseer90718/vim-taskwarrior'
    use 'powerman/vim-plugin-AnsiEsc'

    -- Language specific plugins
    -- TODO: Map the filetypes in filetype.lua setup{}, and make those optional accordingly
    use 'kovetskiy/sxhkd-vim'
    use 'chrisbra/csv.vim'
    use 'vhdirk/vim-cmake'
    use 'vim-pandoc/vim-pandoc'
    use 'vim-pandoc/vim-pandoc-syntax'
    use 'kergoth/vim-bitbake'
    use 'Matt-Deacalion/vim-systemd-syntax'
    use 'cespare/vim-toml'
    use 'tmux-plugins/vim-tmux'
    use 'tmux-plugins/vim-tmux-focus-events'
    use 'mfukar/robotframework-vim'
    use 'MTDL9/vim-log-highlighting'
    use 'coddingtonbear/confluencewiki.vim'

    -- PlanUML support and preview
    use 'aklt/plantuml-syntax'
    use 'scrooloose/vim-slumlord'

    -- Pop-up the built in terminal
    use {'Lenovsky/nuake', opt=true, cmd='Nuake'}

    -- Eye Candy
    --use 'morhetz/gruvbox'
    use { 'sainnhe/gruvbox-material' }
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- Color colorcodes
    use 'norcalli/nvim-colorizer.lua'
    -- Color brackets
    use 'junegunn/rainbow_parentheses.vim'

    -- Start screen
    use 'mhinz/vim-startify'

    -- Highlight same words as under cursor
    use 'RRethy/vim-illuminate'

    -- Use pywal theme
    --'dylanaraps/wal.vim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
        -- When running Neovim for the first time, you load the config before having the actual
        -- plugins installed, which causes a lot of error messages and a mess. So better exit,
        -- so that the user re-enters into a proper environemt/experience.
        --vim.cmd[[quit]]
        vim.cmd[[autocmd User PackerComplete quitall]]
    end
end,
config = {
	git = {
		clone_timeout = 180
	}
}})
