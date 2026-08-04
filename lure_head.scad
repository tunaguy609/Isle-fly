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
bore_d        = 3.5;            // mm, center hole for leader/cable

// --- Eye sockets ---
eye_d         = 12;             // mm, eye recess diameter
eye_depth     = 1.8;            // mm, recess depth
eye_x_offset  = 2;              // mm, forward of centre
eye_y_offset  = ry - 0.5;       // places on the side of the head

// --- Chin slot ---
chin_w        = 9;              // mm, width of oval mouth
chin_h        = 6;              // mm, height of oval mouth
chin_x        = -rx + 6;        // mm, position along X from centre
chin_z        = -(ry * 0.55);   // mm, position on underside

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm
collar_len    = 6;              // mm
collar_x      = rx - collar_len / 2;  // centred at back of egg

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

    // --- Center bore (nose to tail) ---
    translate([-rx, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = head_length + collar_len, $fn = 30);

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 1, $fn = 60);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -eye_y_offset, 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 1, $fn = 60);

    // --- Chin slot (oval mouth on underside-front) ---
    translate([chin_x, 0, chin_z])
        scale([1, chin_w / chin_h, 1])
            rotate([0, 15, 0])          // slight downward angle for bubble trail
                cylinder(d = chin_h, h = ry, $fn = 40);
}
