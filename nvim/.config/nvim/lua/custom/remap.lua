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
    local path
    if vim.b.netrw_curdir then
        path = vim.b.netrw_curdir
    else
        path = vim.fn.expand("%:p")
        if path == "" then
            path = vim.fn.getcwd()
        end
    end
    vim.fn.setreg("+", path)
end, { desc = "Copy current file/dir path to clipboard" })
