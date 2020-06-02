local lsp = require'nvim_lsp'

local M = {}

local function lsp_test_and_load(lserver, settings)
    local found = false

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
            settings = settings,
        }
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
    lsp_test_and_load('tsserver')
    lsp_test_and_load('vimls')
end

return M
