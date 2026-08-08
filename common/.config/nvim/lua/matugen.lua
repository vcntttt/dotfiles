 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#101418',
    base01 = '#1d2024',
    base02 = '#272a2f',
    base03 = '#8d9199',
    base04 = '#c3c7cf',
    base05 = '#e1e2e8',
    base06 = '#e1e2e8',
    base07 = '#e1e2e8',
    base08 = '#ffb4ab',
    base09 = '#d6bee5',
    base0A = '#bac8db',
    base0B = '#9fcafd',
    base0C = '#d6bee5',
    base0D = '#9fcafd',
    base0E = '#bac8db',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e1e2e8',          bg = '#101418' })
  hi('TelescopeBorder',         { fg = '#8d9199',             bg = '#101418' })
  hi('TelescopePromptNormal',   { fg = '#e1e2e8',          bg = '#101418' })
  hi('TelescopePromptBorder',   { fg = '#8d9199',             bg = '#101418' })
  hi('TelescopePromptPrefix',   { fg = '#9fcafd',             bg = '#101418' })
  hi('TelescopePromptCounter',  { fg = '#c3c7cf',  bg = '#101418' })
  hi('TelescopePromptTitle',    { fg = '#101418',             bg = '#9fcafd' })
  hi('TelescopePreviewTitle',   { fg = '#101418',             bg = '#bac8db' })
  hi('TelescopeResultsTitle',   { fg = '#101418',             bg = '#d6bee5' })
  hi('TelescopeSelection',      { fg = '#e1e2e8',          bg = '#272a2f' })
  hi('TelescopeSelectionCaret', { fg = '#9fcafd',             bg = '#272a2f' })
  hi('TelescopeMatching',       { fg = '#9fcafd',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
