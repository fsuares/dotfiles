return {
	"datsfilipe/min-theme.nvim",
	lazy = false,
	name = "min-theme",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("min-theme")
	end
}
