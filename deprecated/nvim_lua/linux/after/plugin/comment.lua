local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

comment.setup {
    pre_hook = function(ctx)
        local status_utils_ok, utils = pcall(require, "ts_context_commentstring.utils")
        if not status_utils_ok then
            return
        end

        local location = nil
        if ctx.ctype == comment.utils.ctype.block then
            location = utils.get_cursor_location()
        elseif ctx.cmotion == comment.utils.cmotion.v or ctx.cmotion == comment.utils.cmotion.V then
            location = utils.get_visual_start_location()
        end

        local status_internals_ok, internals = pcall(require, "ts_context_commentstring.internals")
        if not status_internals_ok then
            return
        end

        return internals.calculate_commentstring {
            key = ctx.ctype == comment.utils.ctype.line and "__default" or "__multiline",
            location = location,
        }
    end,
}

comment.setup({
    toggler = {
        line = '<leader>//'
    },
    opleader = {
        line = '<leader>//'
    }
})
