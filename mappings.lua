local function select_column()
  local col = vim.fn.input "Enter column number to select: "
  -- Check if the input is a number
  if tonumber(col) then
    -- Apply the awk command to select only the specified column
    vim.api.nvim_exec("'<,'>!awk -v col=" .. col .. " '{print $col}'", false)
  else
    print "Invalid column number"
  end
end
vim.api.nvim_create_user_command("SelectCol", select_column, { range = true })

-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    [";"] = { ":" },

    ["<leader>h"] = false, -- Disable default for this mapping
    ["<leader>gj"] = { ":Gitsigns next_hunk<cr>", desc = "Next hunk" },
    ["<leader>gk"] = { ":Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
    ["<leader>ej"] = { "<cmd> lua vim.diagnostic.goto_next()<CR>", desc = "Go to next diagnostic" },
    ["<leader>ek"] = { "<cmd> lua vim.diagnostic.goto_prev()<CR>", desc = "Go to previous diagnostic" },
    ["H"] = { "<cmd>lua require('bufjump').backward()<cr>", desc = "Previous buffer" },
    ["L"] = { "<cmd>lua require('bufjump').forward()<cr>", desc = "Next buffer" },
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "LSP hover" },
    ["<leader>fp"] = {
      "<cmd>lua require( 'telescope.builtin' ).find_files({find_command={'fd', vim.fn.expand('<cword>')}})<cr>",
      desc = "Search for file under cursor",
    },
    ["yp"] = { ":let @+=expand('%:p:.')<cr>", desc = "Yank current buffer path" },
    ["<leader>fg"] = { ":Easypick changed_files<cr>", desc = "Find changed files" },
    ["<leader>f>"] = { ":Easypick conflicts<cr>", desc = "Find files with merge conflicts" },
    ["<leader>a"] = { name = "Assistant" },
    ["<leader>an"] = { "<cmd>GpChatNew<cr>", desc = "New Chat" },
    -- format on leader lf
    ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format buffer" },
    -- ["gf"] = { ":vsplit<cr>gF", desc = "Open file under cursor", noremap = true },
    ["<leader>q"] = {
      "<cmd>execute 'vimgrep /' . @/ . '/ %' | copen<CR>",
      desc = "Populate quickfix with prev. search",
    },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    [";"] = { ":" },
    ["<leader>sc"] = { ":SelectCol<CR>", desc = "Select column" },
    ["<leader>ap"] = { ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual chat paste" },
    ["<leader>ar"] = { ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual chat rewrite" },
  },
}
