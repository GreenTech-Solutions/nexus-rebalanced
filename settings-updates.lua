-- Storms of Nexus-Threat. Nexus-Threat has three map settings for them whose defaults keep the
-- original storms: instability that never goes down, a lightning attempt chance of 5 + 1 % per 1 % of instability and
-- up to 3 attempts per tick from 50 % instability. At 100 % that is about 120 strikes a second, more than a full shield
-- of stabilizers holds, and the instability only grows. This mod sets other defaults: instability halves on its own in
-- 3 hours (with N drills mining the equilibrium is about N x 0.62 %), 0.6 % of chance per 1 % of instability and up to
-- 2 attempts per tick. A player can still change all three in the map settings.
local expect = require("lib.expect")

if mods["Nexus-Threat"] then
  expect.set("setting nt-instability-half-life default", data.raw["double-setting"]
    and data.raw["double-setting"]["nt-instability-half-life"], "default_value", 0, 3)
  expect.set("setting nt-lightning-chance default", data.raw["double-setting"]
    and data.raw["double-setting"]["nt-lightning-chance"], "default_value", 1, 0.6)
  expect.set("setting nt-lightning-attempts default", data.raw["int-setting"]
    and data.raw["int-setting"]["nt-lightning-attempts"], "default_value", 3, 2)
  -- Since 1.0.8 Nexus-Threat regenerates the shield outside storms only with this map setting on (off by default).
  -- On here: before 1.0.8 the shield always came back outside storms.
  expect.set("setting nt-shield-passive-regen default", data.raw["bool-setting"]
    and data.raw["bool-setting"]["nt-shield-passive-regen"], "default_value", false, true)
end

expect.summary("settings")
