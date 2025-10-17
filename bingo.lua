script_name("DYOM Bingo")
script_author("Toriality")
script_description("DYOM Bingo Card for GTA SA")

local imgui = require("imgui")
local encoding = require("encoding")
local data = require("bingo_data")
local detection = require("bingo_detection")
encoding.default = "CP1251"
u8 = encoding.UTF8
local slots = data.slots
local requirements = data.requirements

-- Configuration
local TOGGLE_VISIBILITY_KEY = 0x42-- B key (VK_B)
local TOGGLE_INTERACTION_KEY = 0x49 -- I key (VK_I)
local TOGGLE_CONFIG_KEY = 0x4D -- M key (VK_M)
local BINGO_SIZE = 5

-- State variables
local show_window = imgui.ImBool(false)
local show_config = imgui.ImBool(false)
local requirement_filters = {}
local interactive_mode = false
local bingo_card = {}
local selected_slots = {}
local has_bingo = false

-- Initialize bingo card
function generate_bingo_card()
	bingo_card = {}
	selected_slots = {}
	has_bingo = false

	-- Filter slots according to toggled requirements
	local filtered_slots = {}
	for _, slot in ipairs(slots) do
		local skip = false
		if slot.requires then
			for _, r in ipairs(slot.requires) do
				if requirement_filters[r] and requirement_filters[r].v then
					skip = true
					break
				end
			end
		end
		if not skip then
			table.insert(filtered_slots, slot)
		end
	end

	-- Shuffle remaining phrases
	local shuffled = {}
	for i = 1, #filtered_slots do
		shuffled[i] = filtered_slots[i]
	end
	for i = #shuffled, 2, -1 do
		local j = math.random(i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end

	-- Fill card
	local index = 1
	for row = 1, BINGO_SIZE do
		bingo_card[row] = {}
		selected_slots[row] = {}
		for col = 1, BINGO_SIZE do
			if row == 3 and col == 3 then
				bingo_card[row][col] = { string = "FREE SPACE", id = "free" }
				selected_slots[row][col] = true
			else
				bingo_card[row][col] = shuffled[index] or { string = "Empty", id = "empty" }
				selected_slots[row][col] = false
				index = index + 1
			end
		end
	end
end

-- Auto-check a card by ID
function auto_check_card(task_id)
	printStringNow(task_id, 2000)
	print("Auto-checking: ", task_id)
	for row = 1, BINGO_SIZE do
		for col = 1, BINGO_SIZE do
			if bingo_card[row][col].id == task_id and not selected_slots[row][col] then
				selected_slots[row][col] = true
				printHelpString("~g~Bingo! ~w~" .. bingo_card[row][col].string, 2000)
				has_bingo = check_bingo()

				if has_bingo then
					printHelpString("~y~BINGO! YOU WON!", 5000)
				end

				print("Selected slot: ", row, col, bingo_card[row][col].string)
				return true
			end
		end
	end
	print("Card not found or already selected: ", task_id)
	return false
end

-- Check for bingo (any row, column, or diagonal)
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
		imgui.SetNextWindowPos(imgui.ImVec2(sw - 20, sh - 20), imgui.Cond.FirstUseEver, imgui.ImVec2(1.0, 1.0))
		imgui.SetNextWindowSize(imgui.ImVec2(500, 520), imgui.Cond.FirstUseEver)

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

		-- Bingo grid
		local cell_size = 90
		local padding = 5

		for row = 1, BINGO_SIZE do
			for col = 1, BINGO_SIZE do
				if col > 1 then
					imgui.SameLine()
				end

				imgui.PushID(row * 10 + col)

				-- Set button color based on selection
				if selected_slots[row][col] then
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.7, 0.2, 1.0))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.8, 0.3, 1.0))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.1, 0.6, 0.1, 1.0))
				else
					imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.59, 0.98, 0.4))
					imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.26, 0.59, 0.98, 0.6))
					imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.06, 0.53, 0.98, 1.0))
				end

				-- Wrap text for button
				local slot = bingo_card[row][col]
				local label = u8(slot.string)

				if imgui.Button(label, imgui.ImVec2(cell_size, cell_size)) then
					if row ~= 3 or col ~= 3 then -- Can't toggle free space
						selected_slots[row][col] = not selected_slots[row][col]
						has_bingo = check_bingo()
					end
				end
				if slot.helperText then -- Tooltip
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8(slot.helperText))
					end
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

-- Main script loop
function main()
	wait(1000)

	-- Initialize
	for _, req in ipairs(requirements) do
		requirement_filters[req.name] = imgui.ImBool(false)
	end
	detection.init(auto_check_card)
	print("Detection initialized in main", detection.check_card)
	generate_bingo_card()

	-- Enable ImGui processing
	imgui.Process = false
	imgui.ShowCursor = false

	while true do
		wait(0)

		-- Always render the window if visible
		imgui.Process = show_window.v or show_config.v

		-- Auto-detect game events
		detection.update()

		-- Toggle visibility
		if wasKeyPressed(TOGGLE_CONFIG_KEY) then
			show_config.v = not show_config.v
		end
		if wasKeyPressed(TOGGLE_VISIBILITY_KEY) then
			show_window.v = not show_window.v
		end
		-- Toggle interaction mode
		if (show_window.v or show_config.v) and wasKeyPressed(TOGGLE_INTERACTION_KEY) then
			interactive_mode = not interactive_mode
			imgui.ShowCursor = interactive_mode
			imgui.LockPlayer = interactive_mode
		end
		if (not show_window.v and not show_config.v) and interactive_mode then
			interactive_mode = false
			imgui.ShowCursor = false
			imgui.LockPlayer = false
		end
	end
end
