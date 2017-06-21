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

timer = Timer.new()
shouldRenderSS = false

-- Some helpers
function printInfo()
	-- Writing left side of screen
	xoffset = 10
	Screen.debugPrint(xoffset,10, username,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,25,"---------",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,55,"Resolution:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,70,"Kernel:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,85,"CPU:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,100,"Battery:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,115,"Free space:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,145,"Region:",lcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,160,"Date:",lcolor,TOP_SCREEN)

	-- Writing right side of screen
	xoffset = 160
	Screen.debugPrint(xoffset,55,"800x240, 320x240",rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,70,kernel_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,85,freq_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,100,is_charging_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,115,free_space,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,145,region_string,rcolor,TOP_SCREEN)
	Screen.debugPrint(xoffset,160,date_string,rcolor,TOP_SCREEN)
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
	elseif lcolorIndex == 1 then
		lcolor = Color.new(255,244,53) -- Pastel yellow
	elseif lcolorIndex == 2 then
		lcolor = Color.new(96,255,117) -- Pastel green
	elseif lcolorIndex == 3 then
		lcolor = Color.new(255,170,242) -- Pastel pink
	elseif lcolorIndex > 3 then
		lcolor = Color.new(0,255,255) -- Pastel blue
		lcolorIndex = 0
	elseif lcolorIndex < 0 then
		lcolor = Color.new(255,204,247) -- Pastel pink
		lcolorIndex = 3
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
model_string = ""
processor = ""
if model == 0 then
	model_string = "3ds"
	processor = "ARM11 Duocore"
elseif model == 1 then
	model_string = "3dsXL"
	processor = "ARM11 Duocore"
elseif model == 2 then
	model_string = "New3ds"
	processor = "ARM11 Quadcore"
elseif model == 3 then
	model_string = "2ds"
	processor = "ARM11 Quadcore"
elseif model == 4 then
	model_string = "New3dsXL"
	processor = "ARM11 Quadcore"
elseif model == 5 then
	model_string = "New2dsXL"
	processor = "ARM11 Quadcore"
end

-- Username
username = System.getUsername()
username = username .. "@" .. model_string

-- Kernel
majork,minork,revisionk = System.getKernel() 
kernel_string = majork .. "." .. minork .. "-" .. revisionk

-- Region
region = System.getRegion() - 1 -- ???
region_string = ""
if region == 0 then
	region_string = region_string .. "North America"
elseif region == 1 then
	region_string = region_string .. "Europe"
else
	region_string = region_string .. "Japan"
end

-- Battery status
is_charging = System.isBatteryCharging()
batteryPercent = System.getBatteryLife()
is_charging_string = ""
if is_charging == true then
	is_charging_string = is_charging_string .. "Charging"
else
	is_charging_string = is_charging_string .. "Discharging"
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
	Graphics.drawImage(5, 5, luma) 
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
