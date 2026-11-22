local home = os.getenv("HOME")
local path = os.getenv("OBSIDIAN_DAILY_NOTE_PATH")
local env = io.open(home .. "/.dotfiles/.env", "r")
if env then
	for line in env:lines() do
		local value = line:match("^OBSIDIAN_DAILY_NOTE_PATH=(.*)$")
		if value then
			path = value
		end
	end
	env:close()
end

if not path or path == "" then
	path = "~/Documents/GoogleSync/Notes/Notes/4-Archive/Journaling"
end
path = path:gsub("^~/", function()
	return home .. "/"
end):gsub("/+$", "") .. "/"

return {
	obsidianDailyNotePath = path,
}
