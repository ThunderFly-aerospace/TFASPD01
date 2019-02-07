$fn=40; // model faces resolution.
include <../configuration.scad>

//Držák na konektor RJ11

module fins(outer_r, inner_r, wall, height, count, angle) {
    for (i = [1 : count]) {
        rotate([0, 0, i * 360/count])
        translate([-wall / 2, inner_r, 0])
        difference () {
            cube([wall, outer_r - inner_r, height]);
          
            color("red")
            translate([-1, 0, height])
            rotate([-angle, 0, 0])
            cube([wall + 2, (outer_r - inner_r) + height, height]);
        }
    }
    inner_points = [ for (i = [0 : count - 1]) [sin(i * 360/count) * (outer_r) , cos(i * 360/count) * (outer_r)]];
    // calculate coordinates of external fins polygon
    vertex_angle = (180*(count-2)) / count;   // angle in external fins polygon corner.
    outer_points = [ for (i = [0 : count - 1]) [sin(i * 360/count) * (outer_r + wall/sin(vertex_angle/2)) , cos(i * 360/count) * (outer_r + wall/sin(vertex_angle/2))]];
    polygon_paths = [ [ for (i = [0 : count-1]) i ], [ for (i = [count : 2*count-1]) i ]];


    echo("outer points = ", outer_points);
    echo("inner points = ", inner_points);
    echo("paths = ", polygon_paths);
    echo("vertex_angle = ", vertex_angle);
    
    linear_extrude(height = height - (tan(angle)*(outer_r - inner_r)))
        polygon(
            points =  concat(outer_points, inner_points),
            paths = polygon_paths
        );
}


module WINDGAUGE01A_S03()
{

wall_thickness = 1.2; 
D = 25;  // venturi tube base diameter
D_Diaphragm = D/2;
connection_tube_diameter =  4;

    difference()
    {
        
        cylinder (h = 5*D, d = D + 2*wall_thickness, $fn=100); 

        translate([0,0,0])
            cylinder (h = 6*D, d = D_Diaphragm , $fn=100); 

        translate([0,0,0])
            cylinder (h = 3*D, d1 = D , d2 = D_Diaphragm , $fn=100); 

        translate([0,0,3*D + D_Diaphragm])
            cylinder (h = D, d1 = D_Diaphragm , d2 = D , $fn=100); 

        translate([0,0,3*D + D_Diaphragm + D])
            cylinder (h = 2*D,d = D , $fn=100); 

        translate([0,0,3*D + D_Diaphragm/2])
            rotate([90,0,0])
                cylinder (h = 2*D, d = connection_tube_diameter , $fn=100); 

        translate([0,0,3*D + D_Diaphragm + D + D_Diaphragm /2 ])
            rotate([90,0,0])
                cylinder (h = 2*D, d = connection_tube_diameter , $fn=100); 

            
    }

    fins(2*D, D/2, wall_thickness, 20, 6, 16);
}

   

  
WINDGAUGE01A_S03(); 
