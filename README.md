# Marks Extended

This is a simple plugin to navigate and set local and global marks.

## Setup

The `setup()` function is currently a no-op and can be omitted.
Setup plugin with your favorite package manager, for example lazy.
All functions shown here are all functions that are exposed and can be used.

```lua
	{
		'kolaz19/marks-extended',
		lazy = true,
		config = true,
		keys = {
			{ 'mm', '<cmd>:lua require("marks-extended").set_next_local_mark()<cr>' },
			{ 'mM', '<cmd>:lua require("marks-extended").set_next_global_mark()<cr>' },
			{ '<leader>w', '<cmd>:lua require("marks-extended").jump_to_next_global_mark()<cr>' },
			{ '<leader>q', '<cmd>:lua require("marks-extended").jump_to_previous_global_mark()<cr>' },
			{ '<leader>e', '<cmd>:lua require("marks-extended").jump_to_next_local_mark()<cr>' },
			{ '<leader>E', '<cmd>:lua require("marks-extended").jump_to_previous_local_mark()<cr>' },
		}
	}
```

## Explanation

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
