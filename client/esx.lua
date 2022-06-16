if GetResourceState('JLRP-Framework'):find('start') then
	Framework = true
	local Core = nil
	local isPlayerVisibleToOthers = true

	AddEventHandler('skinchanger:loadDefaultModel', function(male, cb)
		exports['fivem-appearance']:setPlayerModel(male and 'mp_m_freemode_01' or 'mp_f_freemode_01')
		if cb then cb() end
	end)

	AddEventHandler('skinchanger:loadSkin', function(skin, cb)
        if not skin then skin = {} end
		if not skin.model then skin.model = 'mp_m_freemode_01' end

		exports['fivem-appearance']:setPlayerAppearance(skin)

		if cb then cb() end
	end)

	RegisterNetEvent('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
		exports['fivem-appearance']:startPlayerCustomization(function(appearance)
			if (appearance) then
				TriggerServerEvent('esx_skin:save', appearance)
				if submitCb then submitCb() end
			else
				if cancelCb then cancelCb() end
			end
		end, {
			ped = true,
			headBlend = true,
			faceFeatures = true,
			headOverlays = true,
			components = true,
			props = true,
			tattoos = true
		})
	end)

	AddEventHandler('esx_skin:playerRegistered', function()
		Core = exports['JLRP-Framework']:GetFrameworkObjects()
		Core = { TriggerServerCallback = Core.TriggerServerCallback }
		Core.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			if not skin or skin == nil or skin == {} then
				setLocalPlayerOnlyVisibleLocally()
				exports['fivem-appearance']:startPlayerCustomization(function(appearance)
					if (appearance) then
						TriggerServerEvent('esx_skin:save', appearance)
					end
					isPlayerVisibleToOthers = true		
				end, {
					ped = true,
					headBlend = true,
					faceFeatures = true,
					headOverlays = true,
					components = true,
					props = true,
					tattoos = true
				})
			else
				TriggerEvent('skinchanger:loadSkin', skin)
			end
		end)
	end)

	function setLocalPlayerOnlyVisibleLocally()
		CreateThread(function()
			isPlayerVisibleToOthers = false
			SetEntityVisible(PlayerPedId(), false, 0)
			while not isPlayerVisibleToOthers do 
				SetLocalPlayerVisibleLocally(true)
				Wait(0)
			end
			SetLocalPlayerVisibleLocally(false)
			SetEntityVisible(PlayerPedId(), true, 0)
		end)
	end
end