require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "denols", "pyright", "jdtls", "arduino-language-server", }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
