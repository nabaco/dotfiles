-----------------------------------
--         Alpha Greeter         --
-----------------------------------

local alpha_config = function()
    local alpha = require('alpha')
    local startify = require('alpha.themes.startify')

    startify.section.header.val = {
        '     _   __            ____            ______        ',
        '    / | / /  ____ _   / __ )  ____ _  / ____/  ____  ',
        '   /  |/ /  / __ `/  / __  | / __ `/ / /      / __ \\ ',
        '  / /|  /  / /_/ /  / /_/ / / /_/ / / /___   / /_/ / ',
        ' /_/ |_/   \\__,_/  /_____/  \\__,_/  \\____/   \\____/  ',
    }

    startify.section.header.opts.position = "center"

    local fortune = {
        type = "text",
        val = require('alpha.fortune')(),
        opts = {
            position = "center",
            hl = "Title",
            align = "center"
        }
    }

    startify.section.top_buttons.val = {
        startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    }

    local rtp = vim.api.nvim_list_runtime_paths()[1]
    local bookmarks = {
        type = "group",
        val = {
            { type = "padding", val = 1 },
            { type = "text",    val = "Bookmarks" },
            { type = "padding", val = 1 },
            startify.button("i", " init.lua", "<CMD>edit $MYVIMRC<CR>"),
            startify.button("p", " plugins", "<CMD>Files " .. rtp .. "/lua<CR>"),
            startify.button("b", " bashrc", "<CMD>edit ~/.bashrc<CR>"),
            startify.button("l", " bashrc." .. vim.env.USER, "<CMD>edit ~/.bashrc." .. vim.env.USER .. "<CR>"),
        }
    }

    startify.config.layout = {
        { type = "padding", val = 1 },
        startify.section.header,
        fortune,
        { type = "padding", val = 2 },
        startify.section.top_buttons,
        startify.section.mru_cwd,
        startify.section.mru,
        bookmarks,
        { type = "padding", val = 1 },
        startify.section.bottom_buttons,
        startify.section.footer,
    }

    -- startify.nvim_web_devicons.highlight = 'Keyword'

    startify.section.bottom_buttons.val = {
        startify.button("u", "⤒  Update Plugins", function()
            require('lazy').sync()
        end),
        startify.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
    }
    -- startify.section.footer.val = {
    --     { type = "text", val = "footer" },
    -- }

    alpha.setup(startify.config)

    local mapx = require('mapx')
    mapx.nnoremap("<leader>s", "<CMD>Alpha<CR>")
end

return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = vim.argc == 0,
    config = alpha_config
}
