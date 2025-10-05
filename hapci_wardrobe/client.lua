ESX = nil
local PlayerJob = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end

        if ESX.GetPlayerData and ESX.GetPlayerData().job ~= nil then
        PlayerJob = ESX.GetPlayerData().job.name
    else

        PlayerJob = ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name or nil
    end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    if playerData and playerData.job then
        PlayerJob = playerData.job.name
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job then
        PlayerJob = job.name or job
    else
        PlayerJob = nil
    end
end)


Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, v in pairs(Config.Peds) do

            if v.job == nil or v.job == "" or PlayerJob == v.job then
                local dist = #(playerCoords - v.coords)


                if dist <= 10.0 then
                    sleep = 0
                    local mType = v.markerType or 1
                    local scale = v.markerScale or vector3(1.0, 1.0, 0.3)
                    local col = v.markerColor or { r = 255, g = 255, b = 255, a = 150 }
                    DrawMarker(mType, v.coords.x, v.coords.y, v.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale.x, scale.y, scale.z, col.r, col.g, col.b, col.a, false, true, 2, false, nil, nil, false)
                end

                if dist <= (v.range or 2.0) then
                    sleep = 0

                    ESX.ShowHelpNotification("Nyomd meg ~INPUT_CONTEXT~ a(z) ~b~" .. (v.name or "Menü") .. "~s~ megnyitásához")

                    if IsControlJustReleased(0, 38) then
                        if v.command and v.command ~= "" then
                            ExecuteCommand(v.command)
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)
