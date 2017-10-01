class Effect {
  PVector p;
  float age;
  float lifespan;
  float a;
  String s;
  color c;
  
  Effect(float x, float y, String s_, color c_) {
    this(x, y, s_);
    c = c_;
  }
  
  Effect(float x, float y, String s_) {
    p = new PVector(x, y);
    age = 0;
    lifespan = 1;
    a = 0;
    s = s_;
    c = color(0);
  }
  
  void update() {
    p.y = p.y - 0.1;
    age = age + 1.0/60;
    a = map(age, 0, 1, 255, 0);
  }
  
  void show() {
    fill(c, a);
    text(s, p.x, p.y);
  }
  
}