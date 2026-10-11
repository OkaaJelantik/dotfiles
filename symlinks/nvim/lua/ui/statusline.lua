vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	options = {
		theme = "melange",
		icons_enabled = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = false,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch", icon = "\u{e725}" } },
		lualine_c = { { "filename", path = 0 } },
		lualine_x = {
			function()
				local size = vim.fn.getfsize(vim.fn.expand("%"))
				if size < 0 then
					return ""
				elseif size < 1024 then
					return size .. "B"
				elseif size < 1024 * 1024 then
					return string.format("%.1fK", size / 1024)
				else
					return string.format("%.1fM", size / 1024 / 1024)
				end
			end,
			{ "filetype", icon_only = false },
		},
		lualine_y = { "location" },
		lualine_z = { "progress" },
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 0 } },
		lualine_x = { "filetype" },
	},
})
