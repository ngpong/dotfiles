return {
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        ui_select = true,
        layouts = {
          select = {
            layout = {
              border = vim.__icons.border.no_but_title_slim,
              backdrop = false,
              width = 0.45,
              min_width = 50,
              height = 0.4,
              min_height = 3,
            }
          }
        },
      },
    }
  },
}
