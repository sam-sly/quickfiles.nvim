local M = {}

local input = require("quickfiles.input")
local prompts = require("quickfiles.prompts")

-- Ensure that a directory exists, creating parent directories if necessary
local function ensure_directory_exists(dir)
	local uv = vim.loop
	local stat = uv.fs_stat(dir)

	if not stat then
		local parent_dir = vim.fn.fnamemodify(dir, ":h")
		if parent_dir ~= dir then
			if not ensure_directory_exists(parent_dir) then
				return false
			end
		end

		local success, err = uv.fs_mkdir(dir, 511) -- 0777 permissions
		if not success then
			vim.notify("Failed to create directory: " .. err, vim.log.levels.ERROR)
			return false
		end
	end

	return true
end

-- Core function for creating a new file
local function create_new_file(base_path)
	local original_cwd = vim.fn.getcwd() -- Save the original cwd
	vim.fn.chdir(base_path) -- Temporarily set cwd for autocompletion

	local prompt = prompts.get_prompt(base_path, base_path == original_cwd)
	input.input(prompt, function(file_name)
		vim.fn.chdir(original_cwd) -- Restore the original cwd

		if file_name and file_name ~= "" then
			if file_name:match('[:*?"<>|]') then
				vim.notify("Invalid filename: " .. file_name, vim.log.levels.ERROR)
				return
			end

			local new_filepath = vim.fn.fnamemodify(base_path .. "/" .. file_name, ":p")
			local dir = vim.fn.fnamemodify(new_filepath, ":h")

			if not ensure_directory_exists(dir) then
				return
			end

			local fd = vim.loop.fs_open(new_filepath, "w", 420) -- 0644 permissions
			if fd then
				vim.loop.fs_close(fd)
				vim.cmd("edit " .. new_filepath)
				vim.notify("Created and opened file: " .. new_filepath, vim.log.levels.INFO)
			else
				vim.notify("Failed to create file: " .. new_filepath, vim.log.levels.ERROR)
			end
		else
			vim.notify("New file creation cancelled", vim.log.levels.WARN)
		end
	end)
end

-- Create a new file in the buffer's directory
function M.new_file_at_buffer_dir()
	local base_path = vim.fn.expand("%:p:h")
	create_new_file(base_path)
end

-- Create a new file in the current working directory
function M.new_file_at_cwd()
	local base_path = vim.fn.getcwd()
	create_new_file(base_path)
end

return M
