return {
  {
    "folke/which-key.nvim",
    opts = function()
      local wk = require("which-key")
      wk.add({
        -- Universal group name
        { "<leader>t", group = "Terminal", mode = { "v" } },
      })

      -- Keymap: <leader>ts (Terminal Send)
      vim.keymap.set("v", "<leader>ts", function()
        -- Briefly exit visual mode to update the '< and '> marks
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "x", false)

        vim.schedule(function()
          local start_line = vim.fn.line("'<")
          local end_line = vim.fn.line("'>")
          -- Get the relative path of the current file
          local filename = vim.fn.expand("%")
          -- Send the file reference instead of the code itself
          -- Format: filename:start:end (with a trailing space for convenience)
          local prompt = string.format("@%s:%d:%d ", filename, start_line, end_line)

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

          -- Send the reference string to the terminal
          vim.api.nvim_chan_send(term_chan, prompt)
          -- Switch focus to the terminal window (remaining in Normal mode)
          vim.api.nvim_set_current_win(term_win)
        end)
      end, { desc = "Send file reference to terminal" })
    end,
  },
}
