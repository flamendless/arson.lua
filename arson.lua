local Arson = {}

local custom_types = {}

local encode_custom = function(t)
	assert(type(t) == "table", "Passed argument must be of type 'table'")
	local custom = custom_types[t.type]
	if custom then
		return true, custom.on_encode, t.type
	else
		return false
	end
end

local decode_custom = function(t)
	assert(type(t) == "table", "Passed argument must be of type 'table'")
	local custom = custom_types[t.type]
	if custom then
		return true, custom.on_decode
	else
		return false
	end
end

function Arson.register(type_name, on_encode, on_decode)
	assert(type(type_name) == "string", "Passed argument 'type_name' must be of type 'string'")
	assert(custom_types[type_name], "Passed 'type_name' was already registered")
	assert(type(on_encode) == "function", "Passed argument 'on_encode' must be of type 'function'")
	assert(type(on_decode) == "function", "Passed argument 'on_decode' must be of type 'function'")
	custom_types[type_name] = {
		on_encode = on_encode,
		on_decode = on_decode
	}
end

function Arson.unregister(type_name)
	assert(type(type_name) == "string", "Passed argument 'type_name' must be of type 'string'")
	assert(custom_types[type_name], "Passed 'type_name' is not registered")
	custom_types[type_name] = nil
end

function Arson.encode(t, tmp)
	assert(type(t) == "table", "Passed argument 't' must be of type 'table'")
	local tmp = tmp or {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			local is_custom, on_encode, type_name = encode_custom(v)
			if is_custom then
				local custom_data = on_encode(v)
				custom_data.type = type_name
				tmp[k] = custom_data
			else
				tmp[k] = {}
				Arson.encode(v, tmp[k])
			end
		else
			tmp[k] = v
		end
	end
	return tmp
end

function Arson.decode(t)
	assert(type(t) == "table", "Passed argument 't' must be of type 'table'")
	for k, v in pairs(t) do
		if type(v) == "table" then
			local is_custom, on_decode = decode_custom(v)
			if is_custom then
				t[k] = on_decode(v)
			else
				Arson.decode(v)
			end
		end
	end
end

return Arson
