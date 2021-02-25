local lsp = require 'lspconfig'
local lsp_status = require 'lsp-status'

local M = {}

-- lsp_status setup
local kind_labels_mt = {__index = function(_, k) return k end}
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

lsp_status.register_progress()
lsp_status.config({
    kind_labels = kind_labels,
    indicator_errors = "",
    indicator_warnings = "",
    indicator_info = "",
    indicator_hint = "ﯟ",
    indicator_ok = "",
    status_symbol = "",
})

local function on_attach(client, buffer)
    -- custom on_attach calls

    require('lspkind').init({
        with_text = false,
    })

    lsp_status.on_attach(client, buffer)

    local capabilities = vim.lsp.buf_get_clients()[
            next(vim.lsp.buf_get_clients())
        ].resolved_capabilities
    local function create_conditional_map(keys, funcname)
        vim.api.nvim_command(
            'nnoremap <silent> <buffer> '
            .. keys
            .. ' <cmd>lua '
            .. 'vim.lsp.buf.'
            .. funcname
            .. '()<CR>'
        )
    end

    if capabilities.declaration then
        create_conditional_map('gd', 'declaration')
    elseif capabilities.goto_definition then
        create_conditional_map('gd', 'definition')
    end
    if capabilities.document_symbol then
        create_conditional_map('g0', 'document_symbol')
    end
    if capabilities.hover then
        create_conditional_map('K', 'hover')
    end
    if capabilities.implementation then
        create_conditional_map('gD', 'implementation')
    end
    if capabilities.find_references then
        create_conditional_map('gr', 'references')
    end
    if capabilities.signature_help then
        create_conditional_map('<C-k>', 'signature_help')
    end
    if capabilities.type_definition then
        create_conditional_map('1gD', 'type_definition')
    end
    if capabilities.workspace_symbol then
        create_conditional_map('gW', 'workspace_symbol')
    end

    if capabilities.document_range_formatting then
        vim.api.nvim_command(
            'command! -range=% -buffer LspFormat '
            .. 'lua vim.lsp.buf.range_formatting('
            .. '{}, {<line1>, 1}, {<line2>, 1}'
            .. ')'
        )
    elseif capabilities.document_formatting then
        vim.api.nvim_command(
            'command! -buffer LspFormat '
            .. 'lua vim.lsp.buf.formatting()'
        )
    end
end

local function lsp_test_and_load(lserver, settings, cmd)
    local top_cmd = nil
    if cmd ~= nil
    then
        top_cmd = cmd
    else
        top_cmd = lsp[lserver].document_config.default_config.cmd
    end

    if top_cmd ~= nil and vim.fn.executable(top_cmd[1]) ~= 0
    then
        lsp[lserver].setup{
            cmd=top_cmd,
            on_attach=on_attach,
            settings = settings,
            capabilities = vim.tbl_extend("keep", lsp[lserver].capabilities or {}, lsp_status.capabilities),
        }
    end
end

--------------------------------------------------------------------------------
-- python settings
local python_settings = {
    pyls = {
        plugins = {
            yapf = {
                enabled = false,
            },
            autopep8 = {
                enabled = false,
            },
        },
    },
}

-- lua settings
local lua_settings = {
    Lua = {
        diagnostics = {
            globals = {"vim"},
        },
        runtime = {
            version = "Lua 5.1",
        }
    }
}
local function get_lua_cmd()
    local sumneko_root_path = vim.fn.expand('~/build/lua-language-server')
    return {
        sumneko_root_path..'/bin/Linux/lua-language-server',
        '-E',
        sumneko_root_path..'/main.lua'
    }
end

--------------------------------------------------------------------------------

function M.do_setup()
    lsp_test_and_load('bashls')                                     -- npm install -g bash-language-server
    lsp_test_and_load('clangd')                                     -- sudo apt install clangd
    lsp_test_and_load('cmake')                                      -- pip install --upgrade cmake-language-server
    lsp_test_and_load('cssls')                                      -- npm install -g vscode-css-languageserver-bin
    lsp_test_and_load('dockerls')                                   -- npm install -g dockerfile-language-server-nodejs
    lsp_test_and_load('html')                                       -- npm install -g vscode-html-languageserver-bin
    lsp_test_and_load('intelephense')                               -- PHP -- npm install -g intelephense
    lsp_test_and_load('jsonls')                                     -- npm install -g vscode-json-languageserver
    lsp_test_and_load('pyls', python_settings)                      -- pip install --upgrade python-language-server
    lsp_test_and_load('rust_analyzer')                              -- https://github.com/rust-analyzer/rust-analyzer/releases
    lsp_test_and_load('sqlls')                                      -- npm install -g sql-language-server
    lsp_test_and_load('sumneko_lua', lua_settings, get_lua_cmd())   -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
    lsp_test_and_load('texlab')                                     -- cargo install --git https://github.com/latex-lsp/texlab.git
    lsp_test_and_load('tsserver')                                   -- npm install -g typescript typescript-language-server
    lsp_test_and_load('vimls')                                      -- npm install -g vim-language-server
    lsp_test_and_load('yamlls')                                     -- npm install -g yaml-language-server
end


function M.setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            signs = true,
            update_in_insert = true,
            virtual_text = {
                prefix = '',
            },
        }
    )
end

return M
