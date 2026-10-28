-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Apps que abrem ao ligar o PC, cada um no seu workspace (lista em scripts/abrir-workspaces.sh):
-- 1 WezTerm + Neovim, 2 Brave + VS Code, 3 Slack, 4 Chrome + terminal, 5 Sublime, 6 Chromium.
o.exec_on_start("~/.config/hypr/scripts/abrir-workspaces.sh")
