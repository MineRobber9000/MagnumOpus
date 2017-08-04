-- Version checker (allows for separate version functionality)

local ccversion = 0 --assume bottom of barrel (really outdated CC)
if type(term.native)=="function" then -- >= CC 1.6
	ccversion = 1
end
if term.getTextColor~=nil then -- >= CC 1.7
	ccversion = 2
end
if term.getPaletteColor~=nil then -- >= CC 1.8 (unreleased as of yet)
	ccversion = 3
end
