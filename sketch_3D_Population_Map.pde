import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;


float angle;
float r = 300;
Table table; 
PImage earth;
PShape globe;
int dir = 1;
boolean rotate = true;
PeasyCam camera;

void setup()
{
  size(1000, 750, P3D);
  earth = loadImage("worldMapping.png");
  table = loadTable("worldCities.csv", "header");
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  camera = new PeasyCam(this, 500, 375, 500, 200);
  camera.setPitchRotationMode();
}



void draw()
{
  background(51);
  translate(width*0.5, height*0.5);
  if (dir == 0 && rotate) rotateX(-angle); else if (dir == 1 && rotate) rotateY(angle); else if (dir == 2 && rotate) rotateZ(angle);
  angle += 0.005;

  //lights();
  fill(200);
  noStroke();
  shape(globe);

  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");
    float mag = row.getFloat("mag");
    float theta = radians(lat) + PI*0.5;
    float phi = radians(-lon) + PI;
    float x = r * sin(theta) * cos(phi);
    float y = r * cos(theta);
    float z = r * sin(theta) * sin(phi);
    PVector pos = new PVector(x, y, z);
    
    float h = mag;
    h = map(h, 0, 10000000, 2, 100);
    
    PVector xaxis = new PVector(1, 0, 0);
    float angleb = PVector.angleBetween(xaxis, pos);
    PVector raxis = xaxis.cross(pos);

    
    pushMatrix();
    translate(x, y, z);
    rotate(angleb, raxis.x, raxis.y, raxis.z);
    fill(30, 132-h, h+150);
    box(h, 2, 2);
    popMatrix();
  }
}

void mouseClicked()
{
  if (dir == 0) dir = 1; else if (dir == 1) dir = 2; else dir = 0;
}

void keyPressed()
{
  rotate = !rotate;  
}
