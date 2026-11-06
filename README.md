# Nexus Rebalanced

Balance for [Nexus Extended Promethium Endgame](https://mods.factorio.com/mod/Nexus) by Karu_Kiruna, on Factorio 2.1,
for Nexus 1.3.6 or newer. [Nexus-Updated](https://mods.factorio.com/mod/Nexus-Updated), the old 2.1 fork, works too.
Without Nexus the mod does nothing.

| What | Change |
| --- | --- |
| Prices | Nexus 1.3.0 raised the inputs of 25 recipes up to 133 times and halved the output of five parts. Final products cost at most 3x what they cost in 1.2.9 (never more than in 1.3.4); the parts under them cost what they cost in 1.2.9. Recycling and the copies of rigor-module follow the new recipes |
| Beacons | The singularity assembler, the matter stabilizer and the two photon enrichment chambers take beacon effects: none of them can get productivity. The other Nexus machines and the omega lab stay without beacons, as in Nexus: the omega beacon passes on productivity |
| Omega lab | Research speed 20 (was 2) and 6 module slots (was 4) |
| Storms (Nexus-Threat) | New defaults of its map settings: instability halves on its own in 3 hours, 0.6 % lightning chance per 1 % of instability, up to 2 attempts per tick |
| Shield (Nexus-Threat) | Map setting "Passive shield regeneration" on by default: the shield regenerates outside storms, as it always did in Nexus-Threat-Updated |
| With Nexus-Updated only | The zero-point energy engine core uses limiter pumps of its own quality, and the warp drive works only on routes that start or end at the Oort cloud or Sol. Nexus 1.3.6 does both itself |
| Road to Nexus (razi-protocol) | 300,000 km instead of 2,000,000 |

Every change acts only on the value it expects: if a release of Nexus changes a number, that change does nothing and
the log says so. The storm defaults can still be changed in the map settings. A save that had Nexus-Threat before this mod keeps the values it
has; set them in the map settings there.

Removing the mod from a save on Nexus-Updated: cores of a quality above normal lose their limiter pumps (the quality
pumps are this mod's there); build those cores again.

## License

GPLv3: [LICENSE](LICENSE).
