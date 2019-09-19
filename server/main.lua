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
		
		if xPlayer.job.name == 'mafia' or xPlayer.job.name == 'bloods' or xPlayer.job.name == 'lostmc' or xPlayer.job.name == 'taliban' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at', Turfs[currentTurf].nameOfTurf))
			TriggerClientEvent('esx_gangturf:killBlip', xPlayers[i])
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
	
	if xPlayer.job.name == 'mafia' or xPlayer.job.name == 'bloods' or xPlayer.job.name == 'lostmc' or xPlayer.job.name == 'taliban' then
		
	else
		return
		TriggerClientEvent('esx:showNotification', _source, _U('cant_rob_rank'))
	end
	
	if Turfs[currentTurf] then
		local Turf = Turfs[currentTurf]
		
		if xPlayer.job.name == 'mafia' then
			if Turf.isClaimed == 'mafia' then
				TriggerClientEvent('esx:showNotification', _source, _U('already_claimed'))
				return
			end
		elseif xPlayer.job.name == 'bloods' then
			if Turf.isClaimed == 'bloods' then
				TriggerClientEvent('esx:showNotification', _source, _U('already_claimed'))
				return
			end
		elseif xPlayer.job.name == 'lostmc' then
			if Turf.isClaimed == 'lostmc' then
				TriggerClientEvent('esx:showNotification', _source, _U('already_claimed'))
				return
			end
		elseif xPlayer.job.name == 'taliban' then
			if Turf.isClaimed == 'taliban' then
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
			if xPlayer.job.name == 'mafia' or xPlayer.job.name == 'bloods' or xPlayer.job.name == 'lostmc' or xPlayer.job.name == 'taliban' then
				Gangsters = Gangsters + 1
			end
		end

		if not rob then
			if Gangsters >= Config.GangNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'mafia' or xPlayer.job.name == 'bloods' or xPlayer.job.name == 'lostmc' or xPlayer.job.name == 'taliban' then
						TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog', Turf.nameOfTurf))
						TriggerClientEvent('esx_gangturf:setBlip', xPlayers[i], Turfs[currentTurf].position)
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
							
							if xPlayer.job.name == 'mafia' then
								Turf.isClaimed = 'mafia'
							elseif xPlayer.job.name == 'bloods' then
								Turf.isClaimed = 'bloods'
							elseif xPlayer.job.name == 'lostmc' then
								Turf.isClaimed = 'lostmc'
							elseif xPlayer.job.name == 'taliban' then
								Turf.isClaimed = 'taliban'
							end
							
							if Config.GiveSocietyMoney then
								xPlayer.addAccountMoney('black_money', Turf.reward)
							else
								xPlayer.addMoney(Turf.reward)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])
								
								if xPlayer.job.name == 'mafia' or xPlayer.job.name == 'bloods' or xPlayer.job.name == 'lostmc' or xPlayer.job.name == 'taliban' then
									TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at', Turf.nameOfTurf))
									TriggerClientEvent('esx_gangturf:killBlip', xPlayers[i])
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
