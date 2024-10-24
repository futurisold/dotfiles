local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

local plugins = {
    "nvim-lua/plenary.nvim", -- useful lua functions used by lots of plugins
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", branch = "0.1.x",
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- fzf extension for telescope find files
            { 'nvim-telescope/telescope-live-grep-args.nvim' } -- live grep args extension for telescope
        }
    },
    { "folke/which-key.nvim" }, -- fast key bindings
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    { "windwp/nvim-autopairs" }, -- autopairs; integrates with both cmp and treesitter
    { "numToStr/Comment.nvim" }, -- makes commenting easy
    { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" }, -- support for TODO, FIXME, etc
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'}, -- nice buffer display on top of the window
    { "nvim-lualine/lualine.nvim" }, -- nice status line display on the bottom of the window
    { "moll/vim-bbye" }, -- buffer deletion without messing up the layout
    { "akinsho/toggleterm.nvim" }, -- toggle multiple terminal instances
    { "lewis6991/impatient.nvim" }, -- caching to speed up Lua modules
    { "goolord/alpha-nvim" }, -- greeter to nvim
    { "lewis6991/gitsigns.nvim" }, -- git helps
    { "junegunn/vim-easy-align"}, -- easiest align tool I've found for an ogre such as myself
    { "RRethy/vim-illuminate" }, -- highlights other uses of the token inside the script
    { "roobert/search-replace.nvim",
          config = function()
          require("search-replace").setup()
        end
    },

    -- Colorschemes
    {"ellisonleao/gruvbox.nvim", lazy=true},
    {"folke/tokyonight.nvim", lazy=false, priority=1000, opts={}},
    {"rose-pine/neovim", lazy=true},
    {'navarasu/onedark.nvim', lazy=true},
    {"maxmx03/fluoromachine.nvim", lazy=true},
    {"blazkowolf/gruber-darker.nvim", lazy=true},
    {"catppuccin/nvim", name = "catppuccin", priority = 1000},


    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
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
    },

    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- set this if you want to always pull the latest change
      opts = {
        -- add any opts here
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make BUILD_FROM_SOURCE=true",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },

    -- Debugger
    { "mfussenegger/nvim-dap",
        dependencies = {
            'rcarriga/nvim-dap-ui'
        }
    },

    -- LaTeX
    { "lervag/vimtex" },

}

require("lazy").setup(plugins)
