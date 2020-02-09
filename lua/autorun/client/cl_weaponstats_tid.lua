local mat_tid_ammo = Material("vgui/ttt/tid_ammo")

local function GetAccuracyLangString(acc)
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

local function GetRecoilLangString(acc)
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

hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDWeaponStats", function(tData)
	local client = LocalPlayer()
	local ent = tData:GetEntity()

	if not IsValid(client) or not client:IsTerror() or not client:Alive()
	or not IsValid(ent) or tData:GetEntityDistance() > 100 or not ent:IsWeapon() then
		return
	end

	if ent:Clip1() ~= -1 then
		ammomax = (ent.Primary.ClipMax == -1) and "ttt2_wstat_no_ammo" or ent.Primary.ClipMax

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ttt2_wstat_ammo", {
				ammo = ent:GetNWInt("ttt2_wepstat_stored_ammo", 0),
				ammomax = ammomax or 0,
				clip = ent:Clip1() or 0
			}),
			nil,
			{mat_tid_ammo}
		)

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ttt2_wstat_acc", {acc = LANG.TryTranslation(GetAccuracyLangString(ent.Primary.Cone))}),
			nil,
			{mat_tid_ammo}
		)

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ttt2_wstat_rec", {rec = LANG.TryTranslation(GetRecoilLangString(ent.Primary.Recoil))}),
			nil,
			{mat_tid_ammo}
		)

		if ent.Primary.Automatic then
			tData:AddDescriptionLine(
				LANG.TryTranslation("ttt2_wstat_auto"),
				nil,
				{mat_tid_ammo}
			)
		else
			tData:AddDescriptionLine(
				LANG.TryTranslation("ttt2_wstat_not_auto"),
				nil,
				{mat_tid_ammo}
			)
		end

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("ttt2_wstat_speed", {rate = math.Round(60 / ent.Primary.Delay)}),
			nil,
			{mat_tid_ammo}
		)
	end
end)

hook.Add("Initialize", "ttt2_init_weaponstat_lang", function()
	LANG.AddToLanguage("English", "ttt2_wstat_ammo", "Stored Ammunition: {clip} + {ammo} (max: {ammomax})")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_ammo", "Enthaltene Munition: {clip} + {ammo} (max: {ammomax})")

	LANG.AddToLanguage("English", "ttt2_wstat_acc", "Accuracy: {acc}")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc", "Genauigkeit: {acc}")

	LANG.AddToLanguage("English", "ttt2_wstat_rec", "Recoil: {rec}")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec", "Rückstoß: {rec}")

	LANG.AddToLanguage("English", "ttt2_wstat_auto", "Automatic Weapon")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_auto", "AUtomatische Waffe")

	LANG.AddToLanguage("English", "ttt2_wstat_not_auto", "Non automatic weapon")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_not_auto", "Nichtautomatische Waffe")

	LANG.AddToLanguage("English", "ttt2_wstat_speed", "Rate of fire: {rate} SPM")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_speed", "Schussrate {rate} SPM")


	LANG.AddToLanguage("English", "ttt2_wstat_no_ammo", "no ammo pickup")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_no_ammo", "Munitionaufheben nicht möglich")




	LANG.AddToLanguage("English", "ttt2_wstat_acc_verygood", "very good")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc_verygood", "Sehr gut")

	LANG.AddToLanguage("English", "ttt2_wstat_acc_good", "good")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc_good", "Gut")

	LANG.AddToLanguage("English", "ttt2_wstat_acc_average", "average")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc_average", "Mittel")

	LANG.AddToLanguage("English", "ttt2_wstat_acc_bad", "bad")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc_bad", "Schlecht")

	LANG.AddToLanguage("English", "ttt2_wstat_acc_verybad", "very bad")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_acc_verybad", "Sehr schlecht")



	LANG.AddToLanguage("English", "ttt2_wstat_rec_verylow", "very low")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec_verylow", "Sehr niedrig")

	LANG.AddToLanguage("English", "ttt2_wstat_rec_low", "low")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec_low", "Niedrig")

	LANG.AddToLanguage("English", "ttt2_wstat_rec_average", "average")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec_average", "Mittel")

	LANG.AddToLanguage("English", "ttt2_wstat_rec_high", "high")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec_high", "Hoch")

	LANG.AddToLanguage("English", "ttt2_wstat_rec_veryhigh", "very high")
	LANG.AddToLanguage("Deutsch", "ttt2_wstat_rec_veryhigh", "Sehr hoch")
end)
