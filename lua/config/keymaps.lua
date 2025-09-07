-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.cmd('set number')
vim.cmd('set relativenumber')
vim.cmd('map Q gq')
vim.cmd('imap kj <Esc>')
vim.cmd('nmap n nzz')
vim.cmd('nmap N nZZ')
vim.cmd('nmap Y y$')
vim.cmd('set noexpandtab')
vim.cmd('set tabstop=4')
vim.cmd('set softtabstop=4')
vim.cmd('set shiftwidth=4')

-- Сбрасывать выделение после поиска на <Esc>
vim.keymap.set("n", "<Esc>", "<Esc><cmd>nohlsearch<CR>", { silent = true })
-- Сбрасывать выделение после движения курсора
-- Почему-то оба варианта не работают, отменяю
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = function()
--     if vim.fn.mode() == "n" then
--       vim.cmd("nohlsearch")
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = function()
--     vim.cmd("nohlsearch")
--   end,
-- })


--leader space
-- vim.cmd('nnoremap <SPACE> <Nop>')
-- vim.cmd('let mapleader=" "')
-- vim.cmd('map <Space> <Leader>')
-- vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true})

vim.g.mapleader = " "


-- Copy to clipboard
vim.cmd('vnoremap  <leader>y  "+y')
vim.cmd('nnoremap  <leader>Y  "+yg_')
vim.cmd('nnoremap  <leader>y  "+y')
vim.cmd('nnoremap  <leader>yy  "+yy')

-- Paste from clipboard
vim.cmd('nnoremap <leader>p "+p')
vim.cmd('nnoremap <leader>P "+P')
vim.cmd('vnoremap <leader>p "+p')
vim.cmd('vnoremap <leader>P "+P')

vim.cmd('nnoremap <leader><leader> :Ex<CR>')


local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- навигация/поиск
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)

-- файловое дерево
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", opts)

-- форматирование (Conform вызовем из go.lua)
-- map("n", "<leader>f", function() require("conform").format({ async = true }) end, opts)
vim.keymap.set("n", "<leader>ll", function() require("lint").try_lint() end, { desc = "Lint current file" })


-- Дебаг <Leader>dp для вывода попапа ошибки
vim.keymap.set("n", "<leader>dp", function()
  vim.diagnostic.open_float(0, {scope = "line"})
end, { desc = "Show diagnostics popup" })

-- Дебаг <Leader>dc для просмотра ошибки в консоли
-- diagnostics popup & console
local diag_bufnr = nil
local diag_winid = nil

vim.keymap.set("n", "<leader>dc", function()
  if diag_winid and vim.api.nvim_win_is_valid(diag_winid) then
    vim.api.nvim_win_close(diag_winid, true)
    diag_bufnr = nil
    diag_winid = nil
    return
  end

  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if vim.tbl_isempty(diagnostics) then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end

  local lines = vim.split(vim.inspect(diagnostics), "\n")

  diag_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(diag_bufnr, 0, -1, false, lines)
  vim.bo[diag_bufnr].buftype = "nofile"
  vim.bo[diag_bufnr].bufhidden = "wipe"
  vim.bo[diag_bufnr].swapfile = false
  vim.bo[diag_bufnr].filetype = "lua" -- подсветка!

  diag_winid = vim.api.nvim_open_win(diag_bufnr, true, {
    relative = "editor",
    -- width = math.floor(vim.o.columns * 0.5),
    width = math.floor(vim.o.columns),
    height = math.floor(vim.o.lines * 0.3),
    row = math.floor(vim.o.lines * 0.7),
    col = math.floor(vim.o.columns * 0.25),
    border = "rounded",
  })
end, { desc = "Toggle diagnostics console" })

