local M = {}

M.config = function()
    require("neo-tree").setup({
        close_if_last_window = true,
        window = {
            position = "left",
            width = 40,
        },
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = true,
                hide_gitignored = true,
            },
        },
    })
end

return M
