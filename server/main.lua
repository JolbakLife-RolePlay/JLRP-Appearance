Players = {}

function SaveAppearance(citizenid, appearance)
	SetResourceKvp(('%s:appearance'):format(citizenid), json.encode(appearance))
end

exports('save', SaveAppearance)

function LoadAppearance(source, citizenid)
	Players[source] = citizenid
	local data = GetResourceKvpString(('%s:appearance'):format(citizenid))
	return data and json.decode(data) or {}
end

exports('load', LoadAppearance)

function SaveOutfit(citizenid, appearance, slot, outfitNames)
	SetResourceKvp(('%s:outfit_%s'):format(citizenid, slot), json.encode(appearance))
	SetResourceKvp(('%s:outfits'):format(citizenid), json.encode(outfitNames))
end

exports('saveOutfit', SaveOutfit)

function LoadOutfit(citizenid, slot)
	local data = GetResourceKvpString(('%s:outfit_%s'):format(citizenid, slot))
	return data and json.decode(data) or {}
end

exports('loadOutfit', LoadOutfit)

function OutfitNames(citizenid)
	local data = GetResourceKvpString(('%s:outfits'):format(citizenid))
	return data and json.decode(data) or {}
end

exports('outfitNames', OutfitNames)

RegisterNetEvent('ox_appearance:save', function(appearance)
	local citizenid = Players[source]

	if citizenid then
		SaveAppearance(citizenid, appearance)
	end
end)

RegisterNetEvent('ox_appearance:saveOutfit', function(appearance, slot, outfitNames)
	local citizenid = Players[source]

	if citizenid then
		SaveOutfit(citizenid, appearance, slot, outfitNames)
	end
end)

RegisterNetEvent('ox_appearance:loadOutfitNames', function()
	local citizenid = Players[source]
	TriggerClientEvent('ox_appearance:outfitNames', source, citizenid and OutfitNames(citizenid) or {})
end)

RegisterNetEvent('ox_appearance:loadOutfit', function(slot)
	local citizenid = Players[source]
	TriggerClientEvent('ox_appearance:outfit', source, slot, citizenid and LoadOutfit(citizenid, slot) or {})
end)

AddEventHandler('playerDropped', function()
	Players[source] = nil
end)