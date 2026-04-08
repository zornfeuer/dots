local M = {}

M.config = function()
    require("oil").setup({
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        view_options = {
            show_hidden = true,
        },
        skip_confirm_for_simple_edits = true,
    })
end

return M
