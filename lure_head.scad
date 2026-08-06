// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  34mm long x 24mm max diameter – cedar-plug action profile
//  3D print orientation: collar on build plate / nose facing up
// ============================================================

// --- Main dimensions ---
head_length   = 34;   // mm, nose to skirt collar – shorter/stubbier for cedar-plug action
max_diameter  = 24;   // mm, widest point

// --- Derived ---
rx = head_length / 2;          // X half-axis (fore-aft)
ry = max_diameter / 2;         // Y/Z half-axis (radial)

// --- Nose face (flat/cupped dish – cedar plug water-catch) ---
face_d        = 16.0;           // mm, diameter of flat face cutout
face_depth    = 3.0;            // mm, depth of the dish

// --- Bore (line-through hole) ---
bore_d        = 2.0;            // mm, center hole for leader/cable
bore_z_offset = 1.5;            // mm, upward offset of bore exit at nose (tows nose-down for action)

// --- Eye sockets ---
eye_d         = 12;             // mm, eye recess diameter
eye_depth     = 1.8;            // mm, recess depth
eye_x_offset  = 2;              // mm, forward of centre
eye_y_offset  = ry + 1.0;       // start outside the head surface so the cut enters cleanly – no flap

// --- Chin slot ---
chin_w        = 16;             // mm, width of horizontal oval mouth – widened for more action
chin_h        = 4.5;            // mm, height of oval mouth (flatter = more aggressive)
chin_x        = -rx + 1.5;      // mm, position along X – moved to nose for cedar-plug dart
chin_z        = -(ry * 0.78);   // mm, position on underside (lower)

// --- Skirt collar (rear cylinder) ---
collar_d      = 15;             // mm, outer diameter
collar_bore_d = 14;             // mm, inner bore diameter – hollow to accept skirt sleeve
collar_len    = 24;             // mm, shorter collar – less stabilisation, more head swing
collar_x      = rx + collar_len / 2 - 4;  // tucks 4mm into head for smooth blend

// --- Head-to-collar blend ---
blend_d       = 21.0;          // mm, rear shoulder sphere diameter – proud hump where body meets collar

// --- Skirt flair (exposed collar) ---
// Exposed collar runs from shoulder rear edge (~x=30) to collar tail (~x=49), ~19mm
// A cone ramps up from collar_d to flair_od over the first half, then holds flair_od to the tail
flair_od      = 18.0;          // mm, flared outer diameter at the wide end
flair_start_x = rx + blend_d/2 + 0.5;          // just behind the shoulder hump
flair_mid_x   = flair_start_x + 9.5;           // halfway point – where ramp peaks
flair_end_x   = rx + collar_len - 4;            // tail end of collar

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
// Collar sits on the build plate (Z=0), nose faces up (+Z).
// rotate([0,90,0]) maps -X(nose)→+Z and +X(collar)→-Z;
// translate +47 in Z brings the collar end back to Z=0.
translate([0, 0, rx + collar_len - 4])
rotate([0, 90, 0])
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

        // Skirt flair – cone ramps from collar_d up to flair_od at the midpoint,
        // then a cylinder holds that diameter to the tail end
        // Ramp section: collar_d at flair_start_x → flair_od at flair_mid_x
        hull() {
            translate([flair_start_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = collar_d, h = 0.1, center = true, $fn = 60);
            translate([flair_mid_x, 0, 0])
                rotate([0, 90, 0])
                    cylinder(d = flair_od, h = 0.1, center = true, $fn = 60);
        }
        // Flat section: flair_od cylinder from midpoint to tail
        translate([(flair_mid_x + flair_end_x) / 2, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = flair_od, h = flair_end_x - flair_mid_x, center = true, $fn = 60);
    }

    // --- Center bore (nose to tail) – offset upward at nose so lure tows nose-down ---
    // Nose endpoint pushed forward past the dish depth so the hole breaks cleanly
    // through the face cutout and is not blocked by the dish floor.
    hull() {
        translate([-rx - face_depth - 0.1, 0, bore_z_offset])
            rotate([0, 90, 0])
                cylinder(d = bore_d, h = 0.1, $fn = 30);
        translate([rx + collar_len - 4, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = bore_d, h = 0.1, $fn = 30);
    }

    // --- Nose bore stub – straight axial segment bridging the dish floor to the angled bore ---
    // The angled bore is offset upward (bore_z_offset) so its entry clips the dish off-centre;
    // this short straight cylinder (Z=0, centred in the dish) closes the gap and ensures the
    // leader sleeve has a clean, uninterrupted tunnel from the nose face into the head.
    translate([-rx - face_depth - 0.1, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = bore_d, h = face_depth + bore_z_offset + 2, $fn = 30);

    // --- Nose face – flat dish cutout for cedar-plug water-catch action ---
    translate([-rx - 0.1, 0, 0])
        rotate([0, -90, 0])
            cylinder(d = face_d, h = face_depth + 0.1, $fn = 60);

    // --- Skirt collar bore (hollow interior for skirt sleeve) ---
    // Extended 6mm deeper into the head (starts at rx-6 instead of rx);
    // jet exits are at x≈8, collar bore now starts at x≈11 – 3mm clear.
    translate([rx - 6, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = collar_bore_d, h = collar_len + 6, $fn = 60);

    // --- Eye socket – starboard (right, +Y side) ---
    translate([eye_x_offset, eye_y_offset, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Eye socket – port (left, -Y side) ---
    translate([eye_x_offset, -eye_y_offset, 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 0.5, $fn = 80);

    // --- Chin slot (steepened to 45° for cedar-plug dart/yaw action) ---
    translate([chin_x, 0, chin_z])
        rotate([0, 45, 0])                 // steeper face = more action/smoke
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
