require("mason").setup()
require("mason-lspconfig").setup()

local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset('recommended')

lsp.ensure_installed({
    'cssls',
    'gopls',
    'html',
    'jinja_lsp',
    'jsonls',
    'lua_ls',
    'ruff',
    'rust_analyzer',
    'sqls',
    'ts_ls'
})

lsp.nvim_workspace()

local cmp = require('cmp')

local select = {
    behavior = cmp.SelectBehavior.Select
}

local mapping = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(select),
    ['<C-n>'] = cmp.mapping.select_next_item(select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = mapping
})

lsp.set_sign_icons({
    error = '●',
    warn = '●',
    hint = '●',
    info = '●'
})

lsp.set_preferences({
    suggest_lsp_servers = false
})

lsp.on_attach(function(client, buffer)
    local opts = {buffer = buffer, remap = false}

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<Leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<Leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<Leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<Leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<Leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)

    client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            underline = false,
            signs = true,
            update_in_insert = false,
        }
    )
end)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

lspconfig.ruff.setup({
})

lsp.setup()
