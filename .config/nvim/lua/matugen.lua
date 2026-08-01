 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1a110f',
    base01 = '#271d1a',
    base02 = '#322824',
    base03 = '#a08d87',
    base04 = '#d8c2bb',
    base05 = '#f1dfd9',
    base06 = '#f1dfd9',
    base07 = '#f1dfd9',
    base08 = '#ffb4ab',
    base09 = '#d6c68d',
    base0A = '#e7bdb0',
    base0B = '#ffb59c',
    base0C = '#d6c68d',
    base0D = '#ffb59c',
    base0E = '#e7bdb0',
    base0F = '#93000a',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f1dfd9',          bg = '#1a110f' })
  hi('TelescopeBorder',         { fg = '#a08d87',             bg = '#1a110f' })
  hi('TelescopePromptNormal',   { fg = '#f1dfd9',          bg = '#1a110f' })
  hi('TelescopePromptBorder',   { fg = '#a08d87',             bg = '#1a110f' })
  hi('TelescopePromptPrefix',   { fg = '#ffb59c',             bg = '#1a110f' })
  hi('TelescopePromptCounter',  { fg = '#d8c2bb',  bg = '#1a110f' })
  hi('TelescopePromptTitle',    { fg = '#1a110f',             bg = '#ffb59c' })
  hi('TelescopePreviewTitle',   { fg = '#1a110f',             bg = '#e7bdb0' })
  hi('TelescopeResultsTitle',   { fg = '#1a110f',             bg = '#d6c68d' })
  hi('TelescopeSelection',      { fg = '#f1dfd9',          bg = '#322824' })
  hi('TelescopeSelectionCaret', { fg = '#ffb59c',             bg = '#322824' })
  hi('TelescopeMatching',       { fg = '#ffb59c',             bold = true })
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
