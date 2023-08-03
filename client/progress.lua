Citizen.CreateThread(function()
    RedEM = exports["redem_roleplay"]:RedEM()
    Jtmcraft = exports["jtmcraft_redemrp_player_progress"]:API()
    Citizen.Trace("Started jtmcraft progress thread.\n")

    while true do
        Citizen.Wait(0)

        local playerId = PlayerPedId()
        local damageEventData = events.getEventData("EVENT_NETWORK_DAMAGE_ENTITY")

        if damageEventData then
            local killerId = damageEventData["killer entity id"]
            local victimId = damageEventData["damaged entity id"]

            if killerId == playerId and IsPedDeadOrDying(victimId) then
                weaponHash = damageEventData[5]
                ammoHash = damageEventData[6]
                weaponType = Jtmcraft.Weapon.GetType(weaponHash)
                local kx, ky, kz = table.unpack(GetEntityCoords(killerId))
                local vx, vy, vz = table.unpack(GetEntityCoords(victimId))

                local update = {
                    headShot = damageEventData["IsHeadShot"],
                    hatShot = 0,
                    weaponHash = weaponHash,
                    weaponType = weaponType,
                    ammoHash = ammoHash,
                    scopedIn = damageEventData["DamagerWasScopedIn"],
                    onHorse = IsPedOnMount(killerId) or 0,
                    execution = damageEventData["IsVictimExecuted"],
                    distance = Vdist(kx, ky, kz, vx, vy, vz),
                    gameHours = GetClockHours(),
                    gameMinutes = GetClockMinutes(),
                    gameSeconds = GetClockSeconds()
                }
                
                TriggerServerEvent("jtmcraft:progress:combat:update", update)
            end
        end

        local hatShotOffEventData = events.getEventData("EVENT_NETWORK_PED_HAT_SHOT_OFF")
        if hatShotOffEventData then
            Citizen.Trace("hat shot off: implement me\n")
        end
    end
end)
