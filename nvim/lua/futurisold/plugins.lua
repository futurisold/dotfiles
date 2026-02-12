local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

local plugins = {
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", branch = "0.1.x",
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-live-grep-args.nvim' },
        }
    },
    { "folke/which-key.nvim" },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    { "windwp/nvim-autopairs" },
    { "numToStr/Comment.nvim" },
    { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
    { "nvim-lualine/lualine.nvim" },
    { "moll/vim-bbye" },
    { "akinsho/toggleterm.nvim" },
    { "goolord/alpha-nvim" },
    { "lewis6991/gitsigns.nvim" },
    { "junegunn/vim-easy-align" },
    { "RRethy/vim-illuminate" },
    { "roobert/search-replace.nvim",
        config = function() require("search-replace").setup() end,
    },

    -- Colorschemes
    { "ellisonleao/gruvbox.nvim", priority = 1000 },

    -- LSP
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "github/copilot.vim" },

    -- Snippets
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
}

require("lazy").setup(plugins)
