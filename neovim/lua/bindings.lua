function setup_binding(vim)
  -- Keybindings
  vim.g.mapleader = " "

  vim.keymap.set({ "n", "v" }, "<leader>gb", ":BlameToggle window<CR>") -- Git Blame
  vim.keymap.set({ "n", "v" }, "<leader>zn", ":NoNeckPain<CR>")         -- Git Blame

  -- NvimTree
  vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true }) -- File Explorer

  -- Telescope
  vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true }) -- Find Files
  vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true })  -- Grep
  vim.keymap.set("n", "<leader>st", ":Telescope live_grep<CR>", { silent = true })  -- Grep

  -- Git
  vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true }) -- Lazygit

  -- Navigation
  vim.keymap.set({ "n", "v", "t" }, '<C-l>', function() vim.cmd [[wincmd l]] end) -- move right
  vim.keymap.set({ "n", "v", "t" }, '<C-k>', function() vim.cmd [[wincmd k]] end) -- move up
  vim.keymap.set({ "n", "v", "t" }, '<C-j>', function() vim.cmd [[wincmd j]] end) -- move down
  vim.keymap.set({ "n", "v", "t" }, '<C-h>', function() vim.cmd [[wincmd h]] end) -- move left

  -- Diagnostic
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false
  })

  vim.keymap.set(
    "n",
    "<leader>l",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
  )

  -- Code Formatting
  vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
    -- require("conform").format()
  end, { desc = "Format Code" })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })


  -- Bar
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  -- Move to previous/next
  map('n', '<leader>bb', '<Cmd>BufferPrevious<CR>', opts)
  map('n', '<leader>bn', '<Cmd>BufferNext<CR>', opts)

  -- Re-order to previous/next
  map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
  map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

  -- Pin/unpin buffer
  map('n', '<leader>p', '<Cmd>BufferPin<CR>', opts)

  -- Goto pinned/unpinned buffer
  --                 :BufferGotoPinned
  --                 :BufferGotoUnpinned

  -- Close buffer
  map('n', '<leader>c', '<Cmd>BufferClose<CR>', opts)

  -- Wipeout buffer
  --                 :BufferWipeout

  -- Close commands
  --                 :BufferCloseAllButCurrent
  --                 :BufferCloseAllButPinned
  --                 :BufferCloseAllButCurrentOrPinned
  --                 :BufferCloseBuffersLeft
  --                 :BufferCloseBuffersRight

  -- Magic buffer-picking mode
  map('n', '<leader>bj', '<Cmd>BufferPick<CR>', opts)

  -- LSP Binding
  local lsp = vim.lsp.buf

  vim.keymap.set("n", "<space>lD", lsp.type_definition, { desc = "Type Definition" })
  vim.keymap.set("n", "gD", lsp.declaration, { desc = "Go to Declaration" })
  vim.keymap.set("n", "gd", lsp.definition, { desc = "Go to Definition" })
  vim.keymap.set("n", "gr", lsp.references, { desc = "Show References" })
  vim.keymap.set("n", "K", lsp.hover, { desc = "Hover Documentation" })
  vim.keymap.set("n", "<leader>rn", lsp.rename, { desc = "Rename Symbol" })
  vim.keymap.set("n", "<leader>la", lsp.code_action, { desc = "Code Actions" })
  vim.keymap.set("n", "<space>li", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
  vim.keymap.set("n", "<space>lI", "<cmd>Mason<CR>", { desc = "Mason" })

  -- DAP / Debugger Bindings
  local dap = require('dap')
  local dapui = require('dapui')

  vim.keymap.set('n', '<F5>', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
  vim.keymap.set('n', '<F6>', dap.continue, { desc = 'Start/Continue Debugger' })
  vim.keymap.set('n', '<F7>', dap.step_over, { desc = 'Step Over' })
  vim.keymap.set('n', '<F8>', dap.step_into, { desc = 'Step Into' })
  vim.keymap.set('n', '<F9>', dap.step_out, { desc = 'Step Out' })
  vim.keymap.set('n', '<S-F6>', dap.terminate, { desc = 'Stop Debugger' }) -- Shift+F6 to terminate

  vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })
  vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'DAP Eval' })
end

return setup_binding
