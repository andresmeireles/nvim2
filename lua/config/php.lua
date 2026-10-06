local M = {}

function M.laravel()
  local file = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.root(file ~= "" and file or vim.fn.getcwd(), "artisan")
  if not root then
    vim.notify("Open a Laravel project before using Artisan tools.", vim.log.levels.WARN)
    return
  end
  -- Laravel's environment and command runner use the current working directory.
  if vim.fn.getcwd() ~= root then
    vim.cmd.tcd(vim.fn.fnameescape(root))
  end
  require("lazy").load({ plugins = { "laravel.nvim" } })
  return Laravel
end

function M.test(current_file)
  local file = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.root(file ~= "" and file or vim.fn.getcwd(), { "composer.json", ".git" })
  if not root then
    vim.notify("Open a PHP project with composer.json before running tests.", vim.log.levels.WARN)
    return
  end
  if current_file and (vim.bo.filetype ~= "php" or file == "") then
    vim.notify("Open a PHP test file before running file tests.", vim.log.levels.WARN)
    return
  end
  -- Save changes before executing the test suite.
  vim.cmd.wall()
  local args = current_file and { vim.fs.relpath(root, file) or file } or {}
  if vim.fn.filereadable(root .. "/artisan") == 1 then
    local app = M.laravel()
    if not app then
      return
    end
    if current_file then
      args[1] = vim.fn.shellescape(args[1])
    end
    table.insert(args, 1, "test")
    app.run("artisan", args)
    return
  end
  local runner
  for _, name in ipairs({ "pest", "phpunit" }) do
    if vim.fn.filereadable(root .. "/vendor/bin/" .. name) == 1 then
      runner = root .. "/vendor/bin/" .. name
      break
    end
  end
  if not runner then
    vim.notify("No project test runner found. Install Pest or PHPUnit with Composer.", vim.log.levels.WARN)
    return
  end
  local command = { "php", runner }
  vim.list_extend(command, args)
  for index, arg in ipairs(command) do
    command[index] = vim.fn.shellescape(arg)
  end
  require("toggleterm.terminal").Terminal:new({
    cmd = table.concat(command, " "),
    dir = root,
    direction = "horizontal",
    close_on_exit = false,
  }):toggle()
end

return M
