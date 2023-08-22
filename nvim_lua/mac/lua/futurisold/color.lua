-- local colorscheme = "tokyonight-moon"
local colorscheme = "rose-pine"
local transparent = true

if colorscheme == "rose-pine" then
    require('rose-pine').setup({
        --- @usage 'main' | 'moon'
        dark_variant = 'moon',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = true,

        --- @usage string hex value or named color from rosepinetheme.com/palette
        groups = {
            background = 'base',
            panel = 'surface',
            border = 'highlight_med',
            link = 'iris',
            punctuation = 'subtle',

            error = 'love',
            hint = 'iris',
            info = 'foam',
            warn = 'gold',

            headings = {
                h1 = 'iris',
                h2 = 'foam',
                h3 = 'rose',
                h4 = 'gold',
                h5 = 'pine',
                h6 = 'foam',
            }
            -- or set all headings at once
        },

        -- Change specific vim highlight groups
        highlight_groups = {
            ColorColumn = { bg = 'rose' },
            Comment = { fg = 'muted', italic = true },
        }
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


