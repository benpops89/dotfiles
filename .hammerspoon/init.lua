function openAndMaximizeObsidian(pageName)
	-- Open specifid page or default to Daily note

	local day = os.date("%Y-%m-%d")
	pageName = pageName or ("4.Reviews/0.Daily/" .. day)

	-- Open Obsidian at that page
	local url = "obsidian://open?vault=vault&file=" .. hs.http.encodeForQuery(pageName)
	hs.urlevent.openURL(url)

	-- hs.application.launchOrFocus("Obsidian")

	-- Wait for Obsidian to appear and set screen size
	hs.timer.doAfter(0.5, function()
		local obsidian = hs.application.find("Obsidian")
		local obsidianWindow = obsidian:mainWindow()

		-- Set the screen size
		local screenFrame = obsidianWindow:screen():frame()
		local newFrame = {
			x = screenFrame.x,
			y = screenFrame.y,
			w = screenFrame.w * 0.75, -- 75% of screen width
			h = screenFrame.h, -- Full height
		}

		obsidianWindow:setFrame(newFrame)
	end)
end

-- Define hotkey bindings and setup
hotkeyBindings = {
	{ "O", openAndMaximizeObsidian },
}

for _, shortcut in ipairs(hotkeyBindings) do
	hs.hotkey.bind({ "cmd", "alt", "ctrl" }, shortcut[1], shortcut[2])
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)

-- Open Obsidian every Friday
hs.timer.doAt("16:00", "1d", function()
	local day = os.date("*t").wday
	if day == 6 then
		local week = os.date("%Y-W%V")
		openAndMaximizeObsidian("4.Reviews/1.Weekly/" .. week)
	end
end)
