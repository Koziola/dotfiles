return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          text = { spinner = "dots" },
          window = { relative = "editor" },
        },
      },
    },
    config = function()
      local lsp_group = vim.api.nvim_create_augroup("KickstartLSP", {})
      -- Customize the UI of floating windows
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      --  This gets run when a LSP client connects to a particular buffer
      local autoformat_group = vim.api.nvim_create_augroup("LspAutoformat", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Set custom keymaps and create autocmds",
        pattern = "*",
        group = lsp_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- helper function for setting up buffer-local keymaps
          local nmap = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
          end

          nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")
          nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          nmap("gr", function() require("telescope.builtin").lsp_references({fname_width = 100, show_line = false}) end, "[G]oto [R]eferences")
          nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          nmap("K", vim.lsp.buf.hover, "Hover Documentation")
          vim.keymap.set(
            { "n", "i" },
            "<C-k>",
            vim.lsp.buf.signature_help,
            { buffer = args.buf, desc = "LSP: Signature Documentation" }
          )
          vim.keymap.set("n", "<leader>ds", function()
              vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })
            end, { desc = "[D]iagnostics [S]how" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "[D]iagnostics set [L]oclist" })

          -- Format on save for these filetypes
          local autoformat_filetypes = { "ruby", "lua", "typescript", "typescriptreact" }
          if
            client.server_capabilities.documentFormattingProvider
            and vim.tbl_contains(autoformat_filetypes, vim.bo[args.buf].filetype)
          then
            -- Remove prior autocmds so this only triggers once
            vim.api.nvim_clear_autocmds({
              group = autoformat_group,
              buffer = args.buf,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function()
                vim.lsp.buf.format({
                  timeout_ms = 500,
                  -- ignore tsserver / typescript-tools formatting. Should use prettier or eslint instead.
                  filter = function(client) return client.name ~= "typescript-tools" end
                })
              end,
              group = autoformat_group,
              buffer = args.buf,
            })
          end
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "gopls", "eslint", "stylelint_lsp" }
      for _, lsp in ipairs(servers) do
        if lsp == "eslint" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            codeActionOnSave = {
              enable = true,
              mode = "problems"
            }
          })
        elseif lsp == "stylelint_lsp" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
          })
        else
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
          })
        end
      end
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = false,
          tsserver_max_memory = 8 * 1024, -- 8gb
          jsx_close_tag = {
            enable = true,
            filetypes = { "typescriptreact", "javascriptreact" },
          },
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "non-relative",
            quotePreference = "double"
          }
        }
      })
    end
  },
  {
    -- CSS linting
    -- Configured above in lspconfig
    "bmatcuk/stylelint-lsp",
  },
  {
    'fatih/vim-go',
    run = ':GoUpdateBinaries',
    ft = { 'go' },
    config = function()
      vim.g.go_fmt_command = "goimports"
    end
  }
}
