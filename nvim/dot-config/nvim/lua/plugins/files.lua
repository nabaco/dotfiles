-----------------------------------
--       File Types Support      --
-----------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function nvim_tree_config()
    local api = require('nvim-tree.api')
    local preview = require('nvim-tree-preview')

    -- Stage/unstage file under curser in nvim tree window
    local function git_add()
        local node = api.tree.get_node_under_cursor()
        local gs = node.git_status.file

        -- If the current node is a directory get children status
        if gs == nil then
            gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
                or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
        end

        -- If the file is untracked, unstaged or partially staged, we stage it
        if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
            vim.cmd("silent !git add " .. node.absolute_path)

            -- If the file is staged, we unstage
        elseif gs == "M " or gs == "A " then
            vim.cmd("silent !git restore --staged " .. node.absolute_path)
        end

        api.tree.reload()
    end

    -- On attach callback
    local function nvim_tree_on_attach(bufnr)
        -- Options for setting keys
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr) -- Default mapping

        vim.keymap.set('n', 'P', preview.watch, opts('Preview (Watch)'))
        vim.keymap.set('n', '<Esc>', preview.unwatch, opts('Close Preview/Unwatch'))
        vim.keymap.set('n', 'ga', git_add, opts('Git Add'))

        -- This should only happen when opening a folder
        -- Open a file inplace
        if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
            vim.keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, opts('Open'))
        end

        -- Smart tab behavior: Only preview files, expand/collapse directories.
        vim.keymap.set('n', '<Tab>', function()
            local ok, node = pcall(api.tree.get_node_under_cursor)
            if ok and node then
                if node.type == 'directory' then
                    api.node.open.edit()
                else
                    preview.node(node, { toggle_focus = true })
                end
            end
        end, opts('Preview'))

        -- Automatically open files on creation
        -- api.events.subscribe(api.events.Event.FileCreated, function(file)
        --     vim.cmd.edit(file.fname)
        -- end)

        -- Automatically close nvim-tree when it is the last open window
        -- Effectly exits vim
        autocmd('QuitPre', {
            group = augroup('NvimTreeClose', { clear = true }),
            nested = true,
            callback = function()
                -- Only 1 window with nvim-tree left: we probably closed a file buffer
                if #vim.api.nvim_list_wins() == 2 and api.tree.is_visible() and not api.tree.is_tree_buf() then
                    -- close nvim-tree: will go to the last hidden buffer used before closing
                    api.tree.close()
                end
            end
        })

        -- When deleting a buffer, replicate Vim's behaviour when nvim-tree is closed
        -- Without this, upon closing the last buffer, nvim-tree is maximized
        autocmd('BufDelete', {
            group = augroup('NvimTreeHiddenBuffer', { clear = true }),
            nested = true,
            callback = function()
                -- Only 1 window with nvim-tree left: we probably closed a file buffer
                if #vim.api.nvim_list_wins() == 1 and api.tree.is_visible() then
                    -- Required to let the close event complete. An error is thrown without this.
                    vim.defer_fn(function()
                        -- close nvim-tree: will go to the last hidden buffer used before closing
                        api.tree.close()
                        -- re-open nvim-tree
                        api.tree.find_file({ buf = 0, open = true, focus = false, current_window = false, update_root = true })
                    end, 0)
                end
            end
        })
    end

    local nvim_tree_opts = {
        on_attach = nvim_tree_on_attach,
        hijack_cursor = true,
        disable_netrw = true,
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
        respect_buf_cwd = true,
        view = {
            relativenumber = true
        },
        update_focused_file = {
            enable = true,
            update_root = {
                enable = true
            }
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = true,
                    picker = function()
                        return require('window-picker').pick_window {
                            hint = 'floating-big-letter',
                            filter_rules = {
                                -- Don't place picker letters on preview windows
                                file_path_contains = { 'nvim-tree-preview://' },
                            },
                        }
                    end,
                },
                quit_on_open = true,
            },
        },
        live_filter = {
            always_show_folders = false,
        }
    }

    require('nvim-tree').setup(nvim_tree_opts)
end

-- Automatically open nvim-tree when opening a directory
-- Especially relevant since I removed netrw loading
-- Of course this cannot be done as part of the on_attach callback
autocmd('VimEnter', {
    group = augroup('OpenNvimTree', { clear = true }),
    callback = function(data)
        -- buffer is a directory
        local directory = vim.fn.isdirectory(data.file) == 1

        if not directory then
            return
        end

        -- open the tree
        require('nvim-tree.api').tree.find_file({ buf = 0, open = true, current_window = true, update_root = true })
        require('nvim-tree.api').tree.expand_all()
    end
})

-- Autocommands for live reconfiguration of the system when editing specific files
local autoreconf = augroup('autoreconf', { clear = true })
-- autocmd('BufWritePost', { group = autoreconf, pattern = '*sxhkdrc', command = '!pkill -USR1 -x sxhkd' })
-- autocmd('BufWritePost', { group = autoreconf, pattern = '*init.vim', command = 'source ~/.config/nvim/init.vim' })
-- Not required with Lazy.nvim
-- autocmd('BufWritePost', {group=autoreconf, pattern='*init.lua', command=function(args) vim.cmd.source(args.file) end})
-- autocmd('BufWritePost', { group = autoreconf, pattern = '*bspwmrc', command = '!bspc wm -r' })
autocmd('BufWritePost', { group = autoreconf, pattern = '*picom.conf', command = '!pkill -x picom && picom -b' })
-- autocmd('BufWritePost', { group = autoreconf, pattern = '*mpd.conf', command = '!mpd' }) --kill && mpd
-- autocmd('BufWritePost', { group = autoreconf, pattern = '*termite/config', command = '!killall -USR1 termite' })
-- autocmd('BufWritePost',
-- { group = autoreconf, pattern = '*qtile/config.py', command = '!qtile-cmd -o cmd -f restart > /dev/null 2&>1' })

-- Help Neovim recognize Yocto files with different extensions
vim.filetype.add({
    extension = {
        bbappend = "bitbake",
        bbclass = "bitbake",
        bb = "bitbake",
    }
})

return {
    -- Language specific plugins
    -- { 'kovetskiy/sxhkd-vim',                            ft = 'sxhkd' },
    -- { 'chrisbra/csv.vim',                               ft = 'csv' },
    { 'vhdirk/vim-cmake',                               ft = 'cmake' },
    { 'kergoth/vim-bitbake',                            ft = 'bitbake' },
    { 'https://codeberg.org/Dokana/vim-systemd-syntax', branch = 'trunk', ft = 'systemd' },
    { 'cespare/vim-toml',                               ft = 'toml' },
    { 'tmux-plugins/vim-tmux',                          ft = 'tmux' },
    -- { 'mfukar/robotframework-vim',                      ft = 'robot' },
    -- { 'aklt/plantuml-syntax',                           ft = 'plantuml' },
    -- {
    --     'scrooloose/vim-slumlord',
    --     ft = 'plantuml',
    --     config = function()
    --         --  PlantUML path
    --         vim.g.plantuml_executable_script = 'java -jar $NFS/plantuml.jar'
    --     end
    -- }, -- Preview
    -- { 'vim-pandoc/vim-pandoc-syntax', ft = 'pandoc' },
    -- {
    --     'vim-pandoc/vim-pandoc',
    --     ft = 'pandoc',
    --     config = function()
    --         --  Pandoc configuration
    --         vim.g['pandoc#command#custom_open'] = 'zathura'
    --         vim.g['pandoc#command#prefer_pdf'] = 1
    --         vim.g['pandoc#command#autoexec_command'] = "Pandoc! pdf"
    --         vim.g['pandoc#completion#bib#mode'] = 'citeproc'
    --     end
    -- }, -- Utilities, not syntax

    -- When reading logfiles with Ansi Escape codes dumped in them,
    -- conceal the escape code and show the text with the proper color
    { 'powerman/vim-plugin-AnsiEsc',                    ft = 'log' },
    { 'MTDL9/vim-log-highlighting',                     ft = 'log' },

    -- File browsing
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icon
            'b0o/nvim-tree-preview.lua',
            'nvim-lua/plenary.nvim',       -- for the preview extension
            {
                's1n7ax/nvim-window-picker',
                name = 'window-picker',
                config = true
            }
        },
        config = nvim_tree_config,
        cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
        keys = {
            { '<Leader>n', '<CMD>NvimTreeToggle<CR>', "File explorer" },
            { '<Leader>v',
                function()
                    require('nvim-tree.api').tree.toggle({
                        find_file = true,
                        update_root = true,
                    })
                end, "Current file in file explorer" },
        }
    },
}
