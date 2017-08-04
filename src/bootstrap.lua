-- Bootstrap! Downloads programs and sets 

local function get(user,repo,branch,file,output)
	local h = http.get(string.format("https://raw.githubusercontent.com/%s/%s/%s/%s",user,repo,branch,file))
	local h2 = fs.open(output,"w")
	h2.write(h.readAll())
	h.close()
	h2.close()
end

local dirs = {"bin"}

local binarypaths = {true}

local files = {
	{"MineRobber9000","MagnumOpus","master","bin/test.lua","bin/test"}
}

local function makedir(dir)
	if fs.exists(dir) then fs.delete(dir) end
	fs.makeDir(dir)
end

local function foreach(tArgs,mCallback)
	for i=1,#tArgs do
		mCallback(i,tArgs[i])
	end
end

local function makedirs()
	local function callback(i,sDir)
		makedir(sDir)
	end
	foreach(dirs,callback)
end

local function getfiles()
	local function callback(i,tFile)
		get(tFile[1],tFile[2],tFile[3],tFile[4],tFile[5]..(ccversion<3 and "" or ".lua"))
	end
	foreach(files,callback)
end

if not fs.exists(".notbootstrapped") then --if being bootstrapped, download everything needed (currently nothing)
	makedirs()
	makefiles()	
	local h = fs.open(".notbootstrapped","w")
	h.writeLine("DO NOT REMOVE THIS FILE!")
	h.writeLine("If you do, all MagnumOpus binaries will be re-downloaded.")
	h.close()
end

local function addPath(dir)
	shell.setPath(dir..":"..shell.path())
end

local function addbinarypaths()
	local function callback(i,sDir)
		if binarypaths[i] then addPath(sDir) end
	end
	foreach(dirs,callback)
end

