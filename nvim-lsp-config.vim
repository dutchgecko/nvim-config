if exists("g:loaded_lsp_config")
    finish
endif
let g:loaded_lsp_config = 1

function LspLoadPlugins()
    lua << EOF
    local lsp = require'nvim_lsp'

    if lsp_loaded_tbl == nil then
        lsp_loaded_tbl = {}
    end

    function lsp_is_loaded(lserver)
        return lsp_loaded_tbl[lserver]
    end

    function lsp_test_and_load(lserver)

        if lsp_loaded_tbl[lserver] == nil then
            lsp_loaded_tbl[lserver] = false
        end

        if lsp[lserver].install_info ~= nil then
            local binaries = lsp[lserver].install_info().binaries
            local found = false

            for bin, binpath in pairs(binaries) do
                if 
                    vim.fn.executable(binpath) ~= 0
                    or vim.fn.executable(bin) ~= 0
                then
                    found = true
                    break
                end
            end

            if found then
                lsp[lserver].setup{}
                lsp_loaded_tbl[lserver] = true
            end
        else
            if vim.fn.executable(lsp[lserver].document_config.default_config.cmd[1]) ~= 0 then
                lsp[lserver].setup{}
                lsp_loaded_tbl[lserver] = true
            end
        end
    end

    lsp_test_and_load('bashls')
    lsp_test_and_load('clangd')
    lsp_test_and_load('cssls')
    lsp_test_and_load('dockerls')
    lsp_test_and_load('html')
    lsp_test_and_load('pyls')
    lsp_test_and_load('rust_analyzer')
    lsp_test_and_load('tsserver')
    lsp_test_and_load('vimls')
EOF
endfunction

call LspLoadPlugins()

command LspActive lua print(vim.lsp.buf.server_ready())
command LspClientInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))

" Set up bindings and omnicomplete when available
augroup lspconfig
    autocmd!
augroup END

let s:filetype_ls_map = {
            \ 'sh': 'bashls',
            \ 'c': 'clangd',
            \ 'cpp': 'clangd',
            \ 'objc': 'clangd',
            \ 'objcpp': 'clangd',
            \ 'css': 'cssls',
            \ 'Dockerfile': 'dockerls',
            \ 'html': 'html',
            \ 'python': 'pyls',
            \ 'rust': 'rust_analyzer',
            \ 'javascript': 'tsserver',
            \ 'javascriptreact': 'tsserver',
            \ 'javascript.jsx': 'tsserver',
            \ 'typescript': 'tsserver',
            \ 'typescriptreact': 'tsserver',
            \ 'typescript.tsx': 'tsserver',
            \ 'vim': 'vimls',
            \}

function s:setup_lsp_for_buffer()
    lua << EOF
        local timer = vim.loop.new_timer()
        local timer_count = 0
        local max_loops = 5
        timer:start(1000, 1000, vim.schedule_wrap(function()
            if vim.lsp.buf.server_ready() then

                vim.api.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')

                local capabilities = vim.lsp.buf_get_clients()[1].resolved_capabilities
                local function create_mapping(keys, funcname)
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
                    create_mapping('gd', 'declaration')
                end
                if capabilities.goto_definition then
                    create_mapping('<C-]>', 'definition')
                end
                if capabilities.document_symbol then
                    create_mapping('g0', 'document_symbol')
                end
                if capabilities.hover then
                    create_mapping('K', 'hover')
                end
                if capabilities.implementation then
                    create_mapping('gD', 'implementation')
                end
                if capabilities.find_references then
                    create_mapping('gr', 'references')
                end
                if capabilities.signature_help then
                    create_mapping('<C-k>', 'signature_help')
                end
                if capabilities.type_definition then
                    create_mapping('1gD', 'type_definition')
                end
                if capabilities.workspace_symbol then
                    create_mapping('gW', 'workspace_symbol')
                end
                
                timer:close()
            else
                timer_count = timer_count + 1
                if timer_count > max_loops then
                    timer:close()
                    print("Couldn't load language server")
                end
            end
        end))

EOF

endfunction

autocmd lspconfig Filetype sh,
                            \c,cpp,objc,objcpp,
                            \css,
                            \Dockerfile,
                            \html,
                            \python,
                            \rust,
                            \javascript*,typescript*,
                            \vim
                            \ call s:setup_lsp_for_buffer()
