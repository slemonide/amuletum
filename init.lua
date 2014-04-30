local RADIUS = 8

local check_groups = function(name, groups)
   for i = 1, #groups do
      if minetest.get_item_group(name, groups[i]) > 0 then
	 return true
      end
   end
end

local plants_groups = {"tree", "leaves", "flora", "leafdecay"}

local takelife = function(pos)
   local under = {
      x = pos.x,
      y = pos.y -1,
      z = pos.z,
   }
   local under_node = minetest.get_node(under).name
   if minetest.get_item_group(under_node, "tubedevice_receiver") > 0 then
      
      local meta=minetest.get_meta(under)
      local inv=meta:get_inventory()
      
      minetest.sound_play("explo", {pos = pos})
      for dx=-RADIUS,RADIUS do
	 for dz=-RADIUS,RADIUS do
	    for dy=-RADIUS,RADIUS do
	       local npos = {x=pos.x + dx, y=pos.y + dy, z=pos.z + dz}
	       if ((dx)^2 + (dy)^2 + (dz)^2)^0.5 + math.random(0,2) <= RADIUS then
		  local node = minetest.get_node(npos)
		  if check_groups(node.name, plants_groups) then
		     minetest.remove_node(npos)
		     inv:add_item("main", node)
		  end
	       end
	    end
	 end
      end
   end
end

minetest.register_node("amuletum:lifeeater", {
	description = "Life Eater Amuletum",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"amuletum_lifeeater.png"},
	inventory_image = "amuletum_lifeeater.png",
	wield_image = "amuletum_lifeeater.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_source = LIGHT_MAX-1,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,attached_node=1,attached_node=1,hot=30,wield_light=LIGHT_MAX-1},
	sounds = default.node_sound_leaves_defaults(),
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	   takelife(pos)
	end,
	mesecons = {effector = {
     		       action_on = function (pos, node)
			  takelife(pos)
		       end,
	}}
})

minetest.register_craft({
	output = 'amuletum:lifeeater',
	recipe = {
		{'moreores:silver_lump', 'gems:garnet', ''},
		{'animalmaterials:bone', 'group:stick', 'animalmaterials:bone'},
		{'', 'group:stick', 'moreores:silver_lump'},
	}
})

