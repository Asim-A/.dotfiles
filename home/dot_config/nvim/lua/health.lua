--[[
--
-- `:checkhealth` support for this personal config. Not required to use the
-- config itself, but a quick way to confirm the tools it relies on are
-- actually available on this machine.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils used by telescope/lazy/conform/etc.
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

local check_language_toolchains = function()
  vim.health.info 'Per-language toolchains (only needed for the languages you actually use):'

  -- name, executable, what it's used for
  local toolchains = {
    { 'dotnet', 'dotnet', 'building .NET projects debugged via netcoredbg/roslyn' },
    { 'go', 'go', 'gopls/dap-go/delve' },
    { 'python', 'python', 'pyright/ruff/debugpy' },
    { 'node', 'node', 'ts_ls/js-debug-adapter/neotest-jest/neotest-vitest' },
  }

  for _, toolchain in ipairs(toolchains) do
    local name, exe, used_for = toolchain[1], toolchain[2], toolchain[3]
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found '%s' (used for %s)", name, used_for))
    else
      vim.health.warn(string.format("Could not find '%s' (used for %s)", name, used_for))
    end
  end
end

return {
  check = function()
    vim.health.start 'Personal Neovim config'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
    check_language_toolchains()
  end,
}
