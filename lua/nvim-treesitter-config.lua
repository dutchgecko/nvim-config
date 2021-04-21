-- local ts = require'nvim-treesitter'
local configs = require'nvim-treesitter.configs'

configs.setup {
    ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "clojure",
        "cpp",
        "css",
        "dart",
        "fennel",
        "go",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "julia",
        "kotlin",
        "lua",
        "php",
        "python",
        "ql",
        "query",
        "r",
        "regex",
        "rst",
        "rust",
        "toml",
        "typescript",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = {"python",},
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
}
