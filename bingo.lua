script_name("DYOM Bingo")
script_author("Toriality")
script_description("DYOM Bingo Card for GTA SA")

local imgui = require("imgui")
local encoding = require("encoding")
local data = require("bingo_data")
local detection = require("bingo_detection")
encoding.default = "CP1251"
u8 = encoding.UTF8

local TOGGLE_VISIBILITY_KEY = 0x42  -- B key (VK_B)
local TOGGLE_INTERACTION_KEY = 0x49 -- I key (VK_I)
local TOGGLE_CONFIG_KEY = 0x4D      -- M key (VK_M)
local BINGO_SIZE = 5
local CELL_SIZE = 90
local WINDOW_WIDTH = 500
local WINDOW_HEIGHT = 520
local WINDOW_OFFSET = 20
local DEBUG_MODE = false

local slots = data.slots
local requirements = data.requirements

local show_window = imgui.ImBool(false)
local show_config = imgui.ImBool(false)
local requirement_filters = {}
local interactive_mode = false
local bingo_card = {}
local selected_slots = {}
local slot_positions = {}
local has_bingo = false

local function debug_log(...)
  if DEBUG_MODE then
    print("[DYOM Bingo]", ...)
  end
end

local function is_requirement_filtered(requirement_name)
  local filter = requirement_filters[requirement_name]
  return filter and filter.v
end

function generate_bingo_card()
  bingo_card = {}
  selected_slots = {}
  slot_positions = {}
  has_bingo = false

  local filtered_slots = {}
  for _, slot in ipairs(slots) do
    local skip = false
    if slot.requires then
      for _, r in ipairs(slot.requires) do
        if is_requirement_filtered(r) then
          skip = true
          break
        end
      end
    end
    if not skip then
      table.insert(filtered_slots, slot)
    end
  end

  local required_slots = BINGO_SIZE * BINGO_SIZE - 1 -- -1 for free space
  if #filtered_slots < required_slots then
    debug_log("Warning: Not enough slots after filtering. Need " .. required_slots .. ", have " .. #filtered_slots)
    -- TODO: Add user notification
  end

  -- Shuffle remaining phrases using Fisher-Yates algorithm
  local shuffled = {}
  for i = 1, #filtered_slots do
    shuffled[i] = filtered_slots[i]
  end
  for i = #shuffled, 2, -1 do
    local j = math.random(i)
    shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
  end

  -- Fill card and build position lookup table
  local index = 1
  for row = 1, BINGO_SIZE do
    bingo_card[row] = {}
    selected_slots[row] = {}
    for col = 1, BINGO_SIZE do
      if row == 3 and col == 3 then
        -- Free space in center
        bingo_card[row][col] = { string = "FREE SPACE", id = "free" }
        selected_slots[row][col] = true
        slot_positions["free"] = { row = row, col = col }
      else
        local slot = shuffled[index] or { string = "Empty", id = "empty_" .. index }
        bingo_card[row][col] = slot
        selected_slots[row][col] = false
        slot_positions[slot.id] = { row = row, col = col }
        index = index + 1
      end
    end
  end

  debug_log("Generated new bingo card with " .. (index - 1) .. " slots")
end

function auto_check_card(task_id)
  debug_log("Auto-checking task:", task_id)

  local pos = slot_positions[task_id]
  if not pos then
    debug_log("Card not found:", task_id)
    return false
  end

  local row, col = pos.row, pos.col
  if selected_slots[row][col] then
    debug_log("Card already selected:", task_id)
    return false
  end

  selected_slots[row][col] = true
  local slot_text = bingo_card[row][col].string
  printHelpString("~g~Bingo! ~w~" .. slot_text)
  debug_log("Selected slot:", row, col, slot_text)

  has_bingo = check_bingo()
  if has_bingo then
    printHelpString("~y~BINGO! YOU WON!", 5000)
    debug_log("BINGO achieved!")
  end

  return true
end

function check_bingo()
  -- Check rows
  for row = 1, BINGO_SIZE do
    local all_selected = true
    for col = 1, BINGO_SIZE do
      if not selected_slots[row][col] then
        all_selected = false
        break
      end
    end
    if all_selected then
      return true
    end
  end

  -- Check columns
  for col = 1, BINGO_SIZE do
    local all_selected = true
    for row = 1, BINGO_SIZE do
      if not selected_slots[row][col] then
        all_selected = false
        break
      end
    end
    if all_selected then
      return true
    end
  end

  -- Check diagonals
  local diag1 = true
  local diag2 = true
  for i = 1, BINGO_SIZE do
    if not selected_slots[i][i] then
      diag1 = false
    end
    if not selected_slots[i][BINGO_SIZE - i + 1] then
      diag2 = false
    end
  end

  return diag1 or diag2
end

-- ImGui window rendering
function imgui.OnDrawFrame()
  -- Bingo Card Window
  if show_window.v then
    local sw, sh = getScreenResolution()
    local window_x = sw - WINDOW_WIDTH - WINDOW_OFFSET
    local window_y = sh - WINDOW_HEIGHT - WINDOW_OFFSET
    imgui.SetNextWindowPos(imgui.ImVec2(window_x, window_y), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(WINDOW_WIDTH, WINDOW_HEIGHT), imgui.Cond.FirstUseEver)

    local window_flags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar

    if not interactive_mode then
      window_flags = window_flags + imgui.WindowFlags.NoInputs
    end

    imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 0.0))
    imgui.Begin("DYOM Bingo Card", show_window, window_flags)

    if has_bingo then
      imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.0, 0.84, 0.0, 1.0))
      imgui.Text("BINGO! You won!")
      imgui.PopStyleColor()
    end

    for row = 1, BINGO_SIZE do
      for col = 1, BINGO_SIZE do
        if col > 1 then
          imgui.SameLine()
        end

        imgui.PushID(row * 10 + col)

        if selected_slots[row][col] then
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.2, 1.0))
          imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.3, 1.0))
          imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.6, 0.1, 1.0))
        else
          imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.4))
          imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.26, 0.59, 0.98, 0.6))
          imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.06, 0.53, 0.98, 1.0))
        end

        local slot = bingo_card[row][col]
        local label = u8(slot.string)

        if imgui.Button(label, imgui.ImVec2(CELL_SIZE, CELL_SIZE)) then
          if row ~= 3 or col ~= 3 then -- Can't toggle free space
            selected_slots[row][col] = not selected_slots[row][col]
            has_bingo = check_bingo()
          end
        end

        if slot.helperText and imgui.IsItemHovered() then
          imgui.SetTooltip(u8(slot.helperText))
        end

        imgui.PopStyleColor(3)
        imgui.PopID()
      end
    end

    imgui.End()
    imgui.PopStyleColor()
  end

  -- Config Window
  if show_config.v then
    local sw, sh = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.Appearing, imgui.ImVec2(0.5, 0.5))

    local window_flags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize

    if not interactive_mode then
      window_flags = window_flags + imgui.WindowFlags.NoInputs
    end

    imgui.Begin("DYOM Bingo Config", show_config, window_flags)

    imgui.Text("Requirement Filters:")
    imgui.Text("(Check to EXCLUDE these types of slots)")
    imgui.Separator()

    for _, req in ipairs(requirements) do
      imgui.Checkbox(u8(req.description), requirement_filters[req.name])
    end

    imgui.Separator()

    if imgui.Button("Generate New Card", imgui.ImVec2(200, 40)) then
      generate_bingo_card()
    end

    imgui.End()
  end
end

function main()
  if not pcall(function()
        assert(data, "bingo_data module not loaded")
        assert(detection, "bingo_detection module not loaded")
        assert(slots and #slots > 0, "No bingo slots found in bingo_data")
        assert(requirements, "No requirements found in bingo_data")
      end) then
    printStringNow("DYOM Bingo: Failed to load required modules!", 5000)
    return
  end

  wait(1000)

  -- Initialize requirement filters
  for _, req in ipairs(requirements) do
    requirement_filters[req.name] = imgui.ImBool(false)
  end

  -- Initialize detection system
  detection.init(auto_check_card)
  debug_log("Detection initialized")

  -- Generate initial card
  generate_bingo_card()

  -- Configure ImGui
  imgui.Process = false
  imgui.ShowCursor = false

  debug_log("DYOM Bingo initialized successfully")
  printHelpString("~b~DYOM Bingo ~w~loaded! Press ~y~B~w~ to toggle card, ~y~M~w~ for config")

  while true do
    wait(0)

    imgui.Process = show_window.v or show_config.v

    -- Auto-detect game events
    detection.update()

    -- Toggle config window (M key)
    if wasKeyPressed(TOGGLE_CONFIG_KEY) then
      show_config.v = not show_config.v
      if show_config.v and not interactive_mode then
        interactive_mode = true
        imgui.ShowCursor = true
        imgui.LockPlayer = true
      end
    end

    -- Toggle bingo card visibility (B key)
    if wasKeyPressed(TOGGLE_VISIBILITY_KEY) then
      show_window.v = not show_window.v
    end

    -- Toggle interaction mode (I key)
    if (show_window.v or show_config.v) and wasKeyPressed(TOGGLE_INTERACTION_KEY) then
      interactive_mode = not interactive_mode
      imgui.ShowCursor = interactive_mode
      imgui.LockPlayer = interactive_mode
    end

    -- Auto-disable interaction if all windows closed
    if not show_window.v and not show_config.v and interactive_mode then
      interactive_mode = false
      imgui.ShowCursor = false
      imgui.LockPlayer = false
    end
  end
end
