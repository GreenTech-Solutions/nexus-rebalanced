Balance changes for [Nexus Extended Promethium Endgame](https://mods.factorio.com/mod/Nexus) by Karu_Kiruna. The mod changes numbers only: it adds no items, machines or technologies.

## What changes

| | Nexus | With this mod |
| --- | --- | --- |
| Recipes | 30 endgame recipes cost up to 133 times their earlier inputs, and five parts come out one at a time | Buildings, modules and the advanced photon processor take at most 3 times their earlier inputs. The parts they are made of take their earlier inputs and come out two at a time again |
| Element 882 separation | 1 second, 0.4 % promethium | 0.5 seconds, 2 % promethium; gold and platinum ore chances doubled |
| Beacons | No Nexus machine accepts beacon effects | The singularity assembler, the matter stabilizer and both photon enrichment chambers accept them. Machines that can use productivity, and the omega lab, still do not |
| Omega lab | Research speed 2, 4 module slots | Research speed 20, 6 module slots: faster, and more room for productivity modules |
| Storms (Nexus-Threat) | Instability only grows | Instability halves every 3 hours, so it settles at a level set by the number of working drills. At full instability there are about half as many lightning strikes |
| Shield (Nexus-Threat) | Charged by stabilizers only | Also regenerates slowly outside storms |
| Road to Nexus (razi-protocol) | 2,000,000 km | 300,000 km |

Recycling recipes follow the changed recipes, so an item never gives back more than it cost.

## Storm settings

The storm and shield changes are new defaults for four map settings of Nexus-Threat: instability half-life (3 hours), lightning chance per 1 % of instability (0.6), lightning attempts per tick (2) and passive shield regeneration (on). You can change them at any time. A save that already had Nexus-Threat keeps the values it has: set them there under Settings → Mod settings → Map.

## Compatibility

- Each change applies only while Nexus has the value this mod expects. If Nexus changes a number, the mod leaves that recipe or value alone and writes a line that starts with `nexus-rebalanced:` to the log.
- Rigor Module: its copies of the element 882 separation recipe get the same numbers.
- [Nexus Bosses](https://mods.factorio.com/mod/nexus-bosses): summon beacons are made of omega alloy and photon electronics, so they cost less with this mod.

Source and bug reports: [GreenTech-Solutions/nexus-rebalanced](https://github.com/GreenTech-Solutions/nexus-rebalanced).
