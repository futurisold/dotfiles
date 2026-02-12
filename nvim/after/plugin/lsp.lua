local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if not mason_ok or not mason_lspconfig_ok then
    return
end

mason.setup()
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "jedi_language_server" },
})

-- Advertise cmp capabilities to all LSP servers
vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Keybindings attached when an LSP client connects
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf, noremap = true, silent = true }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1 }) end, opts)
        vim.keymap.set("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
    end,
})

-- Lua
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields", "assign-type-mismatch" },
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
        },
    },
})

-- Python
vim.lsp.config("jedi_language_server", {
    settings = {
        jedi = {
            completion = { disable = true },
            diagnostics = { enable = false },
        },
    },
})

vim.lsp.enable({ "lua_ls", "jedi_language_server" })

vim.diagnostic.config({
    signs = false,
    virtual_text = false,
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})
