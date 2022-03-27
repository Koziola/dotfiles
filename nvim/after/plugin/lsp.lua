vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
vim.lsp.set_log_level('info')

lspconfig = require 'lspconfig'
completion = require 'cmp_nvim_lsp'
lsp_status = require 'lsp-status'
require('trouble').setup()

local completion_capabilities = completion.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local custom_capabilities = {}
table.insert(custom_capabilities, lsp_status.capabilities)
table.insert(custom_capabilities, completion_capabilities)

local custom_on_attach = function(client)
-- completion.on_attach(client)
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
capabilities=custom_capabilities
}
