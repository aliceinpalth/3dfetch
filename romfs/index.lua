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
	Screen.debugPrint(xoffset,10, username,rcolor,TOP_SCREEN)
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
	Screen.debugPrint(xoffset,55,firmware_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,70,"800x240, 320x240",rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,85,kernel_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,100,freq_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,115,is_charging_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,130,free_space,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,160,region_string,rcolor,TOP_SCREEN)
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
ip = Network.getIPAddress()

-- 3DS model
model = System.getModel()
modelArray = {"3ds", "3dsXL", "New3ds", "2ds", "New3dsXL", "New2dsXL"}
processorArray = {"ARM11 Duocore", "ARM11 Duocore", "ARM11 Quadcore", "ARM11 Duocore", "ARM11 Quadcore", "ARM11 Quadcore"}
model_string = modelArray[model+1]
processor = processorArray[model+1]

-- Username
username = System.getUsername()
username = username .. "@" .. model_string

-- Kernel
majork,minork,revisionk = System.getKernel() 
kernel_string = majork .. "." .. minork .. "-" .. revisionk

-- Firmware
majorL,minorL,revisionL = System.getLumaVersion()
firmware_string = "Luma v" .. majorL .. "." .. minorL

-- Region
region = System.getRegion()
regionArray = {"North America", "Europe", "Japan"}
region_string = regionArray[region]

-- Battery status
is_charging = System.isBatteryCharging()
batteryPercent = System.getBatteryPercentage()
is_charging_string = ""
if is_charging then
	is_charging_string = is_charging_string .. "Charging @ " .. batteryPercent .. "%"
else
	is_charging_string = is_charging_string .. "Discharging @ " .. batteryPercent .. "%"
end

-- Date
day_value,day,month,year = System.getDate()
day_value_string = getDayString(day_value)
month_string = getMonthString(month)
date_string = day_value_string .. " " .. month_string .. " " .. day .. ", " .. year

-- CPU Frequency
freq = System.getCpuSpeed()
freq_string = processor .. " @ " .. freq .. " hz"

-- Free space
free_space = (math.floor(System.getFreeSpace()/1000000000)) .. " GB"

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
