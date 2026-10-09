-- The zero-point energy engine core of Nexus draws its fluid through four invisible pumps that Nexus places around it
-- (control.lua, on_built_entity). They are always of normal quality, so a legendary core is capped at the 240/s of a
-- normal one. Each quality above normal gets its own limiter pump here, faster by the usual 30 % a quality level;
-- control.lua swaps the pumps of a core for the ones of its quality.
local limiter = data.raw.pump and data.raw.pump["invisible-throughput-limiter-pump"]

if limiter then
  for _, quality in pairs(data.raw.quality or {}) do
    local name = "invisible-throughput-limiter-pump-" .. quality.name

    -- A copy that is there already (made by another mod with the same idea) stays.
    if (quality.level or 0) > 0 and not quality.hidden and not data.raw.pump[name] then
      local copy = table.deepcopy(limiter)
      copy.name = name
      copy.pumping_speed = limiter.pumping_speed * (1 + 0.3 * quality.level)
      copy.placeable_by = { item = "invisible-throughput-limiter-pump-item", count = 1 }
      data:extend({ copy })
      log("nexus-rebalanced: " .. name .. " pumps " .. copy.pumping_speed .. " per tick")
    end
  end
end
