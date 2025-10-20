local dyom = require("dyom")

local detection = {}

local tracking = {
  mission_name = "",
  mission_author = "",

  mission_time = 0,
  mission_weather = 0,

  player_skin = 0,
  player_weapon = 0,
  player_ammo = 0,
  player_health = 0,
  player_interior = 0,

  last_health = 0,
  was_arrested = false,
  was_wasted = false,
}

detection.check_card = nil

function detection.init(check_card_func)
  if not check_card_func then
    error("Detection module requires check_card callback function")
  end

  detection.check_card = check_card_func

  print("[DYOM Bingo Detection] Initialized successfully")
end

function detection.reset()
  tracking.last_health = 0
  tracking.was_arrested = false
  tracking.was_wasted = false
  tracking.mission_name = ""
  tracking.mission_author = ""
  tracking.mission_time = 0
  tracking.mission_weather = 0
  tracking.player_skin = 0
  tracking.player_weapon = 0
  tracking.player_ammo = 0
  tracking.player_health = 0
  tracking.player_interior = 0
end

function detection.update()
  if not detection.check_card then
    return
  end

  local player = PLAYER_PED
  local health = getCharHealth(player)

  if tracking.player_health ~= dyom.getPlayerHealth() then
    tracking.player_health = dyom.getPlayerHealth()
    if tracking.player_health == 150 then
      detection.check_card("player_150_health")
    end
  end

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

  if tracking.mission_name ~= dyom.getMissionName() then
    local mission_name = dyom.getMissionName()
    tracking.mission_name = mission_name
    if string.find(string.lower(tracking.mission_name), "the") then
      detection.check_card("the_in_title")
    end
    if string.find(string.lower(tracking.mission_name), "kill") then
      detection.check_card("kill_in_title")
    end
    if string.find(string.lower(tracking.mission_name), "dyom") then
      detection.check_card("dyom_in_title")
    end
    if string.find(string.lower(tracking.mission_name), "part %d") then
      detection.check_card("part_x")
    end
    if string.find(string.lower(tracking.mission_name), "part 1") then
      detection.check_card("part_1")
    end
    if string.find(string.lower(tracking.mission_name), "motw") then
      detection.check_card("motw_mission")
    end
    if string.find(string.lower(tracking.mission_name), "~[rgbypwmsou]~") then
      detection.check_card("color_in_title")
    end
  end

  if tracking.mission_author ~= dyom.getMissionAuthor() then
    local mission_author = dyom.getMissionAuthor()
    tracking.mission_author = mission_author
    if string.find(string.lower(tracking.mission_author), "dyom") then
      detection.check_card("author_has_dyom")
    end
    if string.find(string.lower(tracking.mission_author), "target13") then
      detection.check_card("made_by_target13")
    end
    if string.find(string.lower(tracking.mission_author), "leoncj") then
      detection.check_card("made_by_leoncj")
    end
    if string.find(string.lower(tracking.mission_author), "%d") then
      detection.check_card("author_has_numbers")
    end
  end

  if tracking.mission_time ~= dyom.getMissionTime() then
    tracking.mission_time = dyom.getMissionTime()
    if tracking.mission_time == 8 then
      detection.check_card("starts_8am")
    end
    if tracking.mission_time >= 6 and tracking.mission_time <= 19 then
      detection.check_card("starts_daytime")
    else
      detection.check_card("starts_nighttime")
    end
  end

  if tracking.player_weapon ~= dyom.getPlayerWeapon() then
    tracking.player_weapon = dyom.getPlayerWeapon()
    if tracking.player_weapon == 0 then
      detection.check_card("starts_no_weapons")
    end
  end

  if tracking.player_ammo ~= dyom.getPlayerAmmo() then
    tracking.player_ammo = dyom.getPlayerAmmo()
    if tracking.player_ammo == 9999 then
      detection.check_card("starts_9999_ammo")
    end
  end

  if tracking.player_interior ~= dyom.getPlayerInterior() then
    tracking.player_interior = dyom.getPlayerInterior()
    if tracking.player_interior ~= 0 then
      detection.check_card("starts_interior")
    end
  end

  if tracking.player_skin ~= dyom.getPlayerSkin() then
    tracking.player_skin = dyom.getPlayerSkin()
    if tracking.player_skin == 0 then
      detection.check_card("player_cj")
    end
    if tracking.player_skin == 265 then
      detection.check_card("player_tenpenny")
    end
    if tracking.player_skin == 270 then
      detection.check_card("player_sweet")
    end
    if dyom.ryder_skins[tracking.player_skin] then
      detection.check_card("player_ryder")
    end
    if dyom.big_smoke_skins[tracking.player_skin] then
      detection.check_card("player_big_smoke")
    end
    if dyom.cop_skins[tracking.player_skin] then
      detection.check_card("player_cop")
    end
    if dyom.military_skins[tracking.player_skin] then
      detection.check_card("player_military")
    end
    if dyom.woman_skins[tracking.player_skin] then
      detection.check_card("player_woman")
    end
    if dyom.triads_skins[tracking.player_skin] then
      detection.check_card("player_triads")
    end
    if dyom.ballas_skins[tracking.player_skin] then
      detection.check_card("player_ballas")
    end
    if dyom.grove_skins[tracking.player_skin] then
      detection.check_card("player_grove")
    end
    if dyom.vagos_skins[tracking.player_skin] then
      detection.check_card("player_vagos")
    end
  end

  if tracking.mission_weather ~= dyom.getMissionWeather() then
    tracking.mission_weather = dyom.getMissionWeather()
    if dyom.sunny_weathers[tracking.mission_weather] then
      detection.check_card("starts_sunny")
    end
    if dyom.rainy_weathers[tracking.mission_weather] then
      detection.check_card("starts_rainy")
    end
    if tracking.mission_weather == 19 then
      detection.check_card("starts_sandstorm")
    end
  end

  tracking.last_health = health
end

return detection
