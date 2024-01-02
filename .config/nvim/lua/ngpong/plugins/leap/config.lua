local M = {}

M.setup = function()
  require('leap').setup {
    case_sensitive = false,
    highlight_unlabeled_phase_one_targets = true,
    max_highlighted_traversal_targets = 10,
    equivalence_classes = { ' \t\r\n' },
    substitute_chars = { ['\r'] = '¬' },
    safe_labels = {},
    special_keys = {
      next_target = '',
      prev_target = '',
      next_group = '',
      prev_group = '',
      multi_accept = '',
      multi_revert = '',
    }
  }
end

return M