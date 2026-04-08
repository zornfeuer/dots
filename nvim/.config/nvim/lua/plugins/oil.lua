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
    })
end

return M
