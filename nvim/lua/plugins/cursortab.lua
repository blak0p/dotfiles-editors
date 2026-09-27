return {
  {
    url = "git@github.com:blak0p/cursortab.nvim.git",
    lazy = false,
    build = "cd server && go build",
    opts = {
      log_level = "debug",
      behavior = {
        ignore_filetypes = { "terminal", "prompt", "codecompanion" },
      },
      provider = {
        type = "fim",
        url = "http://127.0.0.1:8090",
        model = "qwen7b",
        max_tokens = 128,
        fim_tokens = {
          prefix = "<|fim_prefix|>",
          suffix = "<|fim_suffix|>",
          middle = "<|fim_middle|>",
        },
      },
    },
  },
}
