data:extend(
{
  {
    type = "recipe-category",
    name = "crafting-handonly"
  },
  {
    type = "recipe-category",
    name = "thermal-bore",
  },
  {
    type = "recipe-category",
    name = "thermal-extractor",
  },
  {
    type = "recipe-category",
    name = "ore-sorting-5",
  },
  {
    type = "recipe-category",
    name = "electronics-with-fluid"
  }
})

if mods['SpaceMod'] then
  data:extend(
  {
    {
      type = 'item-subgroup',
      name = 'sb-SpaceMod',
      group = mods['ScienceCostTweakerM'] and 'sct-science' or 'intermediate-products',
      order = 'zz[SpaceMod]'
    }
  })
end
