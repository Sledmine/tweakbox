------------------------------------------------------------------------------
-- FP Animation Permutation
-- First persons animation permutation using OpenSauce label format
-- Author: Sledmine
-- Version: 2.0
-- Not deeply tested, be careful!
------------------------------------------------------------------------------
clua_version = 2.042

local debugMode = false

local blam = require 'lua-blam'

--- Function to send debug messages to console output
---@param message string
---@param color string | "'category'" | "'warning'" | "'error'" | "'success'"
function dprint(message, color)
    if (debugMode) then
        if (color == 'category') then
            console_out(message, 0.31, 0.631, 0.976)
        elseif (color == 'warning') then
            -- TO DO
            console_out(message)
        elseif (color == 'error') then
            -- TO DO
            console_out(message)
        elseif (color == 'success') then
            console_out(message, 0.235, 0.82, 0)
        else
            console_out(message)
        end
    end
end

-- List of all the weapon permutable animations in current map
local permutableAnimations = {}

local animationTable = {
    ['idle'] = 1,
    ['posing'] = 2,
    ['fire'] = 3, -- Leaving this like 'fire' because fire-1 was not working for some reason
    ['moving'] = 4,
    ['overlays'] = 5,
    -- I think OpenSauce uses flashlight animations somehow
    -- Anyway if these are working is because you are using OpenSauce, so you don't need the script (?)
    -- ['light-off'] = 6,
    -- ['light-on'] = 7,
    ['reload-empty'] = 8,
    ['reload-full'] = 9,
    ['overheated'] = 10,
    ['ready'] = 11,
    -- ['put-away'] = 12, -- This does not work either, not sure if OpenSauce uses it
    ['overcharged'] = 13,
    ['melee'] = 14,
    -- ['fire-2'] = 15, -- As far as I know fire-2 is never used in any weapon
    ['overcharged-jitter'] = 16, -- No idea what is this
    ['throw-grenade'] = 17
}

function onTimer()
    -- console_out('Randomizing animation!')
    for animationTagId, animationPermutations in pairs(permutableAnimations) do
        local weaponModelAnimations = blam.modelAnimations(
                                          get_tag(animationTagId))
        if (weaponModelAnimations) then
            for animationType, animationPermutationsValues in
                pairs(animationPermutations) do
                weaponModelAnimations.fpAnimationList[animationTable[animationType]] =
                    math.random(animationPermutationsValues[1],
                                animationPermutationsValues[#animationPermutationsValues])
            end
        end
        blam.modelAnimations(get_tag(animationTagId), weaponModelAnimations)
    end
    return true
end

function onMapLoad()
    -- Clean permutable animations list
    permutableAnimations = {}
    -- Look for tags
    for tagId = 0, get_tags_count() - 1 do
        -- Get curren tag type
        local type = get_tag_type(tagId)
        -- We are looking for model animation tags
        if (type == tagClasses.modelAnimations) then
            -- Get current tag path
            local tagPath = get_tag_path(tagId)
            -- We are looking for weapon animation tags
            if (tagPath:find('weapon')) then
                dprint(tagPath)
                -- Get tag animations data
                local modelAnim = blam.modelAnimations(get_tag(tagId))

                -- Iterate through animation list
                for animationIndex, animation in pairs(modelAnim.animationList) do
                    local animationLabel = animation.name
                    -- Find permutable animations
                    if (animationLabel:find('%%')) then
                        dprint('Found permutable animation!', 'success')
                        dprint(animationLabel)
                        if (not permutableAnimations[tagId]) then
                            permutableAnimations[tagId] = {}
                        end
                        for animationType, animationTypeIndex in
                            pairs(animationTable) do
                            if (animationLabel:find(animationType)) then
                                if (not permutableAnimations[tagId][animationType]) then
                                    permutableAnimations[tagId][animationType] =
                                        {}
                                end
                                local animationCount =
                                    #permutableAnimations[tagId][animationType]
                                dprint(animationCount)
                                dprint('Adding animation to list.', 'warning')
                                dprint(animationType, 'category')
                                permutableAnimations[tagId][animationType][animationCount +
                                    1] = animationIndex - 1
                            end
                        end
                    end
                end
            end
        end
    end

    -- Create timer for randomizing animations
    -- This ensures different animations being shown
    set_timer(250, 'onTimer')

end

-- Register function to event on map laod
set_callback('map load', 'onMapLoad')

-- Run function after loading script
-- This is to test script changes after reloading script
onMapLoad()
