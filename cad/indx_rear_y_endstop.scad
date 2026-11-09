// INDX rear Y endstop for Voron 2.4 (right side), integrated version
//
// Print two replacement parts and the Y endstop is built in:
//   "joint" - INDX "XY Joint - Right up V2" with a striker wing on its
//             outboard rear edge. Prints exactly like the original
//             (top face on the bed).
//   "clip"  - Voron Z belt clip (upper), rear-right only, with a deck and a
//             cheek that hold an Omron D2F-5L upright, lever tip down.
//             Same belt-clamping underside, same stock M5x16 screws
//             (counterbored); the deck follows the original clip contour.
//             Prints upside down (deck top on the bed).
//   "assembly" - both in printer coordinates at the moment of the click.
//
// The original meshes are imported from source_stl/ (INDX for Voron 2.4 and
// Voron 2.4, both GPLv3). New features are modelled in Voron 2.4 CAD frame
// coordinates (X+ right, Y+ rear, Z+ up, joint at the CAD gantry pose) and
// mapped into each part's own STL coordinates with the matrices below.

part = "joint"; // [joint, clip, assembly]

/* [Joint striker] */
striker_face_y = 171.8;   // frame Y of the striker face at the CAD pose (+ = later trigger)
wing_bottom    = 89.4;    // frame Z; gantry extrusion top is 88.0
wing_x_end     = 331.5;   // frame X

/* [Switch on the clip] */
switch_hole_y  = 306.3;   // D2F hole line, frame Y
switch_face_x  = 320.0;   // cheek outboard face; switch body sits at X 320..325.8
switch_bottom  = 89.3;    // switch body lower end (lever tip end)
deck_top       = 103.0;
m2_pilot_d     = 1.8;

/* [Hidden] */
$fn = 48;
joint_top   = 93.91;
clip_front  = 313.98;
clip_top    = 98.2;
clip_screws = [[322.0, 320.23], [322.0, 335.73]];

// part STL -> frame
JOINT_S2F = [[-1, 0, 0, 292.0], [0, 1, 0, 183.1], [0, 0, -1, 77.91], [0, 0, 0, 1]];
JOINT_F2S = [[-1, 0, 0, 292.0], [0, 1, 0, -183.1], [0, 0, -1, 77.91], [0, 0, 0, 1]];
CLIP_S2F  = [[0, -1, 0, 437.0], [1, 0, 0, 201.47], [0, 0, 1, 93.0], [0, 0, 0, 1]];
CLIP_F2S  = [[0, 1, 0, -201.47], [-1, 0, 0, 437.0], [0, 0, 1, -93.0], [0, 0, 0, 1]];

function cyl_r(d) = d / 2 / cos(180 / $fn);

module rrect(x0, x1, y0, y1, r)
    translate([x0 + r, y0 + r]) offset(r = r) square([x1 - x0 - 2 * r, y1 - y0 - 2 * r]);

module joint_frame() {
    y0 = striker_face_y - 15;
    union() {
        multmatrix(JOINT_S2F) import("source_stl/INDX XY Joint - Right up V2.stl", convexity = 6);
        translate([0, 0, wing_bottom]) linear_extrude(joint_top - wing_bottom) {
            rrect(308.0, wing_x_end, y0, striker_face_y, 1.5);
            polygon([[303.0, y0], [308.5, y0], [308.5, y0 + 7.3]]);
        }
    }
}

// Clip outlines (frame X, Y), generated with the STLs. The deck follows the
// original Voron clip contour, with the vertical belt slot on the outboard
// side carried up through it (9.2 mm wide, 1.0 mm deep like the stock
// groove); the cheek is the tongue in front of it.
deck_outline = [
    [332.000, 319.713], [332.000, 323.370], [331.000, 323.370], [331.000, 332.570],
    [332.000, 332.570], [332.000, 338.970], [331.961, 339.445], [331.841, 339.934],
    [331.651, 340.371], [331.380, 340.796], [331.060, 341.149], [330.667, 341.464],
    [330.250, 341.695], [329.776, 341.868], [329.308, 341.953], [321.000, 341.970],
    [315.000, 341.970], [314.525, 341.931], [314.036, 341.811], [313.599, 341.621],
    [313.174, 341.350], [312.821, 341.030], [312.506, 340.637], [312.275, 340.220],
    [312.102, 339.746], [312.017, 339.278], [312.000, 335.130], [312.000, 316.970],
    [312.039, 316.495], [312.159, 316.006], [312.349, 315.569], [312.620, 315.144],
    [312.940, 314.791], [313.333, 314.476], [313.750, 314.245], [314.224, 314.072],
    [314.692, 313.987], [323.000, 313.970], [329.000, 313.970], [329.475, 314.009],
    [329.964, 314.129], [330.401, 314.319], [330.826, 314.590], [331.179, 314.910],
    [331.494, 315.303], [331.725, 315.720], [331.898, 316.194], [331.983, 316.662]
];
cheek_upper_outline = [
    [313.000, 303.800], [313.031, 303.409], [313.122, 303.027], [313.272, 302.665],
    [313.477, 302.331], [313.732, 302.032], [314.031, 301.777], [314.365, 301.572],
    [314.727, 301.422], [315.109, 301.331], [315.500, 301.300], [317.500, 301.300],
    [317.891, 301.331], [318.273, 301.422], [318.635, 301.572], [318.969, 301.777],
    [319.268, 302.032], [319.523, 302.331], [319.728, 302.665], [319.878, 303.027],
    [319.969, 303.409], [320.000, 303.800], [320.000, 315.200], [313.000, 315.200]
];
cheek_lower_outline = [
    [313.000, 303.800], [313.031, 303.409], [313.122, 303.027], [313.272, 302.665],
    [313.477, 302.331], [313.732, 302.032], [314.031, 301.777], [314.365, 301.572],
    [314.727, 301.422], [315.109, 301.331], [315.500, 301.300], [317.500, 301.300],
    [317.891, 301.331], [318.273, 301.422], [318.635, 301.572], [318.969, 301.777],
    [319.268, 302.032], [319.523, 302.331], [319.728, 302.665], [319.878, 303.027],
    [319.969, 303.409], [320.000, 303.800], [320.000, 313.680], [313.000, 313.680]
];

deck_bottom = 97.4;   // inside the clip's straight wall, so deck and clip walls run on
r_top    = 1.5;       // top edge round-over
r_bot    = 1.5;       // cheek bottom edge round-over
cb_r     = 5.0;       // counterbore radius (M5 BHCS head is 9.5 mm)
cb_chamf = 0.4;
seat_z   = 98.2;      // stock screw-head seat

// extrude a 2D outline with a rounded top edge and a flat bottom
module round_top(z0, z1, r) {
    intersection() {
        translate([0, 0, z0]) minkowski() {
            linear_extrude(z1 - z0 - r) offset(delta = -r) children();
            sphere(r = r, $fn = 24);
        }
        translate([-1000, -1000, z0]) cube([2000, 2000, z1 - z0]);
    }
}

// extrude a 2D outline with a rounded bottom edge and a flat top
module round_bottom(z0, z1, r) {
    intersection() {
        translate([0, 0, z0 + r]) minkowski() {
            linear_extrude(z1 - z0 - r) offset(delta = -r) children();
            sphere(r = r, $fn = 24);
        }
        translate([-1000, -1000, z0]) cube([2000, 2000, z1 - z0]);
    }
}

module pilots() {   // D2F-5L pilot holes (M2x10 self-tapping), 6.5 mm apart along Z
    for (xl = [6.3, 12.8])
        translate([switch_face_x - 5.0, switch_hole_y, switch_bottom + xl - 3.15]) rotate([0, 90, 0])
            cylinder(d = m2_pilot_d, h = 6.0, $fn = 16);
}

module clip_frame() {
    union() {
        multmatrix(CLIP_S2F) import("source_stl/voron_z_belt_clip_upper.stl", convexity = 6);
        difference() {
            round_top(deck_bottom, deck_top, r_top) polygon(deck_outline);
            for (s = clip_screws) {   // counterbores with a flat seat at the stock head height (Z 98.2)
                translate([s[0], s[1], seat_z]) cylinder(r = cyl_r(2 * cb_r), h = 10);
                translate([s[0], s[1], deck_top - cb_chamf]) cylinder(r1 = cb_r, r2 = cb_r + cb_chamf + 1, h = cb_chamf + 1);
                translate([s[0], s[1], deck_bottom - 1]) cylinder(r = cyl_r(5.5), h = 10);
            }
        }
        difference() {   // cheek, upper part: merges into the deck
            round_top(97.0, deck_top, r_top) polygon(cheek_upper_outline);
            pilots();
        }
        difference() {   // cheek, lower part: stays in front of the drive face
            round_bottom(switch_bottom, 97.6, r_bot) polygon(cheek_lower_outline);
            pilots();
        }
        // even out the vertical belt slot: fill the stock groove's deeper lead-in/lead-out
        // so it is a constant 1.0 mm deep (bottom at X 331) from the drive top up
        translate([330.0, 323.40, 93.05]) cube([1.0, 332.54 - 323.40, 97.55 - 93.05]);
        // 1.5 mm concave blend between the cheek's outboard face and the clip front
        translate([0, 0, 93.3]) linear_extrude(101.6 - 93.3) difference() {
            translate([switch_face_x - 0.3, clip_front - 1.5]) square([1.8, 1.8]);
            translate([switch_face_x + 1.5, clip_front - 1.5]) circle(r = 1.5, $fn = 48);
        }
    }
}

if (part == "joint") {
    multmatrix(JOINT_F2S) joint_frame();     // INDX's own print orientation
} else if (part == "clip") {
    rotate([180, 0, 0]) multmatrix(CLIP_F2S) clip_frame();   // upside down: deck top on the bed
} else {
    trigger = 126.5;                         // joint travel from the CAD pose to the click
    color("tomato") translate([0, trigger, 0]) joint_frame();
    color("royalblue") clip_frame();
    color("dimgray") translate([switch_face_x, switch_hole_y - 5.0, switch_bottom]) cube([5.8, 6.5, 12.8]);  // D2F body
    color("gold") translate([switch_face_x + 1.4, switch_hole_y - 10.0, switch_bottom - 0.3]) cube([3, 5, 12]);   // lever
    color("silver", 0.5) translate([312, 200, 68]) cube([20, 113.9, 20]);                                         // gantry extrusion
}
