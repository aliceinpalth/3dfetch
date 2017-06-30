-- Some colors
colors =
{
	background = Color.new(0, 0, 0),
	right = Color.new(255, 255, 255),
	left = Color.new(0, 255, 255),
	red = Color.new(255, 0, 0),
	green = Color.new(0, 255, 0)
}

-- Configuration option
local configs =
{
	showAnimation = true,
	showSplash = true,
	showCFW = true
}

-- Configuration path
configPath = "/3dfetch.conf"

-- Indexes
colorIndex =
{
	background = 0,
	right = 0,
	left = 0
}

-- Global variables
fetchVer = 1.10
photoNum = 0
oldPad = 0
lastfp = 0
timer = Timer.new()
shouldRenderSS = false
isMenuOpen = false

-- Load default graphics
Graphics.init()

-- Images
logos = 
{
	default = Graphics.loadImage("romfs:/images/isabelle.png"),
	blue = Graphics.loadImage("romfs:/images/isabelle.png"),
	green = Graphics.loadImage("romfs:/images/isabelle.png"),
	pink = Graphics.loadImage("romfs:/images/isabelle.png"),
	yellow = Graphics.loadImage("romfs:/images/isabelle.png")
}

-- Rectangles!
local OPTION_RECT_SIZE 	= {x = 80, y = 66}
local MENU_RECT_SIZE	= {x = 60, y = 26}

-- Append a line to a file
function writeLine(filePath, fileString)
    local file = io.open(filePath, FCREATE)
    local content = io.read(file, 0, io.size(file))..fileString
    io.write(file, 0, content, string.len(content))
    io.close(file)
end

-- Config code written by Al, all of these functions
function readConfig(filePath)
	local fileContent = ""
	
	if System.doesFileExist(filePath) then
		local file = io.open(filePath, 0)
		fileContent = io.read(file, 0, io.size(file))
		io.close(file)
	end
	
	fileContent = string.gsub(fileContent, "\r", "") --Remove windows characters
	if(string.sub(fileContent, -1) == "\n") then fileContent = string.sub(fileContent, 1, -2) end
	return fileContent
end

function setConfigs(configFileContent)
	local configStrings = {System.split(configFileContent, "\n")}
	for key,value in pairs(configStrings) do
		local configPair = {System.split(value, ":")}
		local configOption = ""
		if (string.find(configPair[1], "\x00") ~= nil) then
			configOption = string.sub(configPair[1], 1, string.find(configPair[1], "\x00", 1) - 1)
		else
			configOption = configPair[1]
		end
		configs[configOption] = "true" == configPair[2]
	end

end

function writeConfig(filePath)
	if System.doesFileExist(filePath) then System.deleteFile(filePath) end

	for option,value in pairs(configs) do writeLine(filePath, option..":"..value.."\n") end
end

-- Text output to top screen
function printTopLeftSide()
	local xoffset = 10

	Screen.debugPrint(xoffset, 10, string.lower(getUsernameString()) .. "@" .. string.lower(getCPUString(1)), colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 25, "-----------", colors.left, TOP_SCREEN)
	if configs.showCFW then Screen.debugPrint(xoffset, 55, "Firmware:", colors.left, TOP_SCREEN) end
	Screen.debugPrint(xoffset, 70, "Resolution:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 85, "Kernel:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 100, "CPU:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 115, "Battery:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 130, "Free space:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 160, "Region:", colors.left, TOP_SCREEN)
	Screen.debugPrint(xoffset, 175, "Date:", colors.left, TOP_SCREEN)
end

function printTopRightSide()
	local xoffset = 160

	if configs.showCFW then Screen.debugPrint(xoffset, 55, getCFWString(), colors.right, TOP_SCREEN) end
	Screen.debugPrint(xoffset, 70, "800x240, 320x240", colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 85, getKernelVersionString(), colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 100, getCPUString(2), colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 115, getBatteryStatusString(), colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 130, getFreeSpaceString(), colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 160, getRegionString(), colors.right, TOP_SCREEN)
	Screen.debugPrint(xoffset, 175, getDateString(), colors.right, TOP_SCREEN)
end

-- Next 3 functions take care of the current date
function getMonthString(month)
	local monthArray = 
	{
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	}

	return monthArray[month]
end

function getDayString(day)
	local dayArray =
	{
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday",
		"Sunday"
	}

	return dayArray[day]
end

function getDateString()
	local dayValue, day, month, year = System.getDate()
	return getDayString(dayValue) .. " " .. getMonthString(month) .. " " .. day .. ", " .. year
end

function getUsernameString()
	return System.getUsername()
end

function getCPUString(value)
	model = System.getModel()

	local modelArray =
	{
		"3ds",
		"3dsXL",
		"New3DS",
		"2DS",
		"New3DSXL",
		"New2DSXL"
	}

	local processorArray =
	{
		"ARM11 Duocore",
		"ARM11 Duocore",
		"ARM11 Quadcore",
		"ARM11 Duocore",
		"ARM11 Quadcore",
		"ARM11 Quadcore",
	}
	
	if value == 1 then 
		return modelArray[model + 1]
	elseif value == 2 then
		return processorArray[model + 1] .. " @ " .. System.getCpuSpeed() .. "hz"
	else
		return modelArray[model + 1], processorArray[model + 1]
	end
end

function getRegionString()
	regionNumber = System.getRegion()

	local regionArray =
	{
		"North America",
		"Europe",
		"Japan"
	}

	return regionArray[regionNumber]
end

function getKernelVersionString()
	local majorK, minorK, revisionK = System.getKernel()
	return majorK .. "." .. minorK .. "." .. revisionK
end

function getBatteryStatusString()
	if System.isBatteryCharging() then return "Charging @ " .. System.getBatteryPercentage() .. "%" else
					 return "Discharging @ " .. System.getBatteryPercentage() .. "%" end
end

function getFreeSpaceString()
	return (math.floor(System.getFreeSpace()/1e9)) .. "GB"
end

-- Improved CFW Function
-- The Luma Version checking was adapted from astronautlevel2 and his StarUpdater, all credit where it's due
-- Thanks Al <3
function getCFWString()
	local majorL,minorL,revisionL = System.getLumaVersion()
	local fileContent = ""

	if majorL ~= 0 then
		return "Luma3DS v" .. majorL .. "." .. minorL
	end

	if System.doesFileExist("/boot.firm") then
		local file = io.open("/boot.firm", 0)
		fileContent = io.read(file,0,io.size(file))
		io.close(file)
	elseif System.doesFileExist("/arm9loaderhax.bin") then
		local file = io.open("/arm9loaderhax.bin", 0)
		fileContent = io.read(file,0,io.size(file))
		io.close(file)
	end

	if string.match(fileContent, "Luma3DS") then
		local searchString = "Luma3DS v"
	      	local verString = "v"
      		local isDone = false
		local offset = string.find(fileContent, searchString)

	        if (offset ~= nil) then
        	        offset = offset + string.len(searchString)
			while(isDone == false) do
		                bitRead = fileContent:sub(offset,offset)	
				if bitRead == " " then
					isDone = true
				else
					verString = verString..bitRead
				end
				offset = offset + 1
			end
			return "Luma3DS " .. verString
		end
	
	elseif string.match(fileContent, "skeith") then	return "Skeith"
	elseif string.match(fileContent, "corbenik") then return  "Corbenik"
	elseif string.match(fileContent, "Rei") then return "ReiNAND"
	elseif string.match(fileContent, "cakes") then return "Cakes"
	end


	if System.doesDirectoryExist("/rxTools") or System.doesFileExist("/rxTools.dat") then return "rxTools"
	elseif System.doesDirectoryExist("/rei") then return "ReiNAND"
	elseif System.doesDirectoryExist("/aurei") then return "AuReiNAND"
	elseif System.doesDirectoryExist("/luma") then return "Luma3DS"
	elseif System.doesDirectoryExist("/cakes") then return "Cakes"
	end
end

function updateColors()
	if colorIndex.left == 0 then
		colors.left = Color.new(0,255,255) -- Pastel blue
		logos.default = logos.blue
	elseif colorIndex.left == 1 then
		colors.left = Color.new(255,244,53) -- Pastel yellow
		logos.default = logos.yellow
	elseif colorIndex.left == 2 then
		colors.left = Color.new(96,255,117) -- Pastel green
		logos.default = logos.green
	elseif colorIndex.left == 3 then
		colors.left = Color.new(255,170,242) -- Pastel pink
		logos.default = logos.pink
	elseif colorIndex.left > 3 then
		colors.left = Color.new(0,255,255) -- Pastel blue
		colorIndex.left = 0
		logos.default = logos.blue
	elseif colorIndex.left < 0 then
		colors.left = Color.new(255,204,247) -- Pastel pink
		colorIndex.left = 3
		logos.default = logos.pink
	end
	
	if colorIndex.right == 0 then
		colors.right = Color.new(255,255,255) -- White
	elseif colorIndex.right == 1 then
		colors.right = Color.new(255,244,53) -- Pastel yellow
	elseif colorIndex.right == 2 then
		colors.right = Color.new(96,255,117) -- Pastel green
	elseif colorIndex.right == 3 then
		colors.right = Color.new(61,61,61) -- Black
	elseif colorIndex.right > 3 then
		colors.right = Color.new(255,255,255) -- White
		colorIndex.right = 0
	elseif colorIndex.right < 0 then
		colors.right = Color.new(61,61,61) -- Black
		colorIndex.right = 3
	end
	
	if colorIndex.background == 0 then
		colors.background = Color.new(0,0,0) -- Black
	elseif colorIndex.background == 1 then
		colors.background = Color.new(0,98,137) -- Dark blue
	elseif colorIndex.backrgound == 2 then
		colors.background = Color.new(255,255,255) -- White
	elseif colorIndex.background == 3 then
		colors.background = Color.new(0,175,96) -- Dark green
	elseif colorIndex.background > 3 then
		colors.background = Color.new(0,0,0) -- Black
		colorIndex.background = 0
	elseif colorIndex.background < 0 then
		colors.background = Color.new(0,136,21) -- Dark green
		colorIndex.background = 3
	end
end

function initCFWLogo()
	local cfw = getCFWString()

	if string.match(cfw, "Luma") then
		logos.default = Graphics.loadImage("romfs:/images/luma.png")
		logos.blue = Graphics.loadImage("romfs:/images/luma.png") 
		logos.green = Graphics.loadImage("romfs:/images/luma_g.png") 
		logos.pink = Graphics.loadImage("romfs:/images/luma_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/luma_y.png")
	elseif string.match(cfw,"AuReiNAND") then
		logos.default = Graphics.loadImage("romfs:/images/luma.png")
		logos.blue = Graphics.loadImage("romfs:/images/luma.png") 
		logos.green = Graphics.loadImage("romfs:/images/luma_g.png") 
		logos.pink = Graphics.loadImage("romfs:/images/luma_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/luma_y.png")
	elseif string.match(cfw, "Rei") then -- thanks datcom
		logos.default = Graphics.loadImage("romfs:/images/rei.png")
		logos.blue = Graphics.loadImage("romfs:/images/rei.png") 
		logos.green = Graphics.loadImage("romfs:/images/rei_g.png") 
		logos.pink = Graphics.loadImage("romfs:/images/rei_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/rei_y.png") 
	elseif string.match(cfw, "rxTools") then -- thanks Al
		logos.default = Graphics.loadImage("romfs:/images/rx.png")
		logos.blue = Graphics.loadImage("romfs:/images/rx.png") 
		logos.green = Graphics.loadImage("romfs:/images/rx_g.png")
		logos.pink = Graphics.loadImage("romfs:/images/rx_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/rx_y.png")
	elseif string.match(cfw, "Cakes") then 
		logos.default = Graphics.loadImage("romfs:/images/cakes.png")
		logos.blue = Graphics.loadImage("romfs:/images/cakes.png") 
		logos.green = Graphics.loadImage("romfs:/images/cakes_g.png")
		logos.pink = Graphics.loadImage("romfs:/images/cakes_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/cakes_y.png")
	elseif string.match(cfw, "Skeith") or string.match(cfw, "Corbenik") then
		logos.default = Graphics.loadImage("romfs:/images/corbenik.png")
		logos.blue = Graphics.loadImage("romfs:/images/corbenik.png") 
		logos.green = Graphics.loadImage("romfs:/images/corbenik_g.png") 
		logos.pink = Graphics.loadImage("romfs:/images/corbenik_p.png") 
		logos.yellow = Graphics.loadImage("romfs:/images/corbenik_y.png")
	end

end

function animatePrint(string, time)
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(10,10,string, colors.right, TOP_SCREEN)
	Screen.flip()
	System.sleep(time)
end

function animateInvocation()	
	local ps = string.lower(getUsernameString()) .. "@" .. string.lower(getCPUString(1)) .. " ~ $ "
	local commandString = "3dfetch_"

	Screen.refresh()
	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.fillRect(0, 320, 0, 240, colors.background)
	Graphics.termBlend()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)

	for i=1,string.len(commandString) do
		animatePrint(ps..string.sub(commandString,1,i), 2)
	end
       	 
	animatePrint(ps .. "3dfetch", 2)
	animatePrint(ps .. "3dfetch_", 2)
	animatePrint(ps .. "3dfetch", 2)
	animatePrint(ps .. "3dfetch_", 2)

	System.sleep(4)
end

function drawCFWLogo()
	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.fillRect(0,320,0,240,colors.background)
	Graphics.drawImage(0,0,logos.default)
	Graphics.termBlend()
end

function showMenu()
	animatePrint("topkek", 30)
	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.fillRect(0, 320, 0, 240, colors.background)
	Graphics.termBlend()
	local cur_x = 20
	local cur_y = 20
	local optionRects = {}
	Screen.refresh()

	for option,value in pairs(configs) do
		optionRects[option] = {val = value, x = cur_x, y = cur_y, end_x = cur_x + OPTION_RECT_SIZE["x"], end_y = cur_y + OPTION_RECT_SIZE["y"]}
		cur_x = cur_x + OPTION_RECT_SIZE["x"]
		if (cur_x > 300) then 
			cur_x = 20
			cur_y = cur_y + OPTION_RECT_SIZE["y"]
		end

		currentRect = optionRects[option]
		local color = ""
		if value == true then color = colors.green else color = colors.red end
		Screen.fillRect(currentRect["x"], currentRect["end_x"], currentRect["y"], currentRect["end_y"], color, BOTTOM_SCREEN)
		Screen.debugPrint(currentRect["x"], (currentRect["y"] + currentRect["end_y"]) / 2, option, colors.background, BOTTOM_SCREEN)
	end

	Screen.debugPrint(8, 217, "3dfetch Version: " .. tostring(fetchVer), colors.left, BOTTOM_SCREEN)

	Screen.flip()

	local pad = Controls.read()

	while not (Controls.check(pad, KEY_SELECT)) do 
		pad = Controls.read()
	end
	animatePrint("bottom kek", 30)
end

function takeScreenshot()
	local day_value, day, month, year = System.getDate()
	local hours, minutes, seconds = System.getTime()
	local filepath = "/" .. "3dfetch_" .. day .. month  .. year .. "_" .. hours .. minutes .. seconds
	lastfp = filepath
	
	System.takeScreenshot(filepath .. ".jpg", false)
	shouldRenderSS = true
end

-- Last function calls before main loop engages
initCFWLogo()
configContent = readConfig(configPath)
if (configContent ~= "") then setConfigs(configContent) end -- if configFile is empty we just use defaults
if (configs["showAnimation"]) then animateInvocation() end

-- Main loop
while true do
	seconds = math.ceil(Timer.getTime(timer)/1000)

	Screen.refresh()

	if configs.showSplash then drawCFWLogo() end

	Graphics.initBlend(TOP_SCREEN)
	Graphics.fillRect(0, 800, 0, 240, colors.background)
	Graphics.termBlend()

	pad = Controls.read()

	printTopLeftSide()
	printTopRightSide()

	if Controls.check(pad, KEY_A) and not (Controls.check(oldpad,KEY_A)) then
		takeScreenshot()
	end
	
	-- Menu open
	if Controls.check(pad, KEY_SELECT) and not (Controls.check(oldpad, KEY_SELECT)) then
		showMenu()
	end

	-- Cycling lcolors
	if Controls.check(pad, KEY_DRIGHT) and not (Controls.check(oldpad,KEY_DRIGHT)) then
		colorIndex.left = colorIndex.left + 1
		updateColors()
	end
	if Controls.check(pad, KEY_DLEFT) and not (Controls.check(oldpad,KEY_DLEFT)) then
		colorIndex.left = colorIndex.left - 1
		updateColors()
	end

	-- Cycling rcolors
	if Controls.check(pad, KEY_DUP) and not (Controls.check(oldpad,KEY_DUP)) then
		colorIndex.right = colorIndex.right + 1
		updateColors()
	end
	if Controls.check(pad, KEY_DDOWN) and not (Controls.check(oldpad,KEY_DDOWN)) then
		colorIndex.right = colorIndex.right - 1
		updateColors()
	end

	-- Cycling bgcolors
	if Controls.check(pad, KEY_R) and not (Controls.check(oldpad,KEY_R)) then
		colorIndex.background = colorIndex.background + 1
		updateColors()
	end
	if Controls.check(pad, KEY_L) and not (Controls.check(oldpad,KEY_L)) then
		colorIndex.background = colorIndex.background - 1
		updateColors()
	end

	if seconds > 5 then
		shouldRenderSS = false
		timer = Timer.new()
	end

	if shouldRenderSS == true then
		Screen.debugPrint(10, 10, "Screenshot saved:", colors.right, BOTTOM_SCREEN)
		Screen.debugPrint(10, 25, lastfp, colors.right, BOTTOM_SCREEN)
	end

	-- Flipping screen
	Screen.flip()
	Screen.waitVblankStart()

	oldpad = pad

	-- Sets up HomeMenu syscall
	if Controls.check(Controls.read(),KEY_HOME) or Controls.check(Controls.read(),KEY_POWER) then
		System.showHomeMenu()
	end

	if Controls.check(pad, KEY_START) then System.exit() end

	-- Exit if HomeMenu calls APP_EXITING
	if System.checkStatus() == APP_EXITING then
		System.exit()
	end
end
