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

// --- Eye sockets ---
eye_d         = 12;             // mm, eye recess diameter
eye_depth     = 1.8;            // mm, recess depth
eye_x_offset  = 2;              // mm, forward of centre
eye_y_offset  = ry - 0.5;       // places on the side of the head

// --- Jet tubes ---
jet_d         = 2.2;            // mm, jet tube diameter
jet_start_x   = -rx + 1.4;      // mm, starts just behind the nose trim
jet_end_x     = eye_x_offset + 5.0; // mm, exits just behind the eyes
jet_y_offset  = 3.2;            // mm, offset from centreline
jet_exit_z    = 4.9;            // mm, crown exit height

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm
collar_len    = 6;              // mm
collar_x      = rx - collar_len / 2;  // centred at back of egg

// --- Nose trim ---
nose_flat_x   = -rx + 1.2;      // mm, slightly trims the nose tip for a flatter face

module jet_tube(y_sign = 1) {
    hull() {
        translate([jet_start_x, y_sign * jet_y_offset, 0])
            rotate([0, 90, 0])
                cylinder(d = jet_d, h = 0.1, center = true, $fn = 36);

        translate([jet_end_x, y_sign * jet_y_offset, jet_exit_z])
            rotate([0, 90, 0])
                cylinder(d = jet_d, h = 0.1, center = true, $fn = 36);
    }
}

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

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset + eye_depth, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 4.0, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -(eye_y_offset + eye_depth), 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 4.0, $fn = 80);

    // --- Jet tubes ---
    jet_tube(1);
    jet_tube(-1);
}
