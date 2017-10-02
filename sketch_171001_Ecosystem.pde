//TO-DO
//Genome
//Mating
//Growth
//Physical features as a result of the genome

ArrayList<Bud> buds;
ArrayList<Flower> flowers;
ArrayList<Effect> effects;
color[] colors;
float[] fears;
float timer;
int totaldeaths;
int totalbirths;

final int BUDS_START = 2;
final int DNA_LENGTH = 10;
final color DEATH_COLOR = color(255,0,0);

void setup() {

  frameRate(60);
  size(400, 400);

  timer = 0;

  totaldeaths = 0;
  totalbirths = 0;

  //create buds list
  buds = new ArrayList<Bud>();

  //add BUDS_START buds at start
  for (int i = 0; i < BUDS_START; i++) {
    buds.add(new Bud(random(width), random(height), i));
  }

  //create flowers list
  flowers = new ArrayList<Flower>();

  //add 5 flowers at start
  for (int i = 0; i < 5; i++) {
    flowers.add(new Flower(random(width), random(height), flowers.size()));
  }
  
  //create effects list
  effects = new ArrayList<Effect>();
  
}

void draw() {
  background(200);

  timer = timer + 1.0/60;

  //if (random(1) < 0.001) {
  //  buds.add(new Bud(random(width), random(height), buds.size()));
  //}

  //for each bud
  for (int i = buds.size() - 1; i >= 0; i--) {
    
    Bud b = buds.get(i);
    
    if (b.age > b.lifespan) {
      b.die();
    } else {

      ////flee/flock
      //PVector flee = new PVector(0, 0);
      //PVector flock = new PVector(0, 0);
      //PVector personalspace = new PVector(0, 0);

      //for (Bud be : buds) { //loop through all other buds
      //  if (buds.get(i).id != be.id) { //if not self
      //    float db = PVector.dist(buds.get(i).p, be.p);
      //    if (buds.get(i).s != be.s) { //if species different
      //      if (db < 100*buds.get(i).fear) {
      //        flee.add(buds.get(i).flee(be.p));
      //      }
      //    } else { //if species same
      //      if (db > 50*buds.get(i).fear && db < 150) {
      //        flock.add(buds.get(i).flock(be.p));
      //      }
      //      if (db < buds.get(i).d*2) {
      //        personalspace.add(buds.get(i).personalspace(be.p));
      //      }
      //    }
      //  }
      //}
      //buds.get(i).applyMuscle(flee);
      //buds.get(i).applyMuscle(flock);
      //buds.get(i).applyMuscle(personalspace);

      ////fatigue
      //PVector fatigue = buds.get(i).fatigue();
      //buds.get(i).applyMuscle(fatigue);

      ////halt
      //PVector halt = buds.get(i).halt();
      //buds.get(i).applyMuscle(halt);

      //feed
      //PVector feed = new PVector(0, 0);
      //float db = 9999;
      //int closeflower = -1;
      //for (int j = flowers.size() - 1; j >= 0; j--) {
      //  float newdb = PVector.dist(buds.get(i).p, flowers.get(j).p);
      //  if (newdb < db) {
      //    db = newdb;
      //    closeflower = j;
      //  }
      //}
      //if (db < buds.get(i).d/2) {
      //  flowers.remove(closeflower);
      //  if (random(1) > 0.5) {
      //    effects.add(new Effect(buds.get(i).p.x - 10, buds.get(i).p.y - buds.get(i).d, "BIRTH"));
      //    totalbirths++;
      //    buds.add(new Bud(buds.get(i).p.x, buds.get(i).p.y, buds.size()));
      //  } else {
      //    effects.add(new Effect(buds.get(i).p.x - 5, buds.get(i).p.y - buds.get(i).d, "EAT"));
      //    buds.get(i).lifespan += 5;
      //  }
      //} else if (db < 75) {
      //  feed.add(buds.get(i).feed(flowers.get(closeflower).p));
      //}
      //buds.get(i).applyMuscle(feed);
      //b.decide();
      b.update();
      b.show();
    }
  }
  
  //random flower growth
  if (random(1) < 0.01) {
    flowers.add(new Flower(random(width), random(height), flowers.size()));
  }

  //show all flowers
  for (Flower f : flowers) {
    f.show();
  }
  
  //show all effects
  for (int i = effects.size() - 1; i >= 0; i--) {
    Effect e = effects.get(i);
    if(e.age > e.lifespan) {
      effects.remove(e);
    } else {
      e.update();
      e.show();
    }
  }

  fill(0);
  noStroke();
  text("total buds: " + buds.size(), 2, 15);
  text("total flowers: " + flowers.size(), 2, 30);
  text("time: " + nf(timer, 0, 1), 2, 45);
  text("deaths: " + totaldeaths, 2, 60);
  text("births: " + totalbirths, 2, 75);
}

void mousePressed() {
  buds.add(new Bud(mouseX + random(10), mouseY + random(10), buds.size()));
}