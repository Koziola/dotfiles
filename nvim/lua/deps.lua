local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local helpers = require('helpers')

local stripe = nil

if helpers.isModuleAvailable('stripe-packages') then
    stripe = require('stripe-packages')
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'tpope/vim-sleuth'
  use 'jiangmiao/auto-pairs'

  use 'chriskempson/base16-vim'
  -- On-demand loading for NerdTree
  use 'scrooloose/nerdtree'-- , { 'on':  'NERDTreeToggle' }
  use 'scrooloose/nerdcommenter'

  use 'lukas-reineke/indent-blankline.nvim'
  
  -- Automatically insert closing pairs for certain characters
  -- use 'raimondi/delimitmate'
  use 'windwp/nvim-autopairs'
  
  -- Buffer explorer
  use 'jlanzarotta/bufexplorer'
  
  -- Kill buffers without losing splits
  use 'qpkorr/vim-bufkill'
  
  -- post install (yarn install | npm install) then load plugin only for editing supported files
  use 'prettier/vim-prettier'-- , { 'do': 'yarn install' }
  
  -- coc-nvim - turns this bitch into an IDE
  -- use 'neoclide/coc.nvim', {'branch': 'release'}
  
  use 'fatih/vim-go' --, {'do': ':GoUpdateBinaries'}
  
  -- Neovim LSP useins
  use 'neovim/nvim-lspconfig'
  use 'tjdevries/lsp_extensions.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'-- , {'branch': 'main'}
  -- More flexible configuration for java lsp
  use 'mfussenegger/nvim-jdtls'

  use 'hrsh7th/nvim-cmp' 
  use 'hrsh7th/cmp-nvim-lsp' 
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-path'
  --use 'hrsh7th/cmp-buffer'
  
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
    -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }
  
  --use 'ms-jpq/coq_nvim' -- , {'branch':'coq'}
  --use 'folke/trouble.nvim'
  use 'folke/lua-dev.nvim'
  
  -- Floating terminal windows
  use 'voldikss/vim-floaterm'
  
  -- Telescope (fuzzy finders)
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  use { 'ibhagwan/fzf-lua', requires = { 'kyazdani42/nvim-web-devicons' }}
  
  --Treesitter (syntax highlighting)
  use 'nvim-treesitter/nvim-treesitter'
  
  -- Debugging and running tests.
  -- use 'puremourning/vimspector'
  use 'vim-test/vim-test'
  
  -- Ricing the status bar 
  use 'famiu/feline.nvim'
  use 'kyazdani42/nvim-web-devicons'

  if stripe ~= nil then
      stripe.use_packages(use)
  end
  --stripe.use_packages(use)

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
