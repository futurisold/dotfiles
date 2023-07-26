local lsp = require("lsp-zero")

-- Lua
require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
                disable = { "missing-fields", "assign-type-mismatch" }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Python
require('lspconfig').ruff_lsp.setup {
    init_options = {
        settings = {
            args = { "--ignore", "E501" }
        }
    }
}

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '',
    info = ''
})

lsp.suggest_lsp_servers = false

lsp.on_attach(function()
    local opts = { remap = false }
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K",  function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("n", "<leader>li", function() vim.cmd("LspInfo") end, opts)
    vim.keymap.set("n", "<leader>lI", function() vim.cmd("LspInstallInfo") end, opts)
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.goto_next({ buffer = 0 }) end, opts)
    vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.goto_prev({ buffer = 0 }) end, opts)
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>lq", function() vim.diagnostic.setloclist() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = {
        focusable = true,
        show_header = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})
