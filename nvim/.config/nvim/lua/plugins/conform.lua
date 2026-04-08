local M = {}

M.opts = {
    formatters_by_ft = {
        python = { 'ruff', 'black' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
    },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
}

return M
