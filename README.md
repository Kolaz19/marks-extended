# Marks Plus

This is a simple plugin to navigate and set/manipulate local and global (letter) marks.
This plugin should feel like an addon to the builtin marks.

- Navigating marks without remembering their letter
- Set marks without thinking about which marks have already been set
- Having an overview where you can delete marks easily

## Setup

The `setup()` function is currently a no-op and can be omitted.
Set up the plugin with your favorite package manager, for example lazy.
All functions shown here are all the functions that are exposed and can be used.

```lua
	{
		'kolaz19/marks-extended',
		lazy = true,
		opts = {
            -- Keybind to close the delete-mark popup
			keybind_popup_close = '<ESC>',
            -- Keybind to delete a mark shown in the popup
			keybind_popup_delete_mark = '<CR>',
            -- In the popup, global marks show the file where they are set
            -- Local marks do not show the file, a fixed text can be chosen
			popup_current_file_text = 'CURRENT_FILE',
            -- Global marks are always shown on top
            -- Set this option to true if local marks should be displayed on top
			popup_show_local_first = false,
            -- In the popup, marks are sorted alphabetically
            -- Set this option to true if they should be sorted by their line number
			popup_sort_by_line_number = false,
		},
		branch = 'main',
		keys = {
			{ 'mm', '<cmd>:lua require("marks-extended").set_next_local_mark()<cr>' },
			{ 'mM', '<cmd>:lua require("marks-extended").set_next_global_mark()<cr>' },
			{ '<leader>w', '<cmd>:lua require("marks-extended").jump_to_next_global_mark()<cr>' },
			{ '<leader>q', '<cmd>:lua require("marks-extended").jump_to_previous_global_mark()<cr>' },
			{ '<leader>e', '<cmd>:lua require("marks-extended").jump_to_next_local_mark()<cr>' },
			{ '<leader>E', '<cmd>:lua require("marks-extended").jump_to_previous_local_mark()<cr>' },
			{ '<leader>de', '<cmd>:lua require("marks-extended").popup_delete_global_marks()<cr>' },
			{ '<leader>dr', '<cmd>:lua require("marks-extended").popup_delete_local_marks()<cr>' },
			{ '<leader>df', '<cmd>:lua require("marks-extended").popup_delete_all_marks()<cr>' },
		}
	}
```

## Function overview

```lua
    require("marks-extended").jump_to_next_global_mark()
    require("marks-extended").jump_to_previous_global_mark()
    require("marks-extended").jump_to_next_local_mark()
    require("marks-extended").jump_to_previous_local_mark()
```

Jump with your cursor to the next global or local mark that has already been set.

There are a few rules in place to determine the next mark to jump to:

1. Determine the mark on the same line or the nearest mark in the buffer
2. Jump to the next mark in alphabetical order (based on 'next' or 'previous' functions)
3. The jump can loop around to the first mark (forward) or the last mark (backward) if the end of the sequence has been reached
4. If there is no mark in the current buffer, jump to the first or last mark in alphabetical order

```lua
    require("marks-extended").set_next_local_mark()
    require("marks-extended").set_next_global_mark()
```

Set an available mark (determined alphabetically) at the current position.

```lua
    require("marks-extended").popup_delete_global_marks()
    require("marks-extended").popup_delete_local_marks()
    require("marks-extended").popup_delete_all_marks()
```

Open a popup where global/local marks can be deleted.
Marks in the popup are always grouped locally/globally first independent of other sorting options.
Just move the cursor over a mark and press the key designated for `keybind_popup_delete_mark`.
