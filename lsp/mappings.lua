return {
  n = {
    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references {
          include_declaration = false,
          show_line = false,
        }
      end,
      desc = "LSP References",
    },
  },
}
