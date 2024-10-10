local colorscheme = "gruber-darker"
local transparent = false


if colorscheme == "gruber-darker" then
    require("gruber-darker").setup({
      bold = true,
      invert = {
        signs = false,
        tabline = false,
        visual = false,
      },
      italic = {
        strings = false,
        comments = true,
        operators = false,
        folds = true,
      },
      undercurl = true,
      underline = true,
    })
end

if colorscheme == "rose-pine" then
    require("rose-pine").setup({
        variant = "main", -- Change to "moon" for a darker base
        dark_variant = "main", -- Ensure dark variant matches
        dim_inactive_windows = true, -- Dim inactive windows
        extend_background_behind_borders = true,

        enable = {
            terminal = true,
            legacy_highlights = true,
            migrations = true,
        },

        styles = {
            bold = false, -- Reduce boldness
            italic = false,
            transparency = true, -- Enable transparency for a more matte look
        },

        groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },

        palette = {
            -- Override the builtin palette per variant
            -- moon = {
            --     base = '#18191a',
            --     overlay = '#363738',
            -- },
        },

        highlight_groups = {
            Comment = { italic = true },
            String = { italic = true },
            -- VertSplit = { fg = "muted", bg = "muted" },
        },

        before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
        end,
    })
end

if colorscheme == "catppuccin" then
    require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = false,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
    })
end

if colorscheme == "tokyonight" then
    require('tokyonight').setup({
        style = "night", -- other values: 'night', 'storm', 'moon', 'day'
        })
end

if colorscheme == "onedark" then
    require('onedark').setup({
        style = "darker", -- other values: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
        })
end

if colorscheme == "fluoromachine" then
    require('fluoromachine').setup({
        glow = true,
        theme = "fluoromachine", -- other values: 'fluoromachine', 'retrowave', 'delta'
        transparent = false, -- other values: 'full', true/false
        brightness = 0.05,   -- other values: range from 0 -> 1
        })
end

vim.cmd.colorscheme(colorscheme)

if transparent then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]
    vim.cmd[[hi NvimTreeNormalNC guibg=NONE ctermbg=NONE]]
end

