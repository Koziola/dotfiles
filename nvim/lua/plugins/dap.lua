return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      vim.keymap.set('n', '<leader>dc', require('dap').continue, { desc = 'Debug Continue'})
      vim.keymap.set('n', '<leader>do', require('dap').step_over, { desc = 'Debug Step Over'})
      vim.keymap.set('n', '<leader>di', require('dap').step_into, { desc = 'Debug Step Into'})
      vim.keymap.set('n', '<leader>du', require('dap').step_out, { desc = 'Debug Step Out'})
      vim.keymap.set('n', '<leader>B',  require('dap').toggle_breakpoint, { desc = 'Debug Toggle Breakpoint'})
      vim.keymap.set('n', '<leader>dt',  require('dap').terminate, { desc = 'Debug Terminate'})

    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
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
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'mfussenegger/nvim-dap', 'williamboman/mason.nvim' },
    config = function()
      require('mason-nvim-dap').setup({
        ensure_installed = { 'js' },
      })

      -- alternative to nvim-dap-vscode-js. This configures the adapter explicitly, and uses the DAP adapter
      -- that's installed by mason / mason-nvim-dap
      local dap = require('dap')
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        }
      }

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
  }
}
