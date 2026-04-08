local M = {}

local servers = {
    "ansiblels",
    "clangd",
    "gopls",
    "jinja_lsp",
    "jsonls",
    "lua_ls",
    "marksman",
    "nil_ls",
    "prismals",
    "pylsp",
    "rust_analyzer",
    "ts_ls",
}

local server_overrides = {
    rust_analyzer = {
        filetypes = { "rust" },
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    },
}

local function on_lsp_attach(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local map_opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
        vim.tbl_extend("force", map_opts, { desc = "LSP declaration" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", map_opts, { desc = "LSP hover" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
        vim.tbl_extend("force", map_opts, { desc = "LSP implementation" }))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
        vim.tbl_extend("force", map_opts, { desc = "LSP signature help" }))
    vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", map_opts, { desc = "LSP rename" }))
    vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action,
        vim.tbl_extend("force", map_opts, { desc = "LSP code action" }))
    vim.keymap.set("n", "<Leader>lf", function()
            require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 15000 })
        end,
        vim.tbl_extend("force", map_opts, { desc = "Format buffer (conform)" })
    )
end

M.setup_lsp = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    for _, server in ipairs(servers) do
        local cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_overrides[server] or {})
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
    end

    local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = on_lsp_attach,
    })

    require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
    })
end

M.setup_mason = function(_, opts)
    local local_bin = vim.fn.expand("~/.local/bin")
    if not vim.startswith(vim.env.PATH or "", local_bin) then
        vim.env.PATH = local_bin .. ":" .. (vim.env.PATH or "")
    end

    require("mason").setup(vim.tbl_deep_extend("force", opts or {}, {
        ui = { border = "rounded" },
    }))
end

return M
