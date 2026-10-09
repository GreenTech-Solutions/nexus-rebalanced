-- Storms of Nexus-Threat. Nexus-Threat-Updated (the 2.1 fork) has three map settings for them whose defaults keep the
-- original storms: instability that never goes down, a lightning attempt chance of 5 + 1 % per 1 % of instability and
-- up to 3 attempts per tick from 50 % instability. At 100 % that is about 120 strikes a second, more than a full shield
-- of stabilizers holds, and the instability only grows. This mod sets other defaults: instability halves on its own in
-- 3 hours (with N drills mining the equilibrium is about N x 0.62 %), 0.6 % of chance per 1 % of instability and up to
-- 2 attempts per tick. A player can still change all three in the map settings.
local function set_default(setting_type, name, from, to)
  local setting = data.raw[setting_type] and data.raw[setting_type][name]

  -- Only the default the fork writes; without the fork (or with another default) the setting is left as it is.
  if setting and setting.default_value == from then
    setting.default_value = to
    log("nexus-rebalanced: setting " .. name .. " default " .. from .. " -> " .. to)
  end
end

set_default("double-setting", "nt-instability-half-life", 0, 3)
set_default("double-setting", "nt-lightning-chance", 1, 0.6)
set_default("int-setting", "nt-lightning-attempts", 3, 2)
