return {
  "saghen/blink.cmp",
  version = "*", -- use prebuilt release binary, no Rust toolchain required
  opts = {
    -- "default" only accepts via <C-y>; super-tab makes <Tab> accept the
    -- selected item (or jump a snippet placeholder if one's active).
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = true } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
}
