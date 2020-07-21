class Part {
  PVector pos;
  PVector pos_prev;
  PVector vel;
  PVector veli;
  color col; 
  float lifetime; 
  float rad, rad_in;
  int alpha;
  int shape;
  float omega; 
  float walk;
  float limit;

  Part(float _x, float _y, PImage palette) {
    pos = new PVector(_x, _y);
    pos_prev = new PVector(_x, _y);
    float arg = random(0.0, 1.0);
    veli = new PVector(cos(arg * 2 * PI), sin(arg * 2 * PI));

    vel = new PVector(0, 0);
    veli.mult(0.01);
    lifetime = random(3, 20.0);
    rad_in = 10/lifetime ;
    alpha = int(random(30, 100));
    shape = int(random(0, 2));

    omega = random(0.8, 1.0);
    walk = random(1, 1 + 3.0/rad_in);
    limit = random(0.4, 2.5);


    int x = int(random(0, palette.width ));
    int y = int(random(0, palette.height));
    palette.loadPixels();
    col = palette.pixels[x + y * width];
  }

  void applyForce(PVector f) {
    f.mult(0.1);
    vel.add(f);
  }

  void update() {
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) reset();
    vel.add(veli);
    vel.limit(limit);
    pos.x += random(-walk, walk);
    pos.y += random(-walk, walk);
    pos.add(vel);
    lifetime -= 0.2;
  }

  void reset() {
    float theta = random(0, 1.0) * 2 * PI;
    float rad = random(0, size) + size * 0.001 ;
    float x_spawn =  width/2 + rad * cos(theta);
    float y_spawn =  height/2 + rad * sin(theta);
    pos = new PVector(x_spawn, y_spawn);
    pos_prev.x = pos.x;
    pos_prev.y = pos.y;
    float arg = random(0.0, 1.0);
    veli = new PVector(cos(arg * 2 * PI), sin(arg * 2 * PI));
    vel = new PVector(0, 0);
    lifetime = random(3, 9.0);
    shape = int(random(0, 2));
  }
  void display() {

    stroke(col, alpha * lifetime * 0.8);
    if (shape == 0) strokeCap(ROUND);
    else strokeCap(SQUARE);
    float dist = dist(pos_prev.x, pos_prev.y, pos.x, pos.y);
    if (lifetime > 0) {
      strokeWeight(dist  * dist * 0.05 * lifetime + 1);
    }

    line(pos_prev.x, pos_prev.y, pos.x, pos.y);
    pos_prev.x = pos.x;
    pos_prev.y = pos.y;
  }


  boolean isDead() {
    if (lifetime < 0.06) return true;
    else return false;
  }
}
