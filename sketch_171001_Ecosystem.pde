//TO-DO
//Genome
//Mating
//Growth
//Physical features as a result of the genome
//color gets grayer over time for the buds, they become less desirable and old
//vision is only what is in front of them
//only can steer forward and backwards and turn

ArrayList<Bud> buds;
ArrayList<Flower> flowers;
ArrayList<Effect> effects;

float timer = 0;
float dt = 1.0/60;

int totaldeaths = 0;
int totalbirths = 0;

float mutationRate = 0.1;
float randomFlowerSpawnRate = 0.02;

final int BUDS_START = 20;
final int DNA_LENGTH = 10;
final color DEATH_COLOR = color(255, 0, 0);

final String[] modes = {"Search", "Feed", "Mate", "Flee"};

void setup() {

  frameRate(60);
  size(400, 400);

  //create buds list
  buds = new ArrayList<Bud>();

  //add BUDS_START buds at start
  for (int i = 0; i < BUDS_START; i++) {
    spawnRandomBud(random(width), random(height));
  }

  //create flowers list
  flowers = new ArrayList<Flower>();

  //add 5 flowers at start
  for (int i = 0; i < 5; i++) {
    flowers.add(new Flower(random(width), random(height)));
  }

  //create effects list
  effects = new ArrayList<Effect>();
}

void draw() {
  background(200);

  timer = timer + dt;

  //if (random(1) < 0.001) {
  //  buds.add(new Bud(random(width), random(height), buds.size()));
  //}

  //for each bud
  for (int i = buds.size() - 1; i >= 0; i--) {
    Bud b = buds.get(i);
    b.update();
    b.show();
  }

  //random flower growth
  if (random(1) < randomFlowerSpawnRate) {
    flowers.add(new Flower(random(width), random(height)));
  }

  //show all flowers
  for (Flower f : flowers) {
    f.show();
  }

  //show all effects
  for (int i = effects.size() - 1; i >= 0; i--) {
    Effect e = effects.get(i);
    if (e.age > e.lifespan) {
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
  spawnRandomBud(mouseX + random(10), mouseY + random(10));
}

Bud spawnRandomBud(float x, float y) {
  Bud randomBud = new Bud(x, y, createRandomDNA());
  buds.add(randomBud);
  return randomBud;
}

float[] createRandomDNA() {
  float[] randomDNA = new float[DNA_LENGTH];
  for (int i = 0; i < DNA_LENGTH; i++) {
    randomDNA[i] = random(0.5, 1.5);
  }
  return randomDNA;
}