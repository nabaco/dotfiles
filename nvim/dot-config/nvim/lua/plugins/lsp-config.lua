-----------------------------------
--   Language Server Protocol    --
-----------------------------------

-- Function to concentrate all mappings
local mappings_setup = function(client, bufnr)
    local opts = { silent=true, buffer=bufnr }
    mapx.nname("<leader>l", "LSP")
    nnoremap('<leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    --nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    nnoremap('<c-[>', '<cmd>Lspsaga preview_definition<CR>', opts)
    nnoremap("<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>")
    nnoremap("<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>")
    nnoremap('<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- nnoremap('<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    nnoremap('<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    nnoremap('<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    nnoremap('<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    nnoremap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    nnoremap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    nnoremap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    nnoremap('<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- nnoremap('<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    nnoremap('<leader>lR', '<cmd>Lspsaga rename<CR>', opts)
    nnoremap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    --nnoremap('<leader>ds', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    nnoremap('<leader>ds', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
    -- nnoremap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    -- nnoremap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    nnoremap('[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
    nnoremap(']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
    nnoremap('<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    nnoremap('<leader>la', '<cmd>Lspsaga code_action<CR>', opts)
    vnoremap('<leader>la', '<cmd>Lspsaga range_code_action<CR>', opts)
    cmdbang("LspDiag", function() vim.diagnostic.setloclist() end, {nargs = 0})

    -- Vista config
    vim.g.vista_default_executive='nvim_lsp'
    nnoremap('<leader>t', '<cmd>Vista finder<CR>', opts)

    -- LSP UI imporvements
    require'lspsaga'.init_lsp_saga()

    local caps = client.server_capabilities
    -- Set some keybinds conditional on server capabilities
    if caps.document_formatting then
        nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif caps.document_range_formatting then
        nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

-- Callback to be passed to NeoVim
-- Will be called once an LSP client attaches to a buffer
local on_attach = function(client, bufnr)
    mappings_setup(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    -- Will highlight symbol's usage if I hover on it
    if caps.document_highlight then
        vim.api.nvim_set_hl(0, 'LspReferenceRead', {link = 'Search'})
        vim.api.nvim_set_hl(0, 'LspReferenceText', {link = 'Search'})
        vim.api.nvim_set_hl(0, 'LspReferenceWrite', {link = 'Search'})
        vim.api.nvim_exec([[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
    require "lsp_signature".on_attach({ hi_parameter = "IncSearch"})
end

-- Setup the different LSP servers
local servers_setup = function()
    local lspconfig = require('lspconfig')
    -- Use a loop to conveniently both setup defined servers
    -- and map buffer local keybindings when the language server attaches
    -- Those are only generic servers that don't require extra configuration
    -- TODO: Add a method to have all servers here and store settings separately
    local servers = { "jedi_language_server", "robotframework_ls", "bashls"}
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities
        }
    end

    lspconfig.rust_analyzer.setup{
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    command = "clippy";
                }
            }
        }
    }

    lspconfig.clangd.setup{
        cmd = {
            "clangd",
            "--background-index",
            "--limit-results=0",
            "-j="..io.popen("nproc"):read(),
            "--enable-config",
            "--clang-tidy",
            "--header-insertion=iwyu",
        },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = function(fname)
            return lspconfig.util.root_pattern("compile_commands.json")(fname) or
            lspconfig.util.root_pattern("compile_flags.txt", ".clangd", ".git")(fname);
        end
    }
end

-- configuration function passed to LSP on_attach
local config = function()
    servers_setup()
    vim.cmd.LspStart()
end

return {
    {
        'neovim/nvim-lspconfig', -- Stock defaults
        event = 'VeryLazy',
        config = config,
        dependencies = {
            --'glepnir/lspsaga.nvim',
            'tami5/lspsaga.nvim', -- prettier tools for LSP commands
            {
                -- Sidebar/search for symbols
                'liuchengxu/vista.vim',
                config = function()
                    -- Will show the function I'm in in the status bar
                    vim.api.nvim_exec('autocmd VimEnter * call vista#RunForNearestMethodOrFunction()', false)

                    -- Statusbar configuration
                    -- require'lualine'.setup{
                    --     options = { theme = 'gruvbox-material' },
                    --     sections = { lualine_c = {'filename', 'b:vista_nearest_method_or_function'} }
                    -- }
                end,
            },
            {
                -- Better integration with nvim's tags tools
                'weilbith/nvim-lsp-smag',
                config=function()
                    -- In case no tags are available from the LSP Server,
                    -- or I turned off the LSP client, use regular tags (e.g. ctags)
                    vim.g.lsp_smag_fallback_tags = 1
                end
            },

            {'hrsh7th/cmp-nvim-lsp', branch='main'},
            -- I'm still unsure about the 'trouble' plugin, as I get most out of others.
            -- Might be nice to collect workspace diagnostics.
            {
                'folke/trouble.nvim',
                config=true,
                cmd='Trouble',
            },
        }
    },
        {
            'folke/neodev.nvim',
            ft="lua",
            opts={},
        },
        -- TODO: Setup extra tools as if LSP (shellcheck?)
        -- {
        --     'jose-elias-alvarez/null-ls.nvim',
        --     dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        -- },
}
