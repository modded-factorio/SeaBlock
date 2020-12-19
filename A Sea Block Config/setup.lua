if not seablockconfig then
  seablockconfig = {}
end
seablockconfig.data = {}
function seablockconfig:extend(arr)
  for _, b in ipairs(arr) do
    self.data[b[1]] = {b[2], b[3]}
  end
end

require "angelspetrochem"
require "bobassembly"
require "bobenemies"
require "bobmining"
require "bobmodules"
require "bobplates"
require "reskins-bobs"
require "ScienceCostTweaker"
