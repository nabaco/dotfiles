-----------------------------------
--         Alpha Greeter         --
-----------------------------------

-- If we're opening a file, Alpha plugin is not loaded,
-- meaning that its config function isn't called.
-- So we need to separately map a key to invoke it
if vim.fn.argc() > 0 then
    vim.keymap.set('n', "<leader>s", "<CMD>Lazy load alpha-nvim <BAR> Alpha<CR>")
end

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

    local max_width = 55
    local fortune_text = require('alpha.fortune')()
    local boxed_fortune = { "╭" .. string.rep("─", max_width) .. "╮" }
    for i, line in ipairs(fortune_text) do
        local l = {}
        if line == " " and i == 1 then
        elseif line == " " then
            l = { "│" .. string.rep(" ", max_width) .. "│" }
        elseif #line < max_width then
            l = { "│" .. line .. string.rep(" ", max_width - #line) .. "│" }
        else
            l = { "│" .. line .. " │" }
        end
        boxed_fortune = vim.list_extend(boxed_fortune, l)
    end
    boxed_fortune = vim.list_extend(boxed_fortune, { "╰" .. string.rep("─", max_width) .. "╯" })

    local fortune = {
        type = "text",
        val = boxed_fortune,
        opts = {
            position = "center",
            hl = "Title",
            align = "center"
        }
    }

    -- Days without accidents (changing my neovim config)
    local get_dwa = function()
        local time = require('configpulse').get_time()
        return string.format("%d days, %d hours, and %d minutes without modifying configuration.",
            time.days, time.hours, time.minutes)
    end
    local dwa = {
        type = "text",
        val = get_dwa,
        opts = {
            position = "center",
            hl = "Directory",
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
        dwa,
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
    {
        'goolord/alpha-nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'mrquantumcodes/configpulse',
        },
        -- If we're opening a file, dashboard is not required, so lazy load it
        -- We have a mapping at the top to load it on demand.
        -- otherwise, we want to open the dashboard, so load it immediately.
        lazy = vim.fn.argc() > 0,
        config = alpha_config
    },
}
