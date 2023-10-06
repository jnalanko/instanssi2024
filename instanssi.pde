final int COUNT = 150;

float[] pt;
int[] style;


void setup() {
  size(1024, 768, P3D);
  background(255);
  randomSeed(100);  // use this to get the same result each time

  pt = new float[7 * COUNT]; // rotx, roty, rotz, deg, rad, w, speed
  style = new int[2 * COUNT]; // color, render style

  // Set up arc shapes
  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    //pt[index++] = random(TAU); // Random X axis rotation
    //pt[index++] = random(TAU); // Random Y axis rotation
    pt[index++] = 0; // x rot
    pt[index++] = 0; // y rot
    pt[index++] = random(TAU); // z rot

    pt[index++] = 90; // Short to quarter-circle arcs

    pt[index++] = 100; // Radius. Space them out nicely

    pt[index++] = 15; // Width of band

    pt[index++] = random(1); // Speed of rotation
    //pt[index++] = 0;

    style[i*2] = colorBlended(random(1), 200,255,0, 50,120,0, 210);
    style[i*2+1] = 0;
  }
}

void draw() {
  background(0);

  float t = millis() / 1000.0;
  translate(width/2, height/2, 500 + 100*t);
  //rotateX(PI / 6);
  //rotateY(PI / 6);

  int index = 0;
  for (int i = 0; i < COUNT; i++) {
    pushMatrix();
    translate(0,0,-i * 10);
    //rotateX(pt[index++]);
    //rotateY(pt[index++]);
    index += 2;
    rotateZ(pt[index++]);

    fill(style[i*2]);
    noStroke();
    arc(0, 0, pt[index++], pt[index++], pt[index++]);

    // increase rotation
    pt[index-4] += pt[index] / 50;
    //pt[index-5] += 0.01;
    //pt[index-4] += pt[index++] / 20;
    index++;
    
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
