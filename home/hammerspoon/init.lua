hs = hs
local utils = require("utils")

hs.hotkey.bind({ "cmd", "alt" }, "R", function()
	hs.reload()
end)
hs.alert.show("Config loaded")

-- Quick-capture a task into index.md
hs.hotkey.bind({ "cmd", "alt" }, "T", function()
	local button, text = hs.dialog.textPrompt("Quick Task", "", "", "Add", "Cancel")
	if button == "Add" and text ~= "" then
		local task = hs.task.new("/opt/homebrew/bin/obsidian", function(exitCode, stdOut, stdErr)
			if exitCode ~= 0 then
				hs.alert.show("Failed to capture task: " .. (stdErr or ""))
			else
				hs.alert.show("Task captured")
			end
		end, { "append", "path=index.md", "content=- [ ] " .. text })
		task:start()
	end
end)

-- Copy selected and append to daily note
hs.hotkey.bind({ "cmd", "alt" }, "C", function()
	utils.copySelected(function(clipboardText, err)
		if err then
			hs.alert.show("Error: " .. err)
		else
			local today = os.date("%Y-%m-%d")
			local notePath = obsidianDailyNotePath .. today .. ".md"

			utils.bounceAppIcon("Obsidian")

			err = utils.writeToDocument(clipboardText, notePath)
			if err then
				hs.alert.show("Failed to write to note: " .. err)
			end
		end
	end)
end)

-- Search clipboard text in browser (⌘⌥S)
local ok, SearchClipboard = pcall(dofile, (hs.configdir or ".") .. "/Spoons/SearchClipboard.spoon/init.lua")
if ok and SearchClipboard then
	hs.hotkey.bind({ "cmd", "alt" }, "S", function()
		SearchClipboard:searchClipboard()
	end)
else
	hs.alert.show("SearchClipboard spoon failed to load")
end
