local status_ok, nvim_tree   = pcall(require, "nvim-tree")
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')

if not status_ok then
    return
end


-- check if ps aux finds any running sshfs processes, and if so, don't use nvim-tree
local function has_sshfs_mounts()
    local home = os.getenv("HOME")
    local command = "ps aux | grep -E 'sshfs [^ ]+ " .. home .. "/.sshfs.*'"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

if has_sshfs_mounts() then
    -- Add binding to open :Explore with <leader>e only if sshfs is mounted
    vim.api.nvim_set_keymap('n', '<leader>e', ':Explore<CR>', { noremap = true, silent = true })
    return
end


-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help')) -- pretty much all I need
end

nvim_tree.setup({
    on_attach = on_attach,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    renderer = {
        group_empty = true,
        root_folder_modifier = ":t",
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "U",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  filters = {
    dotfiles = true,
  },
})

if has_devicons then
  devicons.set_icon({
    toml = { icon = "", color = "#6d8086", name = "Toml" }
  })
end

