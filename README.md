# Visidf.nvim

Visualize DataFrame and Numpy Array in Neovim.

## Installation

```lua
{
  "hongzio/visidf.nvim",
  dependencies = {
    "mfussenegger/nvim-dap",
    "folke/snacks.nvim",
  },
  opts = {
    vdpath: "/path/to/vd"
  },
  keys = {
    {
      "<leader>dv",
      function()
        require("visidf").run()
      end,
      desc = "Visualize data",
      mode = { "v" },
    },
    {
      "<leader>dV",
      function()
        require("visidf").prev()
      end,
      desc = "Visualize previous data",
      mode = { "n" },
    },
  }
}
```
