
// Code syntax agreement:
// s_... - sizes enumeration
// if we have x-y-z sizes - can be use 'cube' function order of enumeration

// cell size (base constants): 0 - width
s_cell = [25];

// wall base sizes: 0 - thickness 
s_wall = [8.2, 7];

// 0 - thickness
// 1 - length
// 2 - height
s_brick = [10, 8.2, 7];

// tooth base sizes: 0 - width, 1 - thickness, 2 - height
s_tooth = [5, 8.2, 9];

// face size: 0 - thickness
s_face = [1.1];

// face height
face_height = 1.1;

// standart scale for front, top and back sides
face_scale = [0.9, 1.1, 0.75];

// scale for top side of tooths
face_top_scale = [0.9, 1.1, 0.75];

// scale for left, right sides of tooths
face_side_scale = [0.9, 1.12, 1.19];

wall(1);


module crenelated_line(cnt) {
    for(c=[0:cnt-1]) {
       translate([c * s_cell[0],0,0]) tooth(c, cnt);
    }
}


// i - i=0 - inside line, i=1 - top brick line
// b - number of bricks
// totalBricks - total number of bricks
// shift - shift=true - half brick in begin line, shift = false - half brick in end line
// v - faces vector
module setBrick(i = 0, b, totalBricks, shift, v) {
    
    if(i == 0) {
        // inside line
        if(b == 0) {
            // first brick
            if(shift == true) {
                // set half brick
                // calculate first shift from half brick
                brick(6, v+b, 1, face_height);
            } else {
                // set full brick
                color("yellow") brick(6, v+b, 0, face_height);
            }
        } else if(b < (totalBricks-1)) {
            // inside bricks
            brick(7, v+b);
        } else if(b == totalBricks-1) {
            // this is last brick
            if(shift == true) {
                brick(7, v+b);
            } else {
                brick(5, v+b, 0, face_height);
            }
            
        }
        
    } else {
        // top line
        if(b == 0) {
            // first brick
            if(shift == true) {
                brick(2, v+b, 1, face_height);
            } else {
                brick(2, v+b, 0, face_height);
            }
        } else if(b < (totalBricks-1)) {
            // inside bricks
            brick(3, v+b);
        } else if(b == totalBricks-1) {
            // this is last brick
            if(shift == true) {
                brick(1, v+b);
            } else {
                brick(1, v+b, 0, face_height);
            }
        }
    }
}


// thiсkness - 8.2 mm
// line height - 7 mm
// l - number of cells (length)
// i - bottom line if i==0, if i==1 - top line
// from bottom lines we not set face up
// v - initial vector
module wall_line(l, i = 0, v = 0, shift = false) {
    
    bricks = (l * s_cell[0]) / 10;
    
    for(b = [0 : bricks-1]) {
        
        translate([b * s_brick[0],0,0]) {
            
            if(shift == true && b == 0) {
                color("orange") translate([face_height,0,0]) setBrick(i, b, bricks, shift, v);
            } else {
                // correct shift bricks in line
                if(shift == true) {
                    translate([-1*s_brick[0]/2,0,0]) {
                        color("pink") setBrick(i, b, bricks, shift, v);
                    }
                } else {
                    if(b == 0) {
                       color("red") translate([face_height,0,0]) setBrick(i, b, bricks, shift, v);
                    } else {
                       color("lightblue") setBrick(i, b, bricks, shift, v);
                    }
                }
            }
            
        }
    }
    
    if(bricks % 1 || shift == true) {
        
        // last brick in line
        // get last brick index
        
        lastBrick = round(bricks)-1;
        
        translate([lastBrick * s_brick[0],0,0]) {
            
            if(i == 0) {
                
                // inside line
                
                if(bricks % 1 && shift == false) {
                    
                    // set half brick
                    color("purple") brick(5, v+lastBrick+1, 1, face_height);
                    
                } else if(bricks % 1 == 0 && shift == true) {
                    
                    translate([s_brick[0]/2,0,0]) {
                        color("blue") brick(5, v+lastBrick+1, 1, face_height);
                    }
                    
                } else {
                    
                    // half brick is setting in begin line, set full brick and shift it at half length
                    translate([-1 * s_brick[0]/2,0,0]) {
                        color("white") brick(5, v+lastBrick+1, 0, face_height);
                    }
                }
                
            } else {
                // top line
                if(bricks % 1 && shift == false) {
                    // set half brick with top side
                    color("purple") brick(1, v+lastBrick+1, 1, face_height);
                } else if(bricks % 1 == 0 && shift == true) {
                    
                    translate([s_brick[0]/2,0,0]) {
                        color("gold") brick(1, v+lastBrick+1, 1, face_height);
                    }
                } else {
                    
                    // half brick is setting in begin line, set full brick
                    translate([-1*s_brick[0]/2,0,0]) {
                        color("red") brick(1, v+lastBrick+1, 0, face_height);
                    }
                    
                }
            }            
        }
        
        
    }
}




module wall(l, crenelated = 0) {
    
    translate([face_height,0,0]) cube([l*s_cell[0] - face_height*2, s_wall[0], 3.5]);
    
    translate([0,0,3.5]) {
        
        wall_line(l, 0, 0, true);

        translate([0,0,s_wall[1]]) {
            
            wall_line(l, 0, 6);
            
            translate([0,0,s_wall[1]]) {
                
                if(crenelated == 0) {
                    wall_line(l, 0, 11, true);
                } else {
                    wall_line(l, 1, 11, true);
                }
               
                translate([0,0,s_wall[1]]) {
                    
                    if(crenelated == 0) {
                                    
                        scale([1,1,0.75]) wall_line(l, 0, 18);
                        
                        translate([0,0,s_wall[1]*0.75]) {
                            
                            scale([1,1,0.55]) wall_line(l, 0, 12, true);
                            
                            translate([0,0,s_wall[1]*0.55]) {
                                wall_line(l, 1, 24);
                            }
                            
                        }
                    
                    } else {
                        
                        crenelated_line(l);
                        
                    }
                    
                }            
                
            }
        }
        
    }

}






// flat sides (bottom side - always flat):
// 1 - left
// 2 - right
// 3 - left / right
// 4 - top
// 5 - top / left
// 6 - top / right
// 7 - top / left / right
module brick(s=0, v=1, half=0, offset=0) {
    
    fullScale = [1 - ((s_brick[0])/100 * offset),1.11,face_height];
    // result sacles (after rotating transforms): Z, Y, X
    halfScale = [0.7,0.8 - (s_brick[0]/100 * offset*1.6),face_height];
    
    // core    
    if(half == 1) {
        // crop length
        cube([s_brick[0]/2 - offset, s_brick[1], s_brick[2]]);
    } else {
        cube([s_brick[0] - offset, s_brick[1], s_brick[2]]);
    }
    
    // front
    if(half == 1) {
        translate([0,0,s_brick[2]]) rotate([90,90,0]) set_face(v+1, halfScale);
    } else {
        rotate([90,0,0]) set_face(v+1, fullScale);
    }
        
    
    // back
    if(half == 1) {
        translate([0, s_brick[1], 0]) rotate([90,-90,180]) set_face(v+2, halfScale);  
    } else {
        translate([s_brick[0] - offset, s_brick[1], 0]) rotate([90,0,180]) set_face(v+2, fullScale);
    }
    
    
    if(s!=1 && s!=3 && s!=5 && s!=7) {
        // left
        translate([0, s_brick[1], 0]) {
            rotate([90,0,-90]) set_face(v+3, [0.82,face_height,1]);
        }
    }
    
    
    if(s!=2 && s!=3 && s!=6 && s!=7) {
        // right
        if(half == 1) {
            translate([s_brick[0]/2 - offset, 0, 0]) {
                rotate([90,0,90]) set_face(v+4,[0.82,face_height,1]);
            }
        } else {
            translate([s_brick[0] - offset, 0, 0]) {
                rotate([90,0,90]) set_face(v+4,[0.82,face_height,1]);
            }
        }
    }
    
    if(s<4) {
        // top
        if(half == 1) {
            translate([s_brick[0]/2 - offset, 0, s_brick[2]]) {
                color("green") rotate([0,0,90]) set_face(v+5, [0.82, 0.79 - (s_brick[0]/100 * offset * 1.56),face_height+0.2]);
            }
        } else {
            translate([0, 0, s_brick[2]]) {
                color("green") set_face(v+5, [1.008 - (s_brick[0]/100 * offset), face_height+0.2, 1.16]);
            }
        }
    }
    
        
}


// c - current cell iteration
// cnt - number of cells
module tooth(c, cnt) {
    
    v = rands(0,32,11);
    
    // left tooth
    if(c == 0) {
        translate([s_face[0], 0, 0]) {
            cube(s_tooth);
            // front face
            translate([0,0,s_tooth[2]]) rotate([0,90,0]) set_face(v[1]);
            // back face
            translate([s_tooth[0],s_tooth[1],s_tooth[2]]) {
                rotate([0,90,180]) set_face(v[2]);
            }
            // top face
            translate([s_tooth[0],0,s_tooth[2]]) {
                rotate([-90,0,90]) set_face(v[7], face_top_scale);
            }
            // left face
            translate([0,s_tooth[1],s_tooth[2]]) {
                rotate([0,90,-90]) set_face(v[8], face_side_scale);
            }
            // right face
            translate([s_tooth[0],0,s_tooth[2]]) {
                rotate([0,90,90]) set_face(v[8], face_side_scale);
            }
        }
    } else {
        cube(s_tooth);
        // front face
        translate([0,0,s_tooth[2]]) rotate([0,90,0]) set_face(v[1]);
        // back face
        translate([s_tooth[0],s_tooth[1],s_tooth[2]]) {
            rotate([0,90,180]) set_face(v[2]);
        }
        // top face
        translate([s_tooth[0],0,s_tooth[2]]) {
            rotate([-90,0,90]) set_face(v[5], face_top_scale);
        }
        // right face
        translate([s_tooth[0],0,s_tooth[2]]) {
            rotate([0,90,90]) set_face(v[10], face_side_scale);
        }
        
    }
    
    // right tooth
    if(c == cnt-1) {
        translate([(s_cell[0] - s_tooth[0] - s_face[0]),0,0]) {
            cube(s_tooth);
            // front face
            translate([0,0,s_tooth[2]]) {
                rotate([0,90,0]) set_face(v[3]);
            }
            // back face
            translate([s_tooth[0],s_tooth[1],s_tooth[2]]) {
                rotate([0,90,180]) set_face(v[4]);
            }
            // top face
            translate([s_tooth[0],0,s_tooth[2]]) {
                rotate([-90,0,90]) set_face(v[6], face_top_scale);
            }
            // left face
            translate([0,s_tooth[1],s_tooth[2]]) {
                rotate([0,90,-90]) set_face(v[9], face_side_scale);
            }
            // right face
            translate([s_tooth[0],0,s_tooth[2]]) {
                rotate([0,90,90]) set_face(v[10], face_side_scale);
            }
        }
    } else {
        translate([(s_cell[0] - s_tooth[0]),0,0]) {
            cube(s_tooth);
            // front face
            translate([0,0,s_tooth[2]]) {
                rotate([0,90,0]) set_face(v[3]);
            }
            // back face
            translate([s_tooth[0],s_tooth[1],s_tooth[2]]) {
                rotate([0,90,180]) set_face(v[4]);
            }
            // top face
            translate([s_tooth[0],0,s_tooth[2]]) {
                rotate([-90,0,90]) set_face(v[6], face_top_scale);
            }
            // left face
            translate([0,s_tooth[1],s_tooth[2]]) {
                rotate([0,90,-90]) set_face(v[9], face_side_scale);
            }
        }
    }
}

module set_face(v, f_scale = face_scale) {
    scale(f_scale) static_face(floor(v));
}

module rand_face(seed) {
  num = floor(rands(0,32,1,seed=seed)[0]);
  //static_face(num);
}

module static_face(num) {

  n = num > 20 || num < 1 ? floor(rands(1,20,1)[0]) : num;
    
  filename = str("textures/stone-", n, ".png");
  echo(filename);
    
  scale([0.1255,0.19,0.04]) translate([0,0,-3.5]) surface(file=filename, convexity=1);
  
}