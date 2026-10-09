-- The road to Nexus, only with razi-protocol. razi-protocol 2.0.1 deletes the route from the edge of the solar
-- system to Nexus and adds its own, 2,000,000 km long (prototypes/system/deep_space.lua:153, :166-172). A jump in razi
-- is 15,000 km as a rule, so this one took far more fuel and time than anything before it. This mod makes it
-- 300,000 km. The two routes that follow stay 2,000,000 km long, nexus-oort-cloud and oort-cloud-sol
-- (deep_space.lua:193-208): the last dash to Sol.
local road = data.raw["space-connection"] and data.raw["space-connection"]["solar-system-edge-nexus"]

-- Only the length razi writes: another length was set on purpose by someone, and stays.
if road and road.length == 2000000 then
  road.length = 300000
  log("nexus-rebalanced: space connection solar-system-edge-nexus length 2000000 -> 300000")
elseif road then
  log("nexus-rebalanced: space connection solar-system-edge-nexus length is " .. tostring(road.length)
    .. ", not 2000000, left as it is")
end
