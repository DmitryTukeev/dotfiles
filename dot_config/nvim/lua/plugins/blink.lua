return {
  {
    "saghen/blink.cmp",
    optional = true, -- Ensures this config merges with LazyVim's default
    opts = {
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },
    },
  },
}
