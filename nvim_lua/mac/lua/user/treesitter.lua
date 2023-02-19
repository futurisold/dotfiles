local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
  ensure_installed = { "vim", "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "java", "yaml", "markdown_inline", "markdown"}, -- one of "all" or a list of languages
	ignore_install = { "phpdoc", "latex"}, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css", "latex"}, -- list of language that will be disabled
        additional_vim_regex_highlighting = {"latex", "markdown" }, -- for Obsidian.md
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
})
