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
  'folke/tokyonight.nvim',
  'morhetz/gruvbox',
  'rafi/awesome-vim-colorschemes',
  'sainnhe/everforest',
  { "EdenEast/nightfox.nvim" },
  { 'rose-pine/neovim', name = 'rose-pine'},
  { 'folke/which-key.nvim', config = true },
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = {'string'},
          javascript = {'template_string'},
          java = false,
        },
        enable_check_bracket_line = true,
        map_cr = false,
        map_bs = true,
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
    'tpope/vim-vinegar'
  },
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        view_options = {
          show_hidden = true,
        }
      })
    end
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'haydenmeade/neotest-jest',
      'nvim-lua/plenary.nvim',
      'fredrikaverpil/neotest-golang',
      { url = "git@git.corp.stripe.com:stevearc/neotest-pay-test.git" },
    },
    config = function()
      local neotest_jest = require('neotest-jest')
      local neotest = require('neotest')
      neotest.setup({
        adapters = {
          neotest_jest({
            cwd = neotest_jest.root,
          }),
          require('neotest-golang')({
            go_test_args = { '-v', '-count=1', '-timeout=30s' }
          }),
          require("neotest-pay-test")(),
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
        log_levels = vim.log.levels.WARN,
        output = {
          open_on_run = false,
        },
        quickfix = {
          enabled = false,
        },
      })
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run({ vim.api.nvim_buf_get_name(0) })
      end, { desc = '[T]est [F]ile' })
      vim.keymap.set('n', '<leader>tn', function()
        neotest.run.run({})
      end, { desc = '[T]est [N]earest' })
      vim.keymap.set('n', '<leader>td', function()
        neotest.run.run({strategy = 'dap'})
      end, { desc = '[T]est [D]ebug Nearest' })
      vim.keymap.set('n', '<leader>tc', neotest.run.stop, { desc = '[T]est [C]ancel' })
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
      git_icons = false,
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
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = {
        preset = 'none',
        ['<C-Space>'] = { 'show', 'fallback' },
        ['<CR>'] = {
          function(cmp)
            if cmp.is_visible() and cmp.get_selected_item() ~= nil then
              cmp.accept()
              return true
            end
          end,
          'fallback',
        },
        ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_highlights = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path' },
      },
      completion = {
        list = {
          selection = { preselect = false },
        },
      },
    },
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      local disable_max_size = 1500000
      local function is_large_file(bufnr)
        local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr or 0))
        -- size will be -2 if it doesn't fit into a number
        return size > disable_max_size or size == -2
      end

      -- nvim-treesitter v2 removed the configs module. Parser installation,
      -- highlighting, and indentation are now configured separately.
      require('nvim-treesitter').install({
        'lua', 'typescript', 'tsx', 'java', 'go', 'ruby', 'bash', 'markdown',
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if is_large_file(args.buf) then
            return
          end
          -- Highlighting is now nvim built-in, enabled per buffer via treesitter.start()
          vim.treesitter.start(args.buf)
          -- Treesitter indentation for lua files has problems
          if vim.bo[args.buf].filetype ~= 'lua' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      require('treesitter-context').setup({
        max_lines = 10,
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
      vim.keymap.set('n', '<leader>fc', require('telescope.builtin').commands, { desc = '[F]ind [C]ommand' })
      vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>f.', require('telescope.builtin').resume, { desc = 'Re-open previous picker' })
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

      vim.keymap.set('n', '<leader>fr', function() 
        require('telescope.builtin').oldfiles({cwd_only = true})
      end, { desc = '[F]ind [R]ecent files' })

      require('telescope').setup{
        defaults = {
          dynamic_preview_title = true,
          path_display = function(opts, path)
            local tail = require("telescope.utils").path_tail(path)
            local repo = find_repo_name()
            local path_desc = vim.fn.fnamemodify(path, ':.')

            return string.format("%s (%s)", tail, path_desc)
          end,
        }
      }
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
  { 
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()
      -- Need to figure out some better keybinds here
      vim.keymap.set('n', "<leader>;", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Show Harpoons"})
      vim.keymap.set('n', "<leader>H", function() harpoon:list():add() end, { desc = "Harpoon Add"})
      vim.keymap.set('n', "<leader>ha", function() harpoon:list():select(1) end, { desc = "Harpoon Select 1"})
      vim.keymap.set('n', "<leader>hs", function() harpoon:list():select(2) end, { desc = "Harpoon Select 2"})
      vim.keymap.set('n', "<leader>hd", function() harpoon:list():select(3) end, { desc = "Harpoon Select 3"})
      vim.keymap.set('n', "<leader>hf", function() harpoon:list():select(4) end, { desc = "Harpoon Select 4"})
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon Next"})
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon Prev"})
    end
  }
}
