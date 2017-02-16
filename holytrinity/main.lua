local holyTrinity = RegisterMod("holyTrinity", 1)

holyTrinity.COLLECTIBLE_HOLY_TRINITY = Isaac.GetItemIdByName("Holy Trinity") -- Create ID for item

local items = {2, 3, 38, 52, 68, 87, 110, 114, 118, 132, 149, 152, 153, 168, 169, 182, 220, 221, 222, 229, 233, 237, 245, 329, 330, 331, 347, 358, 395, 496} -- 30 items in list
local spawnX

function holyTrinity:onUpdate()
	-- Beginning of run initialisation
	if Game():GetFrameCount() == 1 then
		--Isaac.DebugString("Attempting to spawn Holy Trinity")
		--Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, holyTrinity.COLLECTIBLE_HOLY_TRINITY, Vector(320, 300), Vector(0,0), nil)
		--Isaac.DebugString("Spawned item Holy Trinity")
		holyTrinity.itemsSpawned = false
	end

	-- Holy Trinity functionality
	for playerNum = 1, Game():GetNumPlayers() do	-- Cycles over all players
		local player = Game():GetPlayer(playerNum)	-- Sets current player variable
	
		if player:HasCollectible(holyTrinity.COLLECTIBLE_HOLY_TRINITY) then -- Does the player have the item?
			if not holyTrinity.itemsSpawned then							  -- Has the item already spawned 3 other items?
				for i=1, 3, 1 do		-- Iterate 3 times for 3 items
					if i==1 then		-- X coordinate for first item
						spawnX=215.1
					elseif i==2 then	-- X coordinate for second item
						spawnX=334.1
					elseif i==3 then	-- X coordinate for third item
						spawnX=453.2
					end
					
					local rVal = math.random(30)			-- Random value from array
					
					Isaac.Spawn(
						EntityType.ENTITY_PICKUP,
						PickupVariant.PICKUP_COLLECTIBLE,
						items[rVal],
						Vector(spawnX, 292.6),
						Vector(0,0),
						Isaac.GetPlayer(0)
					)										-- Create the item using the random value and the X coordinate
				end
			
				holyTrinity.itemsSpawned = true	-- Items have been spawned
			end
		end
	end
end

Isaac.DebugString("Debug!")
holyTrinity:AddCallback(ModCallbacks.MC_POST_UPDATE, holyTrinity.onUpdate) -- Call onUpdate function after game update