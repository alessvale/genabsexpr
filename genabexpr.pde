// Generative Abstract Expressionism
// Alessandro Valentino 2016

int seed = 510;

ArrayList<Part> particles;
int num = 500;
int scl = 50; 
float size ;
float alpha ;

int cols;
int rows;
float[][] noise = new float[num][num];

PImage img;
PImage photo;

void init() {
  size = 40;
  alpha = 0;
  int xback = int(random(0, img.width ));
  int yback = int(random(0, img.height));
  img.loadPixels();
  color back = img.pixels[xback + yback * width]; 
  background(back);

  //Make a table of noise values;
  cols = width/scl;
  rows = height/scl;

  float xoff = 0;
  float yoff = 4;

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      noise[x][y] = noise(xoff, yoff) * 10;
      xoff += 0.01;
    }
    yoff += 0.01;
  }

  //Initialise the particle system;
  particles = new ArrayList<Part>();

  for (int i = 0; i < num; i++) {
    float theta = random(0, 1.0) * 2 * PI;
    float rad = random(0, size);
    float x_spawn =  width/2 + rad * cos(theta);
    float y_spawn =  height/2 + rad * sin(theta);

    Part p = new Part(x_spawn, y_spawn, img);
    particles.add(p);
  }
}
void setup() {
  // Uncomment for replicability  
  // randomSeed(seed);
  //fullScreen();
  size(1200, 720); 
  orientation(LANDSCAPE); 
  size = 40;
  alpha = 0;
  img = loadImage("pal5.jpg");
  img.resize(width, height);
  photo = loadImage("img1.jpg");
  photo.resize(width, height);

  int xback = int(random(0, img.width ));
  int yback = int(random(0, img.height));
  img.loadPixels();
  color back = img.pixels[xback + yback * width]; 
  background(back);

  //Make a table of noise values;

  cols = width/scl;
  rows = height/scl;

  float xoff = 0;
  float yoff = 4;

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      noise[x][y] = noise(xoff, yoff) * 10;
      xoff += 0.01;
    }
    yoff += 0.01;
  }

  //Initialise the particle system;

  particles = new ArrayList<Part>();

  for (int i = 0; i < num; i++) {
    float theta = random(0, 1.0) * 2 * PI;
    float rad = random(0, size);
    float x_spawn =  width/2 + rad * cos(theta);
    float y_spawn =  height/2 + rad * sin(theta);

    Part p = new Part(x_spawn, y_spawn, img);
    particles.add(p);
  }
}

void draw() {
  photo.loadPixels();
  for (int i = 0; i < particles.size(); i++) {
    Part p = particles.get(i);
    int x = int (p.pos.x/scl);
    int y = int (p.pos.y/scl);

    if (x < 0) x = 0;
    if (x > cols) x = cols;
    if (y < 0) y = 0;
    if (y > rows) y = rows;

    float hu = map(hue(photo.pixels[x + y * width]), 0, 255, 0, 1.0);
    float theta = noise[x][y] * hu;
    PVector force = new PVector(cos((theta) * 2 * PI), sin((theta) * 2 * PI));

    //force.rotate(alpha);

    p.applyForce(force);
    p.update();
    p.display();
  }

  for (int i = particles.size() - 1; i >= 0; i--) {
    Part p = particles.get(i);
    if (p.isDead()) {
      p.reset();
    }
  }

  size *= 1.006;
  alpha += 0.01;
}

void keyPressed() {
  //save("frames/" + seed + ".tiff");
}

void mouseReleased() {
  init();
}
