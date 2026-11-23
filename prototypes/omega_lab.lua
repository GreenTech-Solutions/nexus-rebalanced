-- The omega lab of Nexus: how good it is. Its inputs are not touched: Nexus fills them in its data-final-fixes, and
-- razi-protocol adds the five system cards and the Deep Space card after that.
--
-- The omega lab is made the fastest lab: research speed 20, twice that of the singularity lab of Krastorio 2 Spaced Out
-- (10: prototypes/buildings/labs.lua:6), and 6 module slots like that one (:8). Nexus writes 2 and 4
-- (prototypes/entity/omega_lab.lua:171, :245). The power use, the allowed effects, the module categories and the drain
-- of science packs stay. Nexus sets no drain (:154-255), so the default of 100% applies, where the singularity lab has
-- 40% (labs.lua:7), the pressure lab 30% and the biolab and the cryolab 50%: a research unit costs the omega lab 2.5
-- times as many packs as the singularity lab, for twice the speed.
local lab = data.raw.lab and data.raw.lab["omega-lab"]
local expect = require("lib.expect")

expect.set("omega-lab researching_speed", lab, "researching_speed", 2, 20)
expect.set("omega-lab module_slots", lab, "module_slots", 4, 6)
