final int COUNT = 600;
final float PULSE_TIME = 2;

Arc arcs[];

class Arc{
   float xrot, yrot, zrot;
   float z;
   float degrees;
   float radius;
   float width;
   float speed;
   float acceleration;
   color rgba;
}

void setup() {
  size(1920/2, 1080/2, P3D);
  background(255);
  randomSeed(100);  // use this to get the same result each time

  arcs = new Arc[COUNT];

  // Set up arc shapes
  for (int i = 0; i < COUNT; i++) {
    
    arcs[i] = new Arc();
    arcs[i].xrot = 0;
    arcs[i].yrot = 0;
    arcs[i].zrot = random(TAU);
    arcs[i].z = -5*i;

    arcs[i].degrees =  45 + random(45); // length in degrees
    arcs[i].radius = 90 + random(20);
    arcs[i].width = 10; // width of band
    
    arcs[i].speed = random(4)-2;
    if(random(100) > 90) arcs[i].speed += 5;
    
    arcs[i].acceleration = random(0.01);
    if(random(100) > 90) arcs[i].acceleration += 0.02;
    arcs[i].acceleration *= 60;
    
    arcs[i].rgba = colorBlended(random(1), 200,255,0, 50,120,0, 210);
  }
}

float floatmod(float t, float m){
   return t - ((int)(t/m))*m; 
}

void draw_bolt(float x1, float y1, float z1, float x2, float y2, float z2, float brightness){
  //pushMatrix();
  //translate(0,0,-depth);
  stroke(255,255,255,255 * brightness);
  
  strokeWeight(1);
  line(x1, y1, z1, x2, y2, z2);

  strokeWeight(3);
  line(x1, y1, z1, x2, y2, z2);
  
  strokeWeight(6);
  line(x1, y1, z1, x2, y2, z2);
  
  strokeWeight(9);
  line(x1, y1, z1, x2, y2, z2);
  
  
  //popMatrix();  
}

void subdivide_bolt(float x1, float y1, float z1, float x2, float y2, float z2, int depth, float p, float brightness){
  
   if(depth == 0){
       draw_bolt(x1, y1, z1, x2, y2, z2, brightness);
       return;
   }
  
   PVector salama = new PVector(x2-x1, y2-y1, z2-z1);
   PVector q = new PVector(x1,y1,z1);
   
   PVector keski = q.add(salama.mult(p));
   
   keski.x += random(25);
   
   subdivide_bolt(x1, y1, z1, keski.x, keski.y, keski.z, depth-1, random(0.25, 0.75), brightness);
   subdivide_bolt(keski.x, keski.y, keski.z, x2, y2, z2, depth-1, random(0.25, 0.75), brightness);
}

//final float PI = 3.14159265359;

float gaussian(float mu, float sigma, float x){
     return 1.0 / (sigma * sqrt(2*PI)) * exp(-0.5 * pow((x - mu) / sigma, 2));
}

// Idea: kaaret lähtee menemään samaan suuntaan ja kiihtyy

float prev_t = 0;

void draw() {

  float t = millis() / 1000.0; // Current time in seconds
  float dt = t - prev_t;

  float cameraZ = -100*t;

  camera(width/2.0, height/2.0, cameraZ, // Camera position 
         width/2.0, height/2.0, cameraZ- 1, // Look at this point (down the negative z-axis)
         0, 1, 0); // The positive y-axis is the up-direction

  // Draw lightning bolt
  
  float b = floatmod(t,3);
  float brightness1 = min(gaussian(1.5, 0.1, b), 1);
  float brightness2 = min(gaussian(2.5, 0.1, b), 1);
  float brightness3 = min(gaussian(1.0, 0.1, b), 1);
  float flash = min(64, (brightness1 + brightness2 + brightness3) * 32);
  //flash = 0;
  background(flash,flash,32 + flash);

  randomSeed((int)(t/3));
  random(1); // Draw one random value. If we don't do this, then the first value generated is not very random
  float x1 = random(-400, 1600);
  float x2 = random(-400, 1600);
  float x3 = random(-400, 1600);

  randomSeed((int)(t*5));
  subdivide_bolt(x1,-600,-4000, x1, 800, -4000, 4, random(0.25, 0.75), brightness1);
  subdivide_bolt(x2,-600,-4000, x2, 800, -4000, 4, random(0.25, 0.75), brightness2);
  subdivide_bolt(x3,-600,-4000, x3, 800, -4000, 4, random(0.25, 0.75), brightness3);
  
  //translate(width/2 + sin(t) * 20, height/2 + cos(t * 1.2) * 10, 500 + 100*t); // Zoom forward 100 units / second
  //translate(width/2, height/2, cameraZ); // Zoom forward
  
  int pulse_index = COUNT - (int)(floatmod(t, PULSE_TIME) / PULSE_TIME * COUNT);
  int PULSE_WIDTH = 30;

  for (int i = 0; i < COUNT; i++) {
    // Drawing arc i
    
    pushMatrix();
    translate(width/2.0, height/2.0, arcs[i].z); // Center of the coordinate system of the arc
    rotateZ(arcs[i].zrot);
    
    color rgba = arcs[i].rgba;
    float fog = 1 - constrain((arcs[i].z - cameraZ) / 1000, 0, 1);  
    if (abs(i - pulse_index) <= (PULSE_WIDTH/2)){
      float d = 1 - (float)abs(i - pulse_index) / (PULSE_WIDTH / 2);
      rgba = colorBlended(d, red(rgba), green(rgba), blue(rgba), 255, 255, 255, 255);
    }
    rgba = color(red(rgba) + flash, green(rgba) + flash, blue(rgba) + flash,alpha(rgba)*fog + flash * 0.5);
    fill(rgba);
    noStroke();
    
    arc(0, 0, arcs[i].degrees, arcs[i].radius, arcs[i].width);

    // increase z rotation angle
    arcs[i].zrot += arcs[i].speed * dt;
    
    // Decrease speed
    if(t > 5 && t < 10) arcs[i].speed *= pow(0.3, dt);
    if(t > 10 && t < 15) arcs[i].speed += arcs[i].acceleration * dt;
    if(t > 15) arcs[i].speed -= arcs[i].acceleration * dt;
    
    //arcs[i].degrees += dt*2;

    popMatrix();
  }
  
  prev_t = t;
  
  //saveFrame("frames/####.tif");
}


// Get blend of two colors
int colorBlended(float fract,
                 float r, float g, float b,
                 float r2, float g2, float b2, float a) {
  return color(r + (r2 - r) * fract,
               g + (g2 - g) * fract,
               b + (b2 - b) * fract, a);
}


// Draw solid arc
void arc(float x, float y, float degrees, float radius, float w) {
  beginShape(QUAD_STRIP);
  for (int i = 0; i < degrees; i++) {
    float angle = radians(i);
    vertex(x + cos(angle) * radius,
           y + sin(angle) * radius, 0);
    vertex(x + cos(angle) * (radius+w),
           y + sin(angle) * (radius+w), 0);
  }
  endShape();
}
