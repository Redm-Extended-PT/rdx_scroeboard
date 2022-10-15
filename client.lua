--[[
        
        💬 Export from K1Dev => discord: https://discord.gg/awayfromus ] 
        🐌 @Copyright K1Dev
        ☕ Thanks For Coffee Tips 
        🧠 Development team => "RDX-Dev"
--]]

RDX = nil
local display = false
local keys = 0x4AF4D473
local IsPress = false

Citizen.CreateThread(function()
    while RDX == nil do
        TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if ( IsControlPressed(0, keys) and not (RDX == nil) and (IsPress == false) ) then
            IsPress = true

            RDX.TriggerServerCallback('rdx_scoreboard:server:getdata', function(data)
                if not (data == nil) then
                    data = data[1]

                    -- UpdateNUI
                    updatedata(data)

                    display = not display
                    TriggerEvent("rdx_scoreboard:display", display)
                end
                IsPress = false
            end)

            Citizen.Wait(250)
        end

        Citizen.Wait(10)
    end
end)

AddEventHandler("rdx_scoreboard:display", function(value) 
    SendNUIMessage({
        type = "ui",
        display = value
    })
end)

function updatedata(data)
    SendNUIMessage({
        type = "update",
        my_id = GetPlayerServerId(PlayerId()),
        my_phonenmumber = data.my_phonenmumber,
        my_fullname = data.my_fullname,
        my_job = data.my_job,
        my_ping = data.my_ping,
        players = data.players,
        police = data.police,
        ems = data.ems,
        mc = data.mc
    })
end
