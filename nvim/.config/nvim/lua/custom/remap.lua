vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<C-j>", "<C-d>")
vim.keymap.set("n", "<C-k>", "<C-u>")

vim.keymap.set("n", "<C-w>b", "<C-w><C-s>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "vv", "<C-w>v")

vim.keymap.set("n", "<leader>r", "<cmd>edit<CR>", { desc = "Reload file from disk" })
vim.keymap.set("n", "<leader>wd", function()
    local path = vim.fn.expand("%:p")
    if path == "" or vim.fn.isdirectory(path) == 1 then
        path = vim.fn.getcwd()
    end
    vim.fn.setreg("+", path)
end, { desc = "Copy current file/dir path to clipboard" })
