local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "after.mason"
require("after.handlers").setup()
require "after.null-ls"
