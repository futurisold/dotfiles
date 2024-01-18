local status_ok, rsshfs = pcall(require, "remote-sshfs")

if not status_ok then
  print("Failed to load!")
  return
end

require('remote-sshfs').setup({})
