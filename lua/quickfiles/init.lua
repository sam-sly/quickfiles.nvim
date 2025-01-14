local M = {}

-- Default options
local default_opts = {
	prompt = {
		show_directory = true,
		max_depth = 1,
	},
	deletion = {
		confirm = true,
		delete_nested_empty_dirs = true,
	},
	keymaps = {
		new_file_at_buffer_dir = "<leader>fn",
		new_file_at_cwd = "<leader>fN",
		delete_file = "<leader>fd",
		delete_file_and_empty_dirs = "<leader>fD",
	},
}

M.opts = default_opts

-- Config function
function M.config(user_opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, user_opts or {})
	require("quickfiles.keymaps").setup(M.opts)
end

-- Setup function
function M.setup(user_opts)
	M.opts = vim.tbl_deep_extend("force", default_opts, user_opts or {})
	require("quickfiles.keymaps").setup(M.opts)
end

-- Export functions for external use
M.new_file_at_buffer_dir = require("quickfiles.creation").new_file_at_buffer_dir
M.new_file_at_cwd = require("quickfiles.creation").new_file_at_cwd
M.delete_file = require("quickfiles.deletion").delete_file
M.delete_file_and_empty_dirs = require("quickfiles.deletion").delete_file_and_empty_dirs

return M
