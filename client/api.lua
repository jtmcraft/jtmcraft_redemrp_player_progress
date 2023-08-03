API = {
    Blip = {
        CreateForCoords = function (hash, x, y, z, options)
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z)
            SetBlipSprite(blip, hash, true)
            if options.name then
                API.Blip.Name(blip, options.name)
            end
            if options.scale then
                API.Blip.Scale(blip, options.scale)
            end
            return blip
        end,
        Name = function (blip, name)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, name)
        end,
        DeleteWhenNoEntity = function(blip, entity)
            if DoesBlipExist(blip) and not DoesEntityExist(entity) then
                RemoveBlip(blip)
            end
        end,
        Scale = function (blip, scale)
            SetBlipScale(blip, scale)
        end
    },
    Notify = {
        Right = function (text, duration)
            TriggerEvent("redem_roleplay:ShowSimpleRightText", text, duration)
        end,
        RightAdvanced = function(text, duration, key, value)
            TriggerEvent("redem_roleplay:ShowAdvancedRightNotification", text, key, value, "COLOR_PURE_WHITE", duration)
        end
    },
    Player = {
        UpdateMetaData = function (key, value)
            TriggerServerEvent("jtmcraft:update_player_metadata", key, value)
        end
    },
    Weapon = {
        GetType = function (weaponHash)
            local nativeHashes = {
                [0xC4DEC3CA8C365A5D] = "bow",
                [0x792E3EF76C911959] = "knife",
                [0x959383DCD42040DA] = "melee",
                [0xDDC64F5E31EEDAB6] = "pistol",
                [0xDDB2578E95EF7138] = "repeater",
                [0xC212F1D05A8232BB] = "revolver",
                [0x0A82317B7EBFC420] = "rifle",
                [0xC75386174ECE95D5] = "shotgun",
                [0x6AD66548840472E5] = "sniper",
                [0x30E7C16B12DA8211] = "throwable",
            }

            for nativeHash, weaponType in pairs(nativeHashes) do
                if Citizen.InvokeNative(nativeHash, weaponHash) then
                    return weaponType
                end
            end

            return "other"
        end
    }
}

exports("API", function () return API end)
