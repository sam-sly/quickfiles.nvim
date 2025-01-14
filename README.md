# quickfiles.nvim

A fast and lightweight Neovim plugin for managing files without the need for a file explorer. Create, delete, and manage files and directories efficiently, with or without path autocompletion support.

## ✨ Features

- **Create new files** in the current buffer's directory or the current working directory.
- **Delete files** with optional confirmation.
- **Optionally delete empty directories recursively** after file deletion. This feature applies only to the `:QuickFilesDeleteFileAndEmptyDirs` command/keymap.
- **Customizable prompts** for displaying directory names.
- **Optional path autocompletion** support via [snacks.nvim](https://github.com/folke/snacks.nvim).
- **Keymap support** for fast file management.

## 🚀 Installation

Install using your favorite plugin manager.

- [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "sam-sly/quickfiles.nvim" }
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use "sam-sly/quickfiles.nvim"
```

This will load the plugin with its default configuration.

> **Note:** The plugin optionally supports path autocompletion if you have [snacks.nvim](https://github.com/folke/snacks.nvim) installed. Snacks is not a strict dependency and doesn't need to be listed explicitly when using a plugin manager like `lazy.nvim`.

## ⚙️ Configuration

Below is the default configuration:

```lua
require("quickfiles").setup({
  prompt = {
    -- Whether to display the directory name in the prompt.
    show_directory = true,

    -- The number of directory levels to show in the prompt.
    depth = 1,
  },
  deletion = {
    -- Whether to prompt for confirmation before deleting files.
    confirm = true,

    -- If true, recursively deletes empty directories after file deletion.
    -- This applies only to the `:QuickFilesDeleteFileAndEmptyDirs` command/keymap.
    delete_nested_empty_dirs = true,
  },
  keymaps = {
    -- Keymap to create a new file in the current buffer's directory.
    new_file_at_buffer_dir = "<leader>fn",

    -- Keymap to create a new file in the current working directory.
    new_file_at_cwd = "<leader>fN",

    -- Keymap to delete the current file.
    delete_file = "<leader>fd",

    -- Keymap to delete the current file and recursively delete empty directories.
    delete_file_and_empty_dirs = "<leader>fD",
  },
})
```

To override any of the above options, pass them as a table to the `opts` field in [lazy.nvim](https://github.com/folke/lazy.nvim) or directly to the `setup()` function in your Neovim config.

## 🛠 Usage

The plugin provides the following Vim commands and Lua functions:

- **`:QuickFilesNewFileAtBufferDir`**

  Create a new file in the current buffer's directory.

  - Lua: `require('quickfiles').new_file_at_buffer_dir()`

- **`:QuickFilesNewFileAtCwd`**

  Create a new file in the current working directory.

  - Lua: `require('quickfiles').new_file_at_cwd()`

- **`:QuickFilesDeleteFile`**

  Delete the current file.

  - Lua: `require('quickfiles').delete_file()`

- **`:QuickFilesDeleteFileAndEmptyDirs`**

  Delete the current file and recursively delete any empty parent directories.

  - Lua: `require('quickfiles').delete_file_and_empty_dirs()`

## ✨ Optional Features

### Snacks.nvim Integration

If [snacks.nvim](https://github.com/folke/snacks.nvim) is installed, `quickfiles.nvim` will use its `snacks.input` for better autocompletion of file paths in the prompt. This provides a smoother user experience but is entirely optional. If `snacks.nvim` is not installed, the plugin will fall back to Neovim's built-in `vim.ui.input`.

## 📜 License

This plugin is licensed under the MIT License. See [LICENSE](./LICENSE) for more details.
