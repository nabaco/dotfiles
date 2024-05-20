-----------------------------------
--          Dial config          --
-----------------------------------

-- Incerement numbers intelligently
return {
    'monaqa/dial.nvim',
    version = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "b0o/mapx.nvim"
    },
    keys = { '<c-a>', '<c-x>' },
    config = function()
        local m = require('mapx')
        m.nnoremap("<C-a>", function() require('dial.map').manipulate("increment", "normal") end)
        m.nnoremap("<C-x>", function() require('dial.map').manipulate("decrement", "normal") end)
        m.nnoremap("g<C-a>", function() require('dial.map').manipulate("increment", "gnormal") end)
        m.nnoremap("g<C-x>", function() require('dial.map').manipulate("decrement", "gnormal") end)
        m.vnoremap("<C-a>", function() require('dial.map').manipulate("increment", "visual") end)
        m.vnoremap("<C-x>", function() require('dial.map').manipulate("decrement", "visual") end)
        m.vnoremap("g<C-a>", function() require('dial.map').manipulate("increment", "gvisual") end)
        m.vnoremap("g<C-x>", function() require('dial.map').manipulate("decrement", "gvisual") end)
    end
}
