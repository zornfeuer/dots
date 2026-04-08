local M = {}

M.init = function()
    local bc = require("blink-cmp-copilot")
    local orig = bc.get_completions
    function bc:get_completions(context, callback)
        local clients = vim.lsp.get_clients({ name = "copilot" })
        bc.client = clients[1]
        if not bc.client then
            return callback({
                is_incomplete_forward = true,
                is_incomplete_backward = true,
                items = {},
            })
        end
        return orig(self, context, callback)
    end
end

M.opts = {
    keymap = {
        preset = "default",
        ["<C-d>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
        documentation = {
            auto_show = true,
        },
    },
    appearance = {
        kind_icons = {
            Copilot = "",
        },
    },
    sources = {
        default = { "lsp", "path", "buffer", "copilot" },
        providers = {
            copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                score_offset = 100,
                async = true,
                override = {
                    get_trigger_characters = function()
                        return {}
                    end,
                },
                transform_items = function(_, items)
                    local kinds = require("blink.cmp.types").CompletionItemKind
                    local idx = #kinds + 1
                    kinds[idx] = "Copilot"
                    for _, item in ipairs(items) do
                        item.kind = idx
                    end
                    return items
                end,
            },
            lsp = { async = true },
        },
    },
    -- Rust fuzzy: built automatically on install/update via PackChanged in plugins/pack.lua,
    -- plus a glob check before blink.setup. Prebuilt curl disabled (we track main / local build).
    fuzzy = {
        implementation = "prefer_rust",
        prebuilt_binaries = { download = false },
    },
}

return M
