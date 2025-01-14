local M = {}

-- Setup keymaps
function M.setup(opts)
	local map = vim.keymap.set
	local keys = opts.keymaps

	if keys.new_file_at_buffer_dir then
		map("n", keys.new_file_at_buffer_dir, function()
			require("quickfiles.creation").new_file_at_buffer_dir()
		end, { desc = "New File in Buffer Directory" })
	end

	if keys.new_file_at_cwd then
		map("n", keys.new_file_at_cwd, function()
			require("quickfiles.creation").new_file_at_cwd()
		end, { desc = "New File in Current Working Directory" })
	end

	if keys.delete_file then
		map("n", keys.delete_file, function()
			require("quickfiles.deletion").delete_file()
		end, { desc = "Delete Current File" })
	end

	if keys.delete_file_and_empty_dirs then
		map("n", keys.delete_file_and_empty_dirs, function()
			require("quickfiles.deletion").delete_file_and_empty_dirs()
		end, { desc = "Delete File and Empty Directories" })
	end
end

return M
