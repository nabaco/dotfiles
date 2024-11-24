-----------------------------------
-- Autocompletion Configuration  --
-----------------------------------

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp_config = function()
    local cmp = require('cmp')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
            end,
        },
        window = {
            --[[
            border = opts.border or 'rounded',
            winhighlight = opts.winhighlight or 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
            zindex = opts.zindex or 1001,
            col_offset = opts.col_offset or 0,
            side_padding = opts.side_padding or 1
            --]]
            completion = cmp.config.window.bordered({ zindex = 100, max_width = 50 }),
            documentation = cmp.config.window.bordered({ zindex = 120 }),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<S-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
            ['<CR>'] = cmp.mapping({
                i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                -- c = function(fallback)
                --     if cmp.visible() then
                --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                --     else
                --         fallback()
                --     end
                -- end
            }),
            ["<Tab>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                        --     vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                        -- vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                    else
                        fallback()
                    end
                end
            }),
            ["<S-Tab>"] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    else
                        cmp.complete()
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                    elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                        -- return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                    else
                        fallback()
                    end
                end,
                s = function(fallback)
                    if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    else
                        fallback()
                    end
                end
            }),
            ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
            ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
            ['<C-n>'] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end
            }),
            ['<C-p>'] = cmp.mapping({
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end
            }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            --{ name = 'luasnip' }
            { name = 'ultisnips' }
        }, {
            { name = 'buffer' },
        })
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline({
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = {
            { name = 'buffer' }
        }
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline({
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })

    --  UltiSnips Bindings
    -- vim.g.UltiSnipsListSnippets="<Leader>x"
end

return {
    'hrsh7th/nvim-cmp',
    branch = 'main',
    version = false,
    -- load cmp when starting editing, commands or search
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp',              branch = 'main' },
        { 'hrsh7th/cmp-buffer',                branch = 'main' },
        { 'hrsh7th/cmp-cmdline',               branch = 'main' },
        { 'hrsh7th/cmp-path',                  branch = 'main' },
        { 'lukas-reineke/cmp-under-comparator' },
        { 'ray-x/lsp_signature.nvim' },
        {
            'quangnguyen30192/cmp-nvim-ultisnips',
            config = true,
            branch = 'main',
            dependencies = {
                'SirVer/ultisnips',
                version = false,
                dependencies = {
                    'honza/vim-snippets',
                    version = false,
                }
            },
        },
        {
            'windwp/nvim-autopairs', -- Bracket completion
            config = true,
        },


    },
    config = cmp_config
}
