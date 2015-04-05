minetest.register_node("amuletum:light", {
    description = "Liquid Light Source",
    tiles = {"amuletum_light.png"},
    groups = {cracky=3},
    drop = 'amuletum:light',
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("amuletum:liquidlight", {
    description = "Liquid Light",
    drawtype = "airlike",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    climbable = false,
    paramtype = "light",
    light_source = 12,
    sunlight_propagates = true,
    groups = {not_in_creative_inventory=1},
})

-- Grow
minetest.register_abm({
    nodenames = {"air"},
    neighbors = {"amuletum:liquidlight", "amuletum:light"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = minetest.find_node_near(pos, 1, {"amuletum:liquidlight"})
	local source = minetest.find_node_near(pos, 1, {"amuletum:light"})
        if (light and light.y > pos.y)
        or (source and source.y > pos.y) then
            minetest.set_node(pos, {name = "amuletum:liquidlight"})
        end
    end,
})

-- Decay
minetest.register_abm({
    nodenames = {"amuletum:liquidlight"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local light = minetest.find_node_near(pos, 1, {"amuletum:liquidlight"})
	local source = minetest.find_node_near(pos, 1, {"amuletum:light"})
        if not ((light and light.y > pos.y)
        or (source and source.y > pos.y)) then
            minetest.remove_node(pos)
        end
    end,
})
