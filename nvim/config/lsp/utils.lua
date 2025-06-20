local lsp = require('lspconfig')

local function readFile(filePath)
  local file = io.open(filePath, "r")

  if not file then
    return nil
  end

  local contents = file:read("*all")

  file:close()

  return contents;
end

local function read_nearest_ts_config(fromFile)
  local rootDir = lsp.util.root_pattern('tsconfig.json')(fromFile);

  if not rootDir then
    return nil
  end

  local tsConfig = rootDir .. "/tsconfig.json"
  local contents = readFile(tsConfig)
  local manifest = readFile(rootDir .. "/package.json")

  if not contents then
    return nil
  end

  if not manifest then
    return nil
  end


  -- BUG:
  --   this does not follow "extends" or global tsconfigs if a "one tsconfig.json"
  --   is used.
  local isGlint = string.find(contents, '"glint"')
  print('DEBUGPRINT[5]: utils.lua:40: isGlint=' .. vim.inspect(not not isGlint))
  -- NOTE: hyphens don't work here
  local hasGlintPlugin = string.find(manifest, "@glint/tsserver")
  print('DEBUGPRINT[6]: utils.lua:43: hasGlintPlugin=' .. vim.inspect(not not hasGlintPlugin))

  return {
    isGlint = not not isGlint,
    isGlintPlugin = not not hasGlintPlugin,
    rootDir = rootDir,
  };
end

-- See:
-- :help lspconfig
-- search for ROOT DIRECTORY DETECTION
local function is_glint_project(filename, bufnr)
  local result = read_nearest_ts_config(filename)

  if not result then
    return nil
  end

  if result.isGlintPlugin then
    return nil
  end

  if not result.isGlint then
    return nil
  end

  return result.rootDir
end

local function is_ts_project(filename, bufnr)
  local result = read_nearest_ts_config(filename)

  if not result then
    return '/bogus'
  end

  if result.isGlintPlugin then
    return result.rootDir
  end

  if result.isGlint then
    return '/bogus'
  end

  return result.rootDir
end

return {
  is_glint_project = is_glint_project,
  is_ts_project = is_ts_project,
  read_nearest_ts_config = read_nearest_ts_config,
}
