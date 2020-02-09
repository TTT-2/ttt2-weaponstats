-- the stored ammo inside the weapon has to be synced to the client
hook.Add("PlayerDroppedWeapon", "ttt2_weaponstats_handle_dropped_weapon", function(ply, wep)
	wep:SetNWInt("ttt2_wepstat_stored_ammo", wep.StoredAmmo)
end)
