-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Apps que abrem ao ligar o PC, cada um no seu workspace (lista em scripts/abrir-workspaces.sh):
-- 1 herdr, 2 Brave, 3 Chrome (ericsts + ericsts.web), 4 Slack + Chrome (paymetrust), 5 Chrome (Emagine) + Signal.
o.exec_on_start("~/.config/hypr/scripts/abrir-workspaces.sh")
