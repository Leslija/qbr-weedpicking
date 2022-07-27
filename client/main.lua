QBCore = {}
local sharedItems = exports['qbr-core']:GetItems() -- Get Shared Items
local picking = false -- Is player picking
local count = 0 -- Used to check if player is doing something already
local blipstable = {} -- Blips table to remove blips on resource stop


----------------------------------
------ LOAD ANIM AND MODEL -------
----------------------------------
function loadModel(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

----------------------------------
--------- 3D DRAW TEXT ----------
----------------------------------
function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

----------------------------------
----------- CRAFT ITEM------------
----------------------------------
function CraftItem(item)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if count == 0 then -- Is Player Doing Something? Prevent Exploiting
        local dict = loadDict('script_re@gold_panner@gold_success')
        TaskPlayAnim(PlayerPedId(), dict, 'SEARCH01', 8.0, 8.0, -1, 1, false, false, false)
        FreezeEntityPosition(PlayerPedId(), true)
        count = 1
        exports['qbr-core']:Progressbar("search_register", "Crafting...", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("crafting:process:"..item)
            FreezeEntityPosition(PlayerPedId(), false)
            ClearPedTasks(GetPlayerPed())
            count = 0
            print('I am done')
        end)
    else
        exports['qbr-core']:Notify(9, 'You are already doing something!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_RED')
    end
end

-------------------
----- THREADS -----
-------------------
local collectblip = {}
local processblip = {}

for k, v in pairs(Config.Collecting) do
    if v.showBlip then
        CreateThread(function()
            local number = #collectblip + 1
            collectblip[number] = N_0x554d9d53f696d002(1664425300, v.Collect)
            SetBlipSprite(collectblip[number], v.Csprite)
            SetBlipScale(collectblip[number], 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, tonumber(collectblip[number]), "Gather "..sharedItems[v.ItemIn].label)
            table.insert(blipstable, collectblip[number])

            local number2 = #processblip + 1
            processblip[number2] = N_0x554d9d53f696d002(1664425300, v.Process)
            SetBlipSprite(processblip[number2], v.Psprite)
            SetBlipScale(processblip[number2], 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, tonumber(processblip[number2]), "Process "..sharedItems[v.ItemIn].label)
            table.insert(blipstable, processblip[number2])
        end)
    end
end

for k, v in pairs (Config.Collecting) do

    local procesX = v.Process.x
    local procesY = v.Process.y
    local procesZ = v.Process.z

    CreateThread(function()
        while true do
            Wait(3)
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.Process, true)
            local hasitem = false
            local hni = false
            if dist <= 2.0 then
                DrawText3D(procesX, procesY, procesZ+0.1, "Press ~d~[E] ~s~to craft "..sharedItems[v.ItemOut].label.."")
                if IsControlJustPressed(0, 0xCEFD9220) then
                    exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(hasItem)
                        hni = true
                        while(not hni) do
                            Wait(100)
                        end
                        if (hasItem) then
                            CraftItem(sharedItems[v.ItemIn].name)
                        else
                            exports['qbr-core']:Notify(9, 'You don\'t have '..sharedItems[v.ItemIn].label..'!', 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_RED')
                        end
                    end, { [v.ItemIn] = v.Input } )
                end
            end
        end
    end)
end

--------------------------------
---- SETUP GATHER LOCATIONS ----
--------------------------------
for k, v in pairs (Config.Collecting) do
    CreateThread(function()
        while true do
            local closeTo = 0
            local xp
            local yp
            local zp
            for i, c in pairs(Config.GatherLocations) do
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), c.coords, true) <= 2.5 then
                    closeTo = c
                    xp = c.coords.x
                    yp = c.coords.y
                    zp = c.coords.z-0.97
                    break
                end
            end
            if type(closeTo) == 'table' then
                while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 2.5 do
                    Wait(0)
                    DrawText3D(xp, yp, zp+0.97, 'Press ~d~[E]~s~ and ~d~[LMB]~s~ to gather Wet Bud')
                    local hastool = false
                    local hnt = false
                    if IsControlJustReleased(0, 0xCEFD9220) then
                        local player, distance = exports['qbr-core']:GetClosestPlayer()
                        if distance == -1 or distance <= 4.0 then
                            local tool = nil
                            picking = true
                            SetEntityCoords(PlayerPedId(), vector3(closeTo.coords.x, closeTo.coords.y, closeTo.coords.z-0.97))
                            SetEntityHeading(PlayerPedId(), closeTo.heading)
                            FreezeEntityPosition(PlayerPedId(), true)
                            while picking do
                                Wait(0)
                                DisableControlAction(0, 0x07CE1E61, true)
                                if IsDisabledControlJustReleased(0, 0x07CE1E61) then
                                    local dict = loadDict(v.Dict)
                                    TaskPlayAnim(PlayerPedId(), dict, v.Anim, 8.0, 8.0, -1, 1, false, false, false)
                                    exports['qbr-core']:Progressbar("gathering", "Gathering...", v.Duration, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function()
                                        ClearPedTasks(PlayerPedId())
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        TriggerServerEvent(v.ItemIn..':getItem')
                                        picking = false
                                    end)
                                end
                            end
                        else
                        end
                    end
                end
            end
            Wait(250)
        end
    end)
end

-------------------------
----- RESOURCE STOP -----
------ Delete Blips -----
-------------------------
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		for _,v in pairs(blipstable) do
            RemoveBlip(v)
        end
    end
end)
