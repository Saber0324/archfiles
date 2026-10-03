--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "cs2-performance-fixes",
	match = { class = "cs2" },

	immediate = true,
	fullscreen = true,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
	idle_inhibit = "focus",

	stay_focused = true,
	suppress_event = "activate",
})

hl.window_rule({
	name = "bo2-performance-fixes",
	match = { class = "plutonium-bootstrapper-win32.exe" },

	immediate = true,
	fullscreen = true,
	no_anim = true,
	no_blur = true,
	no_shadow = true,
	idle_inhibit = "focus",

	stay_focused = true,
	suppress_event = "activate",
})

hl.window_rule({
	name = "hyprland-share-picker-float",
	match = { class = "hyprland-share-picker" },

	float = true,
})
