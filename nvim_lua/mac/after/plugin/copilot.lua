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
    sh=true,
}

vim.keymap.set('i', '<Tab>]',    '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<Tab><CR>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- highlight color
vim.cmd[[highlight CopilotSuggestion guifg=#555555 ctermfg=8]]
