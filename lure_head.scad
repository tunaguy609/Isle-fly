// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  42mm long x 21mm max diameter
//  3D print orientation: nose facing down / flat face up
//
//  Swim action features:
//    - Concave cupped nose face: deflects water to create zig-zag wobble
//    - Leader bore offset +2 mm above centre: pulls nose down so lure dives
// ============================================================

// --- Main dimensions ---
head_length   = 42;   // mm, nose to skirt collar
max_diameter  = 21;   // mm, widest point

// --- Derived ---
rx = head_length / 2;          // X half-axis (fore-aft)
ry = max_diameter / 2;         // Y/Z half-axis (radial)

// --- Bore (line-through hole) ---
bore_d        = 2.0;            // mm, center hole for leader/cable
bore_z_offset = 2.0;            // mm, bore raised above centreline so lure nose-dives under tow

// --- Cupped nose face ---
cup_r         = ry * 0.85;      // mm, radius of concave cup sphere (slightly smaller than head radius)
cup_depth     = 3.5;            // mm, how deep the cup bites into the nose face
nose_x        = -rx;            // mm, X position of nose tip

// --- Eye sockets ---
eye_d         = 12;             // mm, eye recess diameter
eye_depth     = 1.8;            // mm, recess depth
eye_x_offset  = 2;              // mm, forward of centre
eye_y_offset  = ry - 0.5;       // places on the side of the head

// --- Chin slot ---
chin_w        = 14;             // mm, width of horizontal oval mouth (aggressive)
chin_h        = 4.5;            // mm, height of oval mouth (flatter = more aggressive)
chin_x        = -rx + 3.5;      // mm, position along X from centre (further forward)
chin_z        = -(ry * 0.78);   // mm, position on underside (lower)

// --- Skirt collar (rear cylinder) ---
collar_d        = 15;             // mm
collar_len      = 32;             // mm – restored full length
collar_x        = rx + collar_len / 2 - 4;  // tucks 4mm into head for smoother blend
collar_blend_x  = rx - 3.0;      // mm, blend starts slightly inside the head
collar_blend_d  = 18.0;          // mm, wider blend diameter to merge collar into head

// --- Jets ---
jet_d           = 2.4;           // mm jet tunnel diameter
jet_start_x     = chin_x + 1.0;  // start near mouth
jet_start_z     = chin_z + 0.8;  // lift slightly into body
// Exits at the crown (top of head), behind the eyes and well clear of eye sockets
jet_exit_x      = eye_x_offset + 4.5;  // behind eyes toward tail
jet_exit_y      = 1.2;                 // close to centreline at crown
jet_exit_z      = ry - 1.0;            // near the crown surface (+Z = top)

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

        // Blend collar into head so it reads as one piece
        hull() {
            translate([collar_blend_x, 0, 0])
                sphere(d = collar_blend_d, $fn = 60);
            translate([rx + 1.5, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = collar_d, h = 0.1, center = true, $fn = 60);
        }
    }

    // --- Center bore (offset above centreline for nose-down dive action) ---
    translate([-rx, 0, bore_z_offset])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = head_length + collar_len, $fn = 30);

    // --- Concave cupped nose face (creates zig-zag wobble action) ---
    translate([nose_x - cup_r + cup_depth, 0, 0])
        sphere(r = cup_r, $fn = 80);

    // --- Eye socket – starboard (right, +Y side) ---
    // Translate origin beyond the surface (ry + 1) so the cylinder enters from outside
    // and punches cleanly through, leaving no skin flap over the recess.
    translate([eye_x_offset, ry + 1, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 2.0, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -(ry + 1), 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 2.0, $fn = 80);

    // --- Chin slot (aggressive horizontal oval mouth) ---
    translate([chin_x, 0, chin_z])
        rotate([0, 30, 0])                 // steeper face = more action/smoke
            scale([chin_w/chin_h, 1, 1])   // horizontal oval
                cylinder(d = chin_h, h = ry * 1.2, $fn = 72);

    // --- Twin jet tunnels from chin mouth to crown exits ---
    // Jets rise from under the chin and exit through the top of the head,
    // behind the eye sockets and well clear of them.
    // starboard jet
    hull() {
        translate([jet_start_x,  1.8, jet_start_z])
            sphere(d = jet_d, $fn = 36);
        translate([jet_exit_x,   jet_exit_y, jet_exit_z])
            sphere(d = jet_d, $fn = 36);
    }

    // port jet
    hull() {
        translate([jet_start_x, -1.8, jet_start_z])
            sphere(d = jet_d, $fn = 36);
        translate([jet_exit_x,  -jet_exit_y, jet_exit_z])
            sphere(d = jet_d, $fn = 36);
    }
}
