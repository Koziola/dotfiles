return {
  { 
    'mfussenegger/nvim-dap',
    config = function()
      vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = '[D]ebug Step [O]ver' })
      vim.keymap.set('n', '<leader>di', function() require('dap').step_over() end, { desc = '[D]ebug Step [I]nto' })
      vim.keymap.set('n', '<leader>du', function() require('dap').step_out() end, { desc = '[D]ebug Step O[u]t' })
      vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[D]ebug Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>dr', function() require('dap').repl_open() end, { desc = '[D]ebug [R]epl Open' })
      vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end, { desc = '[D]ebug Run [L]ast' })
      vim.keymap.set({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end, { desc = '[D]ebug [H]over' })
      vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end, { desc = '[D]ebug [P]review' })
      vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end, { desc = '[D]ebug [P]review' })
    end
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function() 
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            trace = true, -- include debugger info
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
    "microsoft/vscode-js-debug",
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function() 
      require("dapui").setup()

      -- Toggle windows when debug session starts/stops
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
}
