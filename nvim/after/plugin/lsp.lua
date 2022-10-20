vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.lsp.set_log_level('info')

lspconfig = require 'lspconfig'
completion = require 'cmp_nvim_lsp'
lsp_status = require 'lsp-status'

--coq = require 'coq'

--require('trouble').setup()
local completion_capabilities = completion.default_capabilities()

local custom_capabilities = {}
table.insert(custom_capabilities, lsp_status.capabilities)
table.insert(custom_capabilities, completion_capabilities)

local custom_on_attach = function(client)
lsp_status.on_attach(client)
end

lspconfig.gopls.setup {
  on_attach=custom_on_attach,
  capabilities=custom_capabilities,
  cmd = {'gopls', 'serve'},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

lspconfig.tsserver.setup {
  on_attach=custom_on_attach,
  capabilities=custom_capabilities,
  cmd = {
    'typescript-language-server',
    '--stdio',
    '--tsserver-path=' .. vim.fn.getenv("HOME") .. '/.nodenv/shims/tsserver',
  },
  cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" }, -- give 8gb of RAM to node
  init_options = {
    maxTsServerMemory = "8192",
    preferences = {
      -- always import absolute paths
      importModuleSpecifierPreference = "non-relative",
    }
  }
}

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]


