return {
  "sheymor21/unirunner.nvim",
  keys = {
    { "<leader>jr", "<cmd>UniRunner<CR>", desc = "Run project command" },
    { "<leader>js", "<cmd>UniRunnerSelect<CR>", desc = "Select project command" },
    { "<leader>jl", "<cmd>UniRunnerLast<CR>", desc = "Re-run last command" },
    { "<leader>jh", "<cmd>UniRunnerPanel<CR>", desc = "Toggle history panel" },
  },
  config = function()
    local UniRunner = require("unirunner")
    local runners = require("unirunner.runners")

    runners.register("go_work", {
      detect = function(root)
        return vim.fn.filereadable(root .. "/go.work") == 1
      end,
      get_commands = function(root)
        local commands = {}
        local work_content = vim.fn.readfile(root .. "/go.work")
        for _, line in ipairs(work_content) do
          local dir = line:match("^use%s+(.+)$")
          if dir then
            dir = vim.fn.trim(dir)
            if vim.fn.isdirectory(root .. "/" .. dir) == 1 then
              table.insert(commands, { name = "test:" .. dir, command = "go test ./" .. dir .. "/..." })
              table.insert(commands, { name = "test-v:" .. dir, command = "go test -v ./" .. dir .. "/..." })
              table.insert(commands, { name = "run:" .. dir, command = "go run ./" .. dir })
              table.insert(commands, { name = "build:" .. dir, command = "go build ./" .. dir })
            end
          end
        end
        return commands
      end,
    })

    UniRunner.setup({
      persist = true,
      working_dir = "root",
      root_markers = { "go.work", "go.mod", "package.json", "justfile", "Makefile", "Cargo.toml", ".git" },
      close_delay = 0,
      panel = {
        height = 30,
        max_history = 10,
        auto_follow = true,
      },
    })
  end,
}
