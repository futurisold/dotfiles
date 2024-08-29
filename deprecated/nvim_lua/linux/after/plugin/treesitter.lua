local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "css", "latex", "markdown"}, -- list of language that will be disabled
        additional_vim_regex_highlighting = { "latex" }, -- for vimtex
    },
    autopairs = { enable = true },
    indent = { enable = true, disable = { "python", "css" } },
})
