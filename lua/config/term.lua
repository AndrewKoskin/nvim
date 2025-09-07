-- Toggle одного терминала внизу на 10 строк
local term = { buf = nil, win = nil }

local function open_term()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_set_current_win(term.win)
    return
  end
  if not (term.buf and vim.api.nvim_buf_is_valid(term.buf)) then
    vim.cmd("botright 10split")
    term.win = vim.api.nvim_get_current_win()
    vim.cmd("terminal")                          -- откроет $SHELL
	vim.fn.chansend(vim.bo.channel, {"zsh\r\n"}) -- В текущий канал запускает zsh
    term.buf = vim.api.nvim_get_current_buf()
  else
    vim.cmd("botright 10split")
    term.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term.win, term.buf) -- вернуть существующий терминал
  end
  vim.cmd("startinsert")
end

local function close_term_win()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, false)      -- закрыть окно, буфер оставить
    term.win = nil
  end
end

local function toggle_term()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    close_term_win()
  else
    open_term()
  end
end

-- Маппинг: свернуть/показать
vim.keymap.set({ "n", "t" }, "<leader>tt", function()
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  end
  toggle_term()
end, { silent = true, desc = "Toggle terminal" })

-- Сделать выход из insert mode вместо \n на <Esc>
-- глобально для всех терминалов
-- vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { silent = false }) -- silent false будет показывать команду в командной строке
-- vim.keymap.set({"n", "t"}, "<Leader>20", "<C-w>20+")

-- Опционально авто-insert и косметика
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})



-- Toggle: max height <-> 10 lines для текущего терминального окна
local function toggle_term_height()
  -- если жмёшь в терминале, выйдем в нормальный режим
  if vim.fn.mode() == "t" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  end
  if vim.bo.buftype ~= "terminal" then
    vim.notify("Текущий буфер не терминал", vim.log.levels.WARN)
    return
  end
  if vim.w._term_is_max then
    vim.cmd("resize 10")          -- вернуть фиксированные 10 строк
    vim.w._term_is_max = false
  else
    vim.cmd("wincmd _")           -- максимизировать по высоте
    vim.w._term_is_max = true
  end
end

vim.keymap.set({ "n", "t" }, "<leader>res", toggle_term_height, { silent = true, desc = "Terminal height: max <-> 10" })

