--- vim.pack: specs + setup registry (only `src`/`name`/`version` go to vim.pack.add — no functions in specs).
local M = {}

local PLUGINS = {
    --- === LSP Block ===
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    {
        src = "https://github.com/williamboman/mason.nvim",
        dependencies = {
            "https://github.com/williamboman/mason-lspconfig.nvim",
        },
        config = require("plugins.lsp").setup_mason,
    },
    {
        name = "conform",
        src = "https://github.com/stevearc/conform.nvim",
        opts = require("plugins.conform").opts
    },
    {
        src = "https://github.com/neovim/nvim-lspconfig",
        dependencies = {
            "https://github.com/williamboman/mason.nvim",
            "https://github.com/williamboman/mason-lspconfig.nvim",
        },
        config = require("plugins.lsp").setup_lsp,
    },
    --- === Mini Plugins ===
    { name = "mini.comment",                                       src = "https://github.com/echasnovski/mini.comment" },
    { name = "mini.pairs",                                         src = "https://github.com/echasnovski/mini.pairs" },
    { name = "mini.notify",                                        src = "https://github.com/echasnovski/mini.notify" },
    --- === Neovim Treesitter ===
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        config = require("plugins.treesitter").config,
        opts = require("plugins.treesitter").opts
    },
    --- === FZF + Devicons ===
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    {
        name = "fzf-lua",
        src = "https://github.com/ibhagwan/fzf-lua",
        dependencies = {
            "https://github.com/nvim-tree/nvim-web-devicons",
        },
    },
    --- === CMP + Copilot ===
    { src = "https://github.com/giuxtaposition/blink-cmp-copilot" },
    {
        src = "https://github.com/zbirenbaum/copilot.lua",
        opts = require("plugins.copilot").opts,
        config = require("plugins.copilot").config,
    },
    {
        name = "blink.cmp",
        src = "https://github.com/saghen/blink.cmp",
        dependencies = {
            "https://github.com/zbirenbaum/copilot.lua",
            "https://github.com/giuxtaposition/blink-cmp-copilot",
        },
        init = require("plugins.cmp").init,
        opts = require("plugins.cmp").opts,
    },
    --- === Neo-tree ===
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    {
        src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
        version = "v3.x",
        dependencies = {
            "https://github.com/nvim-lua/plenary.nvim",
            "https://github.com/MunifTanjim/nui.nvim",
            "https://github.com/nvim-tree/nvim-web-devicons",
        },
        config = require("plugins.neotree").config,
    },
    --- === Other ===
    { src = "https://github.com/pearofducks/ansible-vim" },
    {
        name = "gruvbox-material",
        src = "https://github.com/f4z3r/gruvbox-material.nvim",
        opts = { background = { transparent = true } },
    },
}

--- @param cwd string
local function run_cargo_blink(cwd)
    if vim.fn.executable("cargo") ~= 1 then
        vim.notify("vim.pack: cargo not in PATH; blink.cmp fuzzy binary will not build", vim.log.levels.WARN)
        return
    end
    local r = vim.system({ "cargo", "build", "--release" }, { cwd = cwd }):wait()
    if r.code ~= 0 then
        vim.notify(
            "vim.pack: blink.cmp `cargo build --release` failed:\n" .. (r.stderr or ""),
            vim.log.levels.ERROR
        )
    end
end

--- @param d table
local function run_setup(d)
    if d.init then
        d.init()
    end

    if d.config then
        d.config(nil, d.opts or {})
        return
    end

    if d.name then
        require(d.name).setup(d.opts or {})
    end
end

function M.init()
    local g = vim.api.nvim_create_augroup("UserVimPackBlink", { clear = true })
    vim.api.nvim_create_autocmd("PackChanged", {
        group = g,
        callback = function(ev)
            local data = ev.data
            if not data or data.spec.name ~= "blink.cmp" then
                return
            end
            if data.kind ~= "update" and data.kind ~= "install" then
                return
            end
            run_cargo_blink(data.path)
        end,
    })

    vim.pack.add(PLUGINS)

    for _, d in ipairs(PLUGINS) do
        run_setup(d)
    end
end

return M
