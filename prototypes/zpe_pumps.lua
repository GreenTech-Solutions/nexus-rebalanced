-- The zero-point energy engine core of Nexus draws its fluid through four invisible pumps that Nexus places around it
-- (control.lua, on_built_entity). They are always of normal quality, so a legendary core is capped at the 160/s of a
-- normal one. Each quality above normal gets its own limiter pump here, faster by the usual 30 % a quality level;
-- control.lua swaps the pumps of a core for the ones of its quality.
--
-- The limiter's fluid box of volume 1 is what limits it: it passes 2/3 per tick (40/s), below its pumping_speed of 1.
-- A copy with a faster pumping_speed alone would pass the same 40/s, so the copies get a bigger fluid box and their
-- speed is counted from the 2/3 that a normal pump really passes.
local limiter = data.raw.pump and data.raw.pump["invisible-throughput-limiter-pump"]
local NORMAL_FLOW = 2 / 3

if limiter then
  for _, quality in pairs(data.raw.quality or {}) do
    local name = "invisible-throughput-limiter-pump-" .. quality.name

    -- A copy that is there already (made by another mod with the same idea) stays.
    if (quality.level or 0) > 0 and not quality.hidden and not data.raw.pump[name] then
      local copy = table.deepcopy(limiter)
      copy.name = name
      copy.pumping_speed = NORMAL_FLOW * (1 + 0.3 * quality.level)
      copy.fluid_box.volume = 10
      copy.placeable_by = { item = "invisible-throughput-limiter-pump-item", count = 1 }
      data:extend({ copy })
      log("nexus-rebalanced: " .. name .. " pumps " .. copy.pumping_speed .. " per tick")
    end
  end
end
