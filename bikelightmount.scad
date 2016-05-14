/* [General] */

// height in mm
HEIGHT = 16.;               // [5:40]

// thickness of thinest part of the wall in mm
WALL_THICKNESS = 1.;        // [0.2:10]

// diameter of the seat tube in mm
SEAT_TUBE_DIAMETER = 26.5;   // [20:40]

// angle of your seat tube to mount the light horizontal (in degrees)
SEAT_TUBE_ANGLE = 10.;      // [0:45]


/* [Front - light] */

// TODO
LIGHT_DIST = 4.3;   // [0:28]

// TODO
LIGHTSCREW_DIAMETER = 5.2;   // [1:18]

// diameter of head of screw, which is screwed to light (in mm)
LIGHTSCREW_HEAD_DIAMETER = 9.5;   // [1:18]

// height of head of screw for light (in mm)
LIGHTSCREW_INSET = 2.3;   // [0:12]

// diameter of bottom of light (in mm), other version with 8.8mm
LIGHTDIAMETER = 10.75;    // [1:25]

// height of bottom of light (in mm)
LIGHT_INSET = 2.7;        // [0:12]


/* [Back - screws and nuts] */

// gap, used for tightening with screws (in mm)
GAP = 9.;                 // [2:15]

// with of backside of bike light mount (in mm)
GAPBOX_WIDTH = HEIGHT;

// distance
SCREW_DIST = 4.6;          // [1:15]

// how much screw holes are moved up and down from center (in mm)
SCREW_Z_OFFSET = 0.25 * HEIGHT;   // [0:15]

// TODO
SCREW_DIAMETER = 3.2;       // [1:8]

// TODO
SCREW_HEAD_DIAMETER = 6.3;   // [1:12]

// TODO
SCREW_HEAD_INSET = 2.8;      // [1:12]

// diameter of nut in mm (about 6mm for M3)
NUT_DIAMETER = 6.3;          // [1:12]

// height of nut in mm (usually about 2mm for M3)
NUT_INSET = 2.8;             // [1:12]



/* [Hidden] */

$fn=200;


bikelight_mount();
%seattube();  // will not be printed



/**
 * Bike light mount. This is what you want to print.
 */
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


/**
 * Screw for mounting the light (screwed in light). Object used subtracting,
 * i.e. making the hole for the screw.
 */
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


/**
 * Screws and nuts.
 */
module screws() {
    screw();
    mirror([0., 0., 1.])
        screw();
}


module screw() {
    translate([0.,
            SCREW_DIST/2. + SEAT_TUBE_DIAMETER/2.,
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