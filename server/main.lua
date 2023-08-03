RedEM = exports["redem_roleplay"]:RedEM()

function BuildInsertSql(columnsList, tableName)
    local columns = "("
    local values = "values ("
    for k, v in pairs(columnsList) do
        columns = columns .. v .. ","
        values = values .. "@" .. v .. ","
    end
    columns = string.sub(columns, 1, -2) .. ")"
    values = string.sub(values, 1, -2) .. ")"
    return "insert into " .. tableName .. " " .. columns .. " " .. values .. ";"
end

RegisterServerEvent("jtmcraft:update_player_metadata")
AddEventHandler("jtmcraft:update_player_metadata", function(key, value)
    local player = RedEM.GetPlayer(source)
    player.SetMetaData(key, value)
    RedEM.DB.UpdatePlayer(player)
end)

RegisterServerEvent("jtmcraft:progress:combat:update")
AddEventHandler("jtmcraft:progress:combat:update", function(update)
    local columns = {
        "citizenid",
        "game_hours",
        "game_minutes",
        "game_seconds",
        "scoped_in",
        "on_horse",
        "execution",
        "distance",
        "head_shot",
        "hat_shot",
        "weapon_hash",
        "weapon_type",
        "ammo_hash"
    }

    local record = {
        citizenid = RedEM.GetPlayer(source).citizenid,
        game_hours = update.gameHours,
        game_minutes = update.gameMinutes,
        game_seconds = update.gameSeconds,
        scoped_in = update.scopedIn,
        on_horse = update.onHorse,
        execution = update.execution,
        distance = update.distance,
        head_shot = update.headShot,
        hat_shot = update.hatShot,
        weapon_type = update.weaponType,
        weapon_hash = update.weaponHash,
        ammo_hash = update.ammoHash
    }

    local insert = BuildInsertSql(columns, "jtmcraft_progress_combat")
    MySQL.Async.execute(insert, record)
end)

function ToString(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. ToString(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

RegisterCommand("progress", function(source, args, raw)
    local showProgress = args and #args == 1 and args[1] == 'show'
    local message = {}

    if showProgress == true then
        message.showProgress = true
        local citizenid = RedEM.GetPlayer(source).citizenid
        local killsSql = [[
            select
                count(jpc.citizenid)                                  as totalKills,
                count(case when jpc.weapon_type = 'melee' then 1 end) as melee,
                sum(case when jpc.scoped_in <> 1 then 1 end)          as fromHip,
                sum(jpc.on_horse)                                     as fromHorse,
                sum(jpc.execution)                                    as executions,
                sum(jpc.head_shot)                                    as headShots,
                max(jpc.distance)                                     as longestShot
            from jtmcraft_progress_combat as jpc
            where jpc.citizenid = @citizenid;
        ]]
        MySQL.query(killsSql, { citizenid = citizenid }, function (resultSet)
            message.kills = resultSet[1]

            local byWeaponKillsSql = [[
                select count(citizenid) as totalKills,
                        max(distance)    as longestShot,
                        1                as allKills
                from jtmcraft_progress_combat
                where citizenid = @citizenid
                union
                select count(citizenid),
                        max(distance),
                        2
                from jtmcraft_progress_combat
                where weapon_type = @weaponType
                and citizenid = @citizenid
            ]]

            MySQL.query(byWeaponKillsSql, { citizenid = citizenid, weaponType = 'pistol' }, function (resultSet)
                Citizen.Trace(ToString(resultSet) .. "\n")
                local pistolKillsData = {}
                for _, v in pairs(resultSet) do
                    if v.allKills == 1 then
                        pistolKillsData.total = {
                            kills = v.totalKills,
                            longestShot = v.longestShot
                        }
                    elseif v.allKills == 2 then
                        pistolKillsData.pistol = {
                            kills = v.totalKills,
                            longestShot = v.longestShot
                        }
                    end
                end
                message.pistolKills = pistolKillsData

                TriggerClientEvent("jtmcraft:send_nui_message", source, message)
            end)
        end)
    else
        TriggerClientEvent("jtmcraft:send_nui_message", source, { showProgress = false })
    end
end, false)

RegisterCommand("save", function(source, args, raw)
    RedEM.DB.UpdatePlayer(RedEM.GetPlayer(source))
end, false)
