final int COUNT = 1000;

Arc arcs[];

class Arc{
   float xrot, yrot, zrot;
   float len; // Degrees
   float radius;
   float width;
   float speed;
   color rgb;
   
   //public Arc(float xrot, float yrot, float zrot
}

void setup() {
  size(1024, 768, P3D);
  background(255);
  randomSeed(100);  // use this to get the same result each time

  arcs = new Arc[COUNT];
  //ArrayList<Arc> arcs = new ArrayList<Arc>();

  // Set up arc shapes
  for (int i = 0; i < COUNT; i++) {
    
    arcs[i] = new Arc();
    
    System.out.println(i);

    float xrot = 0;
    float yrot = 0;
    float zrot = random(TAU);

    float len =  45 + random(45); // length in degrees
    float radius = 90 + random(20); // Radius. Space them out nicely
    float width = 10; // Width of band
    
    float speed = random(4)-2;
    if(random(100) > 90) speed += 5;
    color rgb = colorBlended(random(1), 200,255,0, 50,120,0, 210); // color

    arcs[i].xrot = xrot;
    arcs[i].yrot = yrot;
    arcs[i].zrot = zrot;
    arcs[i].len = len;
    arcs[i].radius = radius;
    arcs[i].width = width;
    arcs[i].speed = speed;
    arcs[i].rgb = rgb;

  }
}

void draw() {
  background(0,0,32);

  float t = millis() / 1000.0; // Current time in seconds
  translate(width/2 + sin(t) * 20, height/2 + cos(t * 1.2) * 10, 500 + 100*t); // Zoom forward 100 units / second

  for (int i = 0; i < COUNT; i++) {
    
    // Drawing arc i
    
    pushMatrix();
    translate(0,0, -i * 5);
    rotateZ(arcs[i].zrot); // zrot
    fill(arcs[i].rgb);
    noStroke();
    arc(0, 0, arcs[i].len, arcs[i].radius, arcs[i].width);

    // increase z rotation angle
    arcs[i].zrot += arcs[i].speed / 50;

    popMatrix();
  }
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
