-- Everything runs in data-final-fixes, after Nexus has filled in its own prototypes and after the mods this one lists
-- as optional dependencies: razi-protocol (the road), Krastorio2 (it builds the recycling recipes once more in its
-- data-final-fixes) and rigor-module (its copies of the recipes with chances). Without Nexus nothing is found and
-- nothing changes.
require("prototypes.prices")
require("prototypes.beacons")
require("prototypes.omega_lab")
require("prototypes.road")
require("prototypes.zpe_pumps")
