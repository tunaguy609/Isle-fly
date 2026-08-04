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
vent_d         = 3.0;            // mm, vent diameter
vent_start_x   = -rx + 4.8;      // mm, under-chin inlet position
vent_end_x     = eye_x_offset + 6.8; // mm, exits behind the eyes
vent_y_start   = 2.4;            // mm, starts farther from the centreline under the chin
vent_y_end     = 4.1;            // mm, angles outward toward the crown
vent_start_z   = -6.4;           // mm, under-chin height
vent_end_z     = 6.4;            // mm, crown exit height
vent_port_d    = 3.6;            // mm, exit port diameter
vent_port_lift = 0.8;            // mm, extends the exit cut above the crown

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm
collar_len    = 24;             // mm
collar_x      = rx + collar_len / 2;  // starts at the back of the head and extends aft
ramp_base_x   = rx - 2.5;       // mm, starts the taper slightly inside the back of the head
ramp_base_d   = 18.5;           // mm, broad base diameter for a smoother transition
ramp_pos_from_tail = 12;        // mm, ramp starts this far forward from the tail end of the spigot
ramp_len      = 3;              // mm, retaining ramp length
ramp_peak_d   = 17;             // mm, retaining ramp peak diameter

// --- Nose trim ---
nose_flat_x   = -rx + 1.2;      // mm, slightly trims the nose tip for a flatter face

// --- Leader bore ---
leader_bore_d = 2.5;            // mm, through-bore for leader line
leader_flare_d = 4.5;           // mm, flared nose entry for easier rigging
leader_flare_len = 3.0;         // mm, length of the nose flare

module jet_vent(y_sign = 1) {
    hull() {
        translate([vent_start_x, y_sign * vent_y_start, vent_start_z])
            sphere(d = vent_d, $fn = 40);

        translate([vent_end_x, y_sign * vent_y_end, vent_end_z])
            sphere(d = vent_port_d, $fn = 48);

        translate([vent_end_x + 0.8, y_sign * (vent_y_end + 0.2), vent_end_z + vent_port_lift])
            sphere(d = vent_port_d, $fn = 48);
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

        // Smooth taper from head into collar
        hull() {
            translate([ramp_base_x, 0, 0])
                sphere(d = ramp_base_d, $fn = 60);
            translate([rx + 2.0, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = collar_d, h = 0.1, center = true, $fn = 60);
        }

        // Skirt retaining ramp on spigot
        translate([rx + ramp_pos_from_tail + ramp_len / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(d1 = collar_d, d2 = ramp_peak_d, h = ramp_len, center = true, $fn = 60);
    }

    // --- Nose flattening cut ---
    translate([nose_flat_x - 10, 0, 0])
        cube([20, max_diameter * 2, max_diameter * 2], center = true);

    // --- Leader line bore ---
    rotate([0, 90, 0])
        cylinder(d = leader_bore_d, h = head_length + collar_len + 4, center = true, $fn = 48);

    // --- Leader line nose flare ---
    translate([nose_flat_x - 0.01, 0, 0])
        rotate([0, -90, 0])
            cylinder(d1 = leader_flare_d, d2 = leader_bore_d, h = leader_flare_len, $fn = 48);

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
}
