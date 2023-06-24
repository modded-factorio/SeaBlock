if mods["cargo-ships"] then
	if settings.startup["Cargo-ships-deep-oil-setting"].value == true then 
		--Override Cargo Ships Settings 
		--Make Deep-oil on on the assumption people want the oil to spawn
		data.raw["bool-setting"]["deep_oil"].forced_value=true
		data.raw["bool-setting"]["deep_oil"].hidden=false
		data.raw["string-setting"]["oil_richness"].hidden=false
		data.raw["bool-setting"]["no_oil_for_oil_rig"].hidden=false
		data.raw["int-setting"]["oil_rig_capacity"].hidden=false
		data.raw["bool-setting"]["no_oil_on_land"].hidden=false
		data.raw["bool-setting"]["no_shallow_oil"].hidden=false
	end
end