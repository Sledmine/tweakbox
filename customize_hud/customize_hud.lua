------------------------------------------------------------------------------
-- Customize HUD
-- Sledmine
-- Apply HUD customization for different maps
-- Version 1.0.0
------------------------------------------------------------------------------
local blam = require "blam"
local yml = require "tinyyaml"
local color = require "color"

local tagClasses = blam.tagClasses
local objectClasses = blam.objectClasses

local anchorTypes = {
    ["top left"] = 0,
    ["top right"] = 1,
    ["bottom left"] = 2,
    ["bottom right"] = 3,
    ["center"] = 4
}

clua_version = 2.042

local function findTag(partialName, searchTagType)
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        local tempTag = blam.getTag(tagIndex)
        if (tempTag and tempTag.path:find(partialName) and tempTag.class ==
            searchTagType) then
            return {
                id = tempTag.id,
                path = tempTag.path,
                index = tempTag.index,
                class = tempTag.class,
                indexed = tempTag.indexed,
                data = tempTag.data
            }
        end
    end
    return nil
end

function AppyHUDConfiguration()
    if (map and map ~= "ui") then
        local hudGlobalsTag = findTag("ui\\hud\\default", tagClasses.hudGlobals)
        if (hudGlobalsTag) then
            local hudGlobals = blam.hudGlobals(hudGlobalsTag.id)
            if (hudGlobals) then
                local ymlConfig = read_file("hud.yml")
                if (ymlConfig) then
                    local hudConfig = yml.parse(ymlConfig)
                    -- Position
                    hudGlobals.anchor = anchorTypes[hudConfig.alignment] or 0
                    hudGlobals.x = hudConfig.x or 0
                    hudGlobals.y = hudConfig.y or 60

                    -- Opacity
                    hudGlobals.iconColorA = hudConfig.opacity or 0.5
                    hudGlobals.textColorA = hudConfig.opacity or 0.5

                    -- Colors
                    local r, g, b = color.hex(hudConfig.messagesWithIconColor or "#75baff")
                    hudGlobals.iconColorR = r
                    hudGlobals.iconColorG = g
                    hudGlobals.iconColorB = b

                    local r, g, b = color.hex(hudConfig.messagesJustTextColor or "#75baff")
                    hudGlobals.textColorR = r
                    hudGlobals.textColorG = g
                    hudGlobals.textColorB = b

                    -- Spacing between messages
                    hudGlobals.textSpacing = hudConfig.spacing or 1.35
                    console_out("Sucess, custom HUD config has been loaded!")
                else
                    console_out("Error, at parsing HUD config file!")
                end
            else
                console_out("Error, at attempting to load HUD tags!")
            end
        else
            console_out("Warning, there is no HUD config file to load!")
        end
    end
end

function OnCommand(command)
    if (command == "reload_hud") then
        AppyHUDConfiguration()
        return false
    end
end

-- Register function to event on map laod
set_callback("map load", "AppyHUDConfiguration")
set_callback("command", "OnCommand")
