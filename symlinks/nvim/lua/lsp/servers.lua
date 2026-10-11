vim.pack.add({
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/creativenull/efmls-configs-nvim",
	"https://github.com/mrcjkb/rustaceanvim",
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config["*"] = { capabilities = capabilities }

local servers = {
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"tailwindcss",
	"html",
	"cssls",
	"emmet_language_server",
	"intelephense",
	"dockerls",
	"docker_compose_language_service",
	"gopls",
	"clangd",
}

for _, server in ipairs(servers) do
	vim.lsp.config(server, {})
end

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

vim.g.rustaceanvim = {
	server = { capabilities = capabilities },
}

vim.lsp.enable(servers)
