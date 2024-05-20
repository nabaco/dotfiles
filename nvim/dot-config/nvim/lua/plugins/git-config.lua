-----------------------------------
--       Git VCS Utilities       --
-----------------------------------

local function gitsigns_config(bufnr)
    local gitsigns = require('gitsigns')
    local m = require('mapx')
    m.nname("<leader>g", "Git")

    m.group({ buffer = bufnr }, function()
        -- Navigation
        m.nnoremap(']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end,
            "Next hunk")

        m.nnoremap('[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end,
            "Previous hunk")

        -- Actions
        m.nname('<leader>h', 'GitSigns')
        m.xname('<leader>h', 'GitSigns')
        m.nnoremap('<leader>hs', function() gitsigns.stage_hunk() end, "Stage hunk")
        m.nnoremap('<leader>hr', function() gitsigns.reset_hunk() end, "Reset hunk")
        m.xnoremap('<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            "Stage selected hunk")
        m.xnoremap('<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            "Reset selected hunk")
        m.nnoremap('<leader>hS', function() gitsigns.stage_buffer() end, "Stage buffer")
        m.nnoremap('<leader>hu', function() gitsigns.undo_stage_hunk() end, "Unstage hunk")
        m.nnoremap('<leader>hR', function() gitsigns.reset_buffer() end, "Reset buffer")
        m.nnoremap('<leader>hp', function() gitsigns.preview_hunk() end, "Preview hunk")
        -- "gm" mapping for compatability with GitMessenger - don't break muscle memory
        m.nnoremap({ '<leader>hb', '<leader>gm' }, function() gitsigns.blame_line { full = true } end, "Blame line")
        m.nnoremap('<leader>htb', function() gitsigns.toggle_current_line_blame() end, "Toggle inline blame")
        m.nnoremap('<leader>hd', function() gitsigns.diffthis() end, "Diff buffer")
        m.nnoremap('<leader>hD', function() gitsigns.diffthis('~') end, "Diff buffer HEAD")
        m.nnoremap('<leader>htd', function() gitsigns.toggle_deleted() end, "Toggle delted inline")

        -- Text object
        m.onoremap('ih', function() gitsigns.select_hunk() end)
        m.xnoremap('ih', function() gitsigns.select_hunk() end)
    end)
end

return {
    {
        --The power of git in vim
        'tpope/vim-fugitive',
        cmd = 'Git',
        keys = {
            --  Start a Git command
            { '<Leader>gg', ':Git<Space>',         desc = "Start a Git command" },
            { '<Leader>gs', '<CMD>Git status<CR>', desc = "Git status" },
            -- {'<Leader>gcm', '<CMD>Git commit<CR>', desc="Git commit"},
            { '<Leader>gd', '<CMD>Git diff<CR>',   desc = "Git diff (patch)" },
            { '<Leader>gc', '<CMD>Gdiffsplit<CR>', desc = "Git diff (compare)" },
        }
    },
    {
        --Branch TUI based on fugitive
        'idanarye/vim-merginal',
        dependencies = 'vim-fugitive',
        cmd = {
            'Merginal',
            'MerginalToggle'
        },
        keys = {
            { '<Leader>gb', '<CMD>MerginalToggle<CR>', desc = "Branches" },
        }
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            {
                -- optional - Diff integration
                "sindrets/diffview.nvim",
                opts = {
                    enhanced_diff_hl = true,
                },
                cmd = { 'DiffviewOpen' }
            },
            "ibhagwan/fzf-lua", -- optional
        },
        opts = {
            kind = 'auto',
            graph_style = 'unicode',
            integrations = {
                diffview = true,
                fzf_lua = true,
            },
        },
        config = true,
        keys = {
            { '<leader>gv', function() require('neogit').open() end, desc = "Neogit" }
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            numhl = true,
            on_attach = gitsigns_config,
        },
        config = true,
        event = 'VeryLazy'
    },
}
