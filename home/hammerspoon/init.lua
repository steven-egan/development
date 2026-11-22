hs = hs
local utils = require("utils")
local config = require("config")

hs.hotkey.bind({ "cmd", "alt" }, "R", function()
	hs.reload()
end)
hs.alert.show("Config loaded")

-- Quick-capture a task into index.md
hs.hotkey.bind({ "cmd", "alt" }, "T", function()
	local button, text = hs.dialog.textPrompt("Quick Task", "", "", "Add", "Cancel")
	if button == "Add" and text ~= "" then
		local cli = hs.fs.attributes("/opt/homebrew/bin/obsidian") and "/opt/homebrew/bin/obsidian"
			or "/usr/local/bin/obsidian"
		local task = hs.task.new(cli, function(exitCode, stdOut, stdErr)
			if exitCode ~= 0 then
				hs.alert.show("Failed to capture task: " .. (stdErr or ""))
			else
				hs.alert.show("Task captured")
			end
		end, { "append", "path=index.md", "content=- [ ] " .. text })
		if not task or not task:start() then
			hs.alert.show("Could not start Obsidian CLI; enable it in Obsidian settings")
		end
	end
end)

-- Copy selected and append to daily note
hs.hotkey.bind({ "cmd", "alt" }, "C", function()
	utils.copySelected(function(clipboardText, err)
		if err then
			hs.alert.show("Error: " .. err)
		else
			local today = os.date("%Y-%m-%d")
			local notePath = config.obsidianDailyNotePath .. today .. ".md"

			utils.bounceAppIcon("Obsidian")

			err = utils.writeToDocument(clipboardText, notePath)
			if err then
				hs.alert.show("Failed to write to note: " .. err)
			end
		end
	end)
end)

-- Search clipboard text in the default browser.
hs.hotkey.bind({ "cmd", "alt" }, "S", function()
	local text = hs.pasteboard.getContents()
	if not text or text == "" then
		hs.alert.show("Clipboard has no text")
		return
	end
	hs.urlevent.openURL("https://www.google.com/search?q=" .. hs.http.encodeForQuery(text))
end)
