-- use this table to disable/enable specific filetypes
-- vim.g.copilot_filetypes = { xml = false }

-- since most are enabled by default you can turn them off
-- using this table and only enable for a few filetypes
vim.g.copilot_filetypes = {
    ["*"]=false,
    python=true,
    markdown=true,
    html=true,
    css=true,
    lua=true,
    tex=true,
}

vim.cmd[[imap <silent><script><expr> <leader><CR> copilot#Accept("\<CR>")]]
vim.keymap.set('i', '<leader>]', '<Plug>(copilot-dismiss)')
vim.g.copilot_no_tab_map = true
vim.cmd[[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]

