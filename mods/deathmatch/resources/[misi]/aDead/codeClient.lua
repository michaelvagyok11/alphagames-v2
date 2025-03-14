local sX, sY = guiGetScreenSize();

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local responsiveMultipler = reMap(sX, 720, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end

local poppinsBoldBig = dxCreateFont("files/fonts/Poppins-SemiBold.ttf", respc(25), false, "cleartype")
local poppinsRegular = dxCreateFont("files/fonts/Poppins-Regular.ttf", respc(20), false, "cleartype")

function onWasted(killer, weapon, bodypart)
	if source ~= localPlayer then
		return
	end
	addEventHandler("onClientRender", root, onRender)
	openTick = getTickCount()
	triggerServerEvent("changeDataSync", localPlayer, "a.HUDshowed", false)
	showChat(false)
end
addEventHandler("onClientPlayerWasted", root, onWasted)

function onRender()
	local nowTick = getTickCount();
	local elapsedTime = nowTick - openTick;

	local deathText = "Újraéledés #F1C1761 #c8c8c8másodpercen belül..."
	seconds, rot, width = interpolateBetween(5, 0, dxGetTextWidth(deathText, 1, poppinsRegular, true), 0, 360, 0, elapsedTime / 5000, "Linear")

	if seconds == 0 then
		local elapsedTime = nowTick - (openTick + 5000)
		a = interpolateBetween(a, 0, 0, 0, 0, 0, elapsedTime / 100, "Linear")
		if a == 0 then
			local respawnPos = getElementData(localPlayer, "a.RespawnPosition") or {260.6982421875, 1816.28125, 4.7031307220459}
			local skin = getElementData(localPlayer, "a.Skin") or getElementModel(localPlayer)
			local dim = getElementDimension(localPlayer)

			triggerServerEvent("respawnPlayer", localPlayer, localPlayer, respawnPos[1], respawnPos[2], respawnPos[3], skin, dim)

			removeEventHandler("onClientRender", root, onRender)
			showChat(true)
			triggerServerEvent("changeDataSync", localPlayer, "a.HUDshowed", true)
		end
	else
		a = interpolateBetween(0, 0, 0, 200, 0, 0, elapsedTime / 500, "Linear")
	end

	dxDrawRectangle(0, 0, sX, sY, tocolor(2, 2, 2, a))
	dxDrawText("Meghaltál!", sX / 2, sY / 2, _, _, tocolor(200, 200, 200, a), 1, poppinsBoldBig, "center", "center", false, false, false, true)
	dxDrawText("Újraéledés #F1C176" .. math.floor(seconds) + 1 .. " #c8c8c8másodpercen belül...", sX / 2, sY / 2 + respc(30), _, _, tocolor(200, 200, 200, a), 1, poppinsRegular, "center", "center", false, false, false, true)
	
	dxDrawRectangle(sX / 2 - (dxGetTextWidth(deathText, 1, poppinsRegular, true))/2, sY / 2 + respc(50), width, respc(2), tocolor(50, 50, 50, a))
	
	dxDrawImage(sX / 2 - respc(20), sY / 2 - respc(75), respc(40), respc(40), "files/img/loading.png", rot, 0, 0, tocolor(200, 200, 200, a))
end

function killMyself()
	local respawnPos = getElementData(localPlayer, "a.RespawnPosition") or {260.6982421875, 1816.28125, 4.7031307220459}
	local skin = getElementData(localPlayer, "a.Skin") or getElementModel(localPlayer)
	local dim = getElementDimension(localPlayer)

	triggerServerEvent("respawnPlayer", localPlayer, localPlayer, respawnPos[1], respawnPos[2], respawnPos[3], skin, dim)
end
addCommandHandler("kill", killMyself)