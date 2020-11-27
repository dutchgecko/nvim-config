local lsp = require'lspconfig'

local M = {}

local lsp_loaded_tbl = {}

local function on_attach_vim()
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

local function lsp_test_and_load(lserver, settings)
    local found = false

    if lsp_loaded_tbl[lserver] == nil then
        lsp_loaded_tbl[lserver] = false
    end

    if lsp[lserver].install_info ~= nil
        and lsp[lserver].install_info().binaries ~= nil
    then
        local binaries = lsp[lserver].install_info().binaries

        for bin, binpath in pairs(binaries) do
            if
                vim.fn.executable(binpath) ~= 0
                or vim.fn.executable(bin) ~= 0
            then
                found = true
                break
            end
        end
    end

    if found or (
            lsp[lserver].document_config.default_config.cmd ~= nil and
            vim.fn.executable(lsp[lserver].document_config.default_config.cmd[1]) ~= 0
        ) or (
            lsp[lserver].install_info ~= nil
            and lsp[lserver].install_info().is_installed == true
        )
    then
        lsp[lserver].setup{
            on_attach=on_attach_vim,
            settings = settings,
        }
        lsp_loaded_tbl[lserver] = true
    end
end

--------------------------------------------------------------------------------
-- python settings
-- local python_settings =

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

--------------------------------------------------------------------------------

function M.do_setup()
    lsp_test_and_load('bashls')
    lsp_test_and_load('clangd')
    lsp_test_and_load('cssls')
    lsp_test_and_load('dockerls')
    lsp_test_and_load('html')
    lsp_test_and_load('pyls')
    lsp_test_and_load('rust_analyzer')
    lsp_test_and_load('sumneko_lua', lua_settings)
    lsp_test_and_load('texlab')
    lsp_test_and_load('tsserver')
    lsp_test_and_load('vimls')
end


function M.setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            virtual_text = {
                prefix = '',
            },
        }
    )
end

return M
