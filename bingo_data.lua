-- Get current date
local date = os.date("*t")
local month = os.date("%B", os.time(date))
local year = date.year

local slots = {
  -- Subtitles
  {
    id = "english_mission",
    string = "English",
    requires = {"Subtitles"},
  },
  {
    id = "portuguese_mission",
    string = "Portuguese",
    requires = {"Subtitles"},
  },
  {
    id = "spanish_mission",
    string = "Spanish",
    requires = {"Subtitles"},
  },
  {
    id = "italian_mission",
    string = "Italian",
    requires = {"Subtitles"},
  },
  {
    id = "polish_mission",
    string = "Polish",
    requires = {"Subtitles"},
  },

  -- TTS
  {
    id = "male_tts_voice",
    string = "Male TTS",
    requires = {"TTS"},
  },
  {
    id = "female_tts_voice",
    string = "Female TTS",
    requires = {"TTS"},
  },
  {
    id = "brazilian_tts_voice",
    string = "Brazilian TTS",
    requires = {"TTS"},
  },

  -- Start
  {
    id = "starts_san_fierro",
    string = "San Fierro",
  },
  {
    id = "starts_las_venturas",
    string = "Las Venturas",
  },
  {
    id = "starts_los_santos",
    string = "Los Santos",
  },
  {
    id = "starts_interior",
    string = "Interior",
  },
  {
    id = "starts_grove_street",
    string = "Grove Street",
  },
  {
    id = "starts_verdant_meadows",
    string = "Verdant M.",
  },
  {
    id = "starts_area_69",
    string = "Area 69",
  },
  {
    id = "starts_johnson_house",
    string = "Johnson House",
  },
  {
    id = "starts_no_weapons",
    string = "No weapons",
    helperText = "Player starts the mission without any weapons",
  },
  {
    id = "starts_9999_ammo",
    string = "9999 ammo",
    helperText = "The default value for ammo in DYOM is 9999",
  },
  {
    id = "starts_8am",
    string = "8:00 AM",
    helperText = "Default time of the day in DYOM",
    requires = {"Time"},
  },
  {
    id = "starts_with_cutscene",
    string = "W/ cutscene",
  },
  {
    id = "no_start_cutscene",
    string = "No cutscene",
  },
  {
    id = "starts_nighttime",
    string = "Nighttime",
  },
  {
    id = "starts_daytime",
    string = "Daytime",
  },
  {
    id = "starts_sandstorm",
    string = "Sandstorm",
  },
  {
    id = "starts_rainy",
    string = "Rainy",
  },
  {
    id = "starts_sunny",
    string = "Sunny",
    helperText = "Default weather in DYOM",
  },
  {
    id = "starts_wanted",
    string = "Wanted",
    helperText = "Player starts with a wanted level of at least 1 star",
  },

  -- Mission info
  {
    id = "translated_mission",
    string = "Translated",
    helperText = "Mark this slot if your mission has been translated by the DYOM Rainbomizer auto-translate feature",
    requires = {"Translator"},
  },
  {
    id = "colors_in_title",
    string = "Colors",
  },
  {
    id = "kill_in_title",
    string = '"Kill"',
  },
  {
    id = "the_in_title",
    string = '"The"',
  },
  {
    id = "mission_name_dyom",
    string = '"DYOM"',
    helperText = 'The default mission title in DYOM is "DYOM"',
  },
  {
    id = "author_dyom",
    string = "by DYOM",
    helperText = 'The default author name in DYOM is "DYOM". You can\'t change the author name in the settings after you confirm it',
  },
  {
    id = "within_year",
    string = "Within year",
    helperText = string.format("This mission was published between %s, %d and %s, %d", month, year - 1, month, year),
    requires = {"Info"},
  },
  {
    id = "ten_years_old",
    string = "10+ years",
    helperText = "DYOM's first version was released on November 30, 2008",
    requires = {"Info"},
  },
  {
    id = "made_by_target13",
    string = "Target13",
    helperText = "Target13 is a senior designer of DYOM Community",
  },
  {
    id = "made_by_leoncj",
    string = "LeonCJ",
    helperText = "LeonCJ is a senior designer of DYOM Community",
  },
  {
    id = "author_has_dyom",
    string = "DYOM in name",
  },
  {
    id = "author_has_numbers",
    string = "Numbers",
  },
  {
    id = "part_x",
    string = "Part X (X>1)",
  },
  {
    id = "part_1",
    string = "Part 1",
  },
  {
    id = "motw_mission",
    string = "MOTW",
    helperText = "MOTW stands for Mission Of The Week. It is a weekly contest in DYOM Community",
  },
  {
    id = "mission_pack",
    string = "Mission pack",
    helperText = "Since DYOM only supports up to 100 objectives per mission, many designers choose to separate their stories into several missions",
  },

  -- Mission theme
  {
    id = "gang_mission",
    string = "Gang",
    helperText = "Grove vs Ballas, Mafia families, Biker gangs, etc",
  },
  {
    id = "casual_life",
    string = "Casual life",
    helperText = "Stories that tries to simulate real-life situations, like going to work and meeting your friends",
  },
  {
    id = "alternative_sa",
    string = "Alt SA story",
    helperText = "Stories that provide a different perspective of the original GTA San Andreas storyline",
  },
  {
    id = "zombie_mission",
    string = "Zombie",
  },
  {
    id = "military_mission",
    string = "Military",
  },
  {
    id = "rescue_mission",
    string = "Rescue",
    helperText = "The story is about the player trying to rescue someone or a group of people",
  },
  {
    id = "drug_related",
    string = "Drug-related",
  },
  {
    id = "heist_mission",
    string = "Heist",
    helperText = "The story is about a heist (like casino heist, bank robbery, etc)",
  },
  {
    id = "revenge_mission",
    string = "Revenge",
    helperText = "The story is about a revenge being committed by the player or against the player",
  },
  {
    id = "racing_mission",
    string = "Racing",
  },
  {
    id = "cop_mission",
    string = "Cop",
  },

  -- Bugs and problems
  {
    id = "translate_fail",
    string = "Trans. fail",
    helperText = "Sometimes the auto-translate feature encounters a problem trying to translate the current mission",
    requires = {"Translate"},
  },
  {
    id = "requires_mods",
    string = "Needs mods",
    helperText = "Some designers uses external mods to make more unique missions, and some of these mods can crash DYOM if you don't have them installed",
  },
  {
    id = "mission_crashes",
    string = "Crashes",
  },
  {
    id = "rainbomizer_load_fail",
    string = "Load fail",
    helperText = "Sometimes the Rainbomizer encounters a problem downloading the mission file, or maybe the author deleted it",
  },
  {
    id = "ball_actor_bug",
    string = "Ball actor",
    helperText = "A problem with the base game which occurs when too many NPC actors are loaded at the same time",
  },
  {
    id = "camera_bug",
    string = "Camera bug",
    helperText = "The camera of a cutscene gets stuck during gameplay. This happens when you set an cutscene to follow/look at an actor as the last cutscene before the start of a gameplay.",
  },

  -- Mission status
  {
    id = "mission_passed",
    string = "PASSED",
    helperText = "Complete a mission",
  },
  {
    id = "mission_failed",
    string = "FAILED",
    helperText = "Fail a mission",
  },
  {
    id = "wasted",
    string = "WASTED",
    helperText = "Player died",
  },
  {
    id = "busted",
    string = "BUSTED",
    helperText = "Player gets arrested",
  },
  {
    id = "mission_skipped",
    string = "Skipped",
    helperText = "Skip a mission",
  },

  -- Player
  {
    id = "player_cj",
    string = "CJ",
    helperText = "CJ is the default skin in the DYOM skin selection menu",
  },
  {
    id = "player_ryder",
    string = "Ryder",
  },
  {
    id = "player_cop",
    string = "Cop",
  },
  {
    id = "player_military",
    string = "Military",
  },
  {
    id = "player_sweet",
    string = "Sweet",
  },
  {
    id = "player_big_smoke",
    string = "Big Smoke",
  },
  {
    id = "player_tenpenny",
    string = "Tenpenny",
  },
  {
    id = "player_woman",
    string = "Woman",
  },
  {
    id = "player_triads",
    string = "Triads",
  },
  {
    id = "player_ballas",
    string = "Ballas",
  },
  {
    id = "player_vagos",
    string = "Vagos",
  },
  {
    id = "player_grove_street",
    string = "Grove Street",
  },
  {
    id = "player_150_health",
    string = "150 health",
    helperText = "This happens when the player's health is set to 150",
  },

  -- Settings
  {
    id = "wanted_enabled",
    string = "Wanted ON",
    helperText = "Wanted stars are enabled by default since the first version of the mod. Many designers forget to disable it",
  },
  {
    id = "wanted_disabled",
    string = "Wanted OFF",
  },
  {
    id = "has_intro_text",
    string = "Intro text",
    helperText = 'Appears in the upper-left corner before "Missiondesign by…"',
  },
  {
    id = "riot_mode",
    string = "Riot mode",
    helperText = "This feature was introduced in DYOM 3.0",
  },
  {
    id = "no_peds_cars",
    string = "No peds/cars",
    helperText = "A mission designer can disable pedestrians and traffic in DYOM",
  },

  -- Actors
  {
    id = "kill_the_person",
    string = "Kill person",
    helperText = "Default text for enemy actor objective",
  },
  {
    id = "kill_big_smoke",
    string = "Kill Smoke",
  },
  {
    id = "kill_cj",
    string = "Kill CJ",
  },
  {
    id = "kill_sweet",
    string = "Kill Sweet",
  },
  {
    id = "kill_all_but_one",
    string = "Kill all->1",
    helperText = 'The "Kill whole gang" option was only introduced in later versions of DYOM. That is why many older missions are designed that way',
  },
  {
    id = "kill_all_but_checkpoint",
    string = "Kill all->CP",
    helperText = 'The "Kill whole gang" option was only introduced in later versions of DYOM. That is why many older missions are designed that way',
  },
  {
    id = "enemies_2500_health",
    string = "2500 health",
    helperText = "This is the maximum health an actor can have in DYOM",
  },
  {
    id = "headshots_off",
    string = "No headshots",
    helperText = "Despite what many people think, the default value for headshots is ON. It is the designer's choice to disable the headshot for each spawned actor",
  },
  {
    id = "headshots_inconsistency",
    string = "HS on/off",
    helperText = "Despite what many people think, the default value for headshots is ON. It is the designer's choice to disable the headshot for each spawned actor",
  },
  {
    id = "shirtless_zombie",
    string = "Shirtless",
    helperText = "Shirtless old man is a zombie",
  },
  {
    id = "overpowered_accuracy",
    string = "OP accuracy",
    helperText = "The accuracy options in DYOM are: 10, 25, 50, 75, 100",
  },
  {
    id = "friendly_follows",
    string = "Friend follow",
  },
  {
    id = "friend_better_weapon",
    string = "Friend OP",
    helperText = "Your friend has a better weapon than you",
  },
  {
    id = "health_bar_right",
    string = "HP bar right",
  },
  {
    id = "friend_left_behind",
    string = "Left behind",
    helperText = "Your friend is supposed to go somewhere with you, but you leave them behind",
  },
  {
    id = "enemy_minigun",
    string = "Minigun",
  },
  {
    id = "enemy_combat_shotgun",
    string = "Combat SG",
  },
  {
    id = "enemy_desert_eagle",
    string = "Desert Eagle",
  },
  {
    id = "actor_dancing",
    string = "Dancing",
  },
  {
    id = "actor_aiming",
    string = "Aiming",
  },
  {
    id = "actor_sleeping",
    string = "Sleeping",
  },
  {
    id = "actor_dying",
    string = "Dying",
  },
  {
    id = "actor_route",
    string = "Walk route",
    helperText = "The designer can assign a walk/run/sprint/drive route to an actor",
  },
  {
    id = "actor_driving",
    string = "Driving anim",
    helperText = "The designer can assign a walk/run/sprint/drive route to an actor",
  },
  {
    id = "actor_wrong_name",
    string = "Wrong name",
    helperText = "An actor has a name that does not correspond to the original game character's name. Ex: Actor has Ryder skin but his name is Jorge",
  },

  -- Checkpoints
  {
    id = "next_checkpoint",
    string = "Next CP",
    helperText = "Default text for checkpoint objectives",
  },
  {
    id = "invisible_checkpoint",
    string = "Invisible CP",
  },
  {
    id = "racing_checkpoint",
    string = "Racing CP",
  },
  {
    id = "airplane_checkpoint",
    string = "Airplane CP",
  },
  {
    id = "checkpoint_no_teleport",
    string = "CP no tele",
    helperText = "Checkpoint near yellow marker which doesn't teleport you to the interior when entered",
  },
  {
    id = "checkpoint_in_car",
    string = "CP in car",
    helperText = "Checkpoint is located within the car you need to enter (instead of a 'get in the car' objective)",
  },

  -- Locations
  {
    id = "return_ganton",
    string = "Ganton",
  },
  {
    id = "travel_far",
    string = "Travel far",
  },
  {
    id = "crack_palace",
    string = "Crack Palace",
  },
  {
    id = "meat_factory",
    string = "Meat Factory",
  },
  {
    id = "police_station",
    string = "Police St.",
  },
  {
    id = "jefferson_motel",
    string = "Jeff. Motel",
  },
  {
    id = "house_interior",
    string = "House",
  },
  {
    id = "twenty_four_seven",
    string = "24/7",
  },
  {
    id = "interior_music",
    string = "Music int.",
    helperText = "Uses an interior that has background music in it",
  },
  {
    id = "ls_skyscraper",
    string = "LS Skyscr.",
  },
  {
    id = "lspd_parking",
    string = "LSPD Parking",
  },
  {
    id = "madd_dogg_mansion",
    string = "MD mansion",
  },
  {
    id = "area_69_underground",
    string = "A69 undergr.",
  },
  {
    id = "area_69_exterior",
    string = "A69 exterior",
  },
  {
    id = "caligula_basement",
    string = "Calig. base.",
  },
  {
    id = "casino_interior",
    string = "Casino",
  },

  -- Objects and Pickups
  {
    id = "dead_cop_body",
    string = "Dead cop",
  },
  {
    id = "health_armor_pickups",
    string = "HP/Armor",
  },
  {
    id = "explosive_barrels",
    string = "Expl. barrel",
  },
  {
    id = "ramp_object",
    string = "Ramp",
  },
  {
    id = "garage_door",
    string = "Garage door",
  },
  {
    id = "money_bag_pickup",
    string = "Money bag",
  },
  {
    id = "weapon_pickups",
    string = "Weapon pick.",
  },

  -- Cutscenes and Timeouts
  {
    id = "misspelled_name",
    string = "Misspelled",
  },
  {
    id = "groove_street",
    string = "Groove St.",
  },
  {
    id = "to_be_continued",
    string = "TBC",
    helperText = "TO BE CONTINUED (or something like that). Since DYOM only supports up to 100 objectives per mission, many designers choose to separate their stories into several missions",
  },
  {
    id = "parentheses_sounds",
    string = "(sounds)",
    helperText = "Cutscene has (parentheses) to represent sounds. DYOM has a feature for playing sounds but many designers don't know about it. Anyways, the Rainbomizer mod does not support it yet",
  },
  {
    id = "cutscene_only",
    string = "CS only",
  },
  {
    id = "no_cutscenes",
    string = "No CS",
  },
  {
    id = "long_cutscene",
    string = "Long CS",
  },
  {
    id = "explosion_cutscene",
    string = "Explosion CS",
    helperText = "Something explodes, like a car, a house, Big Smoke, etc",
  },
  {
    id = "smooth_cutscene",
    string = "Smooth CS",
    helperText = "The camera of the cutscene moves around smoothly, instead of being a static shot",
  },
  {
    id = "shaky_camera",
    string = "Shaky cam",
    helperText = "The cutscene has a shaky effect (Commonly used for explosions or drunk player effect)",
  },
  {
    id = "establishing_shot",
    string = "Establ. shot",
    helperText = "A cutscene that shows the location of the scene, used to show where the action will happen",
  },
  {
    id = "first_person_cutscene",
    string = "First-person",
    helperText = "Also known as Point of View shot (POV) is when the DYOM camera is set to emulate the perspective of the player or a defined actor",
  },
  {
    id = "ground_level_shot",
    string = "Ground shot",
    helperText = "A ground level shot is when the cutscene's camera height is on the ground level or very close to it",
  },
  {
    id = "overhead_shot",
    string = "Overhead shot",
  },

  -- Others
  {
    id = "talk_on_phone",
    string = "Phone call",
  },
  {
    id = "timelimit",
    string = "Timelimit",
    helperText = "A timelimit objective starts a timer and the player needs to complete a defined set of objectives before the timer runs out",
  },
  {
    id = "money_objective",
    string = "Money obj.",
    helperText = "A money objective will increase or decrease the amount of money the player has",
  },
  {
    id = "white_marker",
    string = "White marker",
  },
  {
    id = "locked_cars",
    string = "Locked cars",
  },
  {
    id = "quick_mission",
    string = "Quick (<1m)",
  },
  {
    id = "abrupt_ending",
    string = "Abrupt end",
  },
  {
    id = "hitman_skill",
    string = "Hitman skill",
    helperText = 'There are three levels of skills: "Poor", "Gangster" and "Hitman". DYOM missions starts at poor skill and it cannot be changed by the mission designer',
  },
  {
    id = "objective_no_teleport",
    string = "Obj no tele",
    helperText = "Objective inside interior without teleporting you to it",
  },
  {
    id = "meta_dyom",
    string = "Meta-DYOM",
    helperText = "Makes references to the own mission, DYOM modification, DYOM users or DYOM features",
  },
}

local requirements = {
  {
    name = "Translator",
    description = "Limit slots that require translator",
  },
  {
    name = "TTS",
    description = "Limit slots that require Text-To-Speech",
  },
  {
    name = "Info",
    description = "Limit slots that require DYOM Metadata",
  },
  {
    name = "Time",
    description = "Limit slots that require in-game timer",
  },
  {
    name = "Subtitles",
    description = "Limit slots that require original subtitles",
  },
}

return {
  slots = slots,
  requirements = requirements,
}
