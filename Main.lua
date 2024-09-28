CraftingFilters = CraftingFilters or {}
local CF = CraftingFilters

CF.Main = {}

local EM = EVENT_MANAGER
local PM = PROVISIONER_MANAGER

local function clearSearch()
    CFSearchField:SetText("")
end

local function matchFound(recipeName, searchString)
    return string.find(recipeName, searchString, 1, true) ~= nil
end

local function filterResults()
    EM:UnregisterForUpdate(CF.name .. "DelayedSearch")
    PROVISIONER.recipeTree:Reset()

    if CF.UI.CFSearchFieldString == "" then
        PROVISIONER:DirtyRecipeList()
        return
    end

    local searchString = CF.UI.CFSearchFieldString:lower()

    if not searchString or searchString == "" or searchString == " " then
        return
    end

    local craftingInteractionType = GetCraftingInteractionType()
    local recipeLists = PM:GetRecipeListData(craftingInteractionType)
    local requireIngredients = ZO_CheckButton_IsChecked(PROVISIONER.haveIngredientsCheckBox)
    local requireSkills = ZO_CheckButton_IsChecked(PROVISIONER.haveSkillsCheckBox)
    local results = 0
    local parent

    for _, recipeList in pairs(recipeLists) do
        for _, recipe in ipairs(recipeList.recipes) do
            if recipe.requiredCraftingStationType == craftingInteractionType and PROVISIONER.filterType == recipe.specialIngredientType then
                if PROVISIONER:DoesRecipePassFilter(
                        recipe.specialIngredientType, requireIngredients, recipe.maxIterationsForIngredients,
                        requireSkills, recipe.tradeskillsLevelReqs, recipe.qualityReq,
                        craftingInteractionType, recipe.requiredCraftingStationType
                    )
                    and matchFound(recipe.name:lower(), searchString) then
                    parent = parent or PROVISIONER.recipeTree:AddNode("ZO_ProvisionerNavigationHeader",
                        {
                            recipeListIndex = recipeList.recipeListIndex,
                            name = CF.UI.CFSearchFieldString,
                            upIcon = "esoui/art/guild/tabicon_roster_up.dds",
                            downIcon = "esoui/art/guild/tabicon_roster_down.dds",
                            overIcon = "esoui/art/guild/tabicon_roster_over.dds",
                            disabledIcon = "esoui/art/guild/tabicon_roster_disabled.dds"
                        }, nil, SOUNDS.PROVISIONING_BLADE_SELECTED)

                    PROVISIONER.recipeTree:AddNode("ZO_ProvisionerNavigationEntry", recipe, parent,
                        SOUNDS.PROVISIONING_ENTRY_SELECTED)
                    results = results + 1
                end
            end
        end
    end

    if results == 0 then d("No matches found.") end
end

function CF.Main.updateSearch()
    ZO_EditDefaultText_OnTextChanged(CFSearchField)
    CF.UI.CFSearchFieldString = CFSearchField:GetText():lower()

    EM:RegisterForUpdate(CF.name .. "DelayedSearch", 1000, filterResults)
end

function CF.Main.RegisterEvents()
    EM:RegisterForEvent(CF.name .. "StationInteract", EVENT_CRAFTING_STATION_INTERACT, CF.UI.CreateSearchBox)
    EM:RegisterForEvent(CF.name .. "EndStationInteract", EVENT_END_CRAFTING_STATION_INTERACT, clearSearch)
end
