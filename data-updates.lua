--[[
	Done as a data-update to allow other mods to manipulate the base lamp before we clone it. ie: change turn on/off times.
]]
local Constants = require("constants")

GenerateHiddenLights = function()
	local poleLights = {}
	if tonumber(settings.startup["light-power-usage-watts"].value) > 0 then
		for tile=1,75 do
			table.insert(poleLights, GenerateHiddenLight(tile, tile))
		end
	else
		for tile=1,75 do
			table.insert(poleLights, GenerateHiddenLightNoPower(tile, tile))
		end
	end
	data:extend(poleLights)
end

GenerateHiddenLight = function(tile, name)
	if name == nil then name = tile end
	local lightRange = tile * 5
	local hiddenLight = table.deepcopy(data.raw["lamp"]["small-lamp"])
	hiddenLight.name = "hiddenlight-" .. name
	hiddenLight.collision_mask = {}
	hiddenLight.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"}
	hiddenLight.selection_box = nil --makes a nice cross on the powered area rather than a default sized box
	hiddenLight.selectable_in_game = false
	hiddenLight.picture_off = {
		filename = "__base__/graphics/entity/small-lamp/lamp.png",
		width = 0,
		height = 0
	}
	hiddenLight.picture_on = {
		filename = "__base__/graphics/entity/small-lamp/lamp.png",
		width = 0,
		height = 0
	}
	hiddenLight.light = {intensity = 0.6, size = lightRange, color = {r=1.0, g=1.0, b=1.0}}
	hiddenLight.energy_usage_per_tick = settings.startup["light-power-usage-watts"].value .. "W"
	hiddenLight.energy_source.render_no_network_icon = false
	hiddenLight.energy_source.render_no_power_icon = false
	return hiddenLight
end

--Explosion lasts for years of ticks
GenerateHiddenLightNoPower = function(tile, name)
	if name == nil then name = tile end
	local lightRange = tile * 5
	hiddenLight = {
		name = "hiddenlight-" .. name,
		type = "explosion",
		collision_mask = {},
		flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"},
		selectable_in_game = false,
		sound = {filename = Constants.GraphicsModName .. "/sound/silence.ogg", volume = 0},
		animations = {{width = 0, height = 0, frame_count = 1, filename = "__core__/graphics/empty.png", animation_speed = 0.000000000000001}},
		light = {intensity = 0.6, size = lightRange, color = {r=1.0, g=1.0, b=1.0}},
		smoke_slow_down_factor = 1
	}
	return hiddenLight
end

--Used to connect the hidden lights when there is no electric network there and no power usage set (work around engine feature)
GenerateHiddenLightEletricPole = function()
	local hiddenLightPole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
	hiddenLightPole.name = "hiddenlightpole"
	hiddenLightPole.collision_mask = {}
	hiddenLightPole.flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map"}
	hiddenLightPole.selectable_in_game = false
	hiddenLightPole.maximum_wire_distance = 0
	hiddenLightPole.supply_area_distance = 0.1
	hiddenLightPole.pictures = {
		filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole.png",
		priority = "extra-high",
		width = 1,
		height = 0,
		direction_count = 4,
		shift = {1.4, -1.1}
	}
	data:extend({hiddenLightPole})
end



GenerateHiddenLights()
GenerateHiddenLightEletricPole()
