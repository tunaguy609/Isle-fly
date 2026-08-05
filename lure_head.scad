// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  42mm long x 21mm max diameter
//  3D print orientation: nose facing down / flat face up
// ============================================================

// --- Main dimensions ---
head_length   = 42;   // mm, nose to skirt collar
max_diameter  = 21;   // mm, widest point

// --- Derived ---
rx = head_length / 2;          // X half-axis (fore-aft)
ry = max_diameter / 2;         // Y/Z half-axis (radial)

// --- Bore (line-through hole) ---
bore_d        = 2.0;            // mm, center hole for leader/cable

// --- Eye sockets ---
eye_d         = 12;             // mm, eye recess diameter
eye_depth     = 1.8;            // mm, recess depth
eye_x_offset  = 2;              // mm, forward of centre
eye_y_offset  = ry + 1.0;       // start outside the head surface so the cut enters cleanly – no flap

// --- Chin slot ---
chin_w        = 14;             // mm, width of horizontal oval mouth (aggressive)
chin_h        = 4.5;            // mm, height of oval mouth (flatter = more aggressive)
chin_x        = -rx + 3.5;      // mm, position along X from centre (further forward)
chin_z        = -(ry * 0.78);   // mm, position on underside (lower)

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm, outer diameter
collar_bore_d = 14;             // mm, inner bore diameter – hollow to accept skirt sleeve
collar_len    = 32;             // mm, full collar length restored
collar_x      = rx + collar_len / 2 - 4;  // tucks 4mm into head for smooth blend

// --- Head-to-collar blend ---
blend_d       = 18.0;          // mm, rear shoulder sphere diameter – proud hump where body meets collar

// --- Jets ---
jet_d         = 3.2;            // mm jet tunnel diameter – wider bore for stronger water throw
// Entries sit on the flanks of the belly, clearly outside the chin slot (chin_w/2 = 7mm edge)
jet_start_x   = chin_x + 2.0;          // slightly behind chin slot front face so entries are beside it, not in it
jet_start_y   = chin_w / 2 + 2.0;      // outside the chin slot edge – clear separation
jet_start_z   = chin_z + 0.5;          // on the belly surface beside the chin slot
// Exits break through the crown (top) of the head, well clear of the eye sockets on the sides
jet_exit_x    = eye_x_offset + 6.0;   // behind the eyes toward the tail
jet_exit_y    = 1.5;                  // close to centreline at the crown – nowhere near eye pockets
jet_exit_z    = ry + 1.0;             // above the crown surface so the cut fully breaks through

// ============================================================
//  Assembly
// ============================================================
difference() {
    union() {
        // Main egg-shaped head (scaled sphere)
        scale([rx, ry, ry])
            sphere(r = 1, $fn = 80);

        // Skirt collar at rear
        translate([collar_x, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = collar_d, h = collar_len, center = true, $fn = 60);

        // Rear shoulder – 18mm hump where body meets collar, gives a distinct raised shoulder
        translate([rx, 0, 0])
            sphere(d = blend_d, $fn = 60);
    }

    // --- Center bore (nose to tail) ---
    translate([-rx, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = head_length + collar_len, $fn = 30);

    // --- Skirt collar bore (hollow interior for skirt sleeve) ---
    translate([rx, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = collar_bore_d, h = collar_len, $fn = 60);

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -eye_y_offset, 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Chin slot (aggressive horizontal oval mouth) ---
    translate([chin_x, 0, chin_z])
        rotate([0, 30, 0])                 // steeper face = more action/smoke
            scale([chin_w/chin_h, 1, 1])   // horizontal oval
                cylinder(d = chin_h, h = ry * 1.2, $fn = 72);

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
