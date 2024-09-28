CraftingFilters = CraftingFilters or {}
local CF = CraftingFilters
CF.name = "CraftingFilters"
CF.version = "0.1"

local EM = EVENT_MANAGER

function CF.OnAddOnLoaded(event, addonName)
	if addonName ~= CF.name then return end
	EM:UnregisterForEvent(CF.name, EVENT_ADD_ON_LOADED)

	CF.Main.RegisterEvents()
end

EM:RegisterForEvent(CF.name, EVENT_ADD_ON_LOADED, CF.OnAddOnLoaded)
