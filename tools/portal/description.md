Balance for [Nexus Extended Promethium Endgame](https://mods.factorio.com/mod/Nexus) by Karu_Kiruna, on Factorio 2.1, for Nexus 1.3.6 or newer. [Nexus-Updated](https://mods.factorio.com/mod/Nexus-Updated), the old 2.1 fork, works too. Without Nexus the mod does nothing. Source: [GreenTech-Solutions/nexus-rebalanced](https://github.com/GreenTech-Solutions/nexus-rebalanced).

## What changes

- **Prices.** Nexus 1.3.0 raised the inputs of 25 recipes up to 133 times and halved the output of five parts. Final products cost at most 3x what they cost in 1.2.9 (never more than in 1.3.4); the parts under them cost what they cost in 1.2.9. Recycling and the copies of rigor-module follow the new recipes.
- **Beacons** reach the singularity assembler, the matter stabilizer and the two photon enrichment chambers, where no productivity can pass. The other Nexus machines and the omega lab stay without beacons: the omega beacon would push their productivity to the cap, and the lab has no cap.
- **Omega lab:** research speed 20 (was 2) and 6 module slots (was 4).
- **Storms** (Nexus-Threat): new defaults of its map settings. Instability halves on its own in 3 hours, 0.6 % lightning chance per 1 % of instability, up to 2 attempts per tick. You can still change them in the map settings. A save that had Nexus-Threat before this mod keeps the values it has; set them in the map settings there.
- **Shield** (Nexus-Threat): the map setting "Passive shield regeneration" is on by default, so the shield regenerates outside storms.
- **With Nexus-Updated only:** the zero-point energy engine core uses limiter pumps of its own quality, and the warp drive works only on routes to or from the Oort cloud and Sol. Nexus 1.3.6 does both itself.
- **Road to Nexus** (with razi-protocol): 300,000 km instead of 2,000,000.

Every change acts only on the value it expects: if a release of Nexus changes a number, that change does nothing and the log says so.

Removing the mod from a save on Nexus-Updated: cores of a quality above normal lose their limiter pumps; build those cores again.
