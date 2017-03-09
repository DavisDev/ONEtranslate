if not json then -- if not exist module json load! :P
	json = dofile("json.lua") -- load a module json...
end

function translate(src, dst, txt) -- Example "es", "en", "Hola", result: "Hello"
	local url = "https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=es-ES&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e";
	local params = string.format("sl=%s&tl=%s&q=%s",src, dst, txt)
	local result = ""
	local resdata,reslen,resstate = http.post(url, params)
	if resdata != nil then
		local array = json.parse(resdata)
		for k,v in pairs(array["sentences"]) do
			result += v["trans"] or ""
		end
		return result;
	end
	return nil; -- error ...
end