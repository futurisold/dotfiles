local status_ok, vimtex = pcall(require, "vimtex")
if not status_ok then
    return
end

vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.o.conceallevel=2
vim.g.vimtex_syntax_conceal = {
    accents = 1,
    ligatures = 1,
    cites = 1,
    fancy = 1,
    spacing = 1,
    greek = 1,
    math_bounds = 1,
    math_delimiters = 1,
    math_fracs = 1,
    math_super_sub = 1,
    math_symbols = 1,
    sections = 0,
    styles = 1,
}
