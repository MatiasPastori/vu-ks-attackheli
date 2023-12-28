---@class KSChopperServer
---@overload fun(): KSChopperServer
KSChopperServer = class("KSChopperServer")

function KSChopperServer:__init()
	self:RegisterVars()
	self:RegisterEvents()
end

function KSChopperServer:RegisterVars()
	self.ChoppersEnabled = false
end

function KSChopperServer:RegisterEvents()
	Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
	Events:Subscribe('Level:Destroy', self, self.OnLevelDestroy)
	self.playerSyncevent = NetEvents:Subscribe('KSChopperServer:PlayerSync', self, self.OnPlayerSync)
	self.launchEvent = NetEvents:Subscribe('vu-ks-attackheli:Launch', function(player, position)
		--print("Spawning attackheli "..tostring(player.name))
		position.y = position.y + 3
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
		for _, entity in pairs(vehicleEntityBus.entities) do
			entity = Entity(entity)
			entity:Init(Realm.Realm_ClientAndServer, true)
		end
	end)
end

function KSChopperServer:OnLevelLoaded()
	local chopperUS = "Vehicles/AH1Z/AH1Z"
	local chopperRU = "Vehicles/Mi28/Mi28"
	local blueprintUS = ResourceManager:SearchForDataContainer(chopperUS)
	local blueprintRU = ResourceManager:SearchForDataContainer(chopperRU)
	local params = EntityCreationParams()
	params.networked = true
	-- This next 2 lines are known to cause issues for maps that don't have the requested vehicles.
	-- I don't really know how to avoid the erros but it works for our purpose of checking if the vehicle is available for the map.
	local vehicleEntityBusUS = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprintUS, params))
	local vehicleEntityBusRU = EntityBus(EntityManager:CreateEntitiesFromBlueprint(blueprintRU, params))

	if vehicleEntityBusUS ~= nil and vehicleEntityBusRU ~= nil then
		print('Entities correctly created from blueprints!')
		self.ChoppersEnabled = true
	end
end

function KSChopperServer:OnLevelDestroy()
	self:RegisterVars()
end

function KSChopperServer:OnPlayerSync(player)
	print('|||||||||||||| KSChopperServer: OnPlayerSync recieved!')
	NetEvents:SendTo("KSChopperServer:Enabled", player, self.ChoppersEnabled)
end

KSChopperServer = KSChopperServer()



return KSChopperServer
