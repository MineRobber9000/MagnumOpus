-- Main functionality (basic shell)

local function setColor(c)
	if term.isColor() then term.setTextColor(c) end
end

term.clear()
os.version = function() return "MagnumOpus v0.1" end
setColor(colors.yellow)
print(os.version())

local tCommandHistory = {}

while true do
	setColor(colors.yellow)
	write(shell.dir().."> ")
    local sLine
    if settings.get( "shell.autocomplete" ) then
		sLine = read( nil, tCommandHistory, shell.complete )
    else
		sLine = read( nil, tCommandHistory )
    end
	shell.run(sLine)
end
