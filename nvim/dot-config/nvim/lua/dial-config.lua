-----------------------------------
--          Dial config          --
-----------------------------------

-- Incerement numbers intelligently
return {
    'monaqa/dial.nvim',
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    keys = { '<c-a>', '<c-x>' },
    config = function()
        local nnoremap = function(...) vim.keymap.set('n', ...) end
        local vnoremap = function(...) vim.keymap.set('v', ...) end

        nnoremap("<C-a>", function() require('dial.map').manipulate("increment", "normal") end)
        nnoremap("<C-x>", function() require('dial.map').manipulate("decrement", "normal") end)
        nnoremap("g<C-a>", function() require('dial.map').manipulate("increment", "gnormal") end)
        nnoremap("g<C-x>", function() require('dial.map').manipulate("decrement", "gnormal") end)
        vnoremap("<C-a>", function() require('dial.map').manipulate("increment", "visual") end)
        vnoremap("<C-x>", function() require('dial.map').manipulate("decrement", "visual") end)
        vnoremap("g<C-a>", function() require('dial.map').manipulate("increment", "gvisual") end)
        vnoremap("g<C-x>", function() require('dial.map').manipulate("decrement", "gvisual") end)
    end
}
