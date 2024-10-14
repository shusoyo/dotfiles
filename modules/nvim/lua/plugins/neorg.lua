return {
  "nvim-neorg/neorg",
  enabled = false,
  event = "VeryLazy", -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "/Users/epoche/notes/",
          },
          default_workspace = "notes",
        },
      },
    },
  },
}
