# Visidf.nvim

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
    "<leader>dv",
    function()
      require("visidf").run()
    end,
    desc = "Visualize DataFrame",
    mode = { "v" },
  },
}
```
