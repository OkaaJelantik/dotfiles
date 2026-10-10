vim.pack.add({
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/creativenull/efmls-configs-nvim",
	"https://github.com/mrcjkb/rustaceanvim",
})

-- ============================================================================
-- LSP Keymaps & Attach Autocmd
-- ============================================================================
local lsp_augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Keymaps LSP Standard & fzf-lua
	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)
	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	-- Format & Organize Imports
	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end

	-- Format-on-save (Memanggil LSP active / treefmt)
	if client:supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = lsp_augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lsp_augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false, bufnr = bufnr })
			end,
		})
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = lsp_augroup, callback = lsp_on_attach })

-- ============================================================================
-- Native LSP Setup
-- ============================================================================
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config["*"] = { capabilities = capabilities }

-- Map from LSP server name to binary name; only enable servers whose
-- binary is present in PATH. nil_ls -> "nil" is intentional.
local servers = {
	lua_ls = "lua-language-server",
	pyright = "pyright",
	nil_ls = "nil",
}

-- Set all server-specific configs first, then enable those present in PATH
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

for server, binary in pairs(servers) do
	if vim.fn.executable(binary) == 1 then
		vim.lsp.enable(server)
	end
end

-- Rustaceanvim Integration
vim.g.rustaceanvim = {
	server = { capabilities = capabilities },
}
