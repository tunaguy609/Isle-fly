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
eye_y_offset  = ry - 0.5;       // places on the side of the head

// --- Cupped mouth ---
mouth_w       = 14;             // mm, width of the cupped mouth
mouth_h       = 4.8;            // mm, height of the mouth opening
mouth_x       = -rx + 1.4;      // mm, keep the mouth integrated with the nose
mouth_z       = -1.0;           // mm, center the cup around the leader bore
mouth_cup_d   = 11.5;           // mm, diameter of the horizontal cup

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm
collar_len    = 6;              // mm
collar_x      = rx - collar_len / 2;  // centred at back of egg

// --- Nose trim ---
nose_flat_x   = -rx + 1.2;      // mm, slightly trims the nose tip for a flatter face

// --- Jets (new) ---
jet_d         = 2.4;            // mm jet tunnel diameter
jet_start_x   = mouth_x + 0.6;  // start near mouth
jet_start_z   = mouth_z - 1.2;  // start from the lower lip of the cup
jet_exit_x    = eye_x_offset + 2.5;   // exit near the crown, just aft of the eyes
jet_exit_y    = 3.2;                  // keep jets close to the centreline as they rise
jet_exit_z    = ry - 0.4;             // exit through the top of the head

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
    }

    // --- Nose flattening cut ---
    translate([nose_flat_x - 10, 0, 0])
        cube([20, max_diameter * 2, max_diameter * 2], center = true);

    // --- Center bore (nose to tail) ---
    translate([-rx, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = head_length + collar_len, $fn = 30);

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset + eye_depth, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 4.0, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -(eye_y_offset + eye_depth), 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 4.0, $fn = 80);

    // --- Horizontally cupped mouth blended into the leader entry ---
    translate([mouth_x, 0, mouth_z])
        rotate([0, 90, 0])
            difference() {
                cylinder(d = mouth_cup_d, h = 3.2, center = true, $fn = 72);
                translate([0.6, 0, 0])
                    cylinder(d = mouth_cup_d - mouth_h, h = 3.6, center = true, $fn = 72);
            }

    hull() {
        translate([-rx + 0.5, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = bore_d + 1.6, h = 1.0, center = true, $fn = 40);
        translate([mouth_x - 0.6, 0, mouth_z])
            rotate([0, 90, 0])
                cylinder(d = mouth_h, h = 1.2, center = true, $fn = 48);
    }

    // --- Twin jet tunnels from mouth to behind-eye exits ---
    // starboard jet
    hull() {
        translate([jet_start_x,  1.8, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,   jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }

    // port jet
    hull() {
        translate([jet_start_x, -1.8, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,  -jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }
}
