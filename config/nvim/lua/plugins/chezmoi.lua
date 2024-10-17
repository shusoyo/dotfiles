return {
  "xvzc/chezmoi.nvim",
  enabled = false,
  keys = {
    {
      "<leader>fd",
      function()
        require("telescope.builtin").find_files({ cwd = "~/.local/share/chezmoi/" })
      end,
      mode = { "n", "v" },
      desc = "Dotfiles",
    },
  },
  opts = {
    edit = {
      watch = false,
      force = false,
    },
    notification = {
      on_open = true,
      on_apply = true,
      on_watch = false,
    },
    telescope = {
      select = { "<CR>" },
    },
  },
}
