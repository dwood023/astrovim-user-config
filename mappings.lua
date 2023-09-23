-- Mapping data with "desc" stored directly by vim.keymap.set().
--
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
    ["<leader>hj"] = { ":Gitsigns next_hunk<cr>", desc = "Next hunk" },
    ["<leader>hk"] = { ":Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
    ["<leader>ej"] = { "<cmd> lua vim.diagnostic.goto_next()<CR>", desc = "Go to next diagnostic" },
    ["<leader>ek"] = { "<cmd> lua vim.diagnostic.goto_prev()<CR>", desc = "Go to previous diagnostic" },
    ["H"] = { "<cmd>lua require('bufjump').backward()<cr>", desc = "Previous buffer" },
    ["L"] = { "<cmd>lua require('bufjump').forward()<cr>", desc = "Next buffer" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
