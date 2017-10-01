class Bud extends WorldObject {
  float[] DNA;
  PVector v;
  PVector a;
  float angle;
  float d;
  float fear;
  float age;
  float lifespan;
  color c;

  Bud (float x, float y, int id_) {
    super(x, y, id_);
    DNA = new float[DNA_LENGTH];
    for (int i = 0; i < DNA_LENGTH; i++) {
      DNA[i] = random(0.5, 1.5);
    }
    p = new PVector(x, y);
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    angle = random(2*PI);

    //physical characteristics and personality
    float[] dDNA = {DNA[0], DNA[1]};
    float dGene = formulateGene(dDNA);
    d = map(dGene,0,1,10,20);
    
    fear = DNA[2]*DNA[8]*DNA[9];
    lifespan = map(DNA[4]*DNA[5]*DNA[6], 0, 1, 30, 15);

    //color
    int pcolor = int(map(DNA[0]*DNA[1]*DNA[6], 0, 1, 255, 0));
    int acolor = int(map(DNA[7], 0, 1, 0, 255));
    if (DNA[7] > 0.67) {
      c = color(0, pcolor, acolor);
    } else if (DNA[7] > 0.33) {
      c = color(acolor, 0, pcolor);
    } else {
      c = color(pcolor, 1-acolor, 0);
    }

    age = 0;
  }
  
  float formulateGene(float[] strands) {
    float geneValue = 1;
    int numStrands = strands.length;
    for (int i = 0; i < numStrands; i++) {
      geneValue = geneValue * strands[i];
    }
    return map(geneValue, pow(0.5, numStrands), pow(1.5, numStrands), 0, 1);
  }

  //PVector flee(PVector e) {
  //  PVector f = PVector.sub(e, p);
  //  f.setMag(-50*fear/f.mag());
  //  return f;
  //}

  //PVector flock(PVector friend) {
  //  PVector f = PVector.sub(friend, p);
  //  f.setMag(0.001*fear*f.mag());
  //  return f;
  //}

  //PVector personalspace(PVector friend) {
  //  PVector f = PVector.sub(friend, p);
  //  f.setMag(-2/f.mag());
  //  return f;
  //}

  //PVector fatigue() {
  //  PVector f = v.copy().mult(-10*v.mag());
  //  return f;
  //}

  //PVector halt() {
  //  PVector f = v.copy().mult(-2);
  //  return f;
  //}

  //PVector feed(PVector flower) {
  //  PVector f = PVector.sub(flower, p);
  //  f.setMag(1);
  //  return f;
  //}

  //PVector attract(Bud potentialMate) {
  //  float difR = abs(red(potentialMate.c)-red(c))/255;
  //  float difG = abs(green(potentialMate.c)-green(c))/255;
  //  float difB = abs(blue(potentialMate.c)-blue(c))/255;
  //  float difColor = difR*difG*difB;
  //  if (difColor < 0.25) {
  //    PVector f = PVector.sub(potentialMate.p, p);
  //    f.setMag(1*f.mag());
  //    return f;
  //  } else {
  //    PVector f = new PVector(0,0);
  //    return f;
  //  }
  //}

  //void applyMuscle(PVector f) {
  //  PVector fpm = PVector.div(f, pow(d, 2));
  //  a.add(fpm);
  //}

  //void mate(Bud b) {
  //}

  ArrayList<WorldObject> scanSurroundings() {

    ArrayList<WorldObject> objects = new ArrayList<WorldObject>();

    for (Bud b : buds) {
      if (id != b.id) {
        float distance = PVector.dist(p, b.p);
        if (distance <= 50) {
          objects.add(b);
        }
      }
    }

    for (Flower f : flowers) {
      float distance = PVector.dist(p, f.p);
      if (distance <= 50) {
        objects.add(f);
      }
    }

    return objects;
  }

  void die() {
    fill(255, 0, 0);
    noStroke();
    ellipse(p.x, p.y, d, d);
    effects.add(new Effect(p.x - 5, p.y - d, "DEATH", DEATH_COLOR));
    buds.remove(this);
    totaldeaths++;
  }

  void update() {

    v.add(a);
    p.add(v);

    //position bounds
    if (p.x < d/2) {
      p.x = d/2;
      v.x = 0;
    } else if (p.x > width - d/2) {
      p.x = width - d/2;
      v.x = 0;
    }
    if (p.y < d/2) {
      p.y = d/2;
      v.y = 0;
    } else if (p.y > height - d/2) {
      p.y = height - d/2;
      v.y = 0;
    }

    a.set(0, 0);

    age = age + 1.0/60;
    if (age > lifespan - 5) {
      fear = fear * 0.99;
    }
  }

  void show() {

    pushMatrix();

    translate(p.x, p.y);

    pushMatrix();

    rotate(angle);

    fill(c);
    stroke(0);
    ellipse(0, 0, d, d);

    if (age > lifespan - 5) {
      fill(155, 100);
      ellipse(0, 0, d/2, d/2);
    }

    fill(0);
    noStroke();
    //ellipse(0, d-7.5, 5, 5);

    popMatrix();

    noStroke();
    //text(nf(v.mag(),0,3), d/2, 0);

    //text(nf(age,0,1) + "/" + nf(lifespan,0,1), d/2, 0);

    popMatrix();
  }
}