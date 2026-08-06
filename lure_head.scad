// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  40mm long x 24mm max diameter – cedar-plug action profile
//  3D print orientation: collar on build plate / nose facing up
// ============================================================

// --- Main dimensions ---
head_length   = 45;   // mm, nose to skirt collar – shorter/stubbier for cedar-plug action
max_diameter  = 26;   // mm, widest point

// --- Derived ---
rx       = head_length / 2;     // X half-axis (fore-aft)
ry       = max_diameter / 2;    // Y/Z half-axis (radial)

// --- Nose face (flat/cupped dish – cedar plug water-catch) ---
face_d        = 16.0;           // mm, diameter of flat face cutout
face_depth    = 4.0;            // mm, depth of the dish (increased for more cup)

// --- Bore (line-through hole) ---
bore_d        = 2.4;            // mm, center hole for leader/cable

// --- Eye sockets ---
eye_d         = 8.5;            // mm, eye recess diameter
eye_depth     = 2.0;            // mm, recess depth
eye_x_offset  = -1;             // mm, fore-aft position (moved back 1 mm)
eye_y_offset  = ry + 1.0;       // start outside the head surface so the cut enters cleanly

// --- Skirt flair shared dimensions ---
flair_od      = 22.5;           // mm, flared outer diameter at the wide end
flair_ramp    = 9.5;            // mm, length of the narrow→wide ramp
flair_flat    = 2.5;            // mm, length of the wide flat section at the tail of each flair

// --- Front skirt flair (replaces shoulder, sits at head/collar junction) ---
flair1_start_x = rx - 2;
flair1_mid_x   = flair1_start_x + flair_ramp;
flair1_end_x   = flair1_mid_x + flair_flat;

// --- Rear skirt flair (original, sits further down the collar) ---
flair_gap     = 0;
flair_start_x = flair1_end_x + flair_gap;
flair_mid_x   = flair_start_x + flair_ramp;
flair_end_x   = flair_mid_x + flair_flat;

// --- Skirt collar (rear cylinder) ---
collar_d      = 18;
collar_bore_d = 16;

collar_start_x = rx - 4;
collar_end_x   = flair_end_x - 0.5;

// Derived
collar_len    = collar_end_x - collar_start_x;
collar_x      = (collar_start_x + collar_end_x) / 2;

// --- Jets ---
jet_d         = 3.2;
jet_start_x   = -4.0;           // moved forward toward nose
jet_start_y   = 9.0;
jet_start_z   = -8.0;
jet_exit_x    = eye_x_offset + 4.0; // moved further back
jet_exit_y    = 2.5;
jet_exit_z    = ry + 1.0;

// --- Center jet (larger, between side jet entrances) ---
center_jet_d       = 4.2;
center_jet_start_x = jet_start_x;
center_jet_start_y = 0;
center_jet_start_z = jet_start_z;
center_jet_exit_x  = eye_x_offset + 1.5; // exits farther back on body
center_jet_exit_y  = 0;
center_jet_exit_z  = ry + 0.6;

// ============================================================
//  Assembly
// ============================================================
translate([0, 0, rx + collar_len - 4])
rotate([0, 90, 0])
difference() {
    union() {
        // Smooth cedar-plug style body (single continuous loft)
        hull() {
            // Nose tip seed removed to eliminate detached floating artifact

            // Forward body
            translate([-rx * 0.52, 0, 0])
                scale([1.0, 1.00, 0.96])
                    sphere(r = ry * 0.78, $fn = 80);

            // Max girth
            translate([-rx * 0.10, 0, 0])
                scale([1.0, 1.00, 0.98])
                    sphere(r = ry * 1.00, $fn = 90);

            // Rear shoulder (option 2: start later/more aft)
            translate([rx * 0.50, 0, 0])
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

        // Front skirt flair
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

        // Rear skirt flair
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

    // --- Cupped nose dish ---
    // Flat-faced cup cut from the nose side (x = -rx)
    translate([-rx - 0.01, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = face_d, h = face_depth + 0.02, $fn = 80);

    // --- Center bore (leader line through-hole, nose to tail) ---
    translate([-rx - 0.2, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = (collar_end_x - (-rx)) + 0.4, $fn = 40);

    // --- Skirt collar bore ---
    translate([rx - 8, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = collar_bore_d, h = collar_len + 8, $fn = 60);

    // --- Eye sockets ---
    translate([eye_x_offset, eye_y_offset, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    translate([eye_x_offset, -eye_y_offset, 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Twin jet tunnels ---
    hull() {
        translate([jet_start_x,  jet_start_y, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,   jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }

    hull() {
        translate([jet_start_x, -jet_start_y, jet_start_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
        translate([jet_exit_x,  -jet_exit_y, jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = jet_d, h = 0.8, center = true, $fn = 36);
    }

    // --- Center jet tunnel (larger, middle, exits farther back) ---
    hull() {
        translate([center_jet_start_x, center_jet_start_y, center_jet_start_z])
            rotate([0, 90, 0]) cylinder(d = center_jet_d, h = 0.8, center = true, $fn = 40);
        translate([center_jet_exit_x, center_jet_exit_y, center_jet_exit_z])
            rotate([0, 90, 0]) cylinder(d = center_jet_d, h = 0.8, center = true, $fn = 40);
    }
}
