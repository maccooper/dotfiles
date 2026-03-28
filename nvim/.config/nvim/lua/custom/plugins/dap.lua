return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "theHamsta/nvim-dap-virtual-text",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local dap_go = require "dap-go"

            require("dap-go").setup()

            dap.configurations.go = dap.configurations.go or {}
            table.insert(dap.configurations.go, {
                type = "go",
                name = "Debug API Server",
                request = "launch",
                program = "./cmd/server",
                cwd = vim.fn.getcwd(),
            })
            table.insert(dap.configurations.go, {
                type = "go",
                name = "Attach Remote",
                mode = "remote",
                request = "attach",
                host = "127.0.0.1",
                port = "2345",
            })

            -- Floating keybind cheatsheet
            local function show_dap_help()
                local lines = {
                    "  DAP Keybinds                        ",
                    " ─────────────────────────────────────",
                    "  <F1>          Continue              ",
                    "  <F2>          Step Into            ",
                    "  <F3>          Step Over            ",
                    "  <F4>          Step Out             ",
                    "  <F13>         Restart              ",
                    " ─────────────────────────────────────",
                    "  <space>b      Toggle Breakpoint    ",
                    "  <space>B      Conditional BP       ",
                    "  <space>gb     Run to Cursor        ",
                    " ─────────────────────────────────────",
                    "  <leader>db    List Breakpoints     ",
                    "  <leader>dgt   Debug Go Test        ",
                    "  <leader>dgl   Debug Last Test      ",
                    "  <leader>dh    This help            ",
                    " ─────────────────────────────────────",
                    "  q / <Esc>     Close                ",
                }
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                vim.bo[buf].modifiable = false
                local width = 43
                local height = #lines
                vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = height,
                    row = math.floor((vim.o.lines - height) / 2),
                    col = math.floor((vim.o.columns - width) / 2),
                    style = "minimal",
                    border = "rounded",
                    title = " DAP Help ",
                    title_pos = "center",
                })
                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
                vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
            end

            -- Harpoon-style floating breakpoint navigator
            local function list_breakpoints()
                local bps = require("dap.breakpoints").get()
                local entries = {}
                for bufnr, buf_bps in pairs(bps) do
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    local short = vim.fn.fnamemodify(fname, ":~:.")
                    for _, bp in ipairs(buf_bps) do
                        table.insert(entries, {
                            bufnr = bufnr,
                            lnum = bp.line,
                            short = short,
                            condition = bp.condition,
                        })
                    end
                end
                if #entries == 0 then
                    vim.notify("No breakpoints set", vim.log.levels.INFO)
                    return
                end
                table.sort(entries, function(a, b)
                    return a.short < b.short or (a.short == b.short and a.lnum < b.lnum)
                end)

                local lines = {}
                for _, e in ipairs(entries) do
                    local cond = e.condition and ("  [" .. e.condition .. "]") or ""
                    table.insert(lines, string.format("  %s:%d%s", e.short, e.lnum, cond))
                end

                local width = math.min(60, vim.o.columns - 4)
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                vim.bo[buf].modifiable = false

                local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = #lines,
                    row = math.floor((vim.o.lines - #lines) / 2),
                    col = math.floor((vim.o.columns - width) / 2),
                    style = "minimal",
                    border = "rounded",
                    title = " Breakpoints ",
                    title_pos = "center",
                })

                vim.keymap.set("n", "<CR>", function()
                    local idx = vim.api.nvim_win_get_cursor(win)[1]
                    local e = entries[idx]
                    vim.api.nvim_win_close(win, true)
                    vim.api.nvim_set_current_buf(e.bufnr)
                    vim.api.nvim_win_set_cursor(0, { e.lnum, 0 })
                    vim.cmd("normal! zz")
                end, { buffer = buf, silent = true })

                vim.keymap.set("n", "dd", function()
                    local idx = vim.api.nvim_win_get_cursor(win)[1]
                    local e = entries[idx]
                    require("dap.breakpoints").remove(e.bufnr, e.lnum)
                    table.remove(entries, idx)
                    if #entries == 0 then
                        vim.api.nvim_win_close(win, true)
                        return
                    end
                    local updated = {}
                    for _, entry in ipairs(entries) do
                        local cond = entry.condition and ("  [" .. entry.condition .. "]") or ""
                        table.insert(updated, string.format("  %s:%d%s", entry.short, entry.lnum, cond))
                    end
                    vim.bo[buf].modifiable = true
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, updated)
                    vim.bo[buf].modifiable = false
                    vim.api.nvim_win_set_height(win, #entries)
                    local new_idx = math.min(idx, #entries)
                    vim.api.nvim_win_set_cursor(win, { new_idx, 0 })
                end, { buffer = buf, silent = true })

                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
                vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
            end

            -- Keymaps
            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>B", function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end, { desc = "Conditional Breakpoint" })
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F13>", dap.restart)

            vim.keymap.set("n", "<leader>db", list_breakpoints, { desc = "List Breakpoints" })
            vim.keymap.set("n", "<leader>dh", show_dap_help, { desc = "DAP Help" })

            -- Go-specific debug mappings
            vim.keymap.set("n", "<leader>dgt", function()
                dap_go.debug_test()
            end, { desc = "Debug Go Test" })

            vim.keymap.set("n", "<leader>dgl", function()
                dap_go.debug_last_test()
            end, { desc = "Debug Last Go Test" })

            -- Statusline color indicator
            local orig_statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
            dap.listeners.after.event_initialized["statusline_delve"] = function()
                vim.api.nvim_set_hl(0, "StatusLine", { fg = "#f38ba8", bg = orig_statusline.bg })
            end
            local function reset_statusline()
                vim.api.nvim_set_hl(0, "StatusLine", orig_statusline)
            end
            dap.listeners.before.event_terminated["statusline_delve"] = reset_statusline
            dap.listeners.before.event_exited["statusline_delve"] = reset_statusline
        end,
    },
}
