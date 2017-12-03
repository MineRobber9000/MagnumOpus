-- Main functionality (basic shell)

term.clear()
term.setCursorPos(1,1)

os.version = function() return "MagnumOpus v0.1" end
gui.setColor(colors.yellow,"Text")
print(os.version())

local tCommandHistory = {}
local bRunning = true

while bRunning do
	gui.setColor(colors.yellow,"Text")
	write(shell.dir().."> ")
	gui.setColor(colors.white,"Text")
    local sLine
    if settings.get( "shell.autocomplete" ) then
		sLine = read( nil, tCommandHistory, shell.complete )
    else
		sLine = read( nil, tCommandHistory )
    end
	if shell.resolveProgram(sLine)=="rom/programs/exit" then
		bRunning = false
	else
		table.insert(tCommandHistory,sLine)
		shell.run(sLine)
	end
end