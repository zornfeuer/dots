local M = {}

M.opts = {
    formatters_by_ft = {
        python = { 'ruff', 'black' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
    },
    format_after_save = true,
}

return M
