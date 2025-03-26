return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "kwkarlwang/bufjump.nvim",
    event = "VeryLazy",
    config = function() require("bufjump").setup() end,
  },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function() require("neoscroll").setup {} end,
  },
  {
    "axkirillov/easypick.nvim",
    event = "VeryLazy",
    config = function()
      local base_branch = "master"
      local easypick = require "easypick"
      easypick.setup {
        pickers = {
          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff { base_branch = base_branch },
          },
          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      }
    end,
  },
  -- Copy entire astronvim config to add to it. I wish I could override the config
  -- without doing this.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main", -- HACK: force neo-tree to checkout `main` for initial v3 migration since default branch has changed
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    opts = function()
      local utils = require "astronvim.utils"
      local get_icon = utils.get_icon
      return {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem", display_name = get_icon("FolderClosed", 1, true) .. "File" },
            { source = "buffers", display_name = get_icon("DefaultFile", 1, true) .. "Bufs" },
            { source = "git_status", display_name = get_icon("Git", 1, true) .. "Git" },
            { source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
          },
        },
        default_component_configs = {
          indent = { padding = 0 },
          icon = {
            folder_closed = get_icon "FolderClosed",
            folder_open = get_icon "FolderOpen",
            folder_empty = get_icon "FolderEmpty",
            folder_empty_open = get_icon "FolderEmpty",
            default = get_icon "DefaultFile",
          },
          modified = { symbol = get_icon "FileModified" },
          git_status = {
            symbols = {
              added = get_icon "GitAdd",
              deleted = get_icon "GitDelete",
              modified = get_icon "GitChange",
              renamed = get_icon "GitRenamed",
              untracked = get_icon "GitUntracked",
              ignored = get_icon "GitIgnored",
              unstaged = get_icon "GitUnstaged",
              staged = get_icon "GitStaged",
              conflict = get_icon "GitConflict",
            },
          },
        },
        commands = {
          system_open = function(state)
            -- TODO: just use vim.ui.open when dropping support for Neovim <0.10
            (vim.ui.open or require("astronvim.utils").system_open)(state.tree:get_node():get_id())
          end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if (node.type == "directory" or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            else -- if not a directory just open it
              state.commands.open(state)
            end
          end,
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local vals = {
              ["BASENAME"] = modify(filename, ":r"),
              ["EXTENSION"] = modify(filename, ":e"),
              ["FILENAME"] = filename,
              ["PATH (CWD)"] = modify(filepath, ":."),
              ["PATH (HOME)"] = modify(filepath, ":~"),
              ["PATH"] = filepath,
              ["URI"] = vim.uri_from_fname(filepath),
            }

            local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
            if vim.tbl_isempty(options) then
              utils.notify("No values to copy", vim.log.levels.WARN)
              return
            end
            table.sort(options)
            vim.ui.select(options, {
              prompt = "Choose to copy to clipboard:",
              format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
            }, function(choice)
              local result = vals[choice]
              if result then
                utils.notify(("Copied: `%s`"):format(result))
                vim.fn.setreg("+", result)
              end
            end)
          end,
          find_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").find_files {
              cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
            }
          end,
          find_word_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").live_grep {
              search_dirs = node.type == "directory" and { path } or { vim.fn.fnamemodify(path, ":h") },
            }
          end,
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = false, -- disable space until we figure out which-key disabling
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            F = utils.is_available "telescope.nvim" and "find_in_dir" or nil,
            O = "system_open",
            Y = "copy_selector",
            h = "parent_or_close",
            l = "child_or_open",
            o = "open",
            ["<leader>/"] = "find_word_in_dir",
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<C-j>"] = "move_cursor_down",
            ["<C-k>"] = "move_cursor_up",
          },
        },
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_) vim.opt_local.signcolumn = "auto" end,
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          gdscript = { "gdformat" },
        },
      }
    end,
  },
}
