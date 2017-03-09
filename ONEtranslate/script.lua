splash.gekihen()
color.loadpalette() -- Load Defaults colors
color.shine = color.white:a(100)
local back = nil

--[[function onNetGetFile(size,written,speed)
	if back then back:blit(0,0) end
	screen.print(10,10,"Downloading...")
	screen.print(10,30,"Size: "..tostring(size).." Written: "..tostring(written).." Speed: "..tostring(speed).."Kb/s")
	screen.print(10,50,"Porcent: "..math.floor((written*100)/size).."%")
	draw.fillrect(0,520,((written*960)/size),24,color.new(0,255,0))
	screen.flip()
	buttons.read()
	if buttons.circle then	return 0 end --Cancel or Abort
	return 1;
end]]

function wordwrap(text, width, w) -- Ajust string with newline char...
	if not w then w = 1.0 end
	local lines = 1
	local out = ""
	local int = ""
  	for word in string.gmatch(text,"%S+") do
    		if screen.textwidth (int.." "..word,w) > width then
      			out = out..'\n'
     			int = ""
     			lines = lines + 1
    		end
  		out = out.." "..word
  		int = int.." "..word
  	end
  	return out
end

dofile("translate.lua")
back = image.load("back.png")
local langs = {
	mask = { "", "en", "es", "ja", "de", "fr", "it", "nl", "pt", "ru", "ko", "zh-CN" },
	label = { "Auto", "English", "Spanish", "Japanese", "German", "French", "Italian", "Dutch", "Portuguese", "Russian", "Korean", "Chinese"},
}
local text = {src = "", dst = "", lsrc = 0, ldst = 0}
local lang = {src = 1, dst = 2}
local over = 1;
--wlan.connect()
while true do
	buttons.read()
	if buttons.cross then
		if wlan.isconnected() then
			local tmp = osk.init("Text to translate","",1,511)
			if tmp then
				text.src = wordwrap(tmp,920)
				text.lsrc = string.len(text.src)
				text.dst = wordwrap((translate(langs.mask[lang.src], langs.mask[lang.dst], tmp) or "Error!"),920)
			end
		else
			wlan.connect()
		end
	end
	if buttons.l then over -=1
	elseif buttons.r then over += 1 end
	if over > 2 then over = 1 end
	if over < 1 then over = 2 end
	
	if buttons.left and over == 1 and lang.src > 1 then lang.src -= 1
	elseif buttons.right and over == 1 and lang.src < 12 then lang.src += 1
	elseif buttons.left and over == 2 and lang.dst > 2 then lang.dst -= 1
	elseif buttons.right and over == 2 and lang.dst < 12 then lang.dst += 1
	end
	if back then back:blit(0,0) end
	draw.fillrect(10,5,940,25,color.shine)
	draw.rect(10,5,940,25,color.white)
	screen.print(15,10,"ONEtranslate - V1R0",1,color.white,color.blue)
	screen.print(945,10,"Batt: "..tostring(batt.lifepercent()).."%",1,color.white,color.black,__ARIGHT)
	screen.print(830,10,"Wifi: "..(wlan.strength() or "Without connection!").."%",1,color.white,color.black,__ARIGHT)
	draw.fillrect(10,35,200,30,color.shine)
	if over == 1 then
		draw.fillrect(10,35,200,30,color.blue:a(100))
	end
	draw.rect(10,35,200,30,color.white)
	if lang.src > 1 then
		draw.filltriangle(10+3,50, 25+3,35+3, 25+3,65-3, color.white)
	end
	if lang.src < 12 then
		draw.filltriangle(210-3,50, 210-15-3,35+3, 210-15-3,65-3, color.white)
	end
	
	screen.print(10+100,40,langs.label[lang.src],1,color.white,color.black,__ACENTER)
	
	screen.print(480,40,"->",1,color.white,color.blue)
	
	draw.fillrect(750,35,200,30,color.shine)
	if over == 2 then
		draw.fillrect(750,35,200,30,color.blue:a(100))
	end
	draw.rect(750,35,200,30,color.white)
	if lang.dst > 2 then
		draw.filltriangle(750+3,50, 750+15+3,35+3, 750+15+3,65-3, color.white)
	end
	if lang.dst < 12 then
		draw.filltriangle(950-3,50, 950-15-3,35+3, 950-15-3,65-3, color.white)
	end
	screen.print(750+100,40,langs.label[lang.dst],1,color.white,color.black,__ACENTER)
	
	draw.fillrect(10,70,940,232,color.shine)
	draw.rect(10,70,940,232,color.white)
	screen.print(15,80,"Text in:",1,color.white,color.black)
	screen.print(945,80,string.format("%d/5000",text.lsrc),1,color.white,color.black,__ARIGHT)
	screen.print(15,100,text.src or "",1,color.white,color.black)
	
	draw.fillrect(10,307,940,232,color.shine)
	draw.rect(10,307,940,232,color.white)
	screen.print(15,312,"Text out:",1,color.white,color.black)
	--screen.print(945,312,text.ldst,1,color.white,color.black,__ARIGHT)
	screen.print(15,332,text.dst or "",1,color.white,color.black)
	screen.flip()
end