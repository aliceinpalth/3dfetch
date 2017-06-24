-- Some colors
bgcolor = Color.new(0, 0, 0)
rcolor = Color.new(255, 255, 255)
lcolor = Color.new(0,255,255)
lcolorIndex = 0
rcolorIndex = 0
bgcolorIndex = 0
photoNum = 0
oldpad = 0
lastfp = ""

bitmap = Screen.createImage(1, 1, bgcolor)
Graphics.init()
luma = Graphics.loadImage("romfs:/images/luma.png")
luma_b = Graphics.loadImage("romfs:/images/luma.png") 
luma_g = Graphics.loadImage("romfs:/images/luma_g.png") 
luma_p = Graphics.loadImage("romfs:/images/luma_p.png") 
luma_y = Graphics.loadImage("romfs:/images/luma_y.png") 


timer = Timer.new()
shouldRenderSS = false

-- Some helpers
function printInfo()
	-- Writing left side of screen
	xoffset = 10
	Screen.debugPrint(xoffset,10, getUsernameString(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,25,"-----------",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,55,"Firmware:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,70,"Resolution:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,85,"Kernel:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,100,"CPU:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,115,"Battery:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,130,"Free space:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,160,"Region:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,175,"Date:",lcolor,TOP_SCREEN)

	-- Writing right side of screen
	xoffset = 160
	Screen.debugPrint(xoffset,55,getCFW(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,70,"800x240, 320x240",rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,85,getKernelVer(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,100,getCPUString(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,115,getBatteryStatus(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,130,getFreeSpaceString(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,160,getRegion(),rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,175,date_string,rcolor,TOP_SCREEN)
end

function getMonthString(month)
	monthArray = {"Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"}
	return monthArray[month]
end

function getDayString(day)
	dayArray = {"Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"}
	return dayArray[day]
end

function updateLcolors()
	if lcolorIndex == 0 then
		lcolor = Color.new(0,255,255) -- Pastel blue
		luma = luma_b
	elseif lcolorIndex == 1 then
		lcolor = Color.new(255,244,53) -- Pastel yellow
		luma = luma_y
	elseif lcolorIndex == 2 then
		lcolor = Color.new(96,255,117) -- Pastel green
		luma = luma_g
	elseif lcolorIndex == 3 then
		lcolor = Color.new(255,170,242) -- Pastel pink
		luma = luma_p
	elseif lcolorIndex > 3 then
		lcolor = Color.new(0,255,255) -- Pastel blue
		lcolorIndex = 0
		luma = luma_b
	elseif lcolorIndex < 0 then
		lcolor = Color.new(255,204,247) -- Pastel pink
		lcolorIndex = 3
		luma = luma_p
	end
end

function updateRcolors()
	if rcolorIndex == 0 then
		rcolor = Color.new(255,255,255) -- White
	elseif rcolorIndex == 1 then
		rcolor = Color.new(255,244,53) -- Pastel yellow
	elseif rcolorIndex == 2 then
		rcolor = Color.new(96,255,117) -- Pastel green
	elseif rcolorIndex == 3 then
		rcolor = Color.new(61,61,61) -- Black
	elseif rcolorIndex > 3 then
		rcolor = Color.new(255,255,255) -- White
		rcolorIndex = 0
	elseif rcolorIndex < 0 then
		rcolor = Color.new(61,61,61) -- Black
		rcolorIndex = 3
	end
end

function updateBgcolors()
	if bgcolorIndex == 0 then
		bgcolor = Color.new(0,0,0) -- Black
	elseif bgcolorIndex == 1 then
		bgcolor = Color.new(0,98,137) -- Dark blue
	elseif bgcolorIndex == 2 then
		bgcolor = Color.new(255,255,255) -- White
	elseif bgcolorIndex == 3 then
		bgcolor = Color.new(0,175,96) -- Dark green
	elseif bgcolorIndex > 3 then
		bgcolor = Color.new(0,0,0) -- Black
		bgcolorIndex = 0
	elseif bgcolorIndex < 0 then
		bgcolor = Color.new(0,136,21) -- Dark green
		bgcolorIndex = 3
	end
end

-- IP address
-- This function was only added for potential expandability
function getConsoleIPAddress()
	return Network.getIPAddress()
end

-- 3DS model
model = System.getModel()
modelArray = {"3ds", "3dsXL", "New3ds", "2ds", "New3dsXL", "New2dsXL"}
processorArray = {"ARM11 Duocore", "ARM11 Duocore", "ARM11 Quadcore", "ARM11 Duocore", "ARM11 Quadcore", "ARM11 Quadcore"}
model_string = modelArray[model+1]
processor = processorArray[model+1]

-- Username
function getUsernameString()
	return System.getUsername() .. "@" .. model_string
end

-- Kernel
function getKernelVer()
	majork,minork,revisionk = System.getKernel() 
	return majork .. "." .. minork .. "-" .. revisionk
end

-- Improved CFW Function
-- The Luma Version checking was adapted from astronautlevel2 and his StarUpdater, all credit where it's due
-- Thanks Al <3
function getCFW()
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

		if string.match(fileContent, "skeith") then
			return "Skeith"
		end

		if string.match(fileContent, "corbenik") then
			return "Corbenik"
		end

		if string.match(fileContent, "Rei") then
			return "ReiNAND"
		end

		if string.match(fileContent, "cakes") then
			return "Cakes"
		end

	end

	if System.doesDirectoryExist("/rxTools") or System.doesFileExist("/rxTools.dat") then
		return "rxTools"
	end

	if System.doesDirectoryExist("/reinand") then
		return "ReiNAND"
	end

	if System.doesDirectoryExist("/aureinand") then
		return "AuReiNAND"
	end

	if System.doesDirectoryExist("/luma") then
		return "Luma3DS"
	end

	if System.doesDirectoryExist("/cakes") then
		return "Cakes"
	end
end

-- Firmware -> deprecated
function getLumaVer()
	local majorL,minorL,revisionL = System.getLumaVersion()
	return "Luma v" .. majorL .. "." .. minorL
end

-- Region
function getRegion()
	region = System.getRegion()
	regionArray = {"North America", "Europe", "Japan"}
	return regionArray[region]
end

-- Battery status
function getBatteryStatus()
	if System.isBatteryCharging() then
		return "Charging @ " .. System.getBatteryPercentage() .. "%"
	else
		return "Discharging @ " .. System.getBatteryPercentage() .. "%"
	end
end

-- Date
day_value,day,month,year = System.getDate()
day_value_string = getDayString(day_value)
month_string = getMonthString(month)
date_string = day_value_string .. " " .. month_string .. " " .. day .. ", " .. year

-- CPU Frequency
function getCPUString()
	return processor .. " @ " .. System.getCpuSpeed() .. "hz"
end

-- Free space
function getFreeSpaceString()
	return (math.floor(System.getFreeSpace()/1000000000)) .. " GB"
end

-- Main Loop
while true do

	seconds = math.ceil(Timer.getTime(timer)/1000)

	-- Updating screens
	Screen.refresh()

	Graphics.initBlend(BOTTOM_SCREEN)
	Graphics.fillRect(0,320,0,240, bgcolor)	
	Graphics.drawImage(0, 0, luma) 
	Graphics.termBlend()

	Graphics.initBlend(TOP_SCREEN)
	Graphics.fillRect(0,800,0,240, bgcolor)	
	Graphics.termBlend()

	pad = Controls.read()

	printInfo()

	filepath = ""
	-- Screenshot if A is pressed
	if Controls.check(pad, KEY_A) and not (Controls.check(oldpad,KEY_A)) then
		day_value, day, month, year = System.getDate() -- all ints
		filepath = "/" .. "3dfetch_" .. day .. "_" .. month .. "_" .. year .. "_" .. photoNum
		lastfp = "/" .. "3dfetch_" .. day .. "_" .. month .. "_" .. year .. "_" .. photoNum
		photoNum = photoNum + 1
		Screen.saveImage(bitmap, filepath .. ".jpg", false)
		System.takeScreenshot(filepath .. ".jpg", false)
		shouldRenderSS = true
	end

	-- Cycling lcolors
	if Controls.check(pad, KEY_DRIGHT) and not (Controls.check(oldpad,KEY_DRIGHT)) then
		lcolorIndex = lcolorIndex + 1
		updateLcolors()
	end
	if Controls.check(pad, KEY_DLEFT) and not (Controls.check(oldpad,KEY_DLEFT)) then
		lcolorIndex = lcolorIndex - 1
		updateLcolors()
	end

	-- Cycling rcolors
	if Controls.check(pad, KEY_DUP) and not (Controls.check(oldpad,KEY_DUP)) then
		rcolorIndex = rcolorIndex + 1
		updateRcolors()
	end
	if Controls.check(pad, KEY_DDOWN) and not (Controls.check(oldpad,KEY_DDOWN)) then
		rcolorIndex = rcolorIndex - 1
		updateRcolors()
	end

	-- Cycling bgcolors
	if Controls.check(pad, KEY_R) and not (Controls.check(oldpad,KEY_R)) then
		bgcolorIndex = bgcolorIndex + 1
		updateBgcolors()
	end
	if Controls.check(pad, KEY_L) and not (Controls.check(oldpad,KEY_L)) then
		bgcolorIndex = bgcolorIndex - 1
		updateBgcolors()
	end

	if seconds > 5 then
		shouldRenderSS = false
		timer = Timer.new()
	end

	if shouldRenderSS == true then
		Screen.debugPrint(10,10, "Screenshot saved:",rcolor,BOTTOM_SCREEN)
		Screen.debugPrint(10,25, lastfp,rcolor,BOTTOM_SCREEN)
	end

	-- Flipping screen
	Screen.flip()
	Screen.waitVblankStart()

	oldpad = pad

	-- Sets up HomeMenu syscall
	if Controls.check(Controls.read(),KEY_HOME) or Controls.check(Controls.read(),KEY_POWER) then
		System.showHomeMenu()
	end
	
	-- Exit if HomeMenu calls APP_EXITING
	if System.checkStatus() == APP_EXITING then
		Screen.freeImage(bitmap)
		System.exit()
	end
end
