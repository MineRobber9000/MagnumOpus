local function get(user,repo,branch,file,output)
	local h = http.get(string.format("http://raw.githubusercontent.com/%s/%s/%s/%s",user,repo,branch,file))
	local h2 = fs.open(output,"w")
	h2.write(h.readAll())
	h.close()
	h2.close()
end

local dirs = {"bin","help"}

local files = {
	{"MineRobber9000","MagnumOpus","master","bin/test.lua","bin/test"},
	{"MineRobber9000","MagnumOpus","master","help/test.txt","help/test"}
}

local function makedir(dir)
	if fs.exists(dir) then fs.delete(dir) end
	fs.makeDir(dir)
end

local function foreach(tArgs,mCallback)
	for i=1,#tArgs do
		mCallback(tArgs[i])
	end
end

local function makedirs()
	local function callback(sDir)
		makedir(sDir)
	end
	foreach(dirs,callback)
end

local function getfiles()
	local function callback(tFile)
		get(tFile[1],tFile[2],tFile[3],tFile[4],tFile[5])
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

local function addPath(obj,dir)
	obj.setPath(dir..":"..obj.path())
end

addPath(shell,"/bin")
addPath(help,"/help")
