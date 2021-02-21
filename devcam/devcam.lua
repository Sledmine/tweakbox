------------------------------------------------------------------------------
-- Devcam
-- Sledmine (https://github.com/Sledmine)
-- Version 1.0.0
-- Devcam utilities for Halo Custom Edition
------------------------------------------------------------------------------
clua_version = 2.056

local keyboardInputAddress = 0x64C550
local cameraTypeAddress = 0x00647498
local cameraSpeedAddress = 0x647554
local cameraSpeedStep = 0.5
local cameraSpeedMessage = "Camera Speed: x%f"

function printCameraSpeed()
    -- Clear previous console text                        
    execute_script("cls")
    local currentCameraSpeed = read_float(cameraSpeedAddress)
    console_out(cameraSpeedMessage:format(currentCameraSpeed))
end

function OnTick()
    -- Get if the current camera type is set to debug camera
    local isDevcam = read_word(cameraTypeAddress) == 30704

    -- Get current debug camera velocity
    local currentCameraSpeed = read_float(cameraSpeedAddress)

    -- Get time pressed for "z" and "x" keys
    local zKey = read_byte(keyboardInputAddress + 58)
    local yKey = read_byte(keyboardInputAddress + 59)

    if (isDevcam) then
        -- Get pressed key
        if (zKey > 0) then
            -- For some reason maximum camera speed in game is 50
            if (currentCameraSpeed < 50) then
                write_float(cameraSpeedAddress, currentCameraSpeed + cameraSpeedStep)
            end
            printCameraSpeed()
        elseif (yKey > 0) then
            -- Minimum camera speed should be something greater than 0
            if (currentCameraSpeed > 0 and currentCameraSpeed > cameraSpeedStep) then
                write_float(cameraSpeedAddress, currentCameraSpeed - cameraSpeedStep)
            end
            printCameraSpeed()
        end
    end
end

set_callback("tick", "OnTick")
