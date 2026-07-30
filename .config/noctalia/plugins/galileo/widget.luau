local service = "openvpn-client@galileo.service"

local function render(active)
  barWidget.setVisible(active)

  if active then
    barWidget.setGlyph("shield-lock")
    barWidget.setText("Galileo")
    barWidget.setTooltip("Galileo conectada")
  else
    barWidget.setText("")
    barWidget.setGlyph("")
    barWidget.clearTooltip()
  end
end

function update()
  noctalia.setUpdateInterval(2000)
  noctalia.runAsync("systemctl is-active --quiet " .. service, function(result)
    render(result.exitCode == 0)
  end)
end

render(false)
update()
