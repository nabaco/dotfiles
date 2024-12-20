-----------------------------------
--   Language Server Protocol    --
-----------------------------------
local lsp_filetypes = { "python", "robot", "bash", "sh", "rust", "c", "cpp", "lua", "go", "zig" }

-- Function to concentrate all mappings
local function mappings_setup(client, bufnr)
    local wk = require("which-key")
    local opts = { silent = true, buffer = bufnr }

    local function nnoremap(...) vim.keymap.set('n', ...) end
    local function vnoremap(...) vim.keymap.set('v', ...) end

    wk.add({"<leader>l", group="LSP"})
    nnoremap("<leader>lD", function()
        vim.lsp.buf.declaration()
    end, opts, { desc = "Declaration" })
    nnoremap("<c-[>", "<cmd>Lspsaga peek_definition<CR>", opts, { desc = "Peek definition" })
    nnoremap("<leader>ld", function()
        vim.lsp.buf.definition()
    end, opts, { desc = "Definition" })
    nnoremap("<leader>li", function()
        vim.lsp.buf.implementation()
    end, opts, { desc = "Implementation" })
    nnoremap("<leader>lt", function()
        vim.lsp.buf.type_definition()
    end, opts, { desc = "Type definition" })
    nnoremap("<leader>ls", function()
        vim.lsp.buf.workspace_symbol()
    end, opts, { desc = "Symbol search" })
    nnoremap("<leader>lR", "<cmd>Lspsaga rename<CR>", opts, { desc = "Rename" })
    nnoremap("<leader>lr", function()
        vim.lsp.buf.references()
    end, opts, { desc = "References" })
    nnoremap("<leader>la", "<cmd>Lspsaga code_action<CR>", opts, { desc = "Code action" })
    vnoremap("<leader>la", "<cmd>Lspsaga range_code_action<CR>", opts, { desc = "Code action" })

    -- Set some keybinds conditional on server capabilities
    if client.supports_method('textDocument/formatting') then
        nnoremap("<leader>lf", function() vim.lsp.buf.format() end, opts, { desc = "Format" })
    end
    if client.supports_method('textDocument/rangeFormatting') then
        vim.api.nvim_set_option_value(
            "formatexpr",
            "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})",
            { buf = bufnr }
        )
    end

    wk.add({"<leader>w", group="LSP Workspace"})
    nnoremap("<leader>wa", function()
        vim.lsp.buf.add_workspace_folder()
    end, opts, { desc = "Add workspace folder" })
    nnoremap("<leader>wr", function()
        vim.lsp.buf.remove_workspace_folder()
    end, opts, { desc = "Remove workspace folder" })
    nnoremap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts, { desc = "List workspace folders" })

    wk.add({"<leader>d", group="LSP Diagnostics"})
    nnoremap("<leader>ds", "<cmd>Lspsaga show_line_diagnostics<CR>", opts, { desc = "Show line diagnostics" })
    nnoremap("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts, { desc = "Previous diagnostic" })
    nnoremap("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts, { desc = "Next diagnostic" })
    nnoremap("<leader>dq", function() vim.diagnostic.setqflist() end, opts, { desc = "Set diagnostics in Quickfix" })
    vim.api.nvim_buf_create_user_command(bufnr, "LspDiag", function() vim.diagnostic.setqflist() end, { nargs = 0 })

    -- LSP UI imporvements
    require("lspsaga").setup({})
end -- mappings_setup

-- Callback to be passed to NeoVim
-- Will be called once an LSP client attaches to a buffer
local function on_attach(client, bufnr)
    mappings_setup(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    -- Will highlight symbol's usage if I hover on it enough time
    -- Not really required given the illuminate plugin
    if client.supports_method('textDocument/documentHighlight') then
        vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Search" })
        vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Search" })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Search" })
        local lsp_document_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold",
            { group = lsp_document_highlight, buffer = bufnr, callback = function() vim.lsp.buf.document_highlight() end })
        vim.api.nvim_create_autocmd("CursorMoved",
            { group = lsp_document_highlight, buffer = bufnr, callback = function() vim.lsp.buf.clear_references() end })
    end
    require("lsp_signature").on_attach({ hi_parameter = "IncSearch" }, bufnr)
end -- on_attach

-- Setup the different LSP servers
local function servers_setup()
    local lspconfig = require("lspconfig")
    -- Use a loop to conveniently both setup defined servers
    -- and map buffer local keybindings when the language server attaches
    local servers = {
        jedi_language_server = {},
        robotframework_ls = {},
        bashls = {},
        gopls = {},
        zls = {},
        bitbake_language_server = {},
        rust_analyzer = {
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                    },
                },
            },
        },
        clangd = {
            cmd = {
                "clangd",
                "--background-index",
                "--limit-results=0",
                "-j=" .. io.popen("nproc"):read(),
                "--enable-config",
                "--clang-tidy",
                "--header-insertion=iwyu",
            },
            root_dir = function(fname)
                return lspconfig.util.root_pattern("compile_commands.json")(fname)
                    or lspconfig.util.root_pattern("compile_flags.txt", ".clangd", ".git")(fname)
            end,
        },
        lua_ls = {}
    }

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    for lsp, opts in pairs(servers) do
        opts['on_attach'] = on_attach
        opts['capabilities'] = capabilities
        if lsp == "lua_ls" then
            require('lazydev').setup({
                library = {
                    -- plugins = { "nvim-dap-ui" }, types = true,
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            })
        end
        lspconfig[lsp].setup(opts)
    end
end -- servers_setup

-- configuration function passed to LSP on_attach
local function lsp_config()
    servers_setup()
    for _, ft in ipairs(lsp_filetypes) do
        if vim.api.nvim_get_option_value("ft", { buf = 0 }) == ft then
            vim.cmd.LspStart()
        end
    end
end -- lsp_config

-- A handy command, for when shortcuts don't work
-- I need it for now as lua-language-server is misbhaving with my Lua configs
vim.api.nvim_create_user_command("Format", vim.lsp.buf.format, {})

return {
    -- LSP configuration for Lua development in Neovim
    {
        "folke/lazydev.nvim",
        -- It'll be loaded upon being 'required'
        lazy = true,
        dependencies = {
            { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
        }
    },

    -- LSP stock defaults
    {
        "neovim/nvim-lspconfig",
        event = 'VeryLazy',
        -- ft = lsp_filetypes,
        config = lsp_config,
        dependencies = {

            -- prettier tools for LSP commands
            {
                "nvimdev/lspsaga.nvim",
                -- enabled = false,
                config = true,
                opts = {
                    outline = {
                        close_after_jump = true,
                        keys = {
                            toggle_or_jump = '<CR>',
                        }
                    },
                    rename = {
                        keys = {
                            quit = '<ESC>',
                        }
                    }
                },
                dependencies = {
                    -- "nvim-treesitter/nvim-treesitter", -- optional
                    -- "nvim-tree/nvim-web-devicons",     -- optional
                },
            },

            -- Better integration with nvim's tags tools
            {
                "weilbith/nvim-lsp-smag",
                init = function()
                    -- In case no tags are available from the LSP Server,
                    -- or I turned off the LSP client, use regular tags (e.g. ctags)
                    vim.g.lsp_smag_fallback_tags = 1
                end,
            },

            -- Autocompletion based on LSP inputs
            { "hrsh7th/cmp-nvim-lsp", branch = "main" },

            -- Help with function signature
            {
                "ray-x/lsp_signature.nvim",
                -- event = "VeryLazy",
                opts = {},
                config = true,
            },

            -- I'm still unsure about the 'trouble' plugin, as I get most out of others.
            -- Might be nice to collect workspace diagnostics.
            {
                "folke/trouble.nvim",
                config = true,
                cmd = "Trouble",
                -- branch = "dev"
            },
        },
    },
    -- {
    --     "nvimtools/none-ls.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --     ft = { "sh", "bash" },
    --     config = function()
    --         local null_ls = require("null-ls")
    --
    --         null_ls.setup({
    --             sources = {
    --                 null_ls.builtins.formatting.stylua,
    --                 -- null_ls.builtins.completion.spell,
    --             },
    --         })
    --     end,
    -- },
}
