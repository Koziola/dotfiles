local lsp_status = require('lsp-status')

lsp_status.config {
  indicator_errors = "E",
  indicator_warnings = "W",
  indicator_info = "i",
  indicator_hint = "?",
  indicator_ok = "OK",
  current_function = false,
}

local components = {
    -- left, middle, right sections
    active = {{}, {}, {}},
    inactive = {{}, {}, {}}
}

local vim_mode_component = {
  provider = 'vi_mode',
  hl = function()
  return {
      name = require('feline.providers.vi_mode').get_mode_highlight_name(),
      fg = require('feline.providers.vi_mode').get_mode_color(),
      style = 'bold'
  }
  end,
}

local file_info_component = {
  provider = {
      name = 'file_info',
      opts = {
          type = 'full-path'
      }
  },
  short_provider = {
      name = 'file_info',
      opts = {
          type = 'short-path'
      }
  }
}

local lsp_client_component = {
  provider = function()
    lsp_status.register_progress()
    return lsp_status.status()
  end
}

table.insert(components.active[1], vim_mode_component)
table.insert(components.active[1], file_info_component)
table.insert(components.active[3], lsp_client_component)

table.insert(components.inactive[1], file_info_component)

require('feline').setup({
  components = components
})
