return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "j-hui/fidget.nvim",
        opts = {
          text = { spinner = "dots" },
          -- window = { relative = "editor" },
          lsp = { log_handler = "true"}
        },
      },
      -- CSS linting
      "bmatcuk/stylelint-lsp"
    },
    config = function()
      -- Turn off most logging because it's super noisy
      vim.lsp.set_log_level("error")

      local lsp_group = vim.api.nvim_create_augroup("KickstartLSP", {})
      -- Customize the UI of floating windows
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      --  This gets run when a LSP client connects to a particular buffer
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
        end,
      })

      local capabilities = vim.tbl_deep_extend("force",
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )
      -- There are performance issues with the file watcher, so disable it for now.
      capabilities.workspace.didChangeConfiguration.dynamicRegistration = false


      local servers = { "gopls", "eslint", "stylelint_lsp" }
      for _, lsp in ipairs(servers) do
        if lsp == "eslint" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            codeActionOnSave = {
              enable = true,
              mode = "problems"
            },
          })
        elseif lsp == "stylelint_lsp" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
          })
        elseif lsp == "gopls" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            cmd = { "gopls", "--remote=auto" },
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                  shadow = true,
                  fillreturns = true,
                  nonewvars = true,
                  unusedwrite = true,
                  staticcheck = true,
                  structure = true,
                  unparam = true,
                  unusedresult = true,
                  deadcode = true,
                  nilness = true,
                  typeparams = true,
                },
                directoryFilters = {
                  "-bazel-bin",
                  "-bazel-gocode",
                  "-bazel-out",
                  "-bazel-testlogs",
                  "-vendor/github.com/containernetworking/plugins/pkg/ns",
                  "-vendor/github.com/bsm/go-sparkey",
                  "-puppet-config",
                },
                usePlaceholders = true,
                ['local'] = "git%.corp%.stripe%.com/stripe%-internal/gocode",
                semanticTokens = true,
                codelenses = {
                  gc_details = false,
                  regenerate_cgo = false,
                  generate = false,
                  test = false,
                  tidy = false,
                  upgrade_dependency = false,
                  vendor = false,
                },
              }
            }
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
    "ray-x/go.nvim",
    config = function()
      local capabilities = vim.tbl_deep_extend("force",
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )

      require("go").setup({
        lsp_cfg = {
          capabilities = capabilities,
        }
      })
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
    "stevearc/conform.nvim",
    dependencies = {
      { url = "git@git.corp.stripe.com:stevearc/nvim-stripe-configs" },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
            javascript = { "prettierd" },
            typescript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescriptreact = { "prettierd" },
            html = { "prettierd" },
            -- json = { "prettierd" },
            jsonc = { "prettierd" },
            graphql = { "prettierd" },
            go = { "goimports", "gofmt" },
            lua = { "stylua" },
            sql = { "zoolander_format_sql" },
            bzl = { "zoolander_format_build" },
            java = { "zoolander_format_java" },
            scala = { "zoolander_format_scala" },
            terraform = { "sc_terraform" },
          },
        formatters = {
          goimports = {
            cmd = vim.env.HOME .. "/stripe/gocode/bin/goimports",
          },
        },
        format_after_save =  { 
          lsp_format = "fallback",
          async = true
        },
      })
    end
  }
}
