-- Beacons. Every machine of Nexus that takes modules is written with
-- effect_receiver = { uses_module_effects = true, uses_beacon_effects = false, ... } (Nexus/prototypes/entity/
-- advanced_crusher.lua:118, atomacer.lua:87, atomar_assembler.lua:109, atomar_separator.lua:119,
-- matter_activator.lua:109, matter_stabilizer.lua:108, nano_factory.lua:109, nano_fluid_factory.lua:117,
-- photon_enrichment_chamber.lua:109, photon_enrichment_chamber_mk2.lua:109, roller_factory.lua:112,
-- singularity_assembler.lua:133, omega_lab.lua:246), so not even the beacon of Nexus itself reaches them. The game
-- cannot let in one kind of beacon only: a machine takes the beacon effects or not. This mod lets all of them in.
-- allowed_effects stays, so a beacon passes on only what the machine allows (the matter stabilizer takes speed and
-- nothing else). The parts of the zero-point energy engine have no module slots (uses_module_effects = false,
-- zero_point_energy_engine_core/*.lua:106, :134) and are not touched.
-- The list is the 13 machines of Nexus that take modules. tenebris-prime copies every assembling machine into a
-- bioluminescent-* one for pressure 3000 (prototypes/bioluminescent.lua:171), among them one of each of the 12
-- assembling machines below, and these copies inherited the false and keep it, so they take no beacon effects. Their
-- names would go into this list to change that.
local beacon_machines = {
  { "assembling-machine", "advanced-crusher" },
  { "assembling-machine", "atomacer" },
  { "assembling-machine", "atomar-assembler" },
  { "assembling-machine", "atomar-separator" },
  { "assembling-machine", "matter-activator" },
  { "assembling-machine", "matter-stabilizer" },
  { "assembling-machine", "nano-factory" },
  { "assembling-machine", "nano-fluid-factory" },
  { "assembling-machine", "photon-enrichment-chamber" },
  { "assembling-machine", "photon-enrichment-chamber-mk2" },
  { "assembling-machine", "roller-factory" },
  { "assembling-machine", "singularity-assembler" },
  { "lab", "omega-lab" },
}

for _, entry in ipairs(beacon_machines) do
  local group = data.raw[entry[1]]
  local machine = group and group[entry[2]]
  local receiver = machine and machine.effect_receiver

  -- Only the value Nexus writes: a machine without the field takes beacon effects already (the default is true).
  if receiver and receiver.uses_beacon_effects == false then
    receiver.uses_beacon_effects = true
    log("nexus-rebalanced: " .. entry[1] .. " " .. entry[2] .. " takes beacon effects")
  end
end
