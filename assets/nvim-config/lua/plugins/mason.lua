return {
  "mason-org/mason.nvim",
  keys = {
    { "<leader>cm", false },
  },
  opts = {
    ensure_installed = {
      "html-lsp",
      "prettier",
      "pyright",
      "autopep8",
    },
    http_proxy = "http://127.0.0.1:7897",
    https_proxy = "http://127.0.0.1:7897",
  },
}
