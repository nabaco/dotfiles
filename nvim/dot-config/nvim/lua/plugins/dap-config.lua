-----------------------------------
--   Debugger Adapter Protocol   --
-----------------------------------

local config = function()
    require('dap').adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.env.HOME .. '/.local/debugAdapters/bin/OpenDebugAD7',
    }
    require('dap.ext.vscode').load_launchjs(nil, { cppdbg = { 'c', 'cpp' } })
end

local start_dap_ui = function()
    require('dapui').toggle()
end

return {
    {
        'mfussenegger/nvim-dap',
        config = config,
        cmd = "DapContinue",
        dependencies = {
            'theHamsta/nvim-dap-virtual-text',
            config = true,
        }
    },
    {
        'rcarriga/nvim-dap-ui',
        config = true,
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { "<leader>dd", start_dap_ui, desc = "DAP UI" }
        }
    },
}
