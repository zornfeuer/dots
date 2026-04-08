local M = {}

M.config = function()
    require("mini.comment").setup()
    require("mini.pairs").setup()
    require("mini.notify").setup()
    require("mini.diff").setup()
end

return M
