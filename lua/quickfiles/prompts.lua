local M = {}

function M.get_prompt(base_path, is_project_root)
	local opts = require("quickfiles").opts

	-- Check if the directory name should be shown
	if opts.prompt.show_directory then
		local path = base_path
		local segments = {}
		for _ = 1, opts.prompt.max_depth do
			table.insert(segments, 1, vim.fn.fnamemodify(path, ":t")) -- Insert the last segment
			path = vim.fn.fnamemodify(path, ":h") -- Move up one level
			if path == "/" or path == "" then
				break -- Stop at the root
			end
		end

		local dir_path = table.concat(segments, "/")
		if dir_path and dir_path ~= "" then
			return "New file in " .. dir_path .. "/: "
		end
	end

	-- Fallback based on the boolean
	if is_project_root then
		return "New file in Project Root: "
	else
		return "New file in Buffer Directory: "
	end
end

return M
