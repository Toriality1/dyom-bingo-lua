local memory = require("memory")

local GTA_SA_BASE_ADDR = getModuleHandle("gta_sa.exe")

local MISSION_NAME_OFFSET = 0x65C244
local MISSION_NAME_LENGTH = 50

local MISSION_AUTHOR_OFFSET = 0x65C28D
local MISSION_AUTHOR_LENGTH = 50

local MISSION_TIME_OFFSET = 0x654c38
local MISSION_WEATHER_OFFSET = 0x654414

local PLAYER_SKIN_OFFSET = 0x654c50
local PLAYER_WEAOPN_OFFSET = 0x654C54
local PLAYER_AMMO_OFFSET = 0x654C58
local PLAYER_HEALTH_OFFSET = 0x654C5E
local PLAYER_INTERIOR_OFFSET = 0x654c4c

local ACTORS_MAX_COUNT = 100
local ACTORS_HANDLE_OFFSET = 0x6591ec
local ACTORS_HEALTH_OFFSET = 0x656d5c

function addr(offset) return GTA_SA_BASE_ADDR + offset end

return {
  getMissionName = function()
    return memory.tostring(addr(MISSION_NAME_OFFSET), MISSION_NAME_LENGTH)
  end,
  getMissionAuthor = function()
    return memory.tostring(addr(MISSION_AUTHOR_OFFSET), MISSION_AUTHOR_LENGTH)
  end,
  getMissionTime = function()
    return memory.getint32(addr(MISSION_TIME_OFFSET))
  end,
  getMissionWeather = function()
    return memory.getint32(addr(MISSION_WEATHER_OFFSET))
  end,
  getPlayerSkin = function()
    return memory.getint32(addr(PLAYER_SKIN_OFFSET))
  end,
  getPlayerWeapon = function()
    return memory.getint32(addr(PLAYER_WEAOPN_OFFSET))
  end,
  getPlayerAmmo = function()
    return memory.getint32(addr(PLAYER_AMMO_OFFSET))
  end,
  getPlayerHealth = function()
    return memory.getint32(addr(PLAYER_HEALTH_OFFSET))
  end,
  getPlayerInterior = function()
    return memory.getint32(addr(PLAYER_INTERIOR_OFFSET))
  end,
  getListOfActors = function()
    local actors = {}
    for i = 0, ACTORS_MAX_COUNT do
      local address = addr(ACTORS_HANDLE_OFFSET + (i * 4))
      actors[i + 1] = memory.getint32(address)
    end
    return actors
  end,
  getListOfActorsHealth = function()
    local healths = {}
    for i = 0, ACTORS_MAX_COUNT do
      local address = addr(ACTORS_HEALTH_OFFSET + (i * 4))
      healths[i + 1] = memory.getint32(address)
    end
    return healths
  end,
  getActorHealth = function(index)
    if index < 0 or index > ACTORS_MAX_COUNT then
      error("Invalid actor index")
      return nil
    end
    local address = addr(ACTORS_HEALTH_OFFSET + (index * 4))
    return memory.getint32(address)
  end,
  sunny_weathers = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [5] = true,
    [6] = true,
    [10] = true,
    [11] = true,
    [13] = true,
    [14] = true,
    [17] = true,
    [18] = true,
  },
  rainy_weathers = {
    [8] = true,
    [16] = true,
  },
  player_skins = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
  big_smoke_skins = { [269] = true, [311] = true },
  ryder_skins = { [271] = true, [300] = true, [301] = true },
  cop_skins = {
    [265] = true,
    [266] = true,
    [267] = true,
    [280] = true,
    [281] = true,
    [282] = true,
    [283] = true,
    [284] = true,
    [285] = true,
    [286] = true,
    [288] = true,
    [119] = true,
    [3] = true,
    [4] = true
  },
  military_skins = {
    [312] = true,
    [287] = true
  },
  woman_skins = {
    [6] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [31] = true,
    [38] = true,
    [39] = true,
    [40] = true,
    [41] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [63] = true,
    [64] = true,
    [69] = true,
    [75] = true,
    [76] = true,
    [77] = true,
    [85] = true,
    [86] = true,
    [87] = true,
    [88] = true,
    [89] = true,
    [90] = true,
    [91] = true,
    [92] = true,
    [93] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [138] = true,
    [139] = true,
    [140] = true,
    [141] = true,
    [145] = true,
    [148] = true,
    [150] = true,
    [151] = true,
    [152] = true,
    [157] = true,
    [169] = true,
    [172] = true,
    [178] = true,
    [190] = true,
    [191] = true,
    [192] = true,
    [193] = true,
    [194] = true,
    [195] = true,
    [196] = true,
    [197] = true,
    [198] = true,
    [199] = true,
    [201] = true,
    [205] = true,
    [207] = true,
    [211] = true,
    [214] = true,
    [215] = true,
    [216] = true,
    [218] = true,
    [219] = true,
    [224] = true,
    [225] = true,
    [226] = true,
    [231] = true,
    [232] = true,
    [233] = true,
    [237] = true,
    [238] = true,
    [243] = true,
    [244] = true,
    [245] = true,
    [246] = true,
    [251] = true,
    [256] = true,
    [257] = true,
    [263] = true,
    [298] = true,
    [304] = true,
  },
  triads_skins = {
    [120] = true,
    [118] = true,
    [117] = true,
  },
  ballas_skins = {
    [102] = true,
    [103] = true,
    [104] = true,
  },
  grove_skins = {
    [105] = true,
    [106] = true,
    [107] = true,
  },
  vagos_skins = {
    [108] = true,
    [109] = true,
    [110] = true,
  }
}

-- dyom_actor_accuracy/int array - shoting accuracy percent = 0x656eec
-- dyom_actor_ammo/int array - bullet count = 0x656a3c
-- dyom_actor_animation/int array - animation id = 0x65752c
-- dyom_actor_animation_argument/int array - route id / vehicle seat = 0x6576bc
-- dyom_actor_count/int - actor count in current mission = 0x654420
-- dyom_actor_despawn/int array - objective index = 0x65720c
-- dyom_actor_dir/float array - direction: 0 north, 90 east, 180 south, 270 west = 0x65658c
-- dyom_actor_flags/int array - flags = 0x656bcc
-- dyom_actor_gang/int array - group id = 0x655f4c
-- dyom_actor_handle/int array = 0x6591ec
-- dyom_actor_health/int array - health points = 0x656d5c
-- dyom_actor_interior/int array - interiors world number = 0x65671c
-- dyom_actor_must_survive/int array - 0 or 1 = 0x65739c
-- dyom_actor_pos_x/float array = 0x6560dc
-- dyom_actor_pos_y/float array = 0x65626c
-- dyom_actor_pos_z/float array = 0x6563fc
-- dyom_actor_skin/int array - id = 0x655dbc
-- dyom_actor_spawn/int array - objective index = 0x65707c
-- dyom_actor_weapon/int array - weapon id = 0x6568ac
-- dyom_author_name_ptr = 0x6533bc
-- dyom_car_color_1/int array - primary color index = 0x65784c
-- dyom_car_color_2/int array - secondary color index = 0x657914
-- dyom_car_count/int - car count in current mission = 0x6534b4
-- dyom_car_despawn/int array - objective index = 0x653580
-- dyom_car_dir/float array - direction: 0 north, 90 east, 180 south, 270 west = 0x6579dc
-- dyom_car_flags/int array - flags = 0x657c34
-- dyom_car_handle/int array = 0x6538a4
-- dyom_car_health/int array - health points = 0x657b6c
-- dyom_car_id/int array - vehicle id = 0x653970
-- dyom_car_interior/int array - interiors world number = 0x657aa4
-- dyom_car_must_survive/int array - 0 or 1 = 0x657cfc
-- dyom_car_pos_x/float array = 0x653648
-- dyom_car_pos_y/float array = 0x653710
-- dyom_car_pos_z/float array = 0x6537d8
-- dyom_car_spawn/int array - objective index = 0x6534b8
-- dyom_cutscene_in_progress = 0x6595d0
-- dyom_cutscene_skipping = 0x6595b4
-- dyom_editor_actor = 0x6594dc
-- dyom_editor_object_count/handle to displayed menu panel = 0x6543f4
-- dyom_editor_object_handle = 0x658fc8
-- dyom_editor_panel/handle to displayed menu panel = 0x6543d0
-- dyom_intro_texts_ptr/buffer containing 3 x 100 characters = 0x6533c8
-- dyom_mission_day_time = 0x654c38
-- dyom_mission_flags = 0x65440c
-- dyom_mission_index/loaded mission file number. 0 if not loaded or read only mission = 0x6543e8
-- dyom_mission_player_dir = 0x654c48
-- dyom_mission_player_pos_x = 0x654c3c
-- dyom_mission_player_pos_y = 0x654c40
-- dyom_mission_player_pos_z = 0x654c44
-- dyom_mission_published/true if loaded mission is read only = 0x6543ec
-- dyom_mission_timelimit = 0x654c34
-- dyom_mission_wanted_max = 0x65441c
-- dyom_mission_wanted_min = 0x654418
-- dyom_mission_weather = 0x654414
-- dyom_object_count/int - object count in current mission = 0x654428
-- dyom_object_despawn/int array - objective index = 0x658bd4
-- dyom_object_handle/int array = 0x654a8c
-- dyom_object_id/int array - object id = 0x65444c
-- dyom_object_interior/int array - interior idx / behaviour / route = 0x6588b4
-- dyom_object_pos_x/float array = 0x6545dc
-- dyom_object_pos_y/float array = 0x65476c
-- dyom_object_pos_z/float array = 0x6548fc
-- dyom_object_rot_x/float array - angle in degrees = 0x658594
-- dyom_object_rot_y/float array - angle in degrees = 0x658404
-- dyom_object_rot_z/float array - angle in degrees = 0x658724
-- dyom_object_spawn/int array - objective index = 0x658a44
-- dyom_objective_count/int - objective count in current mission = 0x6543f0
-- dyom_objective_dir/float array - direction: 0 north, 90 east, 180 south, 270 west = 0x654c60
-- dyom_objective_handle/int array - entities spawned peer objective (actor for actor objective, car for car objective etc.) = 0x65408c
-- dyom_objective_index/int - current objective index = 0x65341c
-- dyom_objective_interior/int array - interiors world number = 0x654df4
-- dyom_objective_pos_x/float array = 0x653bcc
-- dyom_objective_pos_y/float array = 0x653d64
-- dyom_objective_pos_z/float array = 0x653ef8
-- dyom_objective_prop_10f/float array = 0x655c28
-- dyom_objective_prop_10i/int array = 0x655c28
-- dyom_objective_prop_1f/float array = 0x654220
-- dyom_objective_prop_1i/int array = 0x654220
-- dyom_objective_prop_2f/float array = 0x654f88
-- dyom_objective_prop_2i/int array = 0x654f88
-- dyom_objective_prop_3f/float array = 0x65511c
-- dyom_objective_prop_3i/int array = 0x65511c
-- dyom_objective_prop_4f/float array = 0x6552b0
-- dyom_objective_prop_4i/int array = 0x6552b0
-- dyom_objective_prop_5f/float array = 0x655444
-- dyom_objective_prop_5i/int array = 0x655444
-- dyom_objective_prop_6f/float array = 0x6555d8
-- dyom_objective_prop_6i/int array = 0x6555d8
-- dyom_objective_prop_7f/float array = 0x65576c
-- dyom_objective_prop_7i/int array = 0x65576c
-- dyom_objective_prop_8f/float array = 0x655900
-- dyom_objective_prop_8i/int array = 0x655900
-- dyom_objective_prop_9f/float array = 0x655a94
-- dyom_objective_prop_9i/int array = 0x655a94
-- dyom_objective_texts_ptr/pointer to first objective text. ptr + (N * dyom_objective_text_len_max) to get N-th objective text = 0x6533cc
-- dyom_objective_type/int array = 0x653a38
-- dyom_pickup_ammo/int array - bullet count / money ammount = 0x657e8c
-- dyom_pickup_behaviour/int array - see https://gtamods.com/wiki/0213#pickup_types = 0x657f54
-- dyom_pickup_count/int - pickup count in current mission = 0x654424
-- dyom_pickup_despawn/int array - objective index = 0x65833c
-- dyom_pickup_handle/int array = 0x659414
-- dyom_pickup_id/int array - object id = 0x657dc4
-- dyom_pickup_pos_x/float array = 0x65801c
-- dyom_pickup_pos_y/float array = 0x6580e4
-- dyom_pickup_pos_z/float array = 0x6581ac
-- dyom_pickup_spawn/int array - objective index = 0x658274
-- dyom_route_next_id/int array - next route point index. -1 for end, -2 for looped end = 0x651ab4
-- dyom_route_x/int float - usually position, rotation for every 2nd node in animations, durration for displacement = 0x6520f4
-- dyom_route_y/int float - usually position, rotation for every 2nd node in animations, trigger radius for displacement = 0x652734
-- dyom_route_z/int float - usually position, rotation for every 2nd node in animations = 0x652d74
-- dyom_sound_dir_ptr = 0x6533dc
