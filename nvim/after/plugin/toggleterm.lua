local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

local ok_tree, tree_api = pcall(require, "nvim-tree.api")
local term_mod = require("toggleterm.terminal")
local last_id = nil

local function is_tree_visible()
    return ok_tree and tree_api.tree.is_visible()
end

-- Close/reopen NvimTree around a function call so that split terminals
-- get the correct window tree ordering (NvimTree full-height, terminal scoped
-- to the editor area). Floats are excluded — they auto-close on leave.
function _toggleterm_with_tree_fix(fn)
    local visible = is_tree_visible()
    if visible then tree_api.tree.close() end
    fn()
    if visible then
        tree_api.tree.open()
        vim.cmd("wincmd p")
    end
end

local function smart_open(term)
    if term.direction ~= "float" then
        _toggleterm_with_tree_fix(function() term:open() end)
    else
        term:open()
    end
end

-- Cycle through terminals by delta (+1 or -1).
-- get_all() returns terminals sorted by ID already.
function _toggleterm_cycle(delta)
    local terms = term_mod.get_all()
    if #terms == 0 then vim.cmd("1ToggleTerm") return end
    local current = term_mod.get_focused_id() or last_id
    for _, t in ipairs(terms) do
        if t:is_open() then t:close() end
    end
    local idx = delta > 0 and 1 or #terms
    if current then
        for i, t in ipairs(terms) do
            if t.id == current then
                idx = (i - 1 + delta) % #terms + 1
                break
            end
        end
    end
    local target = terms[idx]
    last_id = target.id
    smart_open(target)
end

-- Create a new terminal with given direction and optional size.
-- Closes all open terminals first to avoid mixed-direction layout bugs.
function _toggleterm_new(direction, size)
    local max_id = 0
    for _, t in ipairs(term_mod.get_all()) do
        if t:is_open() then t:close() end
        if t.id > max_id then max_id = t.id end
    end
    local size_part = size and ("size=" .. size .. " ") or ""
    local cmd = (max_id + 1) .. "ToggleTerm " .. size_part .. "direction=" .. direction
    if direction ~= "float" then
        _toggleterm_with_tree_fix(function() vim.cmd(cmd) end)
    else
        vim.cmd(cmd)
    end
end

-- Smart toggle for <c-\> that applies the NvimTree layout fix when opening.
-- Float terminals auto-close on leave (handle_term_leave in toggleterm), so
-- the tree fix only works as a post-open correction for split terminals.
local function smart_toggle()
    local any_open = false
    for _, t in ipairs(term_mod.get_all()) do
        if t:is_open() then any_open = true break end
    end
    if any_open then
        vim.cmd("ToggleTerm")
        return
    end
    vim.cmd("ToggleTerm")
    if not is_tree_visible() then return end
    local split_term
    for _, t in ipairs(term_mod.get_all()) do
        if t:is_open() and t.direction ~= "float" then
            split_term = t
            break
        end
    end
    if not split_term then return end
    split_term:close()
    tree_api.tree.close()
    split_term:open()
    tree_api.tree.open()
    vim.cmd("wincmd p")
end

toggleterm.setup({
    size = 20,
    open_mapping = false,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
    on_close = function(term)
        if last_id == term.id then last_id = nil end
    end,
})

local toggle_opts = { noremap = true, silent = true, desc = "Toggle terminal" }
vim.keymap.set("n", [[<c-\>]], smart_toggle, toggle_opts)
vim.keymap.set("i", [[<c-\>]], smart_toggle, toggle_opts)

local cycle_opts = { noremap = true, silent = true }
vim.keymap.set({"n", "t"}, "<M-]>", function() _toggleterm_cycle(1) end, vim.tbl_extend("force", cycle_opts, { desc = "Next terminal" }))
vim.keymap.set({"n", "t"}, "<M-[>", function() _toggleterm_cycle(-1) end, vim.tbl_extend("force", cycle_opts, { desc = "Prev terminal" }))

function _G.set_terminal_keymaps()
    local opts = { buffer = 0, noremap = true, silent = true }
    local maps = {
        { [[<c-\>]], [[<cmd>ToggleTerm<cr>]] },
        { '<esc>',   [[<C-\><C-n>]] },
        { '<C-h>',   [[<C-\><C-n><C-W>h]] },
        { '<C-j>',   [[<C-\><C-n><C-W>j]] },
        { '<C-k>',   [[<C-\><C-n><C-W>k]] },
        { '<C-l>',   [[<C-\><C-n><C-W>l]] },
    }
    for _, m in ipairs(maps) do
        vim.keymap.set('t', m[1], m[2], opts)
    end
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = term_mod.Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, auto_scroll = false })

function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end

local node = Terminal:new({ cmd = "node", hidden = true })

function _NODE_TOGGLE()
    node:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

function _NCDU_TOGGLE()
    ncdu:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true })

function _HTOP_TOGGLE()
    htop:toggle()
end

local python = Terminal:new({ cmd = "python", hidden = true })

function _PYTHON_TOGGLE()
    python:toggle()
end
