-----------------------------------
--      Development helpers      --
-----------------------------------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd({"QuitPre", "ExitPre", "WinClosed"}, {
    group = augroup('DevEvents', {clear=true}),
    pattern = {"*.lua"},
    callback = function(ev)
        vim.notify(string.format('event fired: %s', vim.inspect(ev)))
    end
})

