-- Runtime part of the balance: the limiter pumps of the zero-point energy engine core follow its quality, and the warp
-- drive of a platform works only on the way to the Oort cloud and Sol. Both act only when Nexus is there.

local CORE = "zero-point-energy-engine-core"
local BASE_PUMP = "invisible-throughput-limiter-pump"
local WARP_ENGINE = "warp-drive-engine"

-- ZERO-POINT ENERGY ENGINE CORE
-- Nexus places four limiter pumps around a core when a player or a robot builds it, at these offsets from its centre
-- (Nexus control.lua, on_built_entity and on_robot_built_entity), always of normal quality. This handler runs after the
-- one of Nexus (handlers run in the load order of the mods) and puts the pump of the core's quality in their place
-- (prototypes/zpe_pumps.lua). Nexus removes the pumps of a core by the name of the normal one, so the quality pumps
-- are removed here.
local PUMP_OFFSETS = { { x = 8, y = 2 }, { x = -8, y = 2 }, { x = 0, y = 8 }, { x = 0, y = -4 } }

-- The pump of the quality of a core; nil for normal quality, or when there is no pump of that quality.
local function quality_pump(core)
  local quality = core.quality
  if quality.level == 0 then
    return nil
  end

  local name = BASE_PUMP .. "-" .. quality.name
  return prototypes.entity[name] and name or nil
end

local function pumps_of(core, names)
  local found = {}
  for _, offset in ipairs(PUMP_OFFSETS) do
    local position = { x = core.position.x + offset.x, y = core.position.y + offset.y }
    for _, pump in pairs(core.surface.find_entities_filtered({ position = position, radius = 0.5, name = names })) do
      found[#found + 1] = pump
    end
  end
  return found
end

-- Swaps the normal pumps of a core for the ones of its quality. A core whose pumps are of its quality already is left.
local function upgrade_pumps(core)
  local name = quality_pump(core)
  if not name then
    return
  end

  for _, pump in ipairs(pumps_of(core, { BASE_PUMP })) do
    local surface, position, direction, force = pump.surface, pump.position, pump.direction, pump.force
    pump.destroy()
    surface.create_entity({ name = name, position = position, direction = direction, force = force })
  end
end

local function quality_pump_names()
  local names = {}
  for name in pairs(prototypes.get_entity_filtered({ { filter = "type", type = "pump" } })) do
    if name:find("^invisible%-throughput%-limiter%-pump%-") then
      names[#names + 1] = name
    end
  end
  return names
end

local function remove_quality_pumps(core)
  local names = quality_pump_names()
  if #names == 0 then
    return
  end

  for _, pump in ipairs(pumps_of(core, names)) do
    pump.destroy()
  end
end

-- WARP DRIVE
-- The warp drive engine of Nexus is meant for the jump to the Oort cloud and on to Sol. On an ordinary route it throws
-- the platform through dense asteroid lines: the game drops to about 0.6 UPS for hours and multiplayer desyncs
-- (mods.factorio.com/mod/Nexus/discussion/6910ef6d175d819a5a530ec9); Nexus only warns in the chat. The engines of a
-- platform are switched off by script while it travels a route that neither starts nor ends at the Oort cloud or Sol,
-- and on again otherwise.
local WARP_ROUTES = { ["oort-cloud"] = true, sol = true }

local function update_warp_engines(platform)
  if not (platform and platform.valid and platform.surface) then
    return
  end

  local connection = platform.space_connection
  local allowed = not connection or WARP_ROUTES[connection.from.name] or WARP_ROUTES[connection.to.name] or false
  for _, engine in pairs(platform.surface.find_entities_filtered({ name = WARP_ENGINE })) do
    engine.disabled_by_script = not allowed
  end
end

-- A save that had Nexus before this mod: the cores that stand get the pumps of their quality, and the platforms the
-- state of their warp engines.
local function refresh_all()
  if prototypes.entity[CORE] then
    for _, surface in pairs(game.surfaces) do
      for _, core in pairs(surface.find_entities_filtered({ name = CORE })) do
        upgrade_pumps(core)
      end
    end
  end

  if prototypes.entity[WARP_ENGINE] then
    for _, force in pairs(game.forces) do
      for _, platform in pairs(force.platforms) do
        update_warp_engines(platform)
      end
    end
  end
end

script.on_init(refresh_all)
script.on_configuration_changed(refresh_all)

-- The filters name entities of Nexus: they are registered only when Nexus is there. A filter can be given only to one
-- event at a time.
if prototypes.entity[CORE] then
  local function on_core_built(event)
    local core = event.entity
    if core.valid then
      upgrade_pumps(core)
    end
  end

  local function on_core_removed(event)
    local core = event.entity
    if core.valid then
      remove_quality_pumps(core)
    end
  end

  for _, event_id in ipairs({ defines.events.on_built_entity, defines.events.on_robot_built_entity }) do
    script.on_event(event_id, on_core_built, { { filter = "name", name = CORE } })
  end
  for _, event_id in ipairs({
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy,
  }) do
    script.on_event(event_id, on_core_removed, { { filter = "name", name = CORE } })
  end
end

if prototypes.entity[WARP_ENGINE] then
  script.on_event(defines.events.on_space_platform_changed_state, function(event)
    update_warp_engines(event.platform)
  end)

  script.on_event(defines.events.on_space_platform_built_entity, function(event)
    local engine = event.entity
    if engine.valid then
      update_warp_engines(engine.surface.platform)
    end
  end, { { filter = "name", name = WARP_ENGINE } })
end
