local status_ok, dap = pcall(require, "dap")
if not status_ok then
  return
end

-- check if dapui is available
local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
  return
end

get_python_path = function()
-- return the path to the conda environment if it exists
  local conda_env = os.getenv('CONDA_PREFIX')
  if conda_env then
    return conda_env .. '/bin/python'
  else
    -- throw an error if the conda environment does not exist
    error('CONDA_PREFIX is not set')
  end
end

dap.adapters.python = {
  type = 'executable',
  command = get_python_path(),
  args = { '-m', 'debugpy.adapter' }
}

dap.configurations.python = {
    {
    -- The first three options are required by nvim-dap
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = get_python_path()
    }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.after.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "➡",
  texthl = "DiagnosticSignWarn",
  linehl = "Visual",
  numhl = "DiagnosticSignWarn",
})

dapui.setup({
    icons = {
        expanded = "▾",
        current_frame = "▸",
        collapsed = "▸"
    }
})

