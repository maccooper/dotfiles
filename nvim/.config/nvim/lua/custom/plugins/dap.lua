return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"
            local dap_go = require "dap-go"

            -- Setup DAP UI and Go
            require("dapui").setup()
            require("dap-go").setup()

            -- Add custom Go configurations after setup
            dap.configurations.go = dap.configurations.go or {}
            table.insert(dap.configurations.go, {
                type = "go",
                name = "Debug API Server",
                request = "launch",
                program = "./cmd/api", --
                args = {},
                cwd = vim.fn.getcwd(), -- Use current directory
            })

            -- Add remote attachment configuration; lets us see our server responses in terminal
            table.insert(dap.configurations.go, {
                type = "go",
                name = "Attach Remote",
                mode = "remote",
                request = "attach",
                host = "127.0.0.1",
                port = "2345",
            })


            -- JavaScript/TypeScript debugging setup (keeping your existing config)
            dap.adapters.node2 = {
                type = "executable",
                command = "node",
                args = {
                    vim.fn.stdpath('data') .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
                },
            }

            local js_config = {
                {
                    type = 'node2',
                    name = 'Attach to Next.js',
                    request = 'attach',
                    processId = require 'dap.utils'.pick_process,
                    cwd = vim.fn.getcwd(),
                    protocol = 'inspector',
                    sourceMaps = true,
                    skipFiles = { '<node_internals>/**' },
                },
            }

            dap.configurations.javascript = js_config
            dap.configurations.typescript = js_config
            dap.configurations.javascriptreact = js_config
            dap.configurations.typescriptreact = js_config

            -- Your existing key mappings (keeping all of them)
            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F13>", dap.restart)

            -- Go-specific debug mappings
            vim.keymap.set("n", "<leader>dgt", function()
                dap_go.debug_test()
            end, { desc = "Debug Go Test" })

            vim.keymap.set("n", "<leader>dgl", function()
                dap_go.debug_last_test()
            end, { desc = "Debug Last Go Test" })

            -- DAP UI auto-open/close
            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
