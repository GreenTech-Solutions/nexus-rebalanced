-- The road to Nexus, only with razi-protocol. razi-protocol writes 2,000,000 km in
-- prototypes/world/systems/deep_space.lua. A jump in razi is 15,000 km as a rule, so this one took far more fuel and
-- time than anything before it. This mod makes it 300,000 km. The two routes that follow stay 2,000,000 km long,
-- nexus-oort-cloud and oort-cloud-sol: the last dash to Sol.
if mods["razi-protocol"] then
  local road = data.raw["space-connection"] and data.raw["space-connection"]["solar-system-edge-nexus"]
  require("lib.expect").set("space connection solar-system-edge-nexus length", road, "length", 2000000, 300000)
end
