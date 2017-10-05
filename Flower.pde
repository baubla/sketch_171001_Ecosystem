class Flower extends WorldObject {
  
<<<<<<< HEAD
  Flower(float x, float y) {
    super(x, y);
=======
  float size;
  
  Flower(float x, float y, int id_) {
    super(x, y, id_);
    size = random(3, 6);
>>>>>>> 3861b6e8be8743701e95679109369a2d98b4899c
  }
  
  void show() {
    fill(255,255,0);
    stroke(0,255,0);
    ellipse(p.x, p.y, size, size);
  }
  
}