return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    enable = false,
    opts = {
        ensure_installed = { "vimdoc", "javascript", "typescript", "lua", "go" },
        sync_install = true,
        auto_install = false,
        highlight = {
            enable = false,
            additional_vim_regex_highlighting = false,
        },
    },
}
