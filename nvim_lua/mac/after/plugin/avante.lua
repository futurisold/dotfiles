local avante_status_ok, avante = pcall(require, "avante")

if not avante_status_ok then
    return
end

avante.setup({
      ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | [string]
      provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        api_key_name= os.getenv("ANTHROPIC_API_KEY"), -- this is set in your shell rc file
        temperature = 0,
        max_tokens = 4096,
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          none = "c0",
          both = "cb",
          next = "]x",
          prev = "[x",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        toggle = {
          debug = "<leader>ad",
          hint = "<leader>ah",
        },
      },
      hints = { enabled = true },
      windows = {
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          align = "center", -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        debug = false,
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
      },
})

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"
