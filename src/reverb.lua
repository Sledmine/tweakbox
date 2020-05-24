------------------------------------------------------------------------------
-- Reverb
-- On the fly sound class patch for reverberation sounds
-- Author: Sledmine
-- Version: 2.1
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

set_callback('map load', 'onMapLoad')

function onMapLoad()
    local tagsCount = get_tags_count()
    for i = 0, tagsCount - 1 do
        local tagPath = get_tag_path(i)
        if (tagPath) then
            if (tagPath:find('sound') and tagPath:find('ready') or tagPath:find('reload') or tagPath:find('throwgren')) then
                dprint('Found reverb sound!')
                dprint(tagPath, 'success')
                local tagObject = blam.sound(get_tag(i))
                dprint(tagObject.class)
                blam.sound(get_tag(i), {class = 13})
            end
        end
    end
end

onMapLoad()