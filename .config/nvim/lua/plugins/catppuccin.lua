return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "macchiato",
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          CursorLineNr = { fg = colors.rosewater },
          CursorLine = { bg = colors.none },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
