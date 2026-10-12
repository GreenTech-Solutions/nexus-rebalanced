-- Beacons. Every machine of Nexus that takes modules is written with
-- effect_receiver = { uses_module_effects = true, uses_beacon_effects = false, ... } (Nexus/prototypes/entity/
-- advanced_crusher.lua:118, atomacer.lua:87, atomar_assembler.lua:109, atomar_separator.lua:119,
-- matter_activator.lua:109, matter_stabilizer.lua:108, nano_factory.lua:109, nano_fluid_factory.lua:117,
-- photon_enrichment_chamber.lua:109, photon_enrichment_chamber_mk2.lua:109, roller_factory.lua:112,
-- singularity_assembler.lua:133, omega_lab.lua:246), so not even the beacon of Nexus itself reaches them. The game
-- cannot let in one kind of beacon only: a machine takes the beacon effects or not. allowed_effects stays, so a beacon
-- passes on only what the machine allows.
--
-- This mod lets beacons in only where no productivity can pass. The omega beacon of Nexus passes productivity at
-- 2.5 times its modules and with no falloff (omega_beacon.lua:21, :27): one beacon of omega modules mk4 gives +400%.
-- On a recipe that is capped at +300% (maximum_productivity), so the 8 machines whose recipes allow productivity went
-- from +160% (4 slots) to the cap, on top of the eased prices; the omega lab has no cap at all. Those stay without
-- beacons, as Nexus has them. Beacons speed up the other four: the singularity assembler (speed and quality) and the
-- matter stabilizer (speed) allow no productivity, and no recipe of the photon enrichment chambers allows it.
-- The parts of the zero-point energy engine have no module slots (uses_module_effects = false,
-- zero_point_energy_engine_core/*.lua:106, :134) and are not touched.
-- tenebris-prime copies every assembling machine into a bioluminescent-* one for pressure 3000
-- (prototypes/bioluminescent.lua:171), among them one of each of the machines below, and these copies inherited the
-- false and keep it, so they take no beacon effects. Their names would go into this list to change that.
local beacon_machines = {
  { "assembling-machine", "matter-stabilizer" },
  { "assembling-machine", "photon-enrichment-chamber" },
  { "assembling-machine", "photon-enrichment-chamber-mk2" },
  { "assembling-machine", "singularity-assembler" },
}

-- The categories of a recipe. A mod written for 2.0 may still write category.
local function categories_of(recipe)
  return recipe.categories or { recipe.category or "crafting" }
end

-- The first recipe that the machine makes with productivity, or nil. A machine without allowed_effects allows every
-- effect.
local function productive_recipe(machine)
  if machine.allowed_effects then
    local effects = type(machine.allowed_effects) == "table" and machine.allowed_effects or { machine.allowed_effects }
    local allowed = false
    for _, effect in pairs(effects) do
      if effect == "productivity" then
        allowed = true
      end
    end
    if not allowed then
      return nil
    end
  end

  local categories = {}
  for _, category in pairs(machine.crafting_categories or {}) do
    categories[category] = true
  end
  for name, recipe in pairs(data.raw.recipe or {}) do
    if recipe.allow_productivity then
      for _, category in pairs(categories_of(recipe)) do
        if categories[category] then
          return name
        end
      end
    end
  end
  return nil
end

for _, entry in ipairs(beacon_machines) do
  local group = data.raw[entry[1]]
  local machine = group and group[entry[2]]
  local receiver = machine and machine.effect_receiver

  -- Only the value Nexus writes: a machine without the field takes beacon effects already (the default is true).
  if receiver and receiver.uses_beacon_effects == false then
    local recipe = productive_recipe(machine)
    if recipe then
      log("nexus-rebalanced: " .. entry[1] .. " " .. entry[2] .. " left without beacons: it makes " .. recipe
        .. " with productivity")
    else
      receiver.uses_beacon_effects = true
      log("nexus-rebalanced: " .. entry[1] .. " " .. entry[2] .. " takes beacon effects")
    end
  end
end
