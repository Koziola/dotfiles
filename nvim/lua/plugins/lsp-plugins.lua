return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "j-hui/fidget.nvim",
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
          nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
          nmap("=", function()
            vim.lsp.buf.format({
              async = true,
            })
          end, "Format buffer")
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
          local autoformat_filetypes = { "ruby", "lua" }
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
                })
              end,
              group = autoformat_group,
              buffer = args.buf,
            })
          end
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "gopls", "tsserver" }
      for _, lsp in ipairs(servers) do
        if lsp == "tsserver" then
          require("lspconfig")[lsp].setup({
            capabilities = capabilities,
            cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- Give 8gb of RAM to node
            init_options = {
              maxTsServerMemory = "8192",
              preferences = {
                importModuleSpecifierPreference = "non-relative",
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
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'neovim/nvim-lspconfig'},
    config = function()
      local null_ls = require('null-ls')
      local helpers = require('null-ls.helpers')
      local null_utils = require('null-ls.utils')
      local function has_exe(name)
        return function()
          return vim.fn.executable(name) == 1
        end
      end
      null_ls.setup({
        root_dir = function(fname)
          return null_utils.root_pattern('.git')(fname) or null_utils.path.dirname(fname)
        end,
        sources = {
          -- JavaScript, typescript
          null_ls.builtins.formatting.prettierd,

          -- go
          null_ls.builtins.formatting.goimports.with({
            condition = has_exe('goimports'),
          }),
          null_ls.builtins.formatting.gofmt.with({
            condition = has_exe('gofmt'),
          }),

          -- lua
          null_ls.builtins.formatting.stylua.with({
            condition = has_exe('stylua'),
            runtime_condition = helpers.cache.by_bufnr(function(params)
              return null_utils.root_pattern('stylua.toml', '.stylua.toml')(params.bufname)
            end),
          }),

          -- markdown
          null_ls.builtins.diagnostics.vale.with({
            condition = has_exe('vale'),
            runtime_condition = helpers.cache.by_bufnr(function(params)
              return null_utils.root_pattern('.vale.ini')(params.bufname)
            end),
          }),
        },
      })
    end,
  }
}
