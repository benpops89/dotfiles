function openAndMaximizeObsidian(pageName)
	-- Open specifid page or default to Daily note

	local day = os.date("%Y-%m-%d")
	pageName = pageName or ("4.Reviews/0.Daily/" .. day)

	-- Open Obsidian at that page
	local url = "obsidian://open?vault=vault&file=" .. hs.http.encodeForQuery(pageName)
	hs.spaces.gotoSpace(1)
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
	hs.spotify.playTrack("spotify:track:3MrRksHupTVEQ7YbA0FsZK")
	hs.spaces.gotoSpace(1)
end)

-- Daily Review Automation
hs.timer.doAt("16:10", "1d", function()
	local date = os.date("*t")
	if date.wday >= 2 and date.wday <= 6 then
		hs.spotify.playTrack("spotify:track:3MrRksHupTVEQ7YbA0FsZK")
		hs.notify.new({ title = "Closedown Routine", informativeText = "It's time to review the day" }):send()
		openAndMaximizeObsidian("4.Reviews/1.Weekly/" .. os.date("%Y-%m-%d"))
	end
end)

-- Weekly Review Automation
hs.timer.doAt("16:00", "1d", function()
	local day = os.date("*t").wday
	if day == 6 then
		local week = os.date("%Y-W%V")
		openAndMaximizeObsidian("4.Reviews/1.Weekly/" .. week)
	end
end)
