-- Prices of Nexus. Each change acts only while it finds the value that is known to be wrong: a release of Nexus
-- that changes a number makes that change do nothing, and the log tells which number was left as it is.
--
-- Nexus 1.3.0 changed 30 recipes: it raised the inputs of 25 of them, by up to 133 times (omega alloy
-- for the zero-point energy engine core went from 6 to 800). It halved the output of five parts and made the
-- separation of element 882 slower and stingier (changelog.txt:37-94; the recipes
-- of 1.2.9 and 1.3.4 in prototypes/recipe.lua differ in exactly these 30, apart from three bugfixes and the new recipe
-- raw-matter-8). The advanced microchip took 1 processing unit in 1.2.9 and takes 100 in 1.3.4. This mod takes the
-- middle, "total x3":
--   * A final product (the first part of the table) costs min(3 x the amount of 1.2.9, the amount of 1.3.4) of each
--     input; its output and its time are the same in both releases. The advanced photon processor takes 4 omega
--     transformers: 1.2.9 had none, 1.3.4 took 10.
--   * The parts that go into them (the second part) cost what they cost in 1.2.9 again: amounts, outputs, time, drop
--     chances.
-- So "x3" is the rule for the inputs of a final product, not for a whole chain: the parts under it are cheap again,
-- and one advanced photon processor needs 832 omega alloy (588 in 1.2.9, 337,020 in 1.3.4), 1.4 times the price of
-- 1.2.9; 6,800 processors take 5,657,600 omega alloy. Only the numbers below change. Everything else of these
-- recipes stays, among it the bugfixes of 1.3.3
-- (ignored_by_productivity on the results of high-energetic-photonen-fluid-mk2, photonen-energy-fluid-mk1 and -mk2,
-- recipe.lua:450, :493, :536) and the replacement of lithium by kr-lithium in omega-alloy. A recipe row that keeps
-- its 1.3.4 number is not listed: the 4 photon processors and 1000 superconductors of the advanced photon processor,
-- the 10 omega gears of fusion-generator-mk2, the 20 holmium plates and 6 omega alloy of the accumulators, the 1200
-- gold wires of omega-module-mk4, the 80 supercapacitors and 84 superconductors of omega-quality-module, the 8 omega
-- gears of omega-substation and the 12 of singularity-assembler.
--
-- Two things follow the numbers, because other code made its prototypes from these recipes before this file runs:
--   * Recycling. The recycler built <item>-recycling from each recipe as Nexus 1.3.4 has it (recycler/data-updates.lua:
--     4-6; Krastorio2 2.1.3 runs the generator once more in its data-final-fixes, prototypes/compatibility/
--     recycler-final-fixes.lua:9-11), a quarter of the inputs of one item (recycling.lua:105-123), and no later mod
--     builds them again. During development we caught that a part made cheaper would give back more than it costs:
--     the advanced microchip takes 1 electronic memory, 1 electronic triode, 4 gold wires and 1 processing unit, and
--     one chip recycled would return 25, 20, 50 and 25 of them, an endless supply of processing units; the electronic
--     triode would be a loop of the same kind, a zero-point energy engine core would return 200 omega alloy for the
--     18 it costs, and the five parts that are made two at a time would return twice the rate. So when a row changes
--     a recipe, the recycling recipe of its item is
--     built again from the changed recipe by the code of the recycler itself (generate_recycling_recipe); only its
--     results and energy_required are taken over. This happens only while the recycling recipe is what the recycler
--     builds from the recipe as it was before the row, the known-bad state: one that a mod wrote by hand is left as it
--     is, and the log says so. The generator also appends an unlock to the recycling technology (recycling.lua:196);
--     that repeats the one that is there and is taken out again.
--   * Rigor Module. rigor-module 1.1.20 makes a hidden copy of every recipe with a chance among its products, one for
--     each step of rigor, and a machine with rigor modules works on the copy for its rigor (data-final-fixes.lua:
--     621-645; control-helpers.lua:104-115). For element-882-separate that is 48 recipes, __rigor_module_mod__25 to
--     __1200, listed in the mod-data rigor_module_mod_recipe_table by the percent of rigor. rigor-module
--     runs before this file (an optional dependency), so the copies hold the numbers of 1.3.4 and a rigor module in
--     the atomar separator would undo the change (1 s, half the gold and platin ore, little promethium). The rows are therefore applied to the
--     copies as well, with one difference: rigor raises the odds of one product, promethium, to r p / (r p - p + 1)
--     with r = 1 + percent / 100 (utils.lua:100-103; data-final-fixes.lua:639), so a chance that is found raised that
--     way is changed to its new value raised the same way. Were rigor-module to run after this file, its copies would
--     not exist yet and would be made from the changed recipe, so there would be nothing to do here.
--
-- A number is { name, amount in 1.3.4, amount now }. The drop chances of element-882-separate are written to whichever
-- field the product has. Nexus 1.3.4 writes probability (recipe.lua:1199-1206, the time is at :1208); Nexus-Updated,
-- the 2.1 fork, writes independent_probability. The chances are compared with a tolerance, because the
-- data dump of the game shows 0.811 as 0.8110000000000002.
local recycling = require("__recycler__.recycling")

local changes = {
  -- Final products.
  {
    "advanced-photon-processor",
    ingredients = {
      { "omega-transformer", 10, 4 }, { "photon-sensor", 16, 12 }, { "platin-mesh", 40, 30 },
      { "supercapacitor", 800, 600 }, { "thermal-plate", 60, 18 },
    },
  },
  { "fusion-generator-mk2", ingredients = { { "omega-beam", 24, 3 } } },
  { "fusion-reactor-mk2", ingredients = { { "omega-beam", 40, 18 }, { "quantum-processor", 100, 30 } } },
  { "omega-accumulator", ingredients = { { "omega-beam", 4, 3 } } },
  { "omega-accumulator-t2", ingredients = { { "omega-beam", 4, 3 } } },
  { "omega-accumulator-t3", ingredients = { { "omega-beam", 4, 3 } } },
  {
    "omega-module-mk4",
    ingredients = {
      { "omega-beam", 120, 18 }, { "omega-gear", 100, 30 }, { "steel-plate", 280, 84 }, { "thermal-plate", 26, 18 },
    },
  },
  {
    "omega-quality-module",
    ingredients = {
      { "gold-foil-mesh", 24, 18 }, { "gold-wire", 800, 180 }, { "omega-beam", 120, 18 }, { "omega-gear", 200, 30 },
      { "steel-plate", 800, 90 }, { "tempered-glass", 180, 60 },
    },
  },
  {
    "omega-substation",
    ingredients = { { "omega-beam", 20, 6 }, { "supercapacitor", 100, 30 }, { "superconductor", 200, 60 } },
  },
  {
    "photon-stream-thruster",
    ingredients = {
      { "omega-beam", 100, 24 }, { "omega-gear", 80, 30 }, { "supercapacitor", 200, 60 }, { "superconductor", 400, 60 },
    },
  },
  {
    "singularity-assembler",
    ingredients = {
      { "omega-beam", 20, 3 }, { "steel-plate", 800, 240 }, { "supercapacitor", 600, 30 }, { "superconductor", 400, 60 },
    },
  },
  {
    "zero-point-energy-engine-core",
    ingredients = { { "omega-alloy", 800, 18 }, { "omega-beam", 120, 60 }, { "omega-gear", 100, 30 } },
  },

  -- Parts, back to the numbers of 1.2.9.
  {
    "advanced-microchip",
    ingredients = {
      { "electronic-memory", 100, 1 }, { "electronic-triode", 80, 1 }, { "gold-wire", 200, 4 },
      { "processing-unit", 100, 1 },
    },
  },
  {
    "electronic-memory",
    ingredients = { { "omega-beam", 2, 1 } },
    results = { { "electronic-memory", 1, 2 } },
  },
  {
    "electronic-triode",
    ingredients = {
      { "gold-wire", 40, 4 }, { "omega-beam", 10, 1 }, { "organic-mesh", 10, 1 }, { "platin-mesh", 8, 1 },
      { "tempered-glass", 20, 2 },
    },
  },
  {
    "element-882-separate",
    time = { 1, 0.5 },
    probabilities = { { "gold-ore", 0.015, 0.03 }, { "platin-ore", 0.01, 0.02 }, { "promethium", 0.004, 0.02 },
      { "stone", 0.811, 0.77 } },
  },
  { "gold-foil", results = { { "gold-foil", 1, 2 } } },
  { "omega-gear", results = { { "omega-gear", 1, 2 } } },
  { "platin-mesh", results = { { "platin-mesh", 1, 2 } } },
  { "tempered-glass", results = { { "tempered-glass", 1, 2 } } },
  { "omega-alloy", ingredients = { { "high-energetic-photonen-fluid", 200, 100 } } },
  { "omega-module-mk1", ingredients = { { "gold-wire", 40, 20 }, { "omega-gear", 10, 8 } } },
  {
    "omega-module-mk2",
    ingredients = { { "advanced-coil", 4, 2 }, { "omega-beam", 16, 6 }, { "omega-gear", 20, 10 } },
  },
  {
    "omega-module-mk3",
    ingredients = {
      { "advanced-filter", 2, 1 }, { "omega-beam", 16, 6 }, { "omega-gear", 20, 10 }, { "omega-inductor", 2, 1 },
    },
  },
  { "omega-transformer", ingredients = { { "omega-beam", 10, 5 }, { "steel-plate", 100, 10 } } },
  {
    "photon-chip",
    ingredients = {
      { "advanced-microchip", 20, 10 }, { "electronic-triode", 20, 4 }, { "gold-wire", 600, 100 },
      { "omega-beam", 40, 4 }, { "organic-mesh", 20, 8 }, { "quantum-processor", 100, 1 },
      { "supercapacitor", 200, 8 }, { "superconductor", 200, 20 }, { "thermal-plate", 10, 1 },
    },
  },
  {
    "photon-processor",
    ingredients = {
      { "omega-beam", 60, 2 }, { "omega-transformer", 4, 1 }, { "superconductor", 200, 26 },
      { "tempered-glass", 24, 16 }, { "thermal-plate", 40, 4 },
    },
  },
  {
    "photon-sensor",
    ingredients = {
      { "electronic-triode", 20, 5 }, { "gold-wire", 80, 40 }, { "omega-beam", 80, 6 }, { "omega-gear", 60, 4 },
      { "omega-inductor", 8, 1 }, { "promethium-lens", 10, 3 }, { "quantum-processor", 100, 4 },
      { "thermal-plate", 8, 2 },
    },
  },
  { "promethium-lens", ingredients = { { "diamond", 10, 1 } } },
  {
    "thermal-plate",
    ingredients = { { "gold-foil-mesh", 2, 1 }, { "omega-beam", 10, 2 }, { "organic-mesh", 2, 1 } },
  },
}

local tolerance = 1e-6

local recipes = data.raw.recipe or {}

local function same(current, expected)
  return type(current) == "number" and math.abs(current - expected) < tolerance
end

local function number_text(value)
  if value == nil then
    return "missing"
  end
  if type(value) == "number" then
    return string.format("%.9g", value)
  end

  return tostring(value)
end

-- The entry of an ingredient or result list that has this name.
local function find_by_name(list, name)
  for _, entry in pairs(list or {}) do
    if type(entry) == "table" and entry.name == name then
      return entry
    end
  end

  return nil
end

-- The field that holds the drop chance of a product. Only the one that is there is written, never both.
local function probability_field(product)
  if product and product.independent_probability == nil and product.probability ~= nil then
    return "probability"
  end

  return "independent_probability"
end

-- The chance of rigor-module's copy for the rigor `scale` (1 + percent / 100), see the header.
local function odds_scale(probability, scale)
  return scale * probability / (scale * probability - probability + 1)
end

-- Sets holder[field] to `to` when it holds `from` now. Returns the log text of the change; or nil and the log text of
-- why the number was left as it is: it has the wanted value already (the third value is true then), or some value that
-- is neither.
local function set_number(label, holder, field, from, to)
  local current = holder and holder[field]

  if same(current, from) then
    holder[field] = to
    return label .. " " .. number_text(from) .. " -> " .. number_text(to)
  end

  if same(current, to) then
    return nil, label .. " is " .. number_text(to) .. " already", true
  end

  return nil, label .. " is " .. number_text(current) .. ", not " .. number_text(from) .. ", left as it is", false
end

-- Applies the rows of one entry of the table to a recipe. Returns the log texts of what was changed, of what was left
-- as it is, and of the part of that where the number is not the wanted one already. `scale` is given for a copy of
-- rigor-module and only changes how a chance is found, see the header.
local function apply_rows(change, recipe, scale)
  local applied = {}
  local skipped = {}
  local foreign = {}

  local function try(label, holder, field, from, to)
    local text, reason, already = set_number(label, holder, field, from, to)
    if text then
      applied[#applied + 1] = text
    else
      skipped[#skipped + 1] = reason
      if not already then
        foreign[#foreign + 1] = reason
      end
    end
  end

  for _, row in ipairs(change.ingredients or {}) do
    try("ingredient " .. row[1], find_by_name(recipe.ingredients, row[1]), "amount", row[2], row[3])
  end
  for _, row in ipairs(change.results or {}) do
    try("result " .. row[1], find_by_name(recipe.results, row[1]), "amount", row[2], row[3])
  end
  if change.time then
    try("time", recipe, "energy_required", change.time[1], change.time[2])
  end
  for _, row in ipairs(change.probabilities or {}) do
    local product = find_by_name(recipe.results, row[1])
    local field = probability_field(product)
    local from = row[2]
    local to = row[3]

    -- A chance that rigor-module raised, before or after the change, is compared in its raised form.
    if scale and product then
      local raised_from = odds_scale(from, scale)
      local raised_to = odds_scale(to, scale)

      if same(product[field], raised_from) or same(product[field], raised_to) then
        from = raised_from
        to = raised_to
      end
    end

    try("chance of " .. row[1], product, field, from, to)
  end

  return applied, skipped, foreign
end

local function log_rows(label, applied, skipped)
  if #applied > 0 then
    log("nexus-rebalanced: " .. label .. ": " .. table.concat(applied, ", "))
  end
  for _, reason in ipairs(skipped) do
    log("nexus-rebalanced: " .. label .. " skipped: " .. reason)
  end
end

-- The item that a recipe makes; nil when it makes none or several different ones. The recycler names its recycling
-- recipe after this item, and builds none for several (element-882-separate).
local function sole_item(recipe)
  local item_name

  for _, product in pairs(recipe.results or {}) do
    if product.type == "item" then
      if item_name and product.name ~= item_name then
        return nil
      end
      item_name = product.name
    end
  end

  return item_name
end

-- What a recipe returns, order-insensitive; %.9g hides float noise.
local function results_key(recipe)
  local keys = {}

  for _, product in pairs(recipe.results or {}) do
    keys[#keys + 1] = string.format("%s:%s:%.9g:%.9g", product.type or "item", product.name,
      product.amount or 0, product.extra_count_fraction or 0)
  end
  table.sort(keys)

  return table.concat(keys, "|")
end

-- The recycling recipe that the recycler builds from `recipe` as it is now; nil when it builds none. The call
-- overwrites recipes[recycling_name], put back here, and appends an unlock to the recycling technology (recycling.lua:
-- 196), taken out again here: the list of effects stays as it was. The technology has the unlock of every
-- recycling recipe already, from the passes of the recycler. If a mod replaced the list since the recycler captured
-- it, the unlock went into the old one and this one was not touched.
local function built_from(recipe, recycling_name)
  local technology = data.raw.technology and data.raw.technology.recycling
  local effects = technology and technology.effects
  local effect_count = effects and #effects or 0
  local current = recipes[recycling_name]

  recycling.generate_recycling_recipe(recipe)
  local generated = recipes[recycling_name]
  recipes[recycling_name] = current

  if effects then
    for index = #effects, effect_count + 1, -1 do
      effects[index] = nil
    end
  end

  if generated ~= current then
    return generated
  end

  return nil
end

-- Before a row changes the recipe: the recycling recipe of its item, and whether that is what the recycler builds
-- from the recipe as it is (the known-bad state). nil when the item has no recycling recipe.
local function recycling_before(recipe)
  local item_name = sole_item(recipe)
  local current = item_name and recipes[item_name .. "-recycling"]
  if not current then
    return nil
  end

  local built = built_from(recipe, current.name)

  return { current = current, built_from_old = built ~= nil and results_key(built) == results_key(current) }
end

-- After the row: the recycling recipe follows the changed recipe. Only what depends on the amounts and on the number
-- of items made is taken over (results, energy_required); the rest stays, among it the enabled = true that moon-eneas
-- sets on every recycling recipe (prototypes/patches/tech.lua:29-33) and the hidden flag.
local function rebuild_recycling(recipe, before)
  local current = before.current
  local wanted = built_from(recipe, current.name)

  if not wanted then
    return
  end

  -- Nothing to give back differently, as with omega-alloy, where only the amount of a fluid changed.
  if results_key(wanted) == results_key(current) and same(current.energy_required, wanted.energy_required) then
    return
  end

  if not before.built_from_old then
    log("nexus-rebalanced: " .. current.name .. " is not what the recycler builds from the recipe of Nexus 1.3.4, "
      .. "left as it is")
    return
  end

  current.results = wanted.results
  current.energy_required = wanted.energy_required
  log("nexus-rebalanced: " .. current.name .. " rebuilt from the changed recipe")
end

-- The hidden copies that rigor-module made of a recipe, by the percent of rigor ("0" is the recipe itself). Applies the
-- rows to each copy. The log has one line for all that changed, and one for each number that was left as it is
-- because it is neither the old one nor the new one; a copy that has the new numbers already is not worth a line.
local function change_rigor_copies(change)
  local recipe_name = change[1]
  local rigor_table = data.raw["mod-data"] and data.raw["mod-data"].rigor_module_mod_recipe_table
  local copies = rigor_table and rigor_table.data and rigor_table.data[recipe_name]
  if type(copies) ~= "table" then
    return
  end

  local steps = {}
  for key, copy_name in pairs(copies) do
    local percent = tonumber(key)

    if percent and percent > 0 then
      steps[#steps + 1] = { percent = percent, recipe_name = copy_name }
    end
  end
  table.sort(steps, function(left, right) return left.percent < right.percent end)

  local changed = 0
  for _, step in ipairs(steps) do
    local copy = recipes[step.recipe_name]

    if copy then
      local applied, _, foreign = apply_rows(change, copy, 1 + step.percent / 100)
      if #applied > 0 then
        changed = changed + 1
      end
      log_rows("Nexus recipe " .. step.recipe_name, {}, foreign)
    end
  end

  if changed > 0 then
    log("nexus-rebalanced: Nexus recipe " .. recipe_name .. ": " .. changed .. " copies of rigor-module changed too")
  end
end

-- Applies one row of the table; false when the recipe does not exist.
local function change_recipe(change)
  local recipe_name = change[1]
  local recipe = recipes[recipe_name]
  if not recipe then
    return false
  end

  local before = recycling_before(recipe)
  local applied, skipped = apply_rows(change, recipe)
  log_rows("Nexus recipe " .. recipe_name, applied, skipped)

  if before and #applied > 0 then
    rebuild_recycling(recipe, before)
  end
  change_rigor_copies(change)

  return true
end

local missing = {}
for _, change in ipairs(changes) do
  if not change_recipe(change) then
    missing[#missing + 1] = change[1]
  end
end

-- Without Nexus not one of the recipes exists, and that is no news. With it, a missing one was renamed or removed.
if #missing > 0 and #missing < #changes then
  log("nexus-rebalanced: Nexus prices: no recipe " .. table.concat(missing, ", "))
end
