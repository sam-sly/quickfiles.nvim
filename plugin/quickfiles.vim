" Automatically load the Lua plugin
lua require("quickfiles").setup()

" Define commands for quickfiles.nvim

" Reload the plugin
command! QuickFilesConfig lua require("quickfiles").setup()

" Create a new file in the buffer's directory
command! QuickFilesNewBufferDir lua require("quickfiles.creation").new_file_at_buffer_dir()

" Create a new file in the current working directory
command! QuickFilesNewCWD lua require("quickfiles.creation").new_file_at_cwd()

" Delete the current file
command! QuickFilesDeleteFile lua require("quickfiles.deletion").delete_file()

" Delete the current file and empty parent directories
command! QuickFilesDeleteFileAndDirs lua require("quickfiles.deletion").delete_file_and_empty_dirs()

