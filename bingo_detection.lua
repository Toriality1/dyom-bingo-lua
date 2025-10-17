local detection = {}

local tracking = {
	last_health = 0,
}

-- External dependency injected (auto_check_card)
function detection.init(check_card_func)
	detection.check_card = check_card_func
	print("Detection initialized", detection.check_card)
end

-- Detect events
function detection.update()
	if not doesCharExist(PLAYER_PED) then
		return
	end

	local player = PLAYER_PED
	local health = getCharHealth(player)

	if tracking.last_health > 0 and health == 0 then
		detection.check_card("wasted")
	end

	if hasCharBeenArrested(PLAYER_PED) then
		detection.check_card("busted")
	end

	tracking.last_health = health
end

return detection
