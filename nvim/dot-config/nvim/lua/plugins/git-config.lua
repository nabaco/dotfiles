-----------------------------------
--       Git VCS Utilities       --
-----------------------------------

local function gitsigns_config(bufnr)
    local gitsigns = require('gitsigns')
    local wk = require('which-key')

    local function noremap(mode, lhs, rhs, opts)
        local o = opts or {}
        o.buffer = bufnr
        if type(lhs) == "table" then
            for _, v in ipairs(lhs) do
                vim.keymap.set(mode, v, rhs, o)
            end
        else
            vim.keymap.set(mode, lhs, rhs, o)
        end
    end
    local function nnoremap(...)  noremap("n", ...) end
    local function xnoremap(...)  noremap("x", ...) end
    local function onoremap(...)  noremap("o", ...) end

    wk.add({ "<leader>g", group = "Git", mode = "n" })

    -- Navigation
    nnoremap(']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end,
        { desc = "Next hunk" })

    nnoremap('[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end,
        { desc = "Previous hunk" })

    -- Actions
    wk.add({
        { '<leader>h', group = 'GitSigns', mode = 'n' },
        { '<leader>h', group = 'GitSigns', mode = 'x' },
    })
    nnoremap('<leader>hs', function() gitsigns.stage_hunk() end, { desc = "Stage hunk" })
    nnoremap('<leader>hr', function() gitsigns.reset_hunk() end, { desc = "Reset hunk" })
    xnoremap('<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { desc = "Stage selected hunk" })
    xnoremap('<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { desc = "Reset selected hunk" })
    nnoremap('<leader>hS', function() gitsigns.stage_buffer() end, { desc = "Stage buffer" })
    nnoremap('<leader>hu', function() gitsigns.undo_stage_hunk() end, { desc = "Unstage hunk" })
    nnoremap('<leader>hR', function() gitsigns.reset_buffer() end, { desc = "Reset buffer" })
    nnoremap('<leader>hp', function() gitsigns.preview_hunk() end, { desc = "Preview hunk" })
    -- "gm" mapping for compatability with GitMessenger - don't break muscle memory
    nnoremap({ '<leader>hb', '<leader>gm' }, function() gitsigns.blame_line { full = true } end,
        { desc = "Blame line" })
    nnoremap('<leader>htb', function() gitsigns.toggle_current_line_blame() end, { desc = "Toggle inline blame" })
    nnoremap('<leader>hd', function() gitsigns.diffthis() end, { desc = "Diff buffer" })
    nnoremap('<leader>hD', function() gitsigns.diffthis('~') end, { desc = "Diff buffer HEAD" })
    nnoremap('<leader>htd', function() gitsigns.toggle_deleted() end, { desc = "Toggle delted inline" })

    -- Text object
    onoremap('ih', function() gitsigns.select_hunk() end)
    xnoremap('ih', function() gitsigns.select_hunk() end)
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
        version = false,
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
