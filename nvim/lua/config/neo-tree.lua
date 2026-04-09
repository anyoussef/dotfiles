require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      visible = true, -- show dotfiles
      hide_gitignored = false, -- show gitignored files
      hide_by_name = {}, -- optional: files to always hide
      never_show = {}, -- optional: files never to show
    },
    follow_current_file = true, -- optional: follow open file
    group_empty_dirs = true, -- optional: collapse empty dirs
  },
})
