
discordwebhooklink = "WEBHOOK_HERE" -- Change this to your discord webhook for logging to work



-----------------------------------------------------------------
local jailtime = Config.defaultTime
local maxtime = Config.maxTime

RegisterCommand("jailme", function(source, args, raw)
	if #args <= 0 then
		TriggerClientEvent('chatMessage', source, "Use the following format:", {255, 0, 0}, "/jailme [Seconds]")
	else
	jailtime = tonumber(args[1])
	if jailtime > maxtime then
		jailtime = maxtime
	end

	TriggerClientEvent("Jail:JailPlayer", source, jailtime)
	TriggerClientEvent('chatMessage', -1, 'JUDGE', { 54, 86, 245 }, GetPlayerName(source) ..' was jailed for '.. jailtime ..' months')
	local steam = GetPlayerName(source)
	PerformHttpRequest(discordwebhooklink, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**User Jailed:** ".. steam .."\n**Time:** ".. jailtime .. " seconds \n**Jailed By:** ".. steam .." ", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
end, false)

RegisterCommand("unjail", function(source, args, raw)
	if IsPlayerAceAllowed(source, "jail.commands") then
	if #args <= 0 then
		TriggerClientEvent('chatMessage', source, "Use the following format:", {255, 0, 0}, "/unjail [Player ID]")
	else
	local jpid = tonumber(args[1])
	if GetPlayerName(jpid) ~= nil then
		TriggerClientEvent('chatMessage', source, 'JUDGE', { 54, 86, 245 }, "Successfully unjailed ^2" .. GetPlayerName(jpid) .."")
        TriggerClientEvent("Jail:UnjailPlayer", jpid)
		local steam = GetPlayerName(source)
		local jplayer = GetPlayerName(jpid)
		PerformHttpRequest(discordwebhooklink, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**User Unjailed:** ".. jplayer .."\n**Unjailed By:** ".. steam .." ", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
	end
end
else
	TriggerClientEvent('Jail:noperms', source)
end
end, false)


RegisterCommand("jail", function(source, args, raw)
	if IsPlayerAceAllowed(source, "jail.commands") then
	if #args <= 0 then
		TriggerClientEvent('chatMessage', source, "Use the following format:", {255, 0, 0}, "/jail [Player ID] [Seconds]")
	else
	local jpid = tonumber(args[1])
	if args[2] ~= nil then
		jailtime = tonumber(args[2])				
	end
	if jailtime > maxtime then
		jailtime = maxtime
	end
	if GetPlayerName(jpid) ~= nil then
		TriggerClientEvent("Jail:JailPlayer", jpid, jailtime)
		TriggerClientEvent('chatMessage', -1, 'JUDGE', { 54, 86, 245 }, GetPlayerName(jpid) ..' jailed for '.. jailtime ..' secs')
		local steam = GetPlayerName(source)
		local jplayer = GetPlayerName(jpid)
		PerformHttpRequest(discordwebhooklink, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**User Jailed:** ".. jplayer .."\n**Time:** ".. jailtime .. " seconds \n**Jailed By:** ".. steam .." ", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
	end
end
else
	TriggerClientEvent('Jail:noperms', source)
end
end, false)






versionChecker = true -- Set to false to disable version checker

-- Don't touch
resourcename = "Jail"
version = "1.0.0"
rawVersionLink = "https://raw.githubusercontent.com/Swqppingg/Jail/main/version.txt"


-- Check for version updates.
if versionChecker then
PerformHttpRequest(rawVersionLink, function(errorCode, result, headers)
    if (string.find(tostring(result), version) == nil) then
        print("\n\r[".. GetCurrentResourceName() .."] ^1WARNING: Your version of ".. resourcename .." is not up to date. Please make sure to update whenever possible.\n\r")
    else
        print("\n\r[".. GetCurrentResourceName() .."] ^2You are running the latest version of ".. resourcename ..".\n\r")
    end
end, "GET", "", "")
end