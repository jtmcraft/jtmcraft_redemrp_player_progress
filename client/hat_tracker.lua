Citizen.CreateThread(function()
    RedEM = exports["redem_roleplay"]:RedEM()
    Jtmcraft = exports["jtmcraft_redemrp_player_progress"]:API()
    Citizen.Trace("Started jtmcraft hat tracker thread.\n")

    local playerHatBlip = {
        entity = nil,
        blip = nil
    }
    
    local blipHatHash = GetHashKey("BLIP_HAT")

    while true do
        Citizen.Wait(2)

        Jtmcraft.Blip.DeleteWhenNoEntity(playerHatBlip.blip, playerHatBlip.entity)

        local event = events.getEventData("EVENT_PLAYER_HAT_KNOCKED_OFF")
        if event and event["player ped id"] == PlayerPedId() then
            local hatName = RedEM.GetPlayerData().firstname .. "'s hat"
            local hatEntity = event["hat entity id"]
            local x, y, z = table.unpack(GetEntityCoords(hatEntity))
            playerHatBlip.blip = Jtmcraft.Blip.CreateForCoords(blipHatHash, x, y, z, { name = hatName })
            playerHatBlip.entity = hatEntity
        end
    end
end)
