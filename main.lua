local arson = require("arson")
local json = require("json") --https://github.com/rxi/json.lua
local inspect = require("inspect") --https://github.com/kikito/inspect.lua

--Let's say this is your custom vec2 class
local custom_vec2_class = {
	x = 0,
	y = 0,
	type = "my_custom_vec2" --important field your custom class must have
}

--For the vec3 version
local custom_vec3_class = {
	x = 0,
	y = 0,
	z = 0,
	type = "my_custom_vec3" --important field your custom class must have
}

local vec2 = create_new_vec2(0, 0) --a sample constructor of your own class
local vec3 = create_new_vec3(0, 0, 0)

local data_to_store = {
	1, 2, 3, "Hello", "World",
	vec2, vec2, vec3, vec3,
	create_new_vec2(1, 1),
	create_new_vec3(1, 1, 1),
	{
		4, 5, 6,
		foo = vec2,
		foofoo = vec3,
		bar = { 7, 8, 9 }
	}
}

arson.register("my_custom_vec2", --Must match the 'type' field in your custom data
	function(data) --on encode function
		return { x = data.x, y = data.y } --this will be stored in the JSON
	end,
	function(data) --on decode function
		return create_new_vec2(data.x, data.y) --this will be the final data after decoding
	end)

arson.register("my_custom_vec3",
	function(data)
		return { x = data.x, y = data.y, z = data.z }
	end,
	function(data)
		return create_new_vec3(data.x, data.y, data.z)
	end)

--NOTE that the 'data' you will get upon the `on_decode` function is dependent on what you have store during the `on_encode` function

local custom_encoded = arson.encode(data_to_store)
print(inspect(custom_encoded))

local str_json = json.encode(custom_encoded)
print(str_json)

local decoded = json.decode(str_json)
arson.decode(decoded)
print(inspect(decoded))
