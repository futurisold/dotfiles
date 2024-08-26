local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

---@class wk.Opts
local defaults = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "classic",
  -- Delay before showing the popup. Can be a number or a function that returns a number.
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    -- example to exclude mappings without a description
    -- return mapping.desc and mapping.desc ~= ""
    return true
  end,
  --- You can add any mappings here, or use `require('which-key').add()` later
  ---@type wk.Spec
  spec = {},
  -- show a warning when issues were detected with your mappings
  notify = true,
  -- Enable/disable WhichKey for certain mapping modes
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    if vim.list_contains({ "d", "y" }, ctx.operator) then
      return true
    end
    return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
  end,
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  ---@type wk.Win.opts
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
  layout = {
    width = { min = 20 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  ---@type (string|wk.Sorter)[]
  --- Mappings are sorted using configured sorters and natural sort of the keys
  --- Available sorters:
  --- * local: buffer-local mappings first
  --- * order: order of the items (Used by plugins like marks / registers)
  --- * group: groups last
  --- * alphanum: alpha-numerical first
  --- * mod: special modifier keys last
  --- * manual: the order the mappings were added
  --- * case: lower-case first
  sort = { "local", "order", "group", "alphanum", "mod" },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 0, -- expand groups when <= n mappings
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
    desc = {
      { "<Plug>%((.*)%)", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "⌫",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  -- Which-key automatically sets up triggers for your mappings.
  -- But you can disable this and setup the triggers yourself.
  triggers = {
    { "<auto>", mode = "nxsioc" }, -- Normal, Visual, Select, Insert, Operator-pending, Command modes
    { "<leader>", mode = { "n", "v" } }, -- Specific trigger for leader in Normal and Visual modes
  },
  debug = false, -- enable wk.log in the current directory
}

local function breakpoint()
    local line = vim.fn.line('.')
    vim.api.nvim_buf_set_lines(0, line, line, false, {'import code; code.interact(local=locals())'})
end

local n_mappings = {
    mode='n',
    noremap=true,
    silent=true,
    nowait=true,
    buffer=nil,
    icon='', -- this can be set for each mapping; disabled at the root level to propagate to all mappings
    { '<leader>b', "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc="Buffers" },
    { '<leader>e', "<cmd>NvimTreeToggle<cr>",                                                                                        desc="Explorer" },
    { '<leader>w', "<cmd>w!<cr>",                                                                                                    desc="Save" },
    { '<leader>q', "<cmd>q!<cr>",                                                                                                    desc="Quit" },
    { '<leader>c', "<cmd>Bdelete!<cr>",                                                                                              desc="Close Buffer" },
    { '<leader>h', "<cmd>nohlsearch<cr>",                                                                                            desc="No Highlight" },
    { '<leader>d',                                                                                                                   desc='Debugger' },
    { '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                                                                 desc="DAP Breakpoint" },
    { '<leader>dp', breakpoint,                                                                                                      desc="Interact Breakpoint" },
    { '<leader>dt', "<cmd>lua require'dapui'.toggle()<cr>",                                                                          desc="Toggle UI" },
    { '<leader>dc', "<cmd>lua require'dap'.continue()<cr>",                                                                          desc="Continue" },
    { '<leader>di', "<cmd>lua require'dap'.step_into()<cr>",                                                                         desc="Step Into" },
    { '<leader>do', "<cmd>lua require'dap'.step_out()<cr>",                                                                          desc="Step Out" },
    { '<leader>dO', "<cmd>lua require'dap'.step_over()<cr>",                                                                         desc="Step Over" },
    { '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<cr>",                                                                       desc="Toggle Repl" },
    { '<leader>ds', "<cmd>lua require'dap'.continue()<cr>",                                                                          desc="Start" },
    { '<leader>dS', "<cmd>lua require'dap'.close()<cr>",                                                                             desc="Stop" },
    { '<leader>p',                                                                                                                   desc="Plugins (lazyvim)" },
    { '<leader>pb', "<cmd>Lazy build<cr>",                                                                                           desc="Build Plugin" },
    { '<leader>pc', "<cmd>Lazy check<cr>",                                                                                           desc="Check for Updates" },
    { '<leader>pl', "<cmd>Lazy clean<cr>",                                                                                           desc="Clean Plugins" },
    { '<leader>pr', "<cmd>Lazy clear<cr>",                                                                                           desc="Clear Finished Tasks" },
    { '<leader>pd', "<cmd>Lazy debug<cr>",                                                                                           desc="Debug Info" },
    { '<leader>ph', "<cmd>Lazy health<cr>",                                                                                          desc="Health Check" },
    { '<leader>pm', "<cmd>Lazy home<cr>",                                                                                            desc="Plugin List" },
    { '<leader>pi', "<cmd>Lazy install<cr>",                                                                                         desc="Install Plugins" },
    { '<leader>po', "<cmd>Lazy load<cr>",                                                                                            desc="Load Plugin" },
    { '<leader>pg', "<cmd>Lazy log<cr>",                                                                                             desc="Plugin Log" },
    { '<leader>pp', "<cmd>Lazy profile<cr>",                                                                                         desc="Profiling" },
    { '<leader>pe', "<cmd>Lazy reload<cr>",                                                                                          desc="Reload Plugin" },
    { '<leader>ps', "<cmd>Lazy restore<cr>",                                                                                         desc="Restore Plugin" },
    { '<leader>py', "<cmd>Lazy sync<cr>",                                                                                            desc="Sync Plugins" },
    { '<leader>pu', "<cmd>Lazy update<cr>",                                                                                          desc="Update Plugins" },
    { '<leader>g',                                                                                                                   desc="Git" },
    { '<leader>gg', "<cmd>lua _LAZYGIT_TOGGLE()<cr>",                                                                                desc="Lazygit" },
    { '<leader>gj', "<cmd>lua require 'gitsigns'.next_hunk()<cr>",                                                                   desc="Next Hunk" },
    { '<leader>gk', "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",                                                                   desc="Prev Hunk" },
    { '<leader>gl', "<cmd>lua require 'gitsigns'.blame_line()<cr>",                                                                  desc="Blame" },
    { '<leader>gp', "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                                                                desc="Preview Hunk" },
    { '<leader>gr', "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                                                                  desc="Reset Hunk" },
    { '<leader>gR', "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                                                                desc="Reset Buffer" },
    { '<leader>gs', "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                                                                  desc="Stage Hunk" },
    { '<leader>gu', "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                                                             desc="Undo Stage Hunk" },
    { '<leader>go', "<cmd>Telescope git_status<cr>",                                                                                 desc="Open changed file" },
    { '<leader>gb', "<cmd>Telescope git_branches<cr>",                                                                               desc="Checkout branch" },
    { '<leader>gc', "<cmd>Telescope git_commits<cr>",                                                                                desc="Checkout commit" },
    { '<leader>gd', "<cmd>Gitsigns diffthis HEAD<cr>",                                                                               desc="Diff" },
    { '<leader>l',                                                                                                                   desc="LSP" },
    { '<leader>la', "<cmd>lua vim.lsp.buf.code_action()<cr>",                                                                        desc="Code Action" },
    { '<leader>ld', "<cmd>Telescope diagnostics bufnr=0<cr>",                                                                        desc="Document Diagnostics" },
    { '<leader>lw', "<cmd>Telescope diagnostics<cr>",                                                                                desc="Workspace Diagnostics" },
    { '<leader>lf', "<cmd>lua vim.lsp.buf.format{async=true}<cr>",                                                                   desc="Format" },
    { '<leader>li', "<cmd>LspInfo<cr>",                                                                                              desc="Info" },
    { '<leader>lI', "<cmd>LspInstallInfo<cr>",                                                                                       desc="Installer Info" },
    { '<leader>lj', "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",                                                                   desc="Next Diagnostic" },
    { '<leader>lk', "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",                                                                   desc="Prev Diagnostic" },
    { '<leader>ll', "<cmd>lua vim.lsp.codelens.run()<cr>",                                                                           desc="CodeLens Action" },
    { '<leader>lq', "<cmd>lua vim.diagnostic.setloclist()<cr>",                                                                      desc="Quickfix" },
    { '<leader>lr', "<cmd>lua vim.lsp.buf.rename()<cr>",                                                                             desc="Rename" },
    { '<leader>lS', "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                                                              desc="Workspace Symbols" },
    { '<leader>l?', "<cmd>Telescope lsp_document_symbols<cr>",                                                                       desc="Document Symbols" },
    { '<leader>s',                                                                                                                   desc="Search" },
    { '<leader>sb', "<cmd>Telescope git_branches<cr>",                                                                               desc="Checkout branch" },
    { '<leader>sC', "<cmd>Telescope colorscheme<cr>",                                                                                desc="Colorscheme" },
    { '<leader>sh', "<cmd>Telescope help_tags<cr>",                                                                                  desc="Help Help" },
    { '<leader>sM', "<cmd>Telescope man_pages<cr>",                                                                                  desc="Man Pages" },
    { '<leader>sr', "<cmd>Telescope oldfiles<cr>",                                                                                   desc="Open Recent File" },
    { '<leader>sR', "<cmd>Telescope registers<cr>",                                                                                  desc="Registers" },
    { '<leader>sk', "<cmd>Telescope keymaps<cr>",                                                                                    desc="Keymaps" },
    { '<leader>sc', "<cmd>Telescope commands<cr>",                                                                                   desc="Commands" },
    { '<leader>sf', "<cmd>Telescope find_files<cr>",                                                                                 desc="Find files" },
    { '<leader>sg', "<cmd>Telescope live_grep_args<cr>",                                                                             desc="Find text with rg" },
    { '<leader>t',                                                                                                                   desc="Terminal" },
    { '<leader>tn', "<cmd>lua _NODE_TOGGLE()<cr>",                                                                                   desc="Node" },
    { '<leader>tu', "<cmd>lua _NCDU_TOGGLE()<cr>",                                                                                   desc="NCDU" },
    { '<leader>tt', "<cmd>lua _HTOP_TOGGLE()<cr>",                                                                                   desc="Htop" },
    { '<leader>tp', "<cmd>lua _PYTHON_TOGGLE()<cr>",                                                                                 desc="Python" },
    { '<leader>tf', "<cmd>ToggleTerm direction=float<cr>",                                                                           desc="Float" },
    { '<leader>th', "<cmd>ToggleTerm size=10 direction=horizontal<cr>",                                                              desc="Horizontal" },
    { '<leader>tv', "<cmd>ToggleTerm size=80 direction=vertical<cr>",                                                                desc="Vertical" },
    { '<leader>r',                                                                                                                   desc="Query/Replace" },
    { '<leader>rs', "<cmd>SearchReplaceSingleBufferSelections<cr>",                                                                  desc="[s]election list"},
    { '<leader>rW', "<cmd>SearchReplaceSingleBufferCWORD<cr>",                                                                       desc="[W]ORD" },
    { '<leader>rw', "<cmd>SearchReplaceSingleBufferCWord<cr>",                                                                       desc="[w]ord" },
    { '<leader>ro', "<cmd>SearchReplaceSingleBufferOpen<cr>",                                                                        desc="[o]pen" },
    { '<leader>re', "<cmd>SearchReplaceSingleBufferCExpr<cr>",                                                                       desc="[e]xpr" },
    { '<leader>rf', "<cmd>SearchReplaceSingleBufferCFile<cr>",                                                                       desc="[f]ile" },
    { '<leader>x',                                                                                                                   desc="LaTeX" },
    { '<leader>xa', "<cmd>VimtexCompile<cr>",                                                                                        desc="Start compiler" },
    { '<leader>xs', "<cmd>VimtexStop<cr>",                                                                                           desc="Stop compiler" },
    { '<leader>xc', "<cmd>VimtexCompileSS<cr>",                                                                                      desc="Compile" },
    { '<leader>xe', "<cmd>VimtexErrors<cr>",                                                                                         desc="Errors" },
    { '<leader>xr', "<cmd>VimtexReload<cr>",                                                                                         desc="Reload plugin" },
    { '<leader>aa', "<cmd>AvanteAsk<cr>",                                                                                            desc="Ask AI copilot" },
    { '<leader>ac', "<cmd>AvanteClose<cr>",                                                                                          desc="Collapse AI copilot chat panel" },
}

local v_mappings = {
    mode='v',
    noremap=true,
    silent=true,
    nowait=true,
    buffer=nil,
    icon='', -- this can be set for each mapping; disabled at the root level to propagate to all mappings
    { "<leader>r",                                                      desc="Query/Replace" },
    { "<leader>rr", "<cmd>SearchReplaceWithinVisualSelection<cr>",      desc='Search and replace'},
    { "<leader>rc", "<cmd>SearchReplaceWithinVisualSelectionCWord<cr>", desc='Search and replace with current word'},
}

which_key.setup(defaults)
which_key.add(n_mappings)
which_key.add(v_mappings)
