 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#141318',
    base01 = '#201f24',
    base02 = '#2b292f',
    base03 = '#938f99',
    base04 = '#c9c4d0',
    base05 = '#e6e1e9',
    base06 = '#e6e1e9',
    base07 = '#e6e1e9',
    base08 = '#ffb4ab',
    base09 = '#edb8cc',
    base0A = '#cac3dc',
    base0B = '#cabeff',
    base0C = '#edb8cc',
    base0D = '#cabeff',
    base0E = '#cac3dc',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e6e1e9',          bg = '#141318' })
  hi('TelescopeBorder',         { fg = '#938f99',             bg = '#141318' })
  hi('TelescopePromptNormal',   { fg = '#e6e1e9',          bg = '#141318' })
  hi('TelescopePromptBorder',   { fg = '#938f99',             bg = '#141318' })
  hi('TelescopePromptPrefix',   { fg = '#cabeff',             bg = '#141318' })
  hi('TelescopePromptCounter',  { fg = '#c9c4d0',  bg = '#141318' })
  hi('TelescopePromptTitle',    { fg = '#141318',             bg = '#cabeff' })
  hi('TelescopePreviewTitle',   { fg = '#141318',             bg = '#cac3dc' })
  hi('TelescopeResultsTitle',   { fg = '#141318',             bg = '#edb8cc' })
  hi('TelescopeSelection',      { fg = '#e6e1e9',          bg = '#2b292f' })
  hi('TelescopeSelectionCaret', { fg = '#cabeff',             bg = '#2b292f' })
  hi('TelescopeMatching',       { fg = '#cabeff',             bold = true })
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
