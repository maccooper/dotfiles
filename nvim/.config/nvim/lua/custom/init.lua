-- order of imports matters, leader import must happen before it is consumed
require("custom.remap")
require("custom.netrw")
require("custom.autocmds")
require("custom.copilot")
require("custom.options")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
    change_detection = {
        notify = false,
    },
    checker = {
        enabled = true,
        notify = false, -- get notified when new versions of plugins are available
        frequency = 3600, -- check for new versions every hour
    },
})

vim.g.mapleader = " "
vim.o.timeoutlen = 300
