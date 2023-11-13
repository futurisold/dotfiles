local colorscheme = "fluoromachine"
local transparent = false

if colorscheme == "rose-pine" then
    require('rose-pine').setup({
        --- @usage 'main' | 'moon'
        dark_variant = 'moon',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = true,

        highlight_groups = {
                ColorColumn = { bg = 'rose' },
                Comment = { fg = 'muted', italic = true },
            }
    })
end

if colorscheme == "onedark" then
        require('onedark').setup({
            style = "deep", -- other values: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
        })
end

if colorscheme == "fluoromachine" then
    require('fluoromachine').setup({
        glow = true,
        theme = "retrowave", -- other values: 'fluoromachine', 'retrowave', 'delta'
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

