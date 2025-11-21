
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {
    at_edge = "wrap",
  },
  keys = {
    {"<C-h>", "<cmd>SmartCursorMoveLeft<CR>", { desc = "Move to left window" }},
    {"<C-j>", "<cmd>SmartCursorMoveDown<CR>", { desc = "Move to down window" }},
    {"<C-k>", "<cmd>SmartCursorMoveUp<CR>", { desc = "Move to up window" }},
    {"<C-l>", "<cmd>SmartCursorMoveRight<CR>", { desc = "Move to right window" }},
  },
  config = function(_, opts)

    -- resize window
    vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left, { desc = "smart resize left" })
    vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down, { desc = "smart resize down" })
    vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up, { desc = "smart resize up" })
    vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right, { desc = "smart resize right" })
    require("smart-splits").setup(opts)
  end,
}
