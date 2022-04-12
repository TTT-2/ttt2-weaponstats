local mat_tid_dmg = Material("vgui/ttt/dynamic/roles/icon_traitor")
local mat_tid_acc = Material("vgui/ttt/tid/tid_accuracy")
local mat_tid_ammo = Material("vgui/ttt/tid/tid_ammo")
local mat_tid_auto = Material("vgui/ttt/tid/tid_automatic")
local mat_tid_rec = Material("vgui/ttt/tid/tid_recoil")
local mat_tid_speed = Material("vgui/ttt/tid/tid_spm")

local mat_tid_large_ammo = Material("vgui/ttt/tid/tid_lg_ammo")

local function GetAccuracyLangString(weapon)
	local acc = weapon.Primary.Cone
	
	if not acc then
		if weapon.ArcCW and ArcCW then
			acc = weapon:GetBuff("SightsDispersion")

			if acc != 0 then -- Not a sniper
				acc = weapon:GetBuff("HipDispersion") * ArcCW.MOAToAcc / 10	
			end
		end
	end
	
	if acc then
		if acc <= 0.01 then
			return "ttt2_wstat_acc_verygood"
		elseif acc <= 0.025 then
			return "ttt2_wstat_acc_good"
		elseif acc <= 0.05 then
			return "ttt2_wstat_acc_average"
		elseif acc <= 0.075 then
			return "ttt2_wstat_acc_bad"
		else
			return "ttt2_wstat_acc_verybad"
		end
	end
	
	return "ttt2_wstat_acc_average"
end

local function GetRecoilLangString(weapon)
	local acc = weapon.Primary.Recoil
	
	if not acc then
		if weapon.ArcCW and ArcCW then
			acc = weapon.Recoil * 6
		end
	end
	
	if acc then
		if acc <= 2 then
			return "ttt2_wstat_rec_verylow"
		elseif acc <= 3.5 then
			return "ttt2_wstat_rec_low"
		elseif acc <= 5 then
			return "ttt2_wstat_rec_average"
		elseif acc <= 7 then
			return "ttt2_wstat_rec_high"
		else
			return "ttt2_wstat_rec_veryhigh"
		end
	end
	
	return "ttt2_wstat_rec_average"
end

local function GetDamage(weapon)
	local damage = weapon.Primary.Damage
	
	if damage ~= nil then return damage end
	
	damage = weapon.Damage
	
	if damage ~= nil then return damage end
	
	return "N/A"
end

local function GetDelay(weapon)
	local delay = weapon.Primary.Delay
	
	if delay ~= nil then return delay end
	
	delay = weapon.Delay
	
	return delay
end

hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDWeaponStats", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or tData:GetEntityDistance() > 100 or not ent:IsWeapon() then
		return
	end

	if not istable(ent.Primary) then return end

	local clip1 = ent:Clip1()

	-- Use defaultClip as default
	if clip1 == -1 then
		clip1 = ent.Primary.DefaultClip
	end

	-- If there is also no defaultClip then dont show stats at all
	if clip1 == -1 then return end

	ammomax = (ent.Primary.ClipMax == -1) and LANG.TryTranslation("ttt2_wstat_no_ammo") or ent.Primary.ClipMax

	-- add an empty line if there's already data in the description area
	if tData:GetAmountDescriptionLines() > 0 then
		tData:AddDescriptionLine()
	end

	tData:AddDescriptionLine(
		LANG.GetParamTranslation("ttt2_wstat_ammo", {
			ammo = ent:GetNWInt("ttt2_wepstat_stored_ammo", 0),
			ammomax = ammomax or 0,
			clip = clip1 or 0
		}),
		nil,
		{mat_tid_ammo}
	)

	tData:AddDescriptionLine(
		LANG.GetParamTranslation("ttt2_wstat_dmg", {dmg = GetDamage(ent)}),
		nil,
		{mat_tid_dmg}
	)

	tData:AddDescriptionLine(
		LANG.GetParamTranslation("ttt2_wstat_acc", {acc = LANG.TryTranslation(GetAccuracyLangString(ent))}),
		nil,
		{mat_tid_acc}
	)

	tData:AddDescriptionLine(
		LANG.GetParamTranslation("ttt2_wstat_rec", {rec = LANG.TryTranslation(GetRecoilLangString(ent))}),
		nil,
		{mat_tid_rec}
	)

	if ent.Primary.Automatic then
		tData:AddDescriptionLine(
			LANG.TryTranslation("ttt2_wstat_auto"),
			nil,
			{mat_tid_auto}
		)
	else
		tData:AddDescriptionLine(
			LANG.TryTranslation("ttt2_wstat_not_auto"),
			nil,
			{mat_tid_auto}
		)
	end
		
	local delay = GetDelay(ent)
		
	if delay then
		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ttt2_wstat_speed", {rate = math.Round(60 / delay)}),
			nil,
			{mat_tid_speed}
		)
	end
end)

local ammo_types = {
	["item_ammo_357_ttt"] = true,
	["item_box_buckshot_ttt"] = true,
	["item_ammo_smg1_ttt"] = true,
	["item_ammo_pistol_ttt"] = true,
	["item_ammo_revolver_ttt"] = true
}

hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDAmmoBoxes", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or tData:GetEntityDistance() > 100 or not ammo_types[ent:GetClass()] then
		return
	end

	-- enable targetID rendering
	tData:EnableText()
	tData:EnableOutline()
	tData:SetOutlineColor(client:GetRoleColor())

	tData:SetTitle(LANG.TryTranslation("ttt2_wstat_ammo_name"))
	tData:SetSubtitle(LANG.TryTranslation("ttt2_wstat_ammo_walk_over"))
	tData:AddIcon(mat_tid_large_ammo)
end)
