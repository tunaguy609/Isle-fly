// ============================================================
//  Blue Eye Konahead Trolling Lure Head
//  42mm long x 23mm max diameter
//  3D print orientation: skirt collar flat end down / nose pointing up
//
//  Swim action features:
//    - Concave cupped nose face: deflects water to create zig-zag wobble
//    - Leader bore angled: enters nose offset +2 mm above centre, exits collar centreline
// ============================================================

// --- Main dimensions ---
head_length   = 42;   // mm, nose to skirt collar
max_diameter  = 23;   // mm, widest point

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
eye_d         = 8;               // mm, eye seat diameter (to hold eye insert)
eye_depth     = 1.2;             // mm, shallow seat depth
eye_x_offset  = 2;               // mm, forward of centre


// --- Chin slot ---
chin_w        = 10;             // mm, width of horizontal oval mouth
chin_h        = 4.5;            // mm, height of oval mouth (flatter = more aggressive)
chin_x        = -rx + 3.5;      // mm, position along X from centre (further forward)
chin_z        = -(ry * 0.50);   // mm, position on underside (flush with belly surface)

// --- Jets ---
jet_d         = 2.4;            // mm, jet tunnel diameter
// Entry: positioned to intersect the chin slot opening on the belly
jet_entry_x   = chin_x + 1.0;  // mm, near the front of the chin slot
jet_entry_z   = chin_z;         // mm, at the belly surface (inside chin slot cut)
jet_entry_y   = 1.8;            // mm, offset either side of centreline
// Exit: breaks through the crown behind the eyes
jet_exit_x    = eye_x_offset + 5.0;  // mm, behind eyes toward tail
jet_exit_z    = ry + 0.5;            // mm, above crown surface to ensure clean exit hole
jet_exit_y    = 1.2;                 // mm, close to centreline at crown

// --- Skirt collar (rear cylinder) ---
collar_d        = 15;             // mm, outer diameter
collar_bore_d   = 14;             // mm, inner (bore) diameter – hollow to accept skirt sleeve
collar_len      = 32;             // mm – restored full length
collar_x        = rx + collar_len / 2 - 4;  // tucks 4mm into head for smoother blend
collar_blend_x  = rx - 3.0;      // mm, blend starts slightly inside the head
collar_blend_d  = 18.0;          // mm, wider blend diameter to merge collar into head

// --- Skirt retaining lip (at tail end of collar) ---
// A wider flange ring at the tail end – skirt slides over collar and butts against lip
lip_w           = 2.0;           // mm, axial width of flange ring
lip_od          = 18.0;          // mm, outer diameter of flange (wider than collar)


// ============================================================
//  Assembly  –  rotated so skirt collar is flat on the build plate
// ============================================================
rotate([0, -90, 0])
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
        // Skirt retaining lip – wider flange ring at the tail end of the collar
        // Skirt slides over the collar body and butts up against this flange
        translate([rx + collar_len - 4, 0, 0])
            rotate([0, 90, 0])
                cylinder(d = lip_od, h = lip_w, $fn = 60);
    }

    // --- Leader bore: angled from nose entry to collar centreline exit ---
    // Enters at nose tip (z = +bore_z_offset) and exits at the tail end of the
    // collar on the centreline (z = 0), so the leader runs straight through centre.
    hull() {
        translate([-rx, 0, bore_z_offset])
            sphere(d = bore_d, $fn = 30);
        translate([rx + collar_len - 4, 0, 0])
            sphere(d = bore_d, $fn = 30);
    }

    // --- Skirt collar bore (hollow interior for skirt sleeve) ---
    // Starts at the rear face of the head and runs out the tail end of the collar.
    translate([rx, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = collar_bore_d, h = collar_len, $fn = 60);

    // --- Concave cupped nose face (creates zig-zag wobble action) ---
    translate([nose_x - cup_r + cup_depth, 0, 0])
        sphere(r = cup_r, $fn = 80);

    // --- Eye seat – starboard: shallow recess directly in head surface ---
    translate([eye_x_offset, ry + 1, 0])
        rotate([90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 2.0, $fn = 80);

    // --- Eye seat – port ---
    translate([eye_x_offset, -(ry + 1), 0])
        rotate([-90, 0, 0])
            cylinder(d = eye_d, h = eye_depth + 2.0, $fn = 80);


    // --- Chin slot (aggressive horizontal oval mouth) ---
    translate([chin_x, 0, chin_z])
        rotate([0, 30, 0])                 // steeper face = more action/smoke
            scale([chin_w/chin_h, 1, 1])   // horizontal oval
                cylinder(d = chin_h, h = ry * 1.0, $fn = 72);

    // --- Twin jet tunnels: rise from chin slot base to crown exits behind eyes ---
    // Starboard jet
    hull() {
        translate([jet_entry_x,  jet_entry_y, jet_entry_z])
            sphere(d = jet_d, $fn = 36);
        translate([jet_exit_x,   jet_exit_y,  jet_exit_z])
            sphere(d = jet_d, $fn = 36);
    }
    // Port jet
    hull() {
        translate([jet_entry_x, -jet_entry_y, jet_entry_z])
            sphere(d = jet_d, $fn = 36);
        translate([jet_exit_x,  -jet_exit_y,  jet_exit_z])
            sphere(d = jet_d, $fn = 36);
    }


}
