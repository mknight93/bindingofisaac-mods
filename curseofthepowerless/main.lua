LevelCurse = {
	CURSE_NONE = 0,
	CURSE_OF_DARKNESS = 1,
	CURSE_OF_LABYRINTH = 1 << 1,
	CURSE_OF_THE_LOST = 1 << 2,
	CURSE_OF_THE_UNKNOWN = 1 << 3,
	CURSE_OF_THE_CURSED = 1 << 4,
	CURSE_OF_MAZE = 1 << 5,
	CURSE_OF_BLIND = 1 << 6,
	CURSE_OF_POWERLESS = 1 << (Isaac.GetCurseIdByName("Curse of the Powerless") - 1),
	NUM_CURSES = 9
}

local mod = RegisterMod("Curse of the Powerless", 1);
curseactive = false
cursepowerless = false
--playerdamage = false

function mod:Curse()
	local player = Isaac.GetPlayer(0)
	local game = Game()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local cursepowerless2 = Isaac.GetCurseIdByName("Curse of the Powerless") -- Create custom curse
		cursepowerless = true					-- Curse is active
		level:AddCurse(cursepowerless2, true)	-- Add curse to floor
		curseactive = true						-- Set to true to apply effects
end

function mod:OnHit()
	local player = Isaac.GetPlayer(0)
	
	player:DischargeActiveItem()
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, mod.Curse)	-- Callback to update the curse
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnHit, EntityType.ENTITY_PLAYER) -- Callback to check for player taking damage