vim.pack.add({
	"https://github.com/obsidian-nvim/obsidian.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

local function get_notes_path()
	local home = os.getenv("HOME")
	local candidates = {
		home .. "/Documents/Notes",
		home .. "/Notes",
	}
	for _, p in ipairs(candidates) do
		if vim.fn.isdirectory(p) == 1 then
			return p
		end
	end
	error("Notes directory not found")
end

local function setup_obsidian()
	require("obsidian").setup({
		legacy_commands = false,
		workspaces = { { name = "Notes", path = get_notes_path() } },
		picker = { name = "fzf-lua" },
	})

	vim.keymap.set("n", "<leader>nn", function()
		vim.cmd("Obsidian workspace")
		vim.defer_fn(function()
			vim.cmd("Obsidian new")
		end, 500)
	end, { desc = "New note" })
	vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
	vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
	vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" })
	vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })
end

setup_obsidian()

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		require("render-markdown").setup({
			preset = "obsidian",
		})
	end,
})
