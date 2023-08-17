vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Core
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim" -- useful lua functions used by lots of plugins
    use { "nvim-treesitter/nvim-treesitter" } -- nice highlighting without overhead
    use { "nvim-telescope/telescope.nvim",
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }, -- fzf extension for telescope find files
            { 'nvim-telescope/telescope-live-grep-args.nvim' } -- live grep args extension for telescope
        }
    }
    use { "folke/which-key.nvim" } -- fast key bindings
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }
    use { "windwp/nvim-autopairs" } -- autopairs; integrates with both cmp and treesitter
    use { "numToStr/Comment.nvim" } -- makes commenting easy
    use { "folke/todo-comments.nvim",  -- support for TODO, FIXME, etc
        dependencies = "nvim-lua/plenary.nvim",
    }
    use { 'akinsho/bufferline.nvim',
        tag = "*",
        requires =
            { 'nvim-tree/nvim-web-devicons' } -- nice buffer display on top of the window
    }
    use { "nvim-lualine/lualine.nvim" } -- nice status line display on the bottom of the window
    use { "moll/vim-bbye" } -- buffer deletion without messing up the layout
    use { "akinsho/toggleterm.nvim" } -- toggle multiple terminal instances
    use { "lewis6991/impatient.nvim" } -- caching to speed up Lua modules
    use { "lukas-reineke/indent-blankline.nvim" } -- indentation guidelines
    use { "goolord/alpha-nvim" } -- greeter to nvim
    use { "lewis6991/gitsigns.nvim" } -- git helpers
    use { "junegunn/vim-easy-align"} -- easiest align tool I've found for an ogre such as myself
    use { "RRethy/vim-illuminate" } -- highlights other uses of the token inside the script
    use { "roobert/search-replace.nvim",
          config = function()
          require("search-replace").setup()
        end
    }

    -- Colorschemes
    use "ellisonleao/gruvbox.nvim"
    use "folke/tokyonight.nvim"
    use "rose-pine/neovim"
    use { "catppuccin/nvim", as = "catppuccin" }


    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
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
            { "github/copilot.vim" }, -- god mode

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- Debugger
    use { "mfussenegger/nvim-dap",
        requires = {
            'rcarriga/nvim-dap-ui'
        }
    }

    -- LaTeX
    use { "lervag/vimtex" }

end)
