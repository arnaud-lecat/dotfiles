return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettier" },
        python = { "ruff_format" },
      },
      -- ensure conform takes over, not LSP
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback", -- only use LSP if no conform formatter
      },
    },
  },
}
