-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("sleep 5 && openrgb --startminimized --profile 'off'")
end)
