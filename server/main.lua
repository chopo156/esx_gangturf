local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_gangturf:tooFar')
AddEventHandler('esx_gangturf:tooFar', function(currentTurf)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		for key, value in pairs(Config.GangJobs) do
			if xPlayer.job.name == value then
				TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Turfs[currentTurf].nameOfTurf))
				TriggerClientEvent('esx_gangturf:killBlip', xPlayers[i])
			end
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_gangturf:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Turfs[currentTurf].nameOfTurf))
	end
end)

RegisterServerEvent('esx_gangturf:robberyStarted')
AddEventHandler('esx_gangturf:robberyStarted', function(currentTurf)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local foundJob = false
	
	for key, value in pairs(Config.GangJobs) do
		if xPlayer.job.name == value and not foundJob then
			foundJob = true
		end
	end

	if not foundJob then
		TriggerClientEvent('esx:showNotification', _source, _U('cant_rob_rank'))
		return
	end
	
	if Turfs[currentTurf] then
		local Turf = Turfs[currentTurf]
		
		for key, value in pairs(Config.GangJobs) do
			if xPlayer.job.name == value and Turf.isClaimed == value then
				TriggerClientEvent('esx:showNotification', _source, _U('already_claimed'))
				return
			end
		end
		
		if (os.time() - Turf.lastRobbed) < Config.TimerBeforeNewRob and Turf.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - Turf.lastRobbed)))
			return
		end

		local Gangsters = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			for key, value in pairs(Config.GangJobs) do
				if xPlayer.job.name == value then
					Gangsters = Gangsters + 1
				end
			end
		end

		if not rob then
			if Gangsters >= Config.GangNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					for key, value in pairs(Config.GangJobs) do
						if xPlayer.job.name == value then
							TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', Turf.nameOfTurf))
							TriggerClientEvent('esx_gangturf:setBlip', xPlayers[i], Turfs[currentTurf].position)
						end
					end
				end
				
				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', Turf.nameOfTurf))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
				
				TriggerClientEvent('esx_gangturf:currentlyRobbing', _source, currentTurf)
				TriggerClientEvent('esx_gangturf:startTimer', _source)
				
				Turfs[currentTurf].lastRobbed = os.time()
				robbers[_source] = currentTurf

				SetTimeout(Turf.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_gangturf:robberyComplete', _source, Turf.reward)
							
							for key, value in pairs(Config.GangJobs) do
								if xPlayer.job.name == value then
									Turf.isClaimed = value
								end
							end
							
							if Config.GiveDirtyMoney then
								xPlayer.addAccountMoney('black_money', Turf.reward)
							else
								xPlayer.addMoney(Turf.reward)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])
								
								for key, value in pairs(Config.GangJobs) do
									if xPlayer.job.name == value then
										TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at', Turf.nameOfTurf))
										TriggerClientEvent('esx_gangturf:killBlip', xPlayers[i])
									end
								end
								
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('min_gang', Config.GangNumberRequired))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)
