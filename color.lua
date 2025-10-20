script_name('Color Shifter')
script_author('YourName')
script_version('1.0')

require 'lib.moonloader'
local ffi = require 'ffi'
local memory = require 'memory'

-- Define CTimeCycle structure pointers (memory offsets from game exe)
local CTimeCycle = {
    m_nAmbientRed = ffi.cast("unsigned char*", memory.getuint32(0x560C61)),
    m_nAmbientGreen = ffi.cast("unsigned char*", memory.getuint32(0x55F4D6)),
    m_nAmbientBlue = ffi.cast("unsigned char*", memory.getuint32(0x55F4E8)),
    -- Add more as needed: sky, sun, postfx, etc. (full list in the editor script above)
    m_fPostFx1Red = ffi.cast("unsigned char*", memory.getuint32(0x55F6E9)),
    m_fPostFx1Green = ffi.cast("unsigned char*", memory.getuint32(0x55F6FC)),
    m_fPostFx1Blue = ffi.cast("unsigned char*", memory.getuint32(0x55F70F)),
    m_fPostFx1Alpha = ffi.cast("unsigned char*", memory.getuint32(0x55F725)),
    m_fPostFx2Red = ffi.cast("unsigned char*", memory.getuint32(0x55F73B)),
    m_fPostFx2Green = ffi.cast("unsigned char*", memory.getuint32(0x55F751)),
    m_fPostFx2Blue = ffi.cast("unsigned char*", memory.getuint32(0x55F767)),
    m_fPostFx2Alpha = ffi.cast("unsigned char*", memory.getuint32(0x55F77D)),
    m_fLightsOnGroundBrightness = ffi.cast("unsigned char*", memory.getuint32(0x55F640)),
    -- Current weather/hour pointers
    CurrWeather = ffi.cast("short*", 0xC81320),
    Hours = ffi.cast("unsigned char*", 0xB70153)
}

-- Helper to get current timecycle index (NUMWEATHERS = 21 in standard GTA SA)
local NUMWEATHERS = 21
function getCurrentIndex()
    local hour_id = CTimeCycle.Hours[0]  -- Current hour (0-23)
    local weather_id = CTimeCycle.CurrWeather[0]
    return NUMWEATHERS * hour_id + weather_id
end

-- Function to apply changes (example: +20% saturation via postfx contrast, +brightness, hue to warmer)
function applyColorShift()
    local i = getCurrentIndex()

    -- Read current values
    local post1_r = CTimeCycle.m_fPostFx1Red[i]
    local post1_g = CTimeCycle.m_fPostFx1Green[i]
    local post1_b = CTimeCycle.m_fPostFx1Blue[i]
    local post1_a = CTimeCycle.m_fPostFx1Alpha[i]

    -- Apply shifts (adjust multipliers as needed; clamp to 0-255)
    -- Hue shift: Boost red, reduce blue for warmer tones
    CTimeCycle.m_fPostFx1Red[i] = math.min(255, post1_r + 30)
    CTimeCycle.m_fPostFx1Blue[i] = math.max(0, post1_b - 20)

    -- Saturation boost: Amplify RGB differences (simple contrast increase)
    local avg = (post1_r + post1_g + post1_b) / 3
    CTimeCycle.m_fPostFx1Red[i] = math.min(255, avg + (post1_r - avg) * 1.2)  -- 20% boost
    CTimeCycle.m_fPostFx1Green[i] = math.min(255, avg + (post1_g - avg) * 1.2)
    CTimeCycle.m_fPostFx1Blue[i] = math.min(255, avg + (post1_b - avg) * 1.2)

    -- Brightness: Increase alpha/intensity and ground lights
    CTimeCycle.m_fPostFx1Alpha[i] = math.min(255, post1_a + 40)
    CTimeCycle.m_fLightsOnGroundBrightness[i] = math.min(255, CTimeCycle.m_fLightsOnGroundBrightness[i] + 50)

    print('Colors shifted for current time/weather!')
end

-- Main loop: Wait for key press to apply (e.g., F10)
function main()
    while true do
        wait(0)
        if isKeyJustPressed(VK_F10) then
            applyColorShift()
        end
    end
end