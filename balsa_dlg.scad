
use <tail_mount.scad>

show_whole_plane = 1;
show_left_wing_plan = 2;
show_right_wing_plan = 3;
show_tailplane_plan = 4;
show_fuselage_top_plan = 5;
show_fuselage_side_plan = 6;
show_wing_bracket = 7;
show_tail_mount = 8;
show_fuselage_shell = 9;

show_fin_plan = 5;

show_measurement = false;
square_fuselage = true;

show_mode = show_whole_plane;

module forward_mark()
{
   rotate([0,90,0]){
      cylinder (d1 = 1, d2 = 10, h= 10);
   }
}

module rear_mark()
{
   translate([-10,0,0]){
      rotate([0,90,0]){
         cylinder (d1 = 10, d2 = 1, h= 10);
      }
   }
}

/*
aileron root = 30 %
aileron tip = 25 %
*/
flap_angle = 0;

module right_wing_blank()
{
  import("thin_wing.stl");
}

module right_aileron()
{
  intersection(){
    right_wing_blank();
    translate([70.5,15,-3]){
         cube([100,460,8]);
    }
   }
}

module left_aileron()
{
   mirror([0,1,0]){
      right_aileron();
   }
}

module right_wing_front()
{
  difference(){
    right_wing_blank();
    translate([69.5,-1,-3]){
         cube([100,452,8]);
    }
   }
}

module left_wing_front(){
     mirror([0,1,0]){
      right_wing_front();
   }
}


module right_wing(){
  rotate([4,0,0]){
  right_wing_front();
translate([70,0,0]){
rotate([0,flap_angle,0]){
translate([-70,0,0]){
right_aileron();
}
}
}
  }
}

module left_wing()
{
   mirror([0,1,0]){
      right_wing();
   }
}

module wing(){
  translate ([0,-0.1,0]){
   right_wing();
  }
  translate ([0,0.1,0]){
   left_wing();
  }
}

module wing_blank()
{
   translate([0,-0.1,0]){
   rotate([4,0,0]){
     right_wing_blank();
   }
   }

    translate([0,0.1,0]){
   mirror([0,1,0]){
   rotate([4,0,0]){
     right_wing_blank();
   }
   }
   }
   
}

module right_tailplane(){
   scale([1,1.2,1]){
      rotate([0,0,0]){
         import("tail.stl");
      }
   }
}

module left_tailplane()
{
   mirror([0,1,0]){
      right_tailplane();
   }
}

module tailplane(){
   right_tailplane();
   left_tailplane();
}

module fin()
{
   rotate([90,0,0]){
      scale([1,0.6,1]){
         tailplane();
      }
   }
}


fuselage_width_ratio = 0.6;
fuselage_height_ratio = 0.6;

fuselage_scale_x = 4.5;
fuselage_circle_d = 50;

fuselage_pod_pts = [
   [0,fuselage_circle_d/2 * fuselage_height_ratio],
   [150,3],
   [150,-3],
   [0,-fuselage_circle_d/2* fuselage_height_ratio ]
];

//pylon_pts = [
//      [75,25],
//      [135,22],
//      [135,5],
//      [75,5]
//   ];

module fuselage_pod_shell()
{
   intersection(){
      translate([0,0,-25]){
         linear_extrude( height= 50, convexity = 10){
            hull(){
            scale([fuselage_scale_x,fuselage_width_ratio]){
               circle(d = fuselage_circle_d, $fn = 50);
            }
            translate([152,-2]){
               square([1,4]);
            }
            }
         }
      }
      translate([0,25,0]){
         rotate([90,0,0]){
            linear_extrude( height= 50,convexity = 10){

               hull(){
                  scale([fuselage_scale_x,fuselage_height_ratio]){
                     circle(d = fuselage_circle_d, $fn = 50);
                  }
                  polygon(fuselage_pod_pts);
               }
            }
         }
      }
   }
}

module fuselage_pod_shell1(){

intersection(){
fuselage_pod_shell_in_pos();
rotate([45,0,0]){
scale([1,1.25,1.25]){
fuselage_pod_shell_in_pos();
}
}


rotate([22.5,0,0]){
scale([1,1.19,1.19]){
fuselage_pod_shell_in_pos();
}
}

rotate([-22.5,0,0]){
scale([1,1.19,1.19]){
fuselage_pod_shell_in_pos();
}
}
}
}

module fuselage_pod_shape(){
   hull(){
      scale([fuselage_scale_x,fuselage_height_ratio]){
         circle(d = fuselage_circle_d, $fn = 50);
      }
      polygon(fuselage_pod_pts);
   }
      //   polygon(pylon_pts);
}

module fuselage_pod()
{
   width = 4.5;

   translate([0,width/2,0]){
      rotate([90,0,0]){
         linear_extrude( height= width){
            fuselage_pod_shape();
         }
      }
   }
}

module battery()
{
  // cube([79,7,19], center = true);
color([.2,0.2,0.7]){
   cube([70,13,8], center = true);
}
}

module rcrx()
{
color([.5,0.2,0.3]){
	cube([40,22.5,6],center = true);
}
}

module servo( hornside = false, double_ended = false,rotation = 0)
{
   horn_len = hornside?7:-7;
   horn_other_end = double_ended ? -horn_len: 0;
   color([.3,0.2,0.3]){
      translate([-9,-4,-7.5]){
         cube([18,8,15]);
         translate([-4,0,10]){
           cube([26,8,1]);
         }
         translate([4,4,0]){
           cylinder(r=4, h= 16.8);
           translate([0,0,16.9]){
            cylinder(r= 1.5, h = 2.5);
           }
           rotate([0,0,rotation]){
           hull(){
               translate([0,horn_other_end,18]){
                 cylinder (r = 1.5, h=1);
               }
               translate([0,horn_len,18]){
                 cylinder (r = 1.5, h=1);
               }
           }
           }
         }
      }
   }
}

module servo_hk5320( hornside = false, double_ended = false,rotation = 0){
   horn_len = hornside?7:-7;
   horn_other_end = double_ended ? -horn_len: 0;
   color([.3,0.4,0.3]){
   translate([-6.75,-3.0,-8]){
     cube([13.5,6.0,16]);
     translate([-3.25,0,10.2]){
       cube([20,6,0.8]);
     }
     translate([3.25,3,0]){
      cylinder ( d=4.25,h=20.5);
      rotate([0,0,rotation]){
           hull(){
               translate([0,horn_other_end,19]){
                 cylinder (r = 1.5, h=1);
               }
               translate([0,horn_len,19]){
                 cylinder (r = 1.5, h=1);
               }
           }
           }
     }
   }
}
}


module tail_boom_in_pos(){
translate([22,0,0]){
rotate([0,90,0]){
   cylinder(d = 4, h = 403, $fn = 20);
}
}
}


module wing_in_pos(){
   translate([0,0,6]){
      rotate([0,2,0]){
         wing();
      }
   }
}
module wing_blank_in_pos()
{
   translate([0,0,6]){
      rotate([0,2,0]){
         wing_blank();
      }
   }
}

module tailplane_in_pos(){
   translate([350,0,-11]){
     tailplane();
   }
}

module fin_in_pos(){
   translate([410,0,0]){
      fin();
   }
}

module tailmount_in_pos()
{
   translate([374,0,0]){
      rotate([0,180,0]){
      tail_mount();
      }
   }
}

module fuselage_pod_in_pos()
{
   translate ([-50,0,0]){
      fuselage_pod();
   // fuselage_pod_shell();
   }
}

module fuselage_pod_shell_in_pos()
{
   translate ([-50,0,0]){
   // fuselage_pod();
    fuselage_pod_shell();
   }
}
module fuselage_pod_shell_in_pos_stl(){
import("fuselage_skin.stl");
}
module left_aileron_servo_in_pos()
{
 translate([-45,0,0]){
    rotate([0,180,0]){
    rotate([0,-90,90]){
      servo(true,false,90);
   }
   }
 }
}
module right_aileron_servo_in_pos()
{
 translate([-36,0,0]){
    rotate([0,90,90]){
      servo(true,false, 90);
    }
 }
}

module rudder_servo_in_pos()
{
 translate([-21,0,0]){
 rotate([0,-90,-90]){
      servo_hk5320(false,true,90);
 }
 }
}
module elevator_servo_in_pos()
{
 translate([-28,0,0]){
   rotate([0,-90,90]){
      servo_hk5320(false,true,90);
   }
 }
}

module wing_bracket_dowels_in_pos()
{
   translate ([60,12,6.25]){
      rotate([0,94,0]){
         cylinder (d = 2,h= 16,$fn = 20);
      }
   }
 translate ([60,-12,6.25]){
      rotate([0,94,0]){
         cylinder (d = 2,h= 16,$fn = 20);
      }
   }
}

module wing_bracket_in_pos()
{
if(1){
   translate([70,0,0]){
      rotate([0,90,0]){
         import("wing_tail_bracket.stl");
     }
  }
}else{
difference(){
   union(){
      hull(){
         intersection(){
            wing_blank_in_pos();
               translate([70,-5,0]){

               cube([30,10,10]);
            }
         }

         translate ([70,-2.5,0]){
              cube([30,5,1]);
//            rotate([0,90,0]){
//               cylinder (d = 5.5,h = 30, $fn = 20);
//            }
         }
      }

      intersection(){
         wing_blank_in_pos();
            translate([70,-14,0]){

            cube([30,28,10]);
         }
      }
   }
   union(){
   //tail_boom_in_pos();
 translate ([69,0,0]){
            rotate([0,90,0]){
               cylinder (d = 4.4,h = 32, $fn = 20);
            }
         }
   wing_bracket_dowels_in_pos();
//   translate ([60,12.5,6.5]){
//      rotate([0,95,0]){
//         cylinder (d = 2,h= 16,$fn = 20);
//      }
//   }
// translate ([60,-12.5,6.5]){
//      rotate([0,95,0]){
//         cylinder (d = 2,h= 16,$fn = 20);
//      }
//   }

   }
}
}

}

module mount_bolt(){
   translate ([0,0,-1.5]){
   cylinder (d1= 3, d2 = 6, h = 1.5,$fn = 20);
   }
   translate([0,0,-15.5]){
      cylinder (d = 3, h = 15.1, $fn = 20);
   }
}  

module mount_bolt_in_pos(){
 translate([20,0,12.5]){
   mount_bolt();
 }
}
wing_color = "moccasin";
if (show_mode == show_whole_plane){


color("seashell"){
tailmount_in_pos();
}
//color("yellow"){
fuselage_pod_in_pos();
//}
//color("moccasin"){
//%  scale([1.02,1.1,1.1]){
//fuselage_pod_shell_in_pos_stl();
//}
//}
color("black"){
tail_boom_in_pos();
}
color(wing_color){
tailplane_in_pos();
fin_in_pos();
wing_in_pos();
wing_bracket_in_pos();
}
color("red"){
mount_bolt_in_pos();
}
color("grey"){
wing_bracket_dowels_in_pos();
}

left_aileron_servo_in_pos();
right_aileron_servo_in_pos();
rudder_servo_in_pos();
elevator_servo_in_pos();

translate([-100,6,0]){
  rotate([90,0,0]){
   rcrx();
   }
}

translate([-110,-5,0]){
  rotate([90,0,-3]){
   battery();
   }
}

forward_pos = -381;
rearward_pos = 393;
if (show_measurement){
mark_height = 2;
color("red"){
translate([0,0,mark_height]){
   translate([30 + rearward_pos,0,0]){
      forward_mark();
   } 
   translate([30 - forward_pos,0,0]){
      rear_mark();
   }
}
}
}

}else {
    if (show_mode == show_right_wing_plan){
       projection(){
          right_wing_front();
          right_aileron();
       }
   }else{
      if (show_mode == show_left_wing_plan){
         projection(){
             left_wing_front();
             left_aileron();
         }
      }else{
         if(show_mode == show_tailplane_plan){
            projection(){
               tailplane();
            }
         }else{
            if(show_mode == show_fin_plan){
               projection(){
                  rotate([-90,0,0]){
                     fin();
                  }
               }
            }else{
               if(show_mode == show_fuselage_side_plan){
                  projection(cut = true){
                     rotate([-90,0,0]){
                        difference(){
                        fuselage_pod_in_pos();
                           union(){
                              tail_boom_in_pos();
                              left_aileron_servo_in_pos();
                              right_aileron_servo_in_pos();
                              rudder_servo_in_pos();
                              elevator_servo_in_pos();
                              wing_in_pos();
                              wing_bracket_in_pos();
                           }
                        }
                     }
                  }
               }else{

                  if(show_mode == show_fuselage_top_plan){
                     projection(){
             
                     }
                  }else {
                     if (show_mode == show_wing_bracket){
                        rotate([0,-90,0]){
                           translate([-70,0,0]){
                              wing_bracket_in_pos();
                           }
                        }
                     }else {
                        if (show_mode == show_tail_mount){
                           rotate([0,-90,0]){
                              tail_mount();
                           }
                        }else{
                           if (show_mode == show_fuselage_shell){
                              fuselage_pod_shell_in_pos();
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
}












