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
`:TREPLSendLineStatement`. If you want to run the whole statement, use `:TREPLSendContextStatement`.

From lua, these commands are also availabled from `require("repl_region").send_repl_statement("line")` and `require("repl_region").send_repl_statement("global")`.

These commands run the code, and set cursor one line below the region runned (like in RStudio).

## Example

```py
def my_function():
  for i in range(5): # << cursor here
      if i%2 == 0:
        print(i)
```

- `:TREPLSendLineStatement` will run the for loop, and will place the cursor under the `print`.
- `:TREPLSendContextStatement` will run the whole function, and will place the cursor under the `print`.

---

```py
def my_function():
  for i in range(5):
      if i%2 == 0:   # << cursor here
        print(i)
```

- `:TREPLSendLineStatement` will run the if statement, and will place the cursor under the `print`.
- `:TREPLSendContextStatement` will run the whole function and will place the cursor under `print`.

---

Tested with Python, R, nodeJS.
