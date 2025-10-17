local detection = {}

-- Tracking state for various game events
local tracking = {
  last_health = 0,
  was_arrested = false,
  was_wasted = false,
}

-- External dependency injected (auto_check_card function)
detection.check_card = nil

-- Initialize detection system with callback
function detection.init(check_card_func)
  if not check_card_func then
    error("Detection module requires check_card callback function")
  end
  detection.check_card = check_card_func

  -- Reset tracking state
  tracking.was_arrested = false
  tracking.was_wasted = false
  tracking.last_health = 0

  print("[DYOM Bingo Detection] Initialized successfully")
end

-- Reset tracking state (call when starting new mission/card)
function detection.reset()
  tracking.last_health = 0
  tracking.was_arrested = false
  tracking.was_wasted = false
end

-- Main detection update loop (call every frame)
function detection.update()
  if not detection.check_card then
    return -- Not initialized yet
  end

  if not doesCharExist(PLAYER_PED) then
    return -- Player doesn't exist
  end

  local player = PLAYER_PED
  local health = getCharHealth(player)

  if not tracking.was_wasted then
    if tracking.last_health > 0 and health == 0 then
      tracking.was_wasted = true
      detection.check_card("wasted")
    end
  end

  if not tracking.was_arrested then
    if hasCharBeenArrested(player) then
      tracking.was_arrested = true
      detection.check_card("busted")
    end
  end

  tracking.last_health = health

  -- TODO: Add more
end

return detection
