-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Posição fixa: notebook à esquerda, HP V28 4K (HDMI) à direita.
-- Sem isso, "auto" depende da ordem em que os monitores são detectados no arranque.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale })
-- 2560x1440 é o maior modo 16:9 que o HP aceita pela HDMI (4K não sai por essa porta).
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@59.95", position = "1366x0", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Workspaces por monitor: ímpares (1,3,5,7,9) no notebook, pares (2,4,6,8,10) no HP (HDMI).
-- Com a tampa fechada, o Omarchy desliga o eDP-1 e os ímpares passam para o HP.
for ws = 1, 10 do
  local odd = ws % 2 == 1
  hl.workspace_rule({
    workspace = tostring(ws),
    monitor = odd and "eDP-1" or "HDMI-A-1",
    default = (ws == 1 or ws == 2),
  })
end
