local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--     augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--     augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
  -- General
    use { "wbthomason/packer.nvim" } -- pkg manager
    use { "nvim-lua/plenary.nvim" } -- useful lua functions used by lots of plugins
    use { "windwp/nvim-autopairs" } -- autopairs; integrates with both cmp and treesitter
    use { "numToStr/Comment.nvim" } -- makes commenting easy
    use { "kyazdani42/nvim-web-devicons" } -- nice icons
    use { "kyazdani42/nvim-tree.lua" } -- file explorer
    use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' } -- nice buffer display on top of the window
    use { "nvim-lualine/lualine.nvim" } -- nice status line display on the bottom of the window
    use { "moll/vim-bbye" } -- buffer deletion without messing up the layout
    use { "akinsho/toggleterm.nvim" } -- toggle multiple terminal instances
    use { "lewis6991/impatient.nvim" } -- caching to speed up Lua modules
    use { "lukas-reineke/indent-blankline.nvim" } -- indentation guidelines
    use { "goolord/alpha-nvim" } -- greeter to nvim
    use { "folke/which-key.nvim" } -- key bindings
    use { "folke/todo-comments.nvim",  -- support for TODO, FIXME, etc
          requires = "nvim-lua/plenary.nvim",
          config = function()
            require("todo-comments").setup {}
          end
    }
    use { "nvim-treesitter/nvim-treesitter" } -- nice highlighting without overhead
    use { "lewis6991/gitsigns.nvim" } -- git helpers
    use { "nvim-telescope/telescope.nvim",
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }, -- fzf extension for telescope find files
            { 'nvim-telescope/telescope-live-grep-args.nvim' } -- live grep args extension for telescope
        }
    }
    use { "junegunn/vim-easy-align"} -- easiest align tool I've found for an ogre such as myself
    use { "roobert/search-replace.nvim", require("search-replace").setup() }

    -- Colorschemes
    use "ellisonleao/gruvbox.nvim"
    use "folke/tokyonight.nvim"
    use "rose-pine/neovim"

    -- Completion
    use { "hrsh7th/nvim-cmp" } -- completion pkg
    use { "hrsh7th/cmp-buffer" } -- buffer completions
    use { "hrsh7th/cmp-path" } -- path completions
    use { "hrsh7th/cmp-cmdline" } -- cmdline completions
    use { "hrsh7th/cmp-nvim-lsp" } -- cmp utils
    use { "hrsh7th/cmp-nvim-lua" } -- cmp utils for Lua API
    use { "saadparwaiz1/cmp_luasnip" } -- cmp utils; snippet completions
    use { "github/copilot.vim" } -- god mode

    -- Snippets
    use { "L3MON4D3/LuaSnip" } --snippet engine
    use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

    -- LSP
    use { "neovim/nvim-lspconfig" } -- enable LSP
    use { "williamboman/mason.nvim" } -- simple to use language server installer
    use { "williamboman/mason-lspconfig.nvim" } -- bridge between mason & lspconfig
    use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
    use { "RRethy/vim-illuminate" } -- highlights other uses of the token inside the script

    -- Debugger
    use { "mfussenegger/nvim-dap",
        requires = {
            'rcarriga/nvim-dap-ui'
        }
    }

    -- LaTeX
    use { "lervag/vimtex" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
