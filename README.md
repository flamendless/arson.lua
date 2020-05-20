# ARSON

A library-companion to register custom data types that can be encoded and decoded for [json.lua](https://github.com/rxi/json.lua).


## How to use:

Require it as such: `local arson = require("arson")`

or if it is nested in a directory: `local arson = require("folder.folder.arson")`

You can check the [main.lua](https://github.com/flamendless/arson.lua/blob/master/main.lua) as an example. It has descriptive comments.

## Custom Data/Class Prerequisite

Your class or object must have the public field `type`. This will be used by Arson to determine whether a table stored in the data is to be encoded/decoded

Example:
```lua
local my_custom_class = {
	text = "Hello, World!",
	type = "my_custom_class" --IMPORTANT
}
```

## API

* **Arson.register** - register your own custom data/class that can be encoded and decoded

Example:
```lua
--(type_name : string, on_encode : function, on_decode : function)
--returns nothing

arson.register("custom_vec2_class",
	function(data)
		return { x = data.x, y = data.y }
	end,
	function(data)
		return my_custom_vec2_class:new(data.x, data.y)
	end)
```
---

* **Arson.unregister** - unregister an already added custom data/class

Example:
```lua
--(type_name : string)
--returns nothing

arson.unregister("custom_class") --will error
arson.unregister("custom_vec2_class")
```
---

* **Arson.encode** - encode a table

Example:
```lua
--(t : table)
--returns custom_encoded_table : table

local data = {
	1, 2, 3, custom_vec2_class(1, 1),
	foo = { 4, 5, 6 },
	bar = custom_vec2_class(2, 2),
}
local custom_data = arson.encode(data)

--[[
returned table:
{
1, 2, 3, { x = 1, y = 1, type = "custom_vec2_class" },
foo = { 4, 5, 6 },
bar = { x = 1, y = 1, type = "custom_vec2_class" }
}
--]]

--the custom_data table can now be used with json.lua
local str_json = json.encode(custom_data)
```
---

* **Arson.decode** - decode a table. It will modify the table passed as it will replace custom data with the decoded one

Example:
```lua
--(t : table)
--returns nothing

--first let us decode the str_json
local json_decoded = json.decode(str_json)

--then finally decode custom data/class
arson.decode(json_decoded)
```
---

## Why Arson?

It is from `RSON`, which is derived from `Register-JSON`. I know it does not make any sense. But is sounds cool.

## LICENSE

See MIT License [file here](https://github.com/flamendless/arson.lua/blob/master/LICENSE)
