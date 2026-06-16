// --- ANIMATION PARAMETERS ---
// Go to: View -> Animate. Set FPS to 30, Steps to 100 or 200.

$fn = 40; 

// Base gear properties (The Cutter)
teeth = 12;
modulus = 2;
thickness = 6;
bore = 4;

// Orbital properties
orbital_radius = 36; // Lowered to 36 so the gears actually intersect!
orbit_speed = 1;     
spin_speed = 4;      // Must be mathematically proportional to generate real teeth

// --- GENERATIVE SCULPTING EXECUTION ---

// 1. The Sculpted Sun Cylinder
color("red")
difference() {
    // The blank cylinder we want to carve
    cylinder(d=58, h=thickness, center=true);
    
    // We loop from 0 to the current animation time ($t)
    // "steps = 150" controls how smooth/dense the cut cuts are.
    let(steps = 150)
    for (step = [0 : steps * $t]) {
        let(progress = step / steps) // Simulated time from 0.0 to $t
        
        // Place a destructive cutter gear at this historical frame
        planetary_gear_position(orbital_radius, orbit_speed, spin_speed, progress) {
            // We scale the cutter up by 1.02 just to add a tiny bit of backlash clearance
            scale([1.02, 1.02, 1.1]) 
            gear(teeth, modulus, thickness, bore, 0, thickness);
        }
    }
}

// 2. The Visual Planet Gear (The one you see moving in real-time)
planetary_gear_position(orbital_radius, orbit_speed, spin_speed, $t) {
    gear(teeth, modulus, thickness, bore, 10, thickness);
}


// --- POSITIONING MODULE ---
// Replaced $t with a custom 'time_val' variable so we can loop through history
module planetary_gear_position(radius, o_speed, s_speed, time_val) {
    rotate([0, 0, time_val * 360 * o_speed]) 
    translate([radius, 0, 0]) 
    rotate([0, 0, time_val * 360 * s_speed]) 
    children(); 
}

// --- BASE GEAR MODULES ---
module gear(num_teeth, mod, thick, bore, hub_dia, hub_thick) {
    pitch_dia = num_teeth * mod;
    root_dia = pitch_dia - (2.5 * mod);
    
    color("LightSeaGreen")
    difference() {
        union() {
            cylinder(d = root_dia, h = thick, center = true);
            for (i = [0 : num_teeth - 1]) {
                rotate([0, 0, i * (360 / num_teeth)])
                translate([pitch_dia / 2, 0, 0])
                tooth(mod, thick);
            }
            if (hub_dia > bore) {
                cylinder(d = hub_dia, h = hub_thick, center = true);
            }
        }
        if (bore > 0) cylinder(d = bore, h = max(thick, hub_thick) + 2, center = true);
    }
}

module tooth(mod, thick) {
    pitch_width = mod * 1.57; 
    outer_width = mod * 0.8;
    height = mod * 2.25;
    
    translate([-height/2, 0, -thick/2])
    linear_extrude(height = thick)
    polygon(points = [[0, -pitch_width/1.2], [height * 0.6, -pitch_width/2], [height, -outer_width/2], [height, outer_width/2], [height * 0.6, pitch_width/2], [0, pitch_width/1.2]]);
}