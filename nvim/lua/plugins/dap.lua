return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      vim.keymap.set('n', '<leader>dc', require('dap').continue, { desc = 'Debug Continue'})
      vim.keymap.set('n', '<leader>do', require('dap').step_over, { desc = 'Debug Step Over'})
      vim.keymap.set('n', '<leader>di', require('dap').step_into, { desc = 'Debug Step Into'})
      vim.keymap.set('n', '<leader>du', require('dap').step_out, { desc = 'Debug Step Out'})
      vim.keymap.set('n', '<leader>B',  require('dap').toggle_breakpoint, { desc = 'Debug Toggle Breakpoint'} )
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup()

      vim.keymap.set('n', '<leader>dt', require('dapui').toggle, { desc = 'Debug Toggle Windows'})
      
      -- Open and close dap-ui windows automatically
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 
      'mfussenegger/nvim-dap',
      'nvim-treesitter/nvim-treesitter' 
    },
    config = function() 
      require('nvim-dap-virtual-text').setup()
    end
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
      'mfussenegger/nvim-dap',
      'microsoft/vscode-js-debug'
    },
    config = function ()
      require('dap-vscode-js').setup({
        debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
        adapters = { 'pwa-node' }
      })
      for _, language in ipairs({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) do
        require('dap').configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          }
        }
      end
    end
  },
  {
    'microsoft/vscode-js-debug',
    build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'
  } 
}
