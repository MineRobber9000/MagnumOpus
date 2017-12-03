-- Opus GUI Engine
local gui = {}
local embedded = true -- is the Opus engine being embedded in another program? set to false when loading as separate file.

local header = "Null header"
local nBodyMode = 3
local nMaxBodyMode = 3
local tModeNames = {}
tModeNames.TEXT = 1
tModeNames.MENU = 2
tModeNames.UNSET = nMaxBodyMode
local tModeIds = {"TEXT","MENU"}
local tModeMethodSuffixes = {"Text","Menu"}
tModeIds[nMaxBodyMode] = "UNSET"
tModeIds[nMaxBodyMode+1] = "INVALID"
local sText = "Null text"
local tItems = {"Default menu item"}
local nSelected = 1
local bDrawnBefore = true

gui.modes = tModeNames

gui.addMode = function(sName,fDraw,fUpdate)
	table.insert(tModeMethodSuffixes,sName)
	tModeIds[nMaxBodyMode] = sName:upper()
	tModeNames[sName:upper()] = nMaxBodyMode
	gui.modes[sName:upper()] = nMaxBodyMode
	nMaxBodyMode = nMaxBodyMode+1
	tModeNames.UNSET = nMaxBodyMode
	tModeIds[nMaxBodyMode] = "UNSET"
	tModeIds[nMaxBodyMode+1] = "INVALID"
	gui["draw"..sName]=fDraw
	gui["handleUpdate"..sName]=fUpdate
end

gui.clearScr = function()
	term.clear()
	term.setCursorPos(1,1)
end

gui.setColor = function(c,p)
	if term.isColor() then term["set"..p.."Color"](c) end
end

local function cap(v,c)
	if v > c then return c else return v end
end

gui.invalid_drawstate = function(sError)
	error(string.format("Opus GUI Engine attempted to draw in an invalid state. (%d [MODE_%s] (%s))",nBodyMode,tModeIds[cap(nBodyMode,(nMaxBodyMode+1))],sError),0)
end

local w,h = term.getSize()

gui.draw = function()
	bDrawnBefore = true
	gui.clearScr()
	gui.setColor(colors.yellow,"Text")
	write(sHeader)
	gui.setColor(colors.white,"Text")
	gui.setColor(colors.red,"Background")
	term.setCursorPos(w,1)
	write("X")
	gui.setColor(colors.black,"Background")
	term.setCursorPos(1,3)
	if nBodyMode >= tModeNames.UNSET then gui.invalid_drawstate("Invalid state") end
	gui["draw"..tModeMethodSuffixes[nBodyMode]]()
end

gui.drawText = function()
	--Textmode draw function, fairly easy, print text
	print(sText)
end

gui.drawMenu = function()
	for i=1,#tItems do
		gui.setColor(colors.yellow)
		write(i==nSelected and "> " or "  ")
		gui.setColor(colors.white)
		print(tItems[i])
	end
end

local function tablecontains(tTable, vVar)
	for i=1,#tTable do
		if tTable[i]==vVar then return true end
	end
	return false
end

gui.setMode = function(nMode)
	nBodyMode = nMode
end

local function getKeyName(nKey)
	for k,v in pairs(keys) do
		if v==nKey then return k end
	end
end

gui.update = function()
	if not bDrawnBefore then gui.draw() end
	local method = gui["handleUpdate"..tModeMethodSuffixes[nBodyMode]]
	if not method then gui.invalid_drawstate("Invalid mode") end
	local tEvent = {os.pullEvent()}
	if tEvent[1]=="key" then
		if tablecontains({keys.up,keys.down,keys.left,keys.right},tEvent[2]) then
			--Arrow key
			return method({"key.arrow",getKeyName(tEvent[2])})
		else
			if tEvent[2]==keys.enter then
				--Enter key press
				return method({"key.enter"})
			else
				--Generic keypress (useful for custom modes)
				return method({"key",getKeyName(tEvent[2])})
			end
		end
	end
	if tEvent[1]=="mouse_click" then
		if tEvent[2] == 1 and tEvent[3] == w then
			--Close button
			return method({"click.close"})
		else
			--Click event
			return method({"click",tEvent[2],tEvent[3]})
		end
	end
	return "continue" -- let calling app recall update if no proper event is found
end

gui.handleUpdateText = function(tUpdate)
	local sEvent, p1, p2 = table.unpack(tUpdate,1,3)
	if sEvent == "click.close" then return "close" end -- return "close" when closed by user
	if tablecontains({"click","key.enter"},sEvent) then return "enter" end -- continue with text when enter key pressed or screen clicked
end

local tOffsets = {}
tOffsets.up = -1
tOffsets.left = 0
tOffsets.right = 0
tOffsets.down = 1

gui.handleUpdateMenu = function(tUpdate)
	local sEvent, p1, p2 = table.unpack(tUpdate,1,3)
	if sEvent == "click.close" then return "close" end -- return "close" when closed by user
	if sEvent == "key.arrow" then
		nSelected = nSelected + tOffsets[p1]
	end
	if sEvent == "key.enter" then
		return tItems[nSelected]
	end
	if nSelected<1 then nSelected = 1 end
	if nSelected>#tItems then nSelected = #tItems end
	return "continue" -- return "continue", let calling app recall gui.update
end

gui.setHeader = function(sHeaderA)
	if sHeaderA~=nil and type(sHeaderA)~="string" then
		error("Bad argument #1 (expected string/nil, got "..type(sHeaderA)..")")
	end
	if sHeaderA==nil then
		sHeader = "Null header"
	else
		sHeader = sHeaderA
	end
end

gui.setText = function(sTextA)
	if sTextA~=nil and type(sTextA)~="string" then
		error("Bad argument #1 (expected string/nil, got "..type(sTextA)..")")
	end
	if sTextA==nil then
		sText = "Null text"
	else
		sText = sTextA
	end
end

gui.setMenuItems = function(tMenuA)
	if type(tMenuA)~="table" then
		error("Bad argument #1 (expected string/nil, got "..type(tMenuA)..")")
	end
	tItems = tMenuA
end

if embedded then return gui end

