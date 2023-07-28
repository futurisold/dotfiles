local colorscheme = "tokyonight"

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
