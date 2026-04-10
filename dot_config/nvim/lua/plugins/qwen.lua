return {
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>q", group = "Qwen CLI", mode = { "v" } },
      })

      vim.keymap.set("v", "<leader>qv", function()
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "x", false)

        vim.schedule(function()
          local start_line = vim.fn.line("'<")
          local end_line = vim.fn.line("'>")
          local filename = vim.fn.expand("%")

          -- Format differently for single‑line vs multi‑line selections
          local prompt
          if start_line == end_line then
            prompt = string.format("@%s:%d ", filename, start_line)
          else
            prompt = string.format("@%s:%d:%d ", filename, start_line, end_line)
          end

          local term_chan = nil
          local term_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "terminal" then
              term_chan = vim.bo[buf].channel
              term_win = win
              break
            end
          end

          if not term_chan or not term_win then
            vim.notify("No visible terminal pane found!", vim.log.levels.WARN)
            return
          end

          -- Send the text to the terminal
          vim.api.nvim_chan_send(term_chan, prompt)
          -- Switch focus to the terminal window (remaining in Normal mode)
          vim.api.nvim_set_current_win(term_win)
        end)
      end, { desc = "Send Reference to Terminal" })
    end,
  },
}
