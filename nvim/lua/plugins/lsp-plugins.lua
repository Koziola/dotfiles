return {
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      -- Snippets
      'L3MON4D3/LuaSnip',
      config = function()
        local lsp = require('lsp-zero')
        local cmp = require('cmp')

        lsp.preset('recommended')
        lsp.ensure_installed({
          'tsserver',
        })

        lsp.set_preferences({
          suggest_lsp_servers = false,
        })

        lsp.on_attach(function(client)
          lsp_status.on_attach(client)
          client.server_capabilities.document_formatting = false
          client.server_capabilities.document_range_formatting = false

          if client.config.flags then
            client.config.flags.allow_incremental_sync = true
          end
        end)

        lsp.configure('tsserver', {
          init_options = {
            maxTsServerMemory = '8192',
            preferences = {
              importModuleSpecifierPreference = 'non-relative',
            }
          }
        })

        lsp.setup_nvim_cmp({
          mapping = {
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ['<C-e>'] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-n>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, {'i', 's'}),
            ['<C-p>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, {'i', 's'}),
           }
        })
        lsp.setup()

        local lsp_group = vim.api.nvim_create_augroup('KickstartLSP', {})
        local autoformat_group = vim.api.nvim_create_augroup('LspAutoformat', { clear = true })
        vim.api.nvim_create_autocmd('LspAttach', {
          desc = 'Set custom keymaps and create autocmds',
          pattern = '*',
          group = lsp_group,
          callback = function(args)
            local nmap = require('keymap').nmap
            nmap('gd', ':lua vim.lsp.buf.definition()<CR>')
            nmap('gi', ':lua vim.lsp.buf.implementation()<CR>')
            nmap('<leader>k', ':lua vim.lsp.buf.signature_help()<CR>')
            nmap('<leader>h', ':lua vim.lsp.buf.hover()<CR>')
            nmap('<leader>r', ':lua vim.lsp.buf.references()<CR>')
            nmap('<leader>rn', ':lua vim.lsp.buf.rename()<CR>')
            nmap('<leader>ac', ':lua vim.lsp.buf.code_action()<CR>')
            nmap('<leader>sd', ':lua vim.diagnostic.open_float()<CR>')
            nmap('=', function()
              vim.lsp.buf.format({async = true,})
            end)

            local autoformat_filetypes = { 'ruby', 'lua', 'typescript', 'typescriptreact' }
            if
              client.server_capabilities.documentFormattingProvider
              and vim.tbl_contains(autoformat_filetypes, vim.bo[args.buf].filetype)
            then
              -- Remove prior autocmds so this only triggers once
              vim.api.nvim_clear_autocmds({
                group = autoformat_group,
                buffer = args.buf,
              })
              vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function()
                  vim.lsp.buf.format({
                    timeout_ms = 500,
                  })
                end,
                group = autoformat_group,
                buffer = args.buf,
              })
            end
          end
        })

      end
    }
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'neovim/nvim-lspconfig', { url = 'git@git.corp.stripe.com:nms/nvim-lspconfig-stripe.git' } },
    config = function()
      local null_ls = require('null-ls')
      local nullls_stripe = require('lspconfig_stripe.null_ls')
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
          nullls_stripe.diagnostics.eslint_d,
          nullls_stripe.formatting.eslint_d,
          null_ls.builtins.formatting.prettierd,

          -- Horizon stack
          nullls_stripe.formatting.format_java,
          nullls_stripe.formatting.format_build,
          nullls_stripe.formatting.format_scala,
          nullls_stripe.formatting.format_sql,

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
