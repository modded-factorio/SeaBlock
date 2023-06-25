-- Remove resources so mining recipes don't show in FNEI
-- Have to leave at least one resource or game will not load
if settings.startup["No-minerals-mode-setting"].value == true then
  if settings.startup["Cargo-ships-deep-oil-setting"].value == true then
	for k, v in pairs(data.raw["resource"]) do
		if k == "deep_oil" or k == "deep-oil" then
			--v.minable.result = nil
			--v.minable.results = nil
		else
			data.raw["resource"][k] = nil
		end
	end
  else
	for k, v in pairs(data.raw["resource"]) do
		if k == "coal" then
			v.minable.result = nil
			v.minable.results = nil
		else
			data.raw["resource"][k] = nil
		end
	end
  end
end