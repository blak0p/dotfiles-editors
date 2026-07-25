return {
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<CR>", desc = "Diff view" },
      { "<leader>dd", "<cmd>DiffviewOpen HEAD<CR>", desc = "Diff view (HEAD)" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = false,
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
    },
    config = function()
      require("diffview")
      local ns = vim.api.nvim_create_namespace("diffview_reviewed")
      local reviewed = {}

      vim.api.nvim_create_autocmd("User", {
        pattern = "DiffviewViewOpened",
        callback = function()
          vim.schedule(function()
            local panel = require("diffview.lib").get_current_view()
            if not panel or not panel.panel then return end
            local bufnr = panel.panel.bufnr
            if not bufnr then return end

            vim.keymap.set("n", "m", function()
              local line = vim.fn.line(".")
              local text = vim.fn.getline(line)
              if text == "" then return end
              local key = bufnr .. ":" .. text
              if reviewed[key] then
                reviewed[key] = nil
                pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, line)
              else
                reviewed[key] = true
                vim.api.nvim_buf_set_extmark(bufnr, ns, line - 1, 0, {
                  sign_text = "✓",
                  sign_hl = "DiagnosticSignOk",
                  priority = 200,
                })
              end
            end, { buffer = bufnr, desc = "Toggle reviewed" })
          end)
        end,
      })
    end,
  },
}
