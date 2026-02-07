-- Highlight when yanking text
-- Try w/ yap in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Rename tmux window to current filename
if vim.env.TMUX then
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
        group = vim.api.nvim_create_augroup("TmuxWindowName", { clear = true }),
        callback = function()
            local name = vim.fn.expand("%:t")
            if name ~= "" then
                vim.fn.system("tmux rename-window " .. vim.fn.shellescape(name))
            end
        end,
    })
    vim.api.nvim_create_autocmd("VimLeave", {
        group = vim.api.nvim_create_augroup("TmuxWindowRestore", { clear = true }),
        callback = function()
            vim.fn.system("tmux set-window-option automatic-rename on")
        end,
    })
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

