local M = {}

local snacks_available, snacks = pcall(require, "snacks.input")

function M.input(prompt, callback)
	if snacks_available then
		snacks.input({ prompt = prompt, completion = "file" }, callback)
	else
		vim.ui.input({ prompt = prompt }, callback)
	end
end

return M
