local M = {}
local history = {}
local history_path = vim.fn.stdpath("state") .. "/recent-projects.json"
local root_cache = {}
local seeded = false
local namespace = vim.api.nvim_create_namespace("StartupScreen")

local function project_root(file)
  local dir = vim.fs.dirname(file)
  if not root_cache[dir] then
    -- Prefer the repository root over a nested package in a monorepo.
    root_cache[dir] = vim.fs.root(dir, ".git")
      or vim.fs.root(dir, {
        { "composer.json", "artisan", "go.mod", "package.json", "pubspec.yaml", "Cargo.toml", "pyproject.toml", "Makefile" },
      })
      or dir
  end
  return root_cache[dir]
end

local function add_project(root, recent)
  if root == vim.env.HOME or root == "/" or vim.fn.isdirectory(root) == 0 then
    return
  end
  for index, path in ipairs(history) do
    if path == root then
      if not recent then
        return
      end
      table.remove(history, index)
      break
    end
  end
  table.insert(history, recent and 1 or (#history + 1), root)
  while #history > 50 do
    table.remove(history)
  end
end

local function seed_history()
  if seeded then
    return
  end
  seeded = true
  -- oldfiles is ordered from most recently used to least recently used.
  for _, file in ipairs(vim.v.oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      add_project(project_root(vim.fn.fnamemodify(file, ":p")), false)
    end
  end
end

function M.show()
  seed_history()
  local projects = {}
  for _, path in ipairs(history) do
    if vim.fn.isdirectory(path) == 1 then
      projects[#projects + 1] = path
      if #projects == 9 then
        break
      end
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "startup"

  local saved_options = {}
  local screen_options = {
    number = false,
    relativenumber = false,
    signcolumn = "no",
    wrap = false,
    cursorline = true,
    fillchars = "eob: ",
  }
  local function enter()
    local win = vim.api.nvim_get_current_win()
    saved_options[win] = saved_options[win] or {}
    for name, value in pairs(screen_options) do
      saved_options[win][name] = vim.wo[win][name]
      vim.wo[win][name] = value
    end
  end
  local function leave()
    local win = vim.api.nvim_get_current_win()
    for name, value in pairs(saved_options[win] or {}) do
      vim.wo[win][name] = value
    end
    saved_options[win] = nil
  end
  enter()
  vim.api.nvim_create_autocmd("BufWinEnter", { buffer = buf, callback = enter })
  vim.api.nvim_create_autocmd("BufWinLeave", { buffer = buf, callback = leave })

  local actions = {}
  local function new_text()
    vim.cmd.enew()
    vim.bo.filetype = "text"
    vim.cmd.startinsert()
  end
  local function find_files()
    require("telescope.builtin").find_files()
  end
  local function recent_files()
    require("telescope.builtin").oldfiles()
  end
  local function open_project(path)
    if vim.fn.isdirectory(path) == 0 then
      vim.notify("Project directory no longer exists: " .. path, vim.log.levels.WARN)
      return
    end
    vim.cmd.cd(vim.fn.fnameescape(path))
    add_project(path, true)
    require("telescope.builtin").find_files({ cwd = path })
  end
  local function map(key, action, desc)
    vim.keymap.set("n", key, action, { buffer = buf, silent = true, nowait = true, desc = desc })
  end
  map("n", new_text, "Write some text")
  map("i", new_text, "Write some text")
  map("f", find_files, "Find a file")
  map("r", recent_files, "Recent files")
  map("q", "<cmd>quit<cr>", "Quit")
  map("<CR>", function()
    local action = actions[vim.api.nvim_win_get_cursor(0)[1]]
    if action then
      action()
    end
  end, "Open selected item")

  local function render()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    local rows = {
      { "NEOVIM", "Title" },
      { "A project, a file, or a fresh page.", "Comment" },
      { "" },
      { "[n]  Write some text", "String", new_text },
      { "Start typing. Press Esc, then :w filename.txt to save.", "Comment" },
      { "[f]  Find a file    [r]  Recent files    [q]  Quit", "Normal" },
      { "" },
      { "RECENT PROJECTS", "Title" },
    }
    actions = {}
    for index, path in ipairs(projects) do
      local project = path
      local action = function() open_project(project) end
      rows[#rows + 1] = { string.format("[%d]  %s", index, vim.fn.fnamemodify(path, ":~")), "Directory", action }
      map(tostring(index), action, "Open project " .. vim.fs.basename(path))
    end
    if #projects == 0 then
      rows[#rows + 1] = { "Open a project file and it will appear here next time.", "Comment" }
    end
    rows[#rows + 1] = { "" }
    rows[#rows + 1] = { "Press a shortcut, or select a project and press Enter.", "Comment" }

    local width = 0
    for _, row in ipairs(rows) do
      width = math.max(width, vim.fn.strdisplaywidth(row[1]))
    end
    local win = vim.fn.bufwinid(buf)
    local columns = win ~= -1 and vim.api.nvim_win_get_width(win) or vim.o.columns
    local padding = string.rep(" ", math.max(2, math.floor((columns - width) / 2)))
    local lines = { "", "", "" }
    for _, row in ipairs(rows) do
      lines[#lines + 1] = padding .. row[1]
      actions[#lines] = row[3]
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
    for index, row in ipairs(rows) do
      if row[2] then
        vim.api.nvim_buf_set_extmark(buf, namespace, index + 2, #padding, { end_col = #padding + #row[1], hl_group = row[2] })
      end
    end
    vim.bo[buf].modifiable = false
    vim.bo[buf].modified = false
  end
  render()
  vim.api.nvim_win_set_cursor(0, { #projects > 0 and 12 or 7, 0 })
  local resize = vim.api.nvim_create_autocmd("VimResized", { callback = render })
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function() vim.api.nvim_del_autocmd(resize) end,
  })
end

function M.setup()
  if vim.fn.filereadable(history_path) == 1 then
    local ok, stored = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(history_path), "\n"))
    end)
    if ok and type(stored) == "table" then
      for _, path in ipairs(stored) do
        if type(path) == "string" then
          add_project(path, false)
        end
      end
    end
  end
  local group = vim.api.nvim_create_augroup("StartupScreen", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    callback = function(event)
      local file = vim.api.nvim_buf_get_name(event.buf)
      if vim.bo[event.buf].buftype == "" and file ~= "" and vim.fn.filereadable(file) == 1 then
        add_project(project_root(file), true)
      end
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if #history > 0 then
        vim.fn.mkdir(vim.fn.stdpath("state"), "p")
        local ok, err = pcall(vim.fn.writefile, { vim.json.encode(history) }, history_path)
        if not ok then
          vim.notify("Could not save recent projects: " .. tostring(err), vim.log.levels.WARN)
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = function()
      -- Keep explicit files, directories, piped text, and headless runs intact.
      if vim.fn.argc() == 0 and #vim.api.nvim_list_uis() > 0 and vim.bo.buftype == ""
        and vim.api.nvim_buf_get_name(0) == "" and not vim.bo.modified
        and vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_get_current_line() == "" then
        M.show()
      end
    end,
  })
  vim.api.nvim_create_user_command("Startup", M.show, { desc = "Open startup screen" })
  vim.keymap.set("n", "<leader>sd", M.show, { desc = "Open Startup Screen" })
end

return M
