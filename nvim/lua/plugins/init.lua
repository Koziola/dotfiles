return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>g', '<cmd>Git<CR>', { desc = '[G]it' })
    end
  },
  'tpope/vim-surround',
  'tpope/vim-sleuth',
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  'chriskempson/base16-vim',
  'folke/tokyonight.nvim',
  { 'rose-pine/neovim', name = 'rose-pine'},
  { 'folke/which-key.nvim', config = true },
  { -- File tree
    'kyazdani42/nvim-tree.lua',
    opts = {
      git = {
        -- The git integration leads to performance problems
        enable = false,
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      vim.keymap.set('n', '<leader>fT', '<cmd>NvimTreeToggle<CR>', { desc = '[E]xplorer [T]oggle' })
      vim.keymap.set('n', '<leader>ft', '<cmd>NvimTreeFindFileToggle<CR>', { desc = '[E]xplorer [F]ile' })
    end,
  },
  { -- Snippets
    'L3MON4D3/LuaSnip',
    dependencies = {
      { 'rafamadriz/friendly-snippets', lazy = false },
    },
    event = 'InsertEnter *',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        show_current_context = true,
        show_current_context_start = true
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'haydenmeade/neotest-jest',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local neotest_jest = require('neotest-jest')
      local neotest = require('neotest')
      neotest.setup({
        adapters = {
          neotest_jest({
            cwd = neotest_jest.root,
          })
        },
        discovery = {
          enabled = false,
        },
        icons = {
          passed = ' ',
          running = ' ',
          failed = ' ',
          unknown = ' ',
          running_animated = vim.tbl_map(function(s)
            return s .. ' '
          end, { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }),
        },
        output = {
          open_on_run = false,
        },
        quickfix = {
          open = false,
        },
      })
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run({ vim.api.nvim_buf_get_name(0) })
      end, { desc = '[T]est [F]ile' })
      vim.keymap.set('n', '<leader>tn', function()
        neotest.run.run({})
      end, { desc = '[T]est [N]earest' })
      vim.keymap.set('n', '<leader>tl', neotest.run.run_last, { desc = '[T]est [L]ast' })
      vim.keymap.set('n', '<leader>ts', neotest.summary.toggle, { desc = '[T]est toggle [S]ummary' })
      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open()
      end, { desc = '[T]est [O]utput' })
    end,
  },
  { -- Fuzzy finder for files
    'ibhagwan/fzf-lua',
    opts = {
      files = {
        previewer = false,
      },
      -- This is required to support older version of fzf on remote devboxes
      fzf_opts = { ['--border'] = false },
      -- These settings reduce lag from slow git operations
      global_git_icons = false,
      git = {
        files = {
          previewer = false,
        },
      },
    },
    config = function(_, opts)
      require('fzf-lua').setup(opts)
      vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<C-p>', require('fzf-lua').files, { desc = 'Find Files' })
      vim.keymap.set('n', '<C-l>', require('fzf-lua').live_grep, { desc = '[L]ive Grep' })
    end,
  },
  { -- Show buffers in the tabline
    'akinsho/bufferline.nvim',
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'Explorer',
            highlight = 'PanelHeading',
            padding = 1,
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      vim.keymap.set('n', 'go', '<cmd>BufferLinePick<CR>', { desc = '[G]oto [O]pen buffer' })
      vim.keymap.set('n', 'gO', '<cmd>BufferLinePickClose<CR>')
      vim.keymap.set('n', 'gp', '<cmd>BufferLineTogglePin<CR>', {desc = '[G]oto [P]in buffer'})
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
      'L3MON4D3/LuaSnip',
      'kyazdani42/nvim-web-devicons',
    },
    event = 'InsertEnter *',
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      lspkind.init({
        preset = 'codicons'
      })

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({ mode = 'symbol_text' }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
        sorting = {
          comparators = {
            -- Learned about this from this GH issue: https://github.com/hrsh7th/nvim-cmp/issues/381
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- Sort entries with underscores towards the bottom (do I need this?)
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          }
        }
      })
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- Add languages here that you want installed for treesitter
        ensure_installed = { 'lua', 'typescript', 'tsx', 'java', 'go', 'ruby', 'bash', 'markdown' },
        highlight = { enable = true },
        indent = {
          enable = true,
          -- Treesitter indentation for lua files has problems
          disable = { 'lua' },
        },
      })
    end,
  },
  { -- Code outline
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('aerial').setup()
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = '[A]erial toggle' })
      vim.keymap.set({ 'n', 'v' }, '[s', '<cmd>AerialPrev<CR>', { desc = 'Previous aerial symbol' })
      vim.keymap.set({ 'n', 'v' }, ']s', '<cmd>AerialNext<CR>', { desc = 'Next aerial symbol' })
      vim.keymap.set({ 'n', 'v' }, '[S', '<cmd>AerialPrevUp<CR>', { desc = 'Previous aerial parent symbol' })
      vim.keymap.set({ 'n', 'v' }, ']S', '<cmd>AerialNextUp<CR>', { desc = 'Next aerial parent symbol' })
    end,
  },
  { -- General purpose Fuzzy Finder (lsp, help tags, buffers, etc)
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },
    },
    config = function()
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffer' })
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by Live [G]rep' })
      vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ind [R]ecent files' })
      vim.keymap.set('n', '<leader>fc', require('telescope.builtin').commands, { desc = '[F]ind [C]ommand' })
      vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymaps' })
      local function find_repo_name()
        return vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':p:h:h:t')
      end
      -- vim.keymap.set('n', '<leader>fs', function()
      --   require('telescope').load_extension('aerial')
      --   vim.cmd('Telescope aerial')
      -- end, { desc = '[F]ind Document [S]ymbol' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },
  { -- Fancier statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { {
          'filename',
          file_status = true,
          path = 1,
        } },
        lualine_c = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            sections = { 'error', 'warn' },
          },
        },
        lualine_x = {
          'filetype',
        },
      },
      extensions = { 'aerial', 'nvim-tree', 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
    },
  },
  'airblade/vim-gitgutter'
}
