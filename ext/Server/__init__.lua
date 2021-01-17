NetEvents:Subscribe('vu-ks-attackheli:Launch', function(player, position)
	--print("Spawning attackheli "..tostring(player.name))
	position.y = position.y+3 
	local yaw = player.input.authoritativeAimingYaw
	local launchTransform = player.soldier.worldTransform:Clone()
	launchTransform.trans = position
	local params = EntityCreationParams()
	params.transform = launchTransform
	params.networked = true
	vehicleName = "Vehicles/AH1Z/AH1Z"
	if player.teamId == 2 then
		vehicleName = "Vehicles/Mi28/Mi28"
	end
	blueprint = ResourceManager:SearchForDataContainer(vehicleName)
	vehicleEntityBus = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprint, params))
	for _,entity in pairs(vehicleEntityBus.entities) do
		entity = Entity(entity)
		entity:Init(Realm.Realm_ClientAndServer, true)
	end
end)