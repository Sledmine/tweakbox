------------------------------------------------------------------------------
-- FP Animation Permutation
-- First persons animation permutation using OpenSauce label format
-- Author: Sledmine
-- Version: 2.1
------------------------------------------------------------------------------
clua_version = 2.042

local keepTimer = true
local debugMode = false
local permutatorTimer

local blam = require "blam"
local tagClasses = blam.tagClasses
local objectClasses = blam.objectClasses
console_out = blam.consoleOutput

local glue = require "glue"
local inspect = require "inspect"

--- Function to send debug messages to console output
---@param message string
---@param color '"string"' | '"category"' | '"warning"' | '"error"' | '"success"'
function dprint(message, color)
    if (type(message) ~= "string") then
        message = inspect(message)
    end
    if (debugMode) then
        if (color == "category") then
            console_out(message, 0.31, 0.631, 0.976)
        elseif (color == "warning") then
            console_out(message, blam.consoleColors.warning)
        elseif (color == "error") then
            console_out(message, blam.consoleColors.error)
        elseif (color == "success") then
            console_out(message, blam.consoleColors.success)
        else
            console_out(message)
        end
    end
end

-- List of all the weapon permutable animations in current map
local availableAnimations = {}

local animationClasses = {
    ["idle"] = 1,
    ["posing"] = 2,
    ["fire"] = 3, -- Leaving this like 'fire' because fire-1 was not working for some reason
    ["moving"] = 4,
    ["overlays"] = 5,
    -- I think OpenSauce uses flashlight animations somehow
    -- Anyway if these are working is because you are using OpenSauce, so you don't need the script (?)
    -- ["light-off"] = 6,
    -- ["light-on"] = 7,
    ["reload-empty"] = 8,
    ["reload-full"] = 9,
    ["overheated"] = 10,
    ["ready"] = 11,
    ["put-away"] = 12, -- This is used for vehicles where seats does not allow weapons, thx aLTis94
    ["overcharged"] = 13,
    ["melee"] = 14,
    -- ["fire-2"] = 15, -- As far as I know fire-2 is never used in any weapon
    ["overcharged-jitter"] = 16, -- No idea what is this
    ["throw-grenade"] = 17
}

function OnTimer()
    if (keepTimer) then
        for tagIndex, permAnimationClasses in pairs(availableAnimations) do
            local tempTag = blam.getTag(tagIndex)
            local animationsTag = blam.modelAnimations(tagIndex)
            if (animationsTag) then
                local newFpAnimationList = glue.update({}, animationsTag.fpAnimationList)
                for classValue, permutableValues in pairs(permAnimationClasses) do
                    dprint(glue.index(animationClasses)[classValue])
                    newFpAnimationList[classValue] =
                        math.random(permutableValues[1], permutableValues[#permutableValues])
                end
                local animationsTag = blam.modelAnimations(tagIndex)
                animationsTag.fpAnimationList = newFpAnimationList
                dprint(animationsTag.fpAnimationList)
            end
        end
    end
    return true
end

function mapPermutableAnimations(tagIndex, animationLabel, animationIndex)
    -- Find permutable animations
    if (animationLabel:find("%%")) then
        dprint("Found permutable animation!", "success")
        dprint(animationLabel)

        -- Store space for this animation if doesn't exist
        if (not availableAnimations[tagIndex]) then
            availableAnimations[tagIndex] = {}
        end

        for animationClass, classValue in pairs(animationClasses) do
            if (animationLabel:find(animationClass)) then

                -- Store space for this animation class if doesn't exist
                if (not availableAnimations[tagIndex][classValue]) then
                    availableAnimations[tagIndex][classValue] = {}
                end

                local currentAnimation = availableAnimations[tagIndex][classValue]

                local animationCount = #currentAnimation
                dprint("Animation count: " .. animationCount)
                dprint("Adding animation to list.", "warning")
                dprint(animationClass, "category")
                currentAnimation[animationCount + 1] = animationIndex - 1
            end
        end
    end

end

function OnMapLoad()
    -- Clean permutable animations list
    OnMapUnload()
    -- Look for tags
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        -- Get curren tag type
        local tempTag = blam.getTag(tagIndex)
        -- We are looking for model animation tags
        if (tempTag and tempTag.class == tagClasses.modelAnimations) then
            -- We are looking for weapon animation tags
            if (tempTag.path and tempTag.path:find("weapon")) then
                -- Get tag animations data
                local animationsTag = blam.modelAnimations(tagIndex)
                if (animationsTag) then
                    dprint(tempTag.path)
                    -- Iterate through animation list
                    for animationIndex, animation in pairs(animationsTag.animationList) do
                        mapPermutableAnimations(tagIndex, animation.name, animationIndex)
                    end
                end
            end
        end
    end

    -- Create timer for randomizing animations
    -- This ensures different animations being shown
    keepTimer = true
    if (not permutatorTimer) then
        permutatorTimer = set_timer(250, "OnTimer")
    end
end

function OnMapUnload()
    keepTimer = false
    availableAnimations = {}
end

-- Register function to event on map laod
set_callback("map load", "OnMapLoad")
set_callback("unload", "OnMapUnload")

-- Run function after loading script
-- This is to test script changes after reloading script
-- OnMapLoad()
