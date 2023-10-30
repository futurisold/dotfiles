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

            highlight_groups = {
                    ColorColumn = { bg = 'rose' },
                    Comment = { fg = 'muted', italic = true },
                }
        })
end

if colorscheme == "onedark" then
        require('onedark').setup({
            style = "dark", -- other values: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
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

