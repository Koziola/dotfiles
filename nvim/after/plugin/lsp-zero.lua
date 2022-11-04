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
    maxTsServerMemory = "8192",
    preferences = {
      importModuleSpecifierPreference = "non-relative",
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
    end, {"i", "s"}),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {"i", "s"}),
   }
})
lsp.setup()
