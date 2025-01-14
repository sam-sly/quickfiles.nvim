local M = {}

-- Local helper function: Recursively delete directories if they are empty
local function delete_empty_directories(directory)
	local uv = vim.loop
	while directory and directory ~= "" do
		local entries = uv.fs_scandir(directory)
		local is_empty = true
		if entries then
			-- Check if the directory is empty
			local name = uv.fs_scandir_next(entries)
			if name then
				is_empty = false -- Directory is not empty
			end
		end
		if is_empty then
			local success, err = uv.fs_rmdir(directory)
			if not success then
				vim.notify("Failed to delete directory: " .. err, vim.log.levels.ERROR)
				return
			end
			vim.notify("Deleted empty directory: " .. directory, vim.log.levels.INFO)
			directory = vim.fn.fnamemodify(directory, ":h") -- Move up the directory tree
		else
			break -- Stop if the directory is not empty
		end
	end
end

-- Local helper function: Perform the actual file deletion
local function perform_file_deletion(filepath)
	-- Get the current buffer number
	local current_buf = vim.api.nvim_get_current_buf()

	-- Attempt to delete the file
	local success, err = os.remove(filepath)
	if success then
		-- If the file was deleted successfully, switch to another buffer
		local next_buf = vim.fn.bufnr("#") -- Get the alternate buffer
		if next_buf ~= -1 and vim.api.nvim_buf_is_valid(next_buf) then
			vim.cmd("buffer " .. next_buf) -- Switch to the alternate buffer
		else
			vim.cmd("enew") -- Create a new empty buffer if no alternate buffer
		end

		-- Finally, delete the current buffer
		if vim.api.nvim_buf_is_valid(current_buf) then
			vim.cmd("bdelete! " .. current_buf)
		end

		vim.notify("Deleted file: " .. filepath, vim.log.levels.INFO)
	else
		vim.notify("Failed to delete file: " .. err, vim.log.levels.ERROR)
	end
end

-- Local helper function: Perform file and directory deletion
local function perform_file_and_directory_deletion(filepath, dir)
	local opts = require("quickfiles").opts -- Lazy-load config

	-- Delete the file first
	perform_file_deletion(filepath)

	-- Handle empty directory deletion based on the configuration
	if opts.deletion.delete_nested_empty_dirs then
		delete_empty_directories(dir) -- Recursively delete empty directories
	else
		-- Only delete the immediate parent directory if empty
		if vim.fn.isdirectory(dir) == 1 and #vim.fn.glob(dir .. "/*") == 0 then
			local success, err = vim.loop.fs_rmdir(dir)
			if success then
				vim.notify("Deleted empty parent directory: " .. dir, vim.log.levels.INFO)
			else
				vim.notify("Failed to delete directory: " .. err, vim.log.levels.ERROR)
			end
		end
	end
end

-- Delete the current file
function M.delete_file()
	local opts = require("quickfiles").opts -- Lazy-load config
	local filepath = vim.fn.expand("%:p") -- Get the full path of the current file

	if vim.fn.filereadable(filepath) == 0 then
		vim.notify("File does not exist: " .. filepath, vim.log.levels.ERROR)
		return
	end

	if opts.deletion.confirm then
		vim.ui.input({ prompt = "Delete file? (y/n): " }, function(input)
			if input == "y" then
				perform_file_deletion(filepath) -- Only delete the file
			else
				vim.notify("File deletion cancelled", vim.log.levels.WARN)
			end
		end)
	else
		perform_file_deletion(filepath) -- Only delete the file
	end
end

-- Delete the current file and clean up empty directories
function M.delete_file_and_empty_dirs()
	local opts = require("quickfiles").opts -- Lazy-load config
	local filepath = vim.fn.expand("%:p") -- Get the full path of the current file
	local dir = vim.fn.fnamemodify(filepath, ":h") -- Get the file's parent directory

	if vim.fn.filereadable(filepath) == 0 then
		vim.notify("File does not exist: " .. filepath, vim.log.levels.ERROR)
		return
	end

	if opts.deletion.confirm then
		vim.ui.input({ prompt = "Delete file and empty directories? (y/n): " }, function(input)
			if input == "y" then
				perform_file_and_directory_deletion(filepath, dir)
			else
				vim.notify("File deletion cancelled", vim.log.levels.WARN)
			end
		end)
	else
		perform_file_and_directory_deletion(filepath, dir)
	end
end

return M
