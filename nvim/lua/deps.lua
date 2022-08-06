local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'tpope/vim-sleuth'

  use 'chriskempson/base16-vim'
  -- On-demand loading for NerdTree
  use 'scrooloose/nerdtree'-- , { 'on':  'NERDTreeToggle' }
  use 'scrooloose/nerdcommenter'
  
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
  use 'jose-elias-alvarez/null-ls.nvim'-- , {'branch': 'main'}
  -- More flexible configuration for java lsp
  use 'mfussenegger/nvim-jdtls'
  use 'hrsh7th/nvim-cmp' 
  use 'hrsh7th/cmp-nvim-lsp' 
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  -- use 'ms-jpq/coq_nvim', {'branch':'coq'}
  use 'folke/trouble.nvim'
  use 'folke/lua-dev.nvim'
  
  -- Floating terminal windows
  use 'voldikss/vim-floaterm'
  
  -- Telescope (fuzzy finders)
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  
  --Treesitter (syntax highlighting)
  use 'nvim-treesitter/nvim-treesitter'
  
  -- Debugging and running tests.
  -- use 'puremourning/vimspector'
  use 'vim-test/vim-test'
  
  -- Ricing the status bar 
  use 'famiu/feline.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
