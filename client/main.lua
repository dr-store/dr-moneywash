ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
    if Config.MoneyLaundry.EnableBlip then
        if Config.MoneyLaundry.BlipOnlyforJobs then
            local blip = AddBlipForCoord(Config.MoneyLaundry.PedLocation.x, Config.MoneyLaundry.PedLocation.y, Config.MoneyLaundry.PedLocation.z)

            SetBlipSprite(blip, Config.MoneyLaundry.BlipSprite)
            SetBlipDisplay(blip, Config.MoneyLaundry.BlipDisplay)
            SetBlipScale(blip, Config.MoneyLaundry.BlipScale)
            SetBlipColour(blip, Config.MoneyLaundry.BlipColour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.MoneyLaundry.MarkerText)
            EndTextCommandSetBlipName(blip)

            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(1000)

                    local allowed = false
                    for _, job in pairs(Config.MoneyLaundry.Jobs) do
                        if ESX.PlayerData.job and ESX.PlayerData.job.name == job then
                            allowed = true
                            break
                        end
                    end

                    if allowed then
                        SetBlipDisplay(blip, 4)
                    else
                        SetBlipDisplay(blip, 0)
                    end
                end
            end)
        else
            local blip = AddBlipForCoord(Config.MoneyLaundry.PedLocation.x, Config.MoneyLaundry.PedLocation.y, Config.MoneyLaundry.PedLocation.z)

            SetBlipSprite(blip, Config.MoneyLaundry.BlipSprite)
            SetBlipDisplay(blip, Config.MoneyLaundry.BlipDisplay)
            SetBlipScale(blip, Config.MoneyLaundry.BlipScale)
            SetBlipColour(blip, Config.MoneyLaundry.BlipColour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.MoneyLaundry.MarkerText)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
	local ped_hash = GetHashKey(Config.MoneyLaundry.PedCode)
	RequestModel(ped_hash)
	while not HasModelLoaded(ped_hash) do
		Citizen.Wait(1)
	end
	MoneyNPC = CreatePed(1, ped_hash, Config.MoneyLaundry.PedLocation.x, Config.MoneyLaundry.PedLocation.y, Config.MoneyLaundry.PedLocation.z - 1, Config.MoneyLaundry.PedLocation.w, false, true)
	SetBlockingOfNonTemporaryEvents(MoneyNPC, true)
	SetPedDiesWhenInjured(MoneyNPC, false)
	SetPedCanPlayAmbientAnims(MoneyNPC, true)
	SetPedCanRagdollFromPlayerImpact(MoneyNPC, false)
	SetEntityInvincible(MoneyNPC, true)
	FreezeEntityPosition(MoneyNPC, true)

	local options = {
		{
			name = 'moneylaundry',
			icon = 'fa-solid fa-sack-dollar',
			event = 'dr-moneywash:interact',
			label = Config.MoneyLaundry.InteractText,
			distance = 1.5,
		}
	}

	if Config.MoneyLaundry.NeedJob then
		options[1].groups = Config.MoneyLaundry.Jobs
	end

	-- Register the NPC as a targetable entity
	exports.ox_target:addLocalEntity(MoneyNPC, options)
end)


RegisterNetEvent('dr-moneywash:interact')
AddEventHandler('dr-moneywash:interact', function()
    local amount
    local input = lib.inputDialog(Config.MoneyLaundry.MoneyLaunderer, {
        {type = 'number', label = Config.MoneyLaundry.MoneyQuantity, description = Config.MoneyLaundry.Description, default = Config.MoneyLaundry.DefaultNumber, required = true, icon = 'fa-solid fa-sack-dollar'}
    })
    if not input then
        return
    else
        amount = tonumber(input[1])
    end

    if amount >= Config.MoneyLaundry.LaundryMin and amount <= Config.MoneyLaundry.LaundryMax then
        TriggerServerEvent("dr-moneywash:checkblack", amount)
    else
        lib.notify({
            title = Config.MoneyLaundry.MoneyLaunderer,
            description = Config.MoneyLaundry.InvalidQuantity,
            type = 'error'
        })
    end
end)

RegisterNetEvent('dr-moneywash:checkResult')
AddEventHandler('dr-moneywash:checkResult', function(success, amount)
    if success then
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
        if lib.progressCircle({
            duration = Config.MoneyLaundry.LaundryTime * 1000,
            label = Config.MoneyLaundry.TalkingtoDealer,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
                mouse = true,
            },
        }) then
            TriggerServerEvent('dr-moneywash:laundry', amount)
			ClearPedTasks(PlayerPedId())
        else
            lib.notify({
                title = Config.MoneyLaundry.MoneyLaunderer,
                description = Config.MoneyLaundry.MoneyLaunderingCanceled,
                type = 'error'
            })
			ClearPedTasks(PlayerPedId())
        end
    else
        lib.notify({
            title = Config.MoneyLaundry.MoneyLaunderer,
            description = Config.MoneyLaundry.InvalidInput,
            type = 'error'
        })
    end
end)

RegisterNetEvent('dr-moneywash:laundryResult')
AddEventHandler('dr-moneywash:laundryResult', function(amount)
	lib.notify({
		title = Config.MoneyLaundry.MoneyLaunderer,
		description = Config.MoneyLaundry.SuccessLaundry .. ' ' .. amount .. ' ' .. Config.MoneyLaundry.Dollar,
		type = 'success'
	})
end)