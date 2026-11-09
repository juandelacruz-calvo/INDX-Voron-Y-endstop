# Rear Y endstop for karasgit's INDX on the Voron 2.4

A rear Y endstop for a **Voron 2.4 running [karasgit's INDX implementation](https://github.com/karasgit/INDX-for-Voron-2.4)** (INDX for Voron 2.4) with an umbilical (no cable chains). It's **compatible with GE5C Z joints**.

Print two replacement parts and the endstop is built in. No extra brackets or screws, and nothing on the toolhead side of the gantry.

![Overview](images/overview.png)

**Requires:** Voron 2.4 (any size) · karasgit's INDX implementation with its `XY Joint - Right up V2` · umbilical, no Y cable chain · Omron D2F-5L. **Works with:** stock or GE5C Z joints. Right side only.

## Why

karasgit's INDX implementation puts its Y endstop on the front Z bearing block, which isn't available with GE5C Z joints. The Printables [Y endstop relocation mod](https://www.printables.com/model/324787-voron-v24-and-trident-y-endstop-relocation-mod) doesn't fit it either, for two reasons. The implementation reverses the X bar, so the joint's screw tab moves to the front. And its XY joint is trimmed at the inboard rear corner so the carriage can reach X max, so a bumper there would sit in the toolhead's path. This design puts the switch and striker at the **outboard** rear corner, where the Y chain used to run, so the toolhead can never reach them.

## Parts

| Print | Replaces | Orientation |
| --- | --- | --- |
| `stl/INDX XY Joint - Right up V2 - Y endstop.stl` | `XY Joint - Right up V2` from karasgit's INDX implementation | As exported (top face down) |
| `stl/z_belt_clip_upper_rear_right_y_endstop.stl` | Right-rear Z belt clip (upper) only | As exported (deck down) |

ABS/ASA with Voron settings, no supports. Hardware: 1 × D2F-5L and 2 × M2x10 self-tapping screws. All other screws are reused, including the clip's stock M5x16.

The STLs keep the original meshes (karasgit's INDX joint, Voron clip) untouched and add the new features as separate watertight bodies. Slicers merge them into one solid.

![Installed](images/installed.png)

## Install

1. Clear the top of the right gantry extrusion near the rear: old chain mounts, T-nuts. The wing passes 1.4 mm above it.
2. Swap the joint top (`XY Joint - Right up V2`). The screws and bearings are unchanged.
3. Screw the D2F to the clip's cheek from the outboard side: body flush with the cheek front, lever tip down. Wire the two outer pins as for a stock Voron endstop.
4. Support the gantry and swap the right-rear Z belt clip, keeping the belt end clamped. Then run a QGL.

## Klipper

The switch triggers at stock Y travel. To keep your dock positions valid, find the trigger coordinate first with your current front homing: step Y back slowly, using `QUERY_ENDSTOPS`, until the switch reads triggered. All docking moves must stay below that Y. Then:

```ini
[stepper_y]
endstop_pin: ^<pin>            # add ! if QUERY_ENDSTOPS reads inverted
position_endstop: <trigger Y>
position_max: <trigger Y>
homing_positive_dir: true
homing_speed: 20               # slow for the first homes
```

Home Y at an X where the toolhead's path to the rear is clear of the docks.

**Before the first home:** with the motors off, push the gantry back by hand. The switch must click before anything touches: the toolhead, the dock, or the rear Z joint. The hard-limit figures below were measured with stock Z joints, so check this especially with GE5C.

## Geometry

Measured from the Voron 2.4 CAD assembly, the STLs from karasgit's INDX implementation, and the D2F-5L model.

- **Travel after the click:** about 3 mm before the wing meets the cheek, and about 3.3 mm before the joint reaches the rear Z joint (stock hard limit).
- **Clearances:** wing to extrusion 1.4 mm; cheek to joint plate 2.8 mm; nothing extends inboard of the joint.

## Source

`cad/indx_rear_y_endstop.scad` imports the original meshes in `cad/source_stl/`. Set `part` to `joint`, `clip` or `assembly`. To trigger later, increase `striker_face_y` (+1 mm = 1 mm further back) and reprint the joint.

## Credits and license

Derived from karasgit's INDX implementation, [INDX for Voron 2.4](https://github.com/karasgit/INDX-for-Voron-2.4), and [Voron 2.4](https://github.com/VoronDesign/Voron-2) (Voron Design). The idea comes from the Printables [Y endstop relocation mod](https://www.printables.com/model/324787-voron-v24-and-trident-y-endstop-relocation-mod). Licensed under GPLv3; see [LICENSE](LICENSE).
