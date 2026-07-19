return {
  "saghen/blink.cmp",
  version = "*", -- use prebuilt release binary, no Rust toolchain required
  opts = {
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = true } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
}
