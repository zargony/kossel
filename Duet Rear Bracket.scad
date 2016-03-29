// Kossel rear mounting bracket for Duet board
// https://github.com/zargony/kossel-hacks

// Width of extrusions (usually 15 or 20)
extrusion_width = 20;
// Distance of board (aka length of mounting bracket)
board_distance = 55;
// Height of board from upper edge of extrusion
// (0 = same height as upper edge of extrusion)
additional_height = 3.5;
// Width of mounting bracket
mount_width = 40;
// Thickness of bracket
thickness = 3;

hull() {
    translate([board_distance, 0, 0])
        cylinder(h=thickness, r=thickness+1);
    translate([0, -mount_width/2, 0])
        cube([thickness, mount_width, thickness]);
}

translate([board_distance, 0, 0]) {
    stand_height = extrusion_width + additional_height;
    hole_depth = 10;
    difference() {
        cylinder(h=stand_height, r=thickness+1, $fn=100);
        translate([0, 0, stand_height-hole_depth])
            cylinder(h=hole_depth+0.1, r=1, $fn=50);
    }
}

difference() {
    translate([0, -mount_width/2, 0])
        cube([thickness, mount_width, extrusion_width]);
    translate([-0.1, -mount_width/2+5, extrusion_width/2])
        rotate([0, 90, 0])
            cylinder(h=thickness+0.2, r=2, $fn=50);
    translate([-0.1, mount_width/2-5, extrusion_width/2])
        rotate([0, 90, 0])
            cylinder(h=thickness+0.2, r=2, $fn=50);
}

translate([thickness, -thickness/2, 0])
    cube([board_distance-2*thickness, thickness, extrusion_width-2]);
