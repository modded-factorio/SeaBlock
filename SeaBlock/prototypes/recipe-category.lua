data:extend({
  {
    type = "recipe-category",
    name = "sb-crafting-handonly",
  },
  {
    type = "recipe-category",
    name = "sb-thermal-bore",
  },
  {
    type = "recipe-category",
    name = "sb-thermal-extractor",
  },
  {
    type = "recipe-category",
    name = "sb-petrochem-electrolyser-4",
  },
})

if mods["SpaceMod"] then
  data:extend({
    {
      type = "item-subgroup",
      name = "sb-SpaceMod",
      group = mods["ScienceCostTweakerM"] and "sct-science" or "intermediate-products",
      order = "zz[SpaceMod]",
    },
  })
end
