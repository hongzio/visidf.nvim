# Visidf.nvim

Visualize DataFrame and Numpy Array in Neovim.

## Requirements

- [visidata](https://www.visidata.org/)

## Installation

```lua
{
  "hongzio/visidf.nvim",
  dependencies = {
    "mfussenegger/nvim-dap",
    "folke/snacks.nvim",
  },
  opts = {
    vdpath: "/path/to/vd" -- default: "vd"
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

## Usage

In debug mode, first select the data you want to visualize. Then, you can
visualize data by calling `require("visidf").run()` (or `<leader>dv` if the
keybinding is set). To visualize the previous data, call
`require("visidf").prev()` (or `<leader>dV` if the keybinding is set).


## Caveats

It creates `.visidf` file in the current working directory to store the data. Be aware of the size of the data you are visualizing, as it might be slow or crash if the data is too large.

