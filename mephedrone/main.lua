local mephedrone = RegisterMod("mephedrone", 1)
local game = Game()
local MIN_TEAR_DELAY = 5

mephedrone.COLLECTIBLE_MEPHEDRONE = Isaac.GetItemIdByName("Mephedrone") -- Create ID for item
local hasMephedrone = false
local mephedroneBonus = {
	mDamage = 1,
	mTears = 2,
	mSpeed = 0.3,
	mFallSpeed = 0.5,
	mHeight = 0.5,
	mShotSpeed = 0.3,
}

local bonusReceived = {
	damage = false,
	sSpeed = false,
	tears = false,
	speed = false,
	range = false,
}

local damageBonus = {
	dDamage = 0,
	dTears = 0,
	dSpeed = 0,
	dFallSpeed = 0,
	dHeight = 0,
	dShotSpeed = 0,
}

-- Update the player's inventory
local function updateMephedrone(player)
	hasMephedrone = player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE)
end

-- When the run is started or continued
function mephedrone:onPlayerInit(player)	
	updateMephedrone(player)
end

-- When the passive effects should update
function mephedrone:onUpdate(player)
	--if game:GetFrameCount() == 1 then
	--	Isaac.DebugString("Attempting to spawn Mephedrone")
	--	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mephedrone.COLLECTIBLE_MEPHEDRONE, Vector(320, 300), Vector(0,0), nil)
	--	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 50, Vector(270, 300), Vector(0,0), nil)
	--	Isaac.DebugString("Spawned item Mephedrone")
	--end

	updateMephedrone(player)
end

-- When the cache is updated
function mephedrone:onCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE) and not bonusReceived.sSpeed then
			player.ShotSpeed = player.ShotSpeed + mephedroneBonus.mShotSpeed
			bonusReceived.sSpeed = true
		end
	end
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE) then
			if not bonusReceived.damage then
				player.Damage = player.Damage + mephedroneBonus.mDamage
				bonusReceived.damage = true
			end
			
			if not bonusReceived.tears then
				if player.MaxFireDelay >= MIN_TEAR_DELAY + mephedroneBonus.mTears then
					player.MaxFireDelay = player.MaxFireDelay - mephedroneBonus.mTears
				elseif player.MaxFireDelay >= MIN_TEAR_DELAY then
					player.MaxFireDelay = MIN_TEAR_DELAY
				end
				
				bonusReceived.tears = true
			end
		end
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		if player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE) and not bonusReceived.speed then
			player.MoveSpeed = player.MoveSpeed + mephedroneBonus.mSpeed
			bonusReceived.speed = true
		end
	end
	if cacheFlag == CacheFlag.CACHE_RANGE then
		if player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE) and not bonusReceived.range then
			player.TearFallingSpeed = player.TearFallingSpeed + mephedroneBonus.mFallSpeed
			player.TearHeight = player.TearHeight + mephedroneBonus.mHeight
			bonusReceived.range = true
		end
	end
	--Ignore! Tears is cached in damage
	--
	--Isaac.DebugString("Check tear delay cache flag")
	--if cacheFlag == CacheFlag.CACHE_FIREDELAY then
	--	Isaac.DebugString("Tear delay is true!")
	--	if player:HasCollectible(mephedrone.COLLECTIBLE_MEPHEDRONE) then
	--		if player.MaxFireDelay >= MIN_TEAR_DELAY + mephedroneBonus.mTears then
	--			player.MaxFireDelay = player.MaxFireDelay - mephedroneBonus.mTears
	--			Isaac.DebugString("Tear delay has been adjusted: " .. player.MaxFireDelay)
	--		elseif player.MaxFireDelay >= MIN_TEAR_DELAY then
	--			Isaac.DebugString("Tear delay is at minimum, setting to 5")
	--			player.MaxFireDelay = MIN_TEAR_DELAY
	--		end
	--	end
	--end
end

-- When the player is damaged
function mephedrone:onDamage()
	local player = Isaac.GetPlayer(0)
	if hasMephedrone then
		damageBonus.dDamage = (math.random(0, 100) - 50)/100
		damageBonus.dSpeed = (math.random(0, 100) - 50)/100
		damageBonus.dFallSpeed = (math.random(0, 100) - 50)/100
		damageBonus.dHeight = (math.random(0, 100) - 50)/100
		damageBonus.dShotSpeed = (math.random(0, 100) - 50)/100
	
		player.ShotSpeed = player.ShotSpeed + damageBonus.dShotSpeed
		player.Damage = player.Damage + damageBonus.dDamage
		player.MoveSpeed = player.MoveSpeed + damageBonus.dSpeed
		player.TearHeight = player.TearHeight + damageBonus.dHeight
		player.TearFallingSpeed = player.TearFallingSpeed + damageBonus.dFallSpeed
		
		if player.MaxFireDelay <= 5 then
			damageBonus.dTears = math.random(0, 1)
		
			player.MaxFireDelay = player.MaxFireDelay + damageBonus.dTears
		else
			damageBonus.dTears = math.random(-1, 1)
		
			player.MaxFireDelay = player.MaxFireDelay + damageBonus.dTears
		end
	end
end

mephedrone:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mephedrone.onPlayerInit) -- Call onPlayerInit function after player is initialised (new run, continue etc.)
mephedrone:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mephedrone.onDamage, EntityType.ENTITY_PLAYER) -- Call onDamage function after player takes damage
mephedrone:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mephedrone.onUpdate) -- Call onUpdate function after game updates passive effects
mephedrone:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mephedrone.onCache) -- Call onCache to evaluate the cache after picking the item up