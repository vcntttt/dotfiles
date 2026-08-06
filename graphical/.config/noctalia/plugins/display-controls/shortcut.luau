function onClick()
  noctalia.togglePanel("vrivera/display-controls:display-panel")
end

function update()
  shortcut.setLabel("Pantallas")
  shortcut.setIcon("device-desktop")
  shortcut.setActive(false)
  shortcut.setEnabled(true)
end
