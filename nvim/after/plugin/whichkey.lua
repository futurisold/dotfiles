local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

---@class wk.Opts
local defaults = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "classic",
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    return true
  end,
  ---@type wk.Spec
  spec = {},
  notify = true,
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    if vim.list_contains({ "d", "y" }, ctx.operator) then
      return true
    end
    return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
  end,
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  ---@type wk.Win.opts
  win = {
    no_overlap = true,
    padding = { 1, 2 },
    title = true,
    title_pos = "center",
    zindex = 1000,
    bo = {},
    wo = {},
  },
  layout = {
    width = { min = 20 },
    spacing = 3,
    align = "left",
  },
  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  sort = { "local", "order", "group", "alphanum", "mod" },
  expand = 0,
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
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
    breadcrumb = ">>",
    separator = "->",
    group = "+",
    ellipsis = "...",
    rules = {},
    colors = true,
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "C-",
      M = "M-",
      S = "S-",
      CR = "CR ",
      Esc = "Esc ",
      ScrollWheelDown = "ScrollDown ",
      ScrollWheelUp = "ScrollUp ",
      NL = "NL ",
      BS = "BS ",
      Space = "Space ",
      Tab = "Tab ",
    },
  },
  show_help = true,
  show_keys = true,
  triggers = {
    { "<auto>", mode = "nxsioc" },
    { "<leader>", mode = { "n", "v" } },
  },
  debug = false,
}

local function toggle_explorer()
    local ok, _ = pcall(vim.cmd, "NvimTreeToggle")
    if not ok then
        vim.cmd("Explore")
    end
end

local n_mappings = {
    mode='n',
    noremap=true,
    silent=true,
    nowait=true,
    buffer=nil,
    icon='',
    { '<leader>b', "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc="Buffers" },
    { '<leader>e', toggle_explorer,                                                                                                  desc="Explorer" },
    { '<leader>w', "<cmd>w!<cr>",                                                                                                    desc="Save" },
    { '<leader>q', "<cmd>q!<cr>",                                                                                                    desc="Quit" },
    { '<leader>c', "<cmd>Bdelete!<cr>",                                                                                              desc="Close Buffer" },
    { '<leader>h', "<cmd>nohlsearch<cr>",                                                                                            desc="No Highlight" },
    { '<leader>p',                                                                                                                   desc="Plugins (lazy)" },
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
    { '<leader>lj', "<cmd>lua vim.diagnostic.jump({count=1})<cr>",                                                                   desc="Next Diagnostic" },
    { '<leader>lk', "<cmd>lua vim.diagnostic.jump({count=-1})<cr>",                                                                  desc="Prev Diagnostic" },
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
}

local v_mappings = {
    mode='v',
    noremap=true,
    silent=true,
    nowait=true,
    buffer=nil,
    icon='',
    { "<leader>r",                                                      desc="Query/Replace" },
    { "<leader>rr", "<cmd>SearchReplaceWithinVisualSelection<cr>",      desc='Search and replace'},
    { "<leader>rc", "<cmd>SearchReplaceWithinVisualSelectionCWord<cr>", desc='Search and replace with current word'},
}

which_key.setup(defaults)
which_key.add(n_mappings)
which_key.add(v_mappings)
