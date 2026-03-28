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

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })

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

            -- Floating breakpoint navigator
            local function list_breakpoints()
                local bps = require("dap.breakpoints").get()
                local entries = {}
                for bufnr, buf_bps in pairs(bps) do
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    local short = vim.fn.fnamemodify(fname, ":t")
                    for _, bp in ipairs(buf_bps) do
                        local line_content = vim.api.nvim_buf_get_lines(bufnr, bp.line - 1, bp.line, false)[1] or ""
                        line_content = line_content:match("^%s*(.-)%s*$")
                        table.insert(entries, {
                            bufnr = bufnr,
                            lnum = bp.line,
                            ref = string.format("%s:%d", short, bp.line),
                            content = line_content,
                            conditional = bp.condition ~= nil,
                        })
                    end
                end
                if #entries == 0 then
                    vim.notify("No breakpoints set", vim.log.levels.INFO)
                    return
                end
                table.sort(entries, function(a, b)
                    return a.ref < b.ref
                end)

                local ns = vim.api.nvim_create_namespace("dap_bp_nav")
                local col_width = 0
                for _, e in ipairs(entries) do
                    col_width = math.max(col_width, #e.ref)
                end

                local function render(target_buf)
                    local lines = {}
                    for _, e in ipairs(entries) do
                        local marker = e.conditional and "◆ " or "  "
                        table.insert(lines, string.format("%s%-" .. col_width .. "s   %s", marker, e.ref, e.content))
                    end
                    vim.bo[target_buf].modifiable = true
                    vim.api.nvim_buf_set_lines(target_buf, 0, -1, false, lines)
                    vim.api.nvim_buf_clear_namespace(target_buf, ns, 0, -1)
                    for i in ipairs(entries) do
                        vim.api.nvim_buf_add_highlight(target_buf, ns, "Comment", i - 1, 2, 2 + col_width + 2)
                    end
                    vim.bo[target_buf].modifiable = false
                end

                local width = math.min(72, vim.o.columns - 4)
                local buf = vim.api.nvim_create_buf(false, true)
                render(buf)

                local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = #entries,
                    row = math.floor((vim.o.lines - #entries) / 2),
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
                    render(buf)
                    vim.api.nvim_win_set_height(win, #entries)
                    vim.api.nvim_win_set_cursor(win, { math.min(idx, #entries), 0 })
                end, { buffer = buf, silent = true })

                vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
                vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
            end

            -- Keymaps
            vim.keymap.set("n", "<space>b", function()
                local line = vim.api.nvim_get_current_line()
                if line:match("^%s*$") then
                    vim.notify("Can't set breakpoint on empty line", vim.log.levels.WARN)
                    return
                end
                dap.toggle_breakpoint()
            end)
            vim.keymap.set("n", "<space>B", function()
                local line = vim.api.nvim_get_current_line()
                if line:match("^%s*$") then
                    vim.notify("Can't set breakpoint on empty line", vim.log.levels.WARN)
                    return
                end
                local condition = vim.fn.input("Condition: ")
                if condition == "" then return end
                if condition:match("^%s*if%s") or condition:match("^%s*for%s") or condition:match("^%s*var%s") or condition:match("^%s*func%s") then
                    vim.notify("Condition must be an expression (e.g. x > 0, err != nil)", vim.log.levels.WARN)
                    return
                end
                dap.set_breakpoint(condition)
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

            -- Surface invalid breakpoint conditions
            dap.listeners.after.event_breakpoint["notify_unverified"] = function(_, body)
                if body and body.breakpoint and body.breakpoint.verified == false then
                    local msg = body.breakpoint.message or "invalid breakpoint"
                    vim.notify("Breakpoint rejected: " .. msg, vim.log.levels.WARN)
                end
            end

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
