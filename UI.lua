CraftingFilters = CraftingFilters or {}
local CF = CraftingFilters

CF.UI = {}

local WM = WINDOW_MANAGER

function CF.UI.CreateSearchBox()
    local CFSearchBox = _G[CF.name .. "CFSearchBox"]

    if not CFSearchBox then
        local parentControl = GetControl("ZO_ProvisionerTopLevelNavigationContainerScroll")
        CFSearchBox = WM:CreateControlFromVirtual(CF.name .. "CFSearchBox", parentControl, "ZO_InventorySearchTemplate")
        CFSearchBox:SetDimensions(180, 30)
        CFSearchBox:SetAnchor(RIGHT, parentControl, TOPRIGHT, 0, 20)
        CFSearchBox:SetDrawLayer(DL_CONTROLS)
    end

    CFSearchField = CFSearchBox:GetNamedChild("Box")
    CFSearchFieldText = CFSearchField:GetNamedChild("Text")

    CFSearchField:SetHandler("OnTextChanged", CF.Main.updateSearch)
end
