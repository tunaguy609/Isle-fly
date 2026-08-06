// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  40mm long x 24mm max diameter – cedar-plug action profile
//  3D print orientation: collar on build plate / nose facing up
// ============================================================

// --- Main dimensions ---
head_length   = 40;   // mm, nose to skirt collar – shorter/stubbier for cedar-plug action
max_diameter  = 24;   // mm, widest point

// --- Derived ---
rx       = head_length / 2;     // X half-axis (fore-aft) – used for nose/front half
rear_rx  = rx * 1.5;            // X half-axis for rear half – larger value = shallower rear taper
ry       = max_diameter / 2;    // Y/Z half-axis (radial)
front_ry = ry * 0.90;           // Nose-side radial scale for fuller, longer taper (less bulbous front half)

// --- Nose face (flat/cupped dish – cedar plug water-catch) ---
face_d        = 16.0;           // mm, diameter of flat face cutout
face_depth    = 3.0;            // mm, depth of the dish
face_z_offset = face_d / 2 + bore_d / 2; // mm, shift dish down so its top edge is bore_d/2 below the bore centreline –
                                //     full bore wall thickness is preserved all the way to the nose face

// --- Bore (line-through hole) ---
bore_d        = 2.4;            // mm, center hole for leader/cable
// Bore runs straight along the X axis (no Z offset) so the leader sleeve is one clean tube nose-to-collar.

// --- Eye sockets ---
eye_d         = 8.5;            // mm, eye recess diameter
eye_depth     = 2.0;            // mm, recess depth
eye_x_offset  = 0;              // mm, forward of centre
eye_y_offset  = ry + 1.0;       // start outside the head surface so the cut enters cleanly – no flap

// --- Skirt flair shared dimensions ---
flair_od      = 20.0;          // mm, flared outer diameter at the wide end
flair_ramp    = 9.5;           // mm, length of the narrow→wide ramp
flair_flat    = 5.0;           // mm, length of the wide flat section at the tail of each flair

// --- Front skirt flair (replaces shoulder, sits at head/collar junction) ---
// Ramps from collar_d (narrow) to flair_od (wide) going toward tail, then holds flair_od
flair1_start_x = rx - 2;                        // starts 2mm before head rear edge
flair1_mid_x   = flair1_start_x + flair_ramp;  // where ramp peaks
flair1_end_x   = flair1_mid_x + flair_flat;    // tail end of this flair

// --- Rear skirt flair (original, sits further down the collar) ---
flair_gap     = 0;                              // mm, gap between the two flairs
flair_start_x = flair1_end_x + flair_gap;      // starts 6mm behind the front flair tail
flair_mid_x   = flair_start_x + flair_ramp;    // halfway point – where ramp peaks
flair_end_x   = flair_mid_x + flair_flat;      // tail end of rear flair

// --- Skirt collar (rear cylinder) ---
collar_d      = 18;             // mm, outer diameter
collar_bore_d = 16;             // mm, inner bore diameter – hollow to accept skirt sleeve

// Collar starts 4mm inside head, and ends slightly before rear flair tail
// to prevent any visible collar tail protruding past the last flair.
collar_start_x = rx - 4;
collar_end_x   = flair_end_x - 0.5;

// Derived
collar_len    = collar_end_x - collar_start_x;
collar_x      = (collar_start_x + collar_end_x) / 2;

// --- Jets ---
jet_d         = 3.2;            // mm jet tunnel diameter – wider bore for stronger water throw
// Entries sit on the flanks of the belly, clearly outside the chin slot (chin_w/2 = 7mm edge)
jet_start_x   = 0;              // centered in X to keep the entry on the body
jet_start_y   = 9.0;            // outside the body centerline, on the flank
jet_start_z   = -8.0;           // lower belly entry
// Exits break through the crown (top) of the head, well clear of the eye sockets on the sides
jet_exit_x    = eye_x_offset + 6.0;   // behind the eyes toward the tail
jet_exit_y    = 2.5;                  // close to centreline at the crown – nowhere near eye pockets
jet_exit_z    = ry + 1.0;             // above the crown surface so the cut fully breaks through

// ============================================================
//  Assembly
// ============================================================
// Collar sits on the build plate (Z=0), nose faces up (+Z).
// rotate([0,90,0]) maps -X(nose)→+Z and +X(collar)→-Z;
// translate +47 in Z brings the collar end back to Z=0.
translate([0, 0, rx + collar_len - 4])
rotate([0, 90, 0])
difference() {
    union() {
        // Smooth cedar-plug style body (single continuous loft)
        // Control stations along X: nose -> belly max -> shoulder -> collar blend
        hull() {
            // Nose tip (small, slightly flattened)
            translate([-rx, 0, 0])
                scale([1.0, 0.92, 0.88])
                    sphere(r = 0.9, $fn = 64);

            // Forward body
            translate([-rx * 0.52, 0, 0])
                scale([1.0, 1.00, 0.96])
                    sphere(r = ry * 0.78, $fn = 80);

            // Max girth
            translate([-rx * 0.10, 0, 0])
                scale([1.0, 1.00, 0.98])
                    sphere(r = ry * 1.00, $fn = 90);

            // Rear shoulder
            translate([rx * 0.38, 0, 0])
                scale([1.0, 0.98, 0.95])
                    sphere(r = ry * 0.88, $fn = 80);

            // Blend into collar start so there is no hard step
            translate([rx - 3.5, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d1 = ry * 1.70, d2 = collar_d, h = 3.5, $fn = 80);
        }

        // Skirt collar at rear
        translate([collar_x, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = collar_d, h = collar_len, center = true, $fn = 60);

        // Front skirt flair (replaces shoulder) – ramps narrow→wide toward tail
        hull() {
            translate([flair1_start_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = collar_d, h = 0.1, center = true, $fn = 60);
            translate([flair1_mid_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = flair_od, h = 0.1, center = true, $fn = 60);
        }
        translate([(flair1_mid_x + flair1_end_x) / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = flair_od, h = flair1_end_x - flair1_mid_x, center = true, $fn = 60);

        // Rear skirt flair – same profile, further down the collar
        hull() {
            translate([flair_start_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = collar_d, h = 0.1, center = true, $fn = 60);
            translate([flair_mid_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = flair_od, h = 0.1, center = true, $fn = 60);
        }
        translate([(flair_mid_x + flair_end_x) / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = flair_od, h = flair_end_x - flair_mid_x, center = true, $fn = 60);
    }

    // --- Center bore (nose to tail) – straight axial tube, leader sleeve runs clean nose-to-collar ---
    translate([-rx - 0.1, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = (collar_end_x - (-rx)) + 0.2, $fn = 30);

    // --- Skirt collar bore (hollow interior for skirt sleeve) ---
    // Extended 8mm deeper into the head (starts at rx-8 instead of rx);
    // jet exits are at x≈8, collar bore now starts at x≈9 – 1mm clear is enough
    // since the bore is centred (Z=0) and jets are offset well off-axis.
    translate([rx - 8, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = collar_bore_d, h = collar_len + 8, $fn = 60);

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -eye_y_offset, 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Twin jet tunnels: entries on belly flanks outside chin slot, exits through crown ---
    // starboard jet
    hull() {
        translate([jet_start_x,  jet_start_y, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,   jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }

    // port jet
    hull() {
        translate([jet_start_x, -jet_start_y, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,  -jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }
}
