class Flower extends WorldObject {
  
  float size;
  
  Flower(float x, float y, int id_) {
    super(x, y, id_);
    size = random(3, 6);
  }
  
  void show() {
    fill(255,255,0);
    stroke(0,255,0);
    ellipse(p.x, p.y, size, size);
  }
  
}