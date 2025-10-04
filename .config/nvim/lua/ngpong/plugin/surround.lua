return {
  "nvim-mini/mini.surround",
  main = "mini.surround",
  lazy = true,
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "fsa",
      delete = "fsd",
      replace = "fsr",
      find = "",
      find_left = "",
      highlight = "",
      update_n_lines = "",

      suffix_last = "",
      suffix_next = "",
    },
    respect_selection_type = true,
    silent = true,
  }
}
