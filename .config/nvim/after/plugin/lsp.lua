local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'ts_ls',
    'eslint',
    'lua_ls',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.setup()


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end


    -- https://news.ycombinator.com/item?id=41738502

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    -- vim.keymap.set("n", "gds", "<C-w>v<cmd>lua vim.lsp.buf.definition()<CR>")
    vim.keymap.set("n", "gds", function()
        vim.lsp.buf_request(0, "textDocument/definition", vim.lsp.util.make_position_params(),
            function(err, result, _, _)
                if err or not result or vim.tbl_isempty(result) then return end

                -- Open a vertical split
                vim.cmd("vsplit")
                vim.cmd("wincmd l")

                -- Jump to the definition in the new split
                vim.lsp.util.jump_to_location(result[1], "utf-8")
            end)
    end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    -- search workspace for arbitrary keyword
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    -- is there a shorter keybinding we could use here? search workspace for cword
    vim.keymap.set("n", "<leader>vcws", function()
        local query = vim.fn.expand("<cword>")
        vim.lsp.buf.workspace_symbol(query)
    end, opts)

    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
