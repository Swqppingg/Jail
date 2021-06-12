local cJ = false
local eJE = false

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/jailme', 'Jail yourself', {
		{ name="Seconds", help="Seconds" }
	})
	TriggerEvent('chat:addSuggestion', '/jail', 'Jail another player', {
		{ name="Player ID", help="Player ID" },
		{ name="Seconds", help="Seconds" }
	})
	TriggerEvent('chat:addSuggestion', '/unjail', 'Unjail another player', {
		{ name="Player ID", help="Player ID" }
	})
end)

RegisterNetEvent("Jail:JailPlayer")
AddEventHandler("Jail:JailPlayer", function(jailtime)
	if cJ == true then
		return
	end
	local pP = PlayerPedId()
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
			cJ = true
			eJE = false
			while jailtime > 0 and not eJE do
				pP = PlayerPedId()
				RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if Config.mythic_notify then
				exports['mythic_notify']:PersistentAlert('start', 'jailAlert', "error", "You are currently in Jail")
				end
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jailtime % 30 == 0 then
					TriggerEvent('chatMessage', 'JUDGE', { 54, 86, 245 }, jailtime .." months left until release.")
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(1677.233, 2658.618, 45.216, pL['x'], pL['y'], pL['z'])
				if D > 90 then
					SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
					if D > 100 then
						jailtime = jailtime + 60
						if jailtime > 1500 then
							jailtime = 1500
						end
						TriggerEvent('chatMessage', 'JUDGE', { 54, 86, 245 }, "Your jail time was extended due to an unlawful escape attempt.")
					end
				end
				jailtime = jailtime - 0.5
			end
			if Config.mythic_notify then
				exports['mythic_notify']:PersistentAlert('end', 'jailAlert')
				end
			SetEntityCoords(pP, 1855.807, 2601.949, 45.323)
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("Jail:UnjailPlayer")
AddEventHandler("Jail:UnjailPlayer", function()
	eJE = true
end)

RegisterNetEvent('Jail:noperms')
AddEventHandler('Jail:noperms', function()
    ShowInfo("~r~Insufficient Permissions.")
end)

function ShowInfo(text)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(true, false)
end
