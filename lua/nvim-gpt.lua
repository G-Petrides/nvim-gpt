local api = vim.api
local gpt_buffer = nil
local gpt_window = nil
local gpt_key = nil
local job = require 'plenary.job'

local function promptToBuffer(prompt)
    api.nvim_set_current_win(gpt_window) -- set the current window
    api.nvim_set_current_buf(gpt_buffer) -- set the current buffer
    local lines = api.nvim_buf_line_count(gpt_buffer) -- get the buffer lines
    api.nvim_buf_set_lines(0, lines, -1, false, {"Prompt: "..prompt}) -- append the buffer lines
    api.nvim_buf_set_lines(0, lines+1, -1, false, {""}) -- append the buffer lines
    api.nvim_win_set_cursor(0, {lines+2, 0}) -- set the cursor position
end

local function runPrompt(prompt)

  promptToBuffer(prompt)

  job:new({command = "curl", args={
    "-s",
    "-X",
    "POST" ,"https://api.openai.com/v1/chat/completions",
    "-H", "Content-Type: application/json",
    "-H", "Authorization: Bearer "..gpt_key,
    "--data-raw", '{"model": "gpt-3.5-turbo","messages": [{"role": "user", "content":"'..prompt..'"}]}'
  }, on_exit = function(res, _)
    local gpt_data = res:result()[1]
    local decoded_json = vim.json.decode(gpt_data)
    local message = decoded_json["choices"][1]["message"]["content"]

    vim.schedule(function()
      api.nvim_set_current_win(gpt_window) -- set the current window
      api.nvim_set_current_buf(gpt_buffer) -- set the current buffer
      local lines = api.nvim_buf_line_count(gpt_buffer) -- get the buffer lines
      for line in message:gmatch("[^\r\n]+") do
        api.nvim_buf_set_lines(0, lines, -1, false, {line}) -- append the buffer lines
        lines = lines + 1
      end
      api.nvim_buf_set_lines(0, lines+1, -1, false, {""}) -- append the buffer lines
      api.nvim_buf_set_lines(0, lines+2, -1, false, {"####"}) -- append the buffer lines
      api.nvim_buf_set_lines(0, lines+3, -1, false, {""}) -- append the buffer lines
      api.nvim_win_set_cursor(0, {lines+3, 0}) -- set the cursor position
    end)
  end}):start()
end

local function printMessage(prompt)

  if gpt_window == nil or not api.nvim_win_is_valid(gpt_window) then
    api.nvim_command('botright vsplit new') -- split a new window 
    gpt_window = api.nvim_tabpage_get_win(0) -- get the window handler
    api.nvim_set_current_win(gpt_window) -- set the current window
    api.nvim_win_set_width(0, 100) -- set the window width
    gpt_buffer = api.nvim_win_get_buf(0) -- get the buffer handler 
  end

  if gpt_key == nil then
    print("Please set the GPT-3 API key.")
  else
    runPrompt(prompt)
  end
end

local function setup(key)
  gpt_key = key
end

return {
  printMessage = printMessage,
  setup = setup
}
