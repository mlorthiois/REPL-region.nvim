# REPL-region.nvim

This Neovim plugin lets you send the statement region code in a REPL. It's based on [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
and [neoterm](https://github.com/kassio/neoterm).

## Usage

To use with the packer plugin manager, enter in your config file:

```lua
use({
  "mlorthiois/repl-region.nvim",
  requires = {
    "nvim-treesitter/nvim-treesitter",
    "kassio/neoterm"
  },
})
```

Then, place your cursor on the line containing the statement you want to run, and use command
`:TREPLSendRegion`.

This command run the code, and set cursor one line below the region runned (like in RStudio).

## Example

```py
def my_function():
  for i in range(5):
      if i%2 == 0:
        print(i)
```

If your cursor is on:

- the first line, the whole function will be runned.
- the second line, the whole for statement will be runned.
- the third line, the if statement
- the fourth line, the print function.

Tested with Python, R, nodeJS.
