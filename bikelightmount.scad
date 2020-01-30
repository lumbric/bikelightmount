/* Bike light mount
 *
 * https://github.com/lumbric/bikelightmount
 * http://www.thingiverse.com/thing:1566371
 *
 * This is a costumizeable bike light holder inspired by the
 * [31.6mm bike light holder](http://www.thingiverse.com/thing:1487051). My
 * seat tube is too thin, so I redesigned it in OpenScad and made it
 * costumizeable.
 *
 * You need:
 *   - 2 M3 nuts
 *   - 2 screws, ~16-20mm lenght
 *   - aluminum LED bike light
 *
 * These aluminum LED bike lights are very wide spread and very cheap. Just
 * search on ebay or aliexpress. They are powered by 2x CR2032 batteries
 * lasting for quite a while if you use them in flashing mode. They are also
 * bright enough for the rear light, but I would not recommend them for your
 * front light. Note that sizes very a bit, you might need to adapt the
 * parameters LIGHTDIAMETER.
 *
 * This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
 * International License. To view a copy of this license, visit
 * http://creativecommons.org/licenses/by-sa/4.0/.
 *
 */

/* [General] */


BIKELIGHT_DIAMETER = 25.5;
BIKELIGHT_LENGTH= 33;

NECK_DIAMETER = 11;
NECK_LENGTH = 2.5;

BOTTOM_DIAMETER = 16.5;
BOTTOM_LENGTH = 1.2;

BIKELIGHT_OFFSET = 2.9;

// height in mm
HEIGHT = BIKELIGHT_DIAMETER;               // [5:40]

// how much gap additional to calculate
WALL_DELTA = 0.3;

// thickness of thinest part of the wall in mm
WALL_THICKNESS = 1.0;        // [0.2:10]

// diameter of the seat tube in mm
SEAT_TUBE_DIAMETER = 25.1;   // [20:40]

// angle of your seat tube to mount the light horizontal (in degrees)
SEAT_TUBE_ANGLE = 1.;      // [0:45]



/* [Back - screws and nuts] */

// gap, used for tightening with screws (in mm)
GAP = 2.;                 // [2:15]


// diameter of screws used to fix bikelightmount (in mm)
SCREW_DIAMETER = 2.;       // [1:8]

// diameter of head of both screws used to fix bikelightmount (in mm)
SCREW_HEAD_DIAMETER = 4.;   // [1:12]

// height of screw head (in mm), use less than SCREW_HEAD_INSET <= (GAPBOX_WIDTH - GAP)/2. - WALL_THICKNESS
SCREW_HEAD_INSET = 2.;      // [1:12]



/* [Hidden] */


// thickness of wall separating light and screw head
wall_thickness_lightscrew = WALL_THICKNESS;


$fn=150;



bikelight_mount();
//%seattube();  // will not be printed
%bikelight();
//screws();


module screws() {
    screw();
    //mirror([0., 0., 1.]) {
        //screw();
    //}
}

module screw() {
    rotate([0., 90., 0.]) {
        translate([HEIGHT * 0.23 , 0.7 -SEAT_TUBE_DIAMETER/2. - BIKELIGHT_OFFSET/2. - WALL_THICKNESS/2., 0.]) {
            translate([0., 0.,  -0.6*SEAT_TUBE_DIAMETER])
                cylinder(d=SCREW_DIAMETER, h=SEAT_TUBE_DIAMETER);
            translate([0., 0.,  -1.4 * SEAT_TUBE_DIAMETER])
                cylinder(d=SCREW_HEAD_DIAMETER, h=SEAT_TUBE_DIAMETER);
        }
    }
}


/**
 * Bike light mount. This is what you want to print.
 */
module bikelight_mount() {
    difference() {
        base();
        seattube();

        bikelight(delta=WALL_DELTA);
        gap();
        screws();
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

        translate([0., -SEAT_TUBE_DIAMETER/2. - BIKELIGHT_OFFSET, 0.])
            rotate([90., 0., 0.])
                cylinder(d=0.95* BIKELIGHT_DIAMETER, h=BIKELIGHT_OFFSET + WALL_THICKNESS);
    }
}


module gap() {
    translate([0., -SEAT_TUBE_DIAMETER, 0.])
        cube([GAP, SEAT_TUBE_DIAMETER*2, 2*HEIGHT], center=true);
}


module bikelight(delta=0.) {
    // not meant to be printed, just for nicer visualisation
    translate([0., -SEAT_TUBE_DIAMETER/2. - BIKELIGHT_OFFSET, 0.]) {
        rotate([0., 90., -90.]) {
            translate([0., 0., -delta])
                cylinder(d=BOTTOM_DIAMETER + 2*delta, h=BOTTOM_LENGTH + 2*delta);
            translate([0., 0., BOTTOM_LENGTH+delta - BOTTOM_LENGTH/2.])
                cylinder(d=NECK_DIAMETER + 2*delta, h=2*NECK_LENGTH - BOTTOM_LENGTH/2. + 2*delta);
            translate([0., 0., BOTTOM_LENGTH + NECK_LENGTH - delta])
                cylinder(d=BIKELIGHT_DIAMETER + 2*delta, h=BIKELIGHT_LENGTH);
        }
    }
}


module seattube() {
    rotate([SEAT_TUBE_ANGLE, 0., 0.])
        translate([0., 0., -HEIGHT])
            cylinder(h=10*HEIGHT, d=SEAT_TUBE_DIAMETER, center=true);
}


