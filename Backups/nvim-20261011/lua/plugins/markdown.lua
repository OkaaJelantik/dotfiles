vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		require("render-markdown").setup({
			preset = "obsidian",
		})
	end,
})
