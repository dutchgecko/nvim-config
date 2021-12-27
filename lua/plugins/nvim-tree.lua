local nvim_tree = require'nvim-tree'

nvim_tree.setup {
    update_focused_file = {
        enable = true,
    },
    disable_netrw = true,
    view = {
        width = 45,
        height = 30,
        side = 'left',
        auto_resize = true,
        number = false,
        relativenumber = false,
        signcolumn = "no",
    },
    filters = {
        dotfiles = false,
        custom = {
            ".git",
            "node_modules",
            ".cache",
            "__pycache__",
            ".mypy_cache",
            ".pytest_cache",
        },
    },
}
