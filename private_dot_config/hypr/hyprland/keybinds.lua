---------------------
---- KEYBINDINGS ----
---------------------

local vars = require("variables")
local mainMod = "SUPER"
local mainModShift = "SUPER + SHIFT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- 0. workspaces.
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	-- Switch workspaces with mainMod + [0-9]
	hl.bind(
		mainMod .. " + " .. key,
		hl.dsp.focus({ workspace = i }),
		{ description = "Switch focus to workspace " .. key }
	)
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move active window to workspace " .. key }
	)
end

-- 1. Window management.
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Move focus to the left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus to the right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating windows" })

-- Maximize toggle
hl.bind(mainMod .. " + M", hl.dsp.layout("colresize +conf"), { description = "Toggles the size of the active window" })

-- fullscreen toggle.
hl.bind(
	mainMod .. " + F",
	hl.dsp.window.fullscreen({ action = "toggle" }),
	{ description = "Toggles fullscreen for the active window" }
)

-- Toggle dwindle/scrolling
hl.bind(mainMod .. " + CTRL + S", function()
	local current = hl.get_config("general.layout")
	if current == "dwindle" then
		hl.config({ general = { layout = "scrolling" } })
	else
		hl.config({ general = { layout = "dwindle" } })
	end
end, { description = "Toggles between scrolling and tiling layouts" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Goes up one workspace with the mouse scroll up" }
)

hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Goes down one workspace with the mouse scroll down" }
)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drags the window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resizes the window" })

-- 2. Applications.
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager), { description = "Opens the file manager" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(vars.code), { description = "Opens the text editor" })
hl.bind(mainMod .. "+ RETURN", hl.dsp.exec_cmd(vars.terminal), { description = "Opens the terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(vars.browser), { description = "Opens the browser" })

-- 3. Noctalia panels.
hl.bind(mainModShift .. " + RETURN", hl.dsp.exec_cmd(vars.menu), { description = "Opens the app launcher" })
hl.bind(mainModShift .. " + V", hl.dsp.exec_cmd(vars.clipboard), { description = "Opens the clipboard" })
hl.bind(mainModShift .. " + ESCAPE", hl.dsp.exec_cmd(vars.power_menu), { description = "Opens the power menu" })
hl.bind(
	mainModShift .. "+ SLASH",
	hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
	{ description = "Open the keybind cheatsheet" }
)

-- 4. Screenshots
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'),
	{ description = "Takes a screenshot of a region of the screen" }
)

hl.bind(
	"SUPER + S",
	hl.dsp.exec_cmd("hyprshot -z -m output -m active --clipboard-only"),
	{ description = "Takes a screenshhot of the active window" }
)

-- 5. Volume.
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true, description = "Raises the volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true, description = "Lowers the volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true, description = "Mutes the audio" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true, description = "Mutes the microphone" }
)

-- 6. Music controls.
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Next" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Previous" })

-- 7. Brightness.
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
	{ locked = true, repeating = true, description = "Raises the brightness" }
)

hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
	{ locked = true, repeating = true, description = "Lowers the brightness" }
)
