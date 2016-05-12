HEIGHT = 16;
WALL_THICKNESS = 2;

SEAT_TUBE_DIAMETER = 26;
SEAT_TUBE_ANGLE = 10.;

GAP = 5;
GAPBOX_WIDTH = HEIGHT;
SCREW_DIST = 5;
LIGHT_DIST = 3;

LIGHTSCREW_DIAMETER = 5;
LIGHTSCREW_HEAD_DIAMETER = 9;
LIGHTSCREW_INSET = 2.;

LIGHTDIAMETER = 10.7;
LIGHT_INSET = 1.5;

SCREW_Z_OFFSET = 0.25 * HEIGHT;
SCREW_DIAMETER = 3;
SCREW_HEAD_DIAMETER = 4;
SCREW_HEAD_INSET = 3;
NUT_DIAMETER = 6;
NUT_INSET = 2.5;

$fn=100;

bikelight_mount();


module bikelight_mount() {
    difference() {
        base();
        seattube();
        gap();

        screws();
        lightscrew();
    }
}


/**
 * Base object. Need to cut out holes for screws and seat tube and gap.
 */
module base() {
    hull() {
        intersection() {
            outer_diameter = 3*SEAT_TUBE_DIAMETER;
            cube([outer_diameter, outer_diameter, HEIGHT], center=true);

            rotate([SEAT_TUBE_ANGLE, 0., 0.])
                cylinder(h=10*HEIGHT,
                        d=SEAT_TUBE_DIAMETER + 2*WALL_THICKNESS,
                        center=true);
        }
        translate([0., WALL_THICKNESS + SEAT_TUBE_DIAMETER/2., 0.])
            cube([HEIGHT, 2*SCREW_DIST, HEIGHT], center=true);

        translate([0., -WALL_THICKNESS -SEAT_TUBE_DIAMETER/2., 0.])
            cube([GAPBOX_WIDTH, 2*LIGHT_DIST, HEIGHT], center=true);
    }
}


module lightscrew() {
    translate([0., -WALL_THICKNESS-LIGHT_DIST-SEAT_TUBE_DIAMETER/2., 0.])
        rotate([90., 0., 0.])
            cylinder(d=LIGHTDIAMETER, h=2*LIGHT_INSET, center=true);
    translate([0., -SEAT_TUBE_DIAMETER/2., 0.])
        rotate([90., 0., 0.])
            cylinder(d=LIGHTSCREW_HEAD_DIAMETER, h=2*LIGHTSCREW_INSET, center=true);
    translate([0., -SEAT_TUBE_DIAMETER/2., 0.])
        rotate([90., 0., 0.])
            cylinder(d=LIGHTSCREW_DIAMETER, h=SEAT_TUBE_DIAMETER, center=true);
}


module gap() {
    translate([0., SEAT_TUBE_DIAMETER/2., 0.])
        cube([GAP, SEAT_TUBE_DIAMETER, 3*HEIGHT], center=true);
}


module seattube() {
    rotate([SEAT_TUBE_ANGLE, 0., 0.])
        translate([0., 0., -HEIGHT])
            cylinder(h=10*HEIGHT, d=SEAT_TUBE_DIAMETER, center=true);
}


module screws() {
    screw();
    mirror([0., 0., 1.])
        screw();
}


module screw() {
    translate([0.,
            WALL_THICKNESS/2. + SCREW_DIST/2. + SEAT_TUBE_DIAMETER/2.,
            SCREW_Z_OFFSET]) {
        rotate([0., 90., 0.])
            cylinder(d=SCREW_DIAMETER, h=SEAT_TUBE_DIAMETER, center=true);

        translate([GAPBOX_WIDTH/2. + SCREW_HEAD_INSET, 0., 0.])
            rotate([0., 90., 0.])
                cylinder(d=SCREW_HEAD_DIAMETER, h=2*SCREW_HEAD_INSET, center=true);

        translate([-(GAPBOX_WIDTH/2. + NUT_INSET), 0., 0.])
            rotate([0., 90., 0.])
                cylinder(d=NUT_DIAMETER, h=2*NUT_INSET, center=true, $fn=6);
    }
}
