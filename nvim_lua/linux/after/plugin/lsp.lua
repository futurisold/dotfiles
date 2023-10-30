local lsp = require("lsp-zero")

use_ruff = false

lsp.ensure_installed({
    "lua_ls",
    "jedi_language_server",
    "ruff_lsp",
})
lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '',
    info = ''
})
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false, noremap = true, silent = true }
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
end

-- Lua
require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
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
if use_ruff then
    require('lspconfig').ruff_lsp.setup {
        on_attach = on_attach,
        init_options = {
            settings = {
                args = {
                    "--ignore", "E501", -- line too long
                    "--ignore", "F403", -- 'from module import *' used; unable to detect undefined names
                    "--ignore", "F405", -- 'module' may be undefined, or defined from star imports: module
                    "--ignore", "E701", -- multiple statements on one line (colon)
                },
            }
        }
    }
end

require("lspconfig").jedi_language_server.setup{
    on_attach = on_attach,
    settings = {
        jedi = {
            completion = {
                disable = true,
            },
            diagnostics = {
                enable = false,
            }
        }
    }
}

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
