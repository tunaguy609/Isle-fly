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

// --- Jet vents ---
vent_d         = 2.8;            // mm, vent diameter
vent_start_x   = -rx + 4.4;      // mm, under-chin inlet position
vent_mid_x     = -1.0;           // mm, centre of the internal angled run
vent_end_x     = eye_x_offset + 7.0; // mm, internal exit behind the eyes
vent_y_start   = 1.6;            // mm, starts close to centreline under the chin
vent_y_mid     = 2.6;            // mm, carries through the body before flaring outward
vent_y_end     = 4.2;            // mm, crown exit offset
vent_start_z   = -6.2;           // mm, under-chin height
vent_mid_z     = -0.4;           // mm, interior rise through the body
vent_end_z     = 6.0;            // mm, crown exit height
port_d         = 3.4;            // mm, crown exit port diameter
port_len       = 8.0;            // mm, extra cut length to break through the surface
port_tilt_y    = 18;             // degrees, splay outward from centreline
port_tilt_z    = -32;            // degrees, lean aft and down into the vent path

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm
collar_len    = 6;              // mm
collar_x      = rx - collar_len / 2;  // centred at back of egg

// --- Nose trim ---
nose_flat_x   = -rx + 1.2;      // mm, slightly trims the nose tip for a flatter face

module jet_vent(y_sign = 1) {
    hull() {
        translate([vent_start_x, y_sign * vent_y_start, vent_start_z])
            sphere(d = vent_d, $fn = 36);

        translate([vent_mid_x, y_sign * vent_y_mid, vent_mid_z])
            sphere(d = vent_d, $fn = 36);

        translate([vent_end_x, y_sign * vent_y_end, vent_end_z])
            sphere(d = vent_d, $fn = 36);
    }
}

module jet_exit_port(y_sign = 1) {
    translate([vent_end_x + 0.4, y_sign * vent_y_end, vent_end_z + port_len / 2 - 0.6])
        rotate([0, y_sign * port_tilt_y, 0])
            rotate([0, 0, 0])
                rotate([0, 0, 0])
                    rotate([0, 90 + port_tilt_z, 0])
                        cylinder(d = port_d, h = port_len, center = true, $fn = 48);
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

    // --- Jet vents ---
    jet_vent(1);
    jet_vent(-1);
    jet_exit_port(1);
    jet_exit_port(-1);
}
