final int COUNT = 300;
final float PULSE_TIME = 2;

Arc arcs[];

class Arc{
   float xrot, yrot, zrot;
   float degrees;
   float radius;
   float width;
   float speed;
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

    arcs[i].degrees =  45 + random(45); // length in degrees
    arcs[i].radius = 90 + random(20);
    arcs[i].width = 10; // width of band
    
    arcs[i].speed = random(4)-2;
    if(random(100) > 90) arcs[i].speed += 5;
    
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

void draw() {
  background(0,0,32);

  float t = millis() / 1000.0; // Current time in seconds
  translate(width/2 + sin(t) * 20, height/2 + cos(t * 1.2) * 10, 500 + 100*t); // Zoom forward 100 units / second
  
  int pulse_index = COUNT - (int)(floatmod(t, PULSE_TIME) / PULSE_TIME * COUNT);
  int PULSE_WIDTH = 30;

  for (int i = 0; i < COUNT; i++) {
    // Drawing arc i
    
    pushMatrix();
    translate(0,0, -i * 5);
    rotateZ(arcs[i].zrot);
    
    color rgba = arcs[i].rgba;
    if (abs(i - pulse_index) <= (PULSE_WIDTH/2)){
      float d = 1 - (float)abs(i - pulse_index) / (PULSE_WIDTH / 2);
      rgba = colorBlended(d, red(rgba), green(rgba), blue(rgba), 255, 255, 255, 255);
    }
    fill(rgba);
    noStroke();
    
    arc(0, 0, arcs[i].degrees, arcs[i].radius, arcs[i].width);

    // increase z rotation angle
    arcs[i].zrot += arcs[i].speed / 50;

    popMatrix();
  }

  // Draw lightning bolt
  
  float b = floatmod(t,3);
  float brightness = min(gaussian(1.5, 0.3, b), 1);
  randomSeed((int)(t*5));
  subdivide_bolt(0,-600,-1000, 0, 200, -1000, 4, random(0.25, 0.75), brightness);
  //float x = keski.x;
  //float y = keski.y;
  //float z = keski.z;
  //beginShape(LINES);
  //vertex(0,-100,-1000);
  //vertex(x,y,z);
  //vertex(0, 100, -1000);
  //endShape();
  //draw_bolt(0,-100,-1000, x,y,z);
  //draw_bolt(x,y,z, 0, 100, -1000);
  //draw_bolt(0,-100,-500, 0, 100, -500);
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
           y + sin(angle) * radius);
    vertex(x + cos(angle) * (radius+w),
           y + sin(angle) * (radius+w));
  }
  endShape();
}
