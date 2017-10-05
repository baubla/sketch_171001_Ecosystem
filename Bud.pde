class Bud extends WorldObject {
  float[] DNA;
  PVector v;
  PVector a;
  float angle;
  float angleNoiseSeed;
  float d;
  float fear;
  float age;
  float lifespan;
  color c;
  float sight;
  float puberty;
  float mateCooldown;
  float feedCooldown;
  float mateThreshold;
  float fleeThreshold;

  Bud (float x, float y, float[] DNA_) {
    super(x, y);
    DNA = DNA_;
    p = new PVector(x, y);
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    
    angleNoiseSeed = x * y * 1/DNA[0] * 1/DNA[1];
    angle = map(noise(angleNoiseSeed, 0),0,1,0,2*PI);

    //physical characteristics and personality
    float[] dDNA = {DNA[0], DNA[1]};
    float dGene = formulateGene(dDNA);
    d = map(dGene, 0, 1, 10, 20);
    
    float[] fearDNA = {DNA[2], DNA[8], DNA[9]};
    float fearGene = formulateGene(fearDNA);
    fear = fearGene;
    
    float[] lifespanDNA = {DNA[4], DNA[5], DNA[6]};
    float lifespanGene = formulateGene(lifespanDNA);
    lifespan = map(lifespanGene, 0, 1, 30, 15);
    
    float[] pubertyDNA = {DNA[0], DNA[9]};
    float pubertyGene = formulateGene(pubertyDNA);
    puberty = map(pubertyGene, 0, 1, 8, 12);

    //color
    float[] pcolorDNA = {DNA[0], DNA[1], DNA[6]};
    float pcolorGene = formulateGene(pcolorDNA);
    int pcolor = int(map(pcolorGene, 0, 1, 255, 0));

    int acolor = int(map(DNA[7], 0.5, 1.5, 0, 255));
    if (DNA[7] > 1.17) {
      c = color(0, pcolor, acolor);
    } else if (DNA[7] > 0.83) {
      c = color(acolor, 0, pcolor);
    } else {
      c = color(pcolor, 1-acolor, 0);
    }

    sight = 50;

    age = 0;
    
    mateCooldown = 0;
    feedCooldown = 0;
    
    mateThreshold = 0.8;
    fleeThreshold = 0.6;
  }

  float formulateGene(float[] strands) {
    float geneValue = 1;
    int numStrands = strands.length;
    for (int i = 0; i < numStrands; i++) {
      geneValue = geneValue * strands[i];
    }
    return map(geneValue, pow(0.5, numStrands), pow(1.5, numStrands), 0, 1);
  }

  void fleeMode() {
    ArrayList<Bud> budsInView = getBudsInView();
    PVector f = new PVector(0, 0);
    for (Bud b : budsInView) {
      float mateEvaluation = evaluateMate(b);
      if (mateEvaluation < fleeThreshold) {
        PVector f_ = PVector.sub(p, b.p);
        f_.setMag(1000*fear/f_.mag());
        f.add(f_);
      }
    }
    println(f.mag());
    applyForce(f);
  }

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

  void fatigue() {
    PVector f = v.copy().mult(-10*v.mag());
    applyForce(f);
  }

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

  void applyForce(PVector f) {
    PVector fpm = PVector.div(f, pow(d, 2));
    a.add(fpm);
  }

  //void mate(Bud b) {
  //}

  //void decide() {

  //  Bud closestBud = null;
  //  float closestDistance = 9999;

  //  ArrayList<Bud> budsInView = new ArrayList<Bud>();

  //  for (Bud b : buds) {
  //    if (this != b) {
  //      float distance = PVector.dist(p, b.p);
  //      if (distance <= sight) {
  //        budsInView.add(b);
  //        if (distance < closestDistance) {
  //          closestDistance = distance;
  //          closestBud = b;
  //        }
  //      }
  //    }
  //  }
  //}

  void decide() {

    Bud closestBud = getClosestBud();
    Flower closestFlower = getClosestFlower();

    if (closestFlower == null && closestBud == null) {
      searchMode();
    } else if (closestFlower == null) {
      float mateEvaluation = evaluateMate(closestBud);
      if (mateEvaluation < fleeThreshold) {
        fleeMode();
      } else if (mateEvaluation > mateThreshold && age >= puberty && mateCooldown <= 0) {
        mateMode(closestBud);
      } else {
        searchMode();
      }
    } else if (closestBud == null) {
      if (feedCooldown <= 0) {
        feedMode(closestFlower);
      } else {
        searchMode();
      }
    } else {
      float mateEvaluation = evaluateMate(closestBud);
      if (mateEvaluation < fleeThreshold) {
        fleeMode();
      } else {
        float distToClosestBud = PVector.dist(p, closestBud.p);
        float distToClosestFlower = PVector.dist(p, closestFlower.p);
        if (distToClosestBud < distToClosestFlower) {
          if (mateEvaluation > mateThreshold && age >= puberty && mateCooldown <= 0) {
            mateMode(closestBud);
          } else {
            searchMode();
          }
        } else {
          if (feedCooldown <= 0) {
            feedMode(closestFlower);
          } else {
            searchMode();
          }
        }
      }
    }
  }

  void searchMode() {
    PVector f = PVector.fromAngle(angle);
    f.mult(2);
    applyForce(f);
  }

  void mateMode(Bud b) {
    float distanceToMate = PVector.dist(p, b.p);
    if (distanceToMate < (d/2 + b.d/2)) {
      mate(b);
    } else {
      PVector f = PVector.sub(b.p, p);
      f.mult(0.05);
      applyForce(f);
    }
  }

  void feedMode(Flower f) {
    float distanceToFlower = PVector.dist(p, f.p);
    if (distanceToFlower < d/2) {
      eat(f);
    } else {
      PVector force = PVector.sub(f.p, p);
      force.mult(0.05);
      applyForce(force);
    }
  }

  void mate(Bud b) {
<<<<<<< HEAD
    b.birth(DNA);
  }
  
  void birth(float[] fatherDNA) {
    float[] childDNA = new float[10];
    for (int i = 0; i < DNA.length; i++) {
      childDNA[i] = (DNA[i] + fatherDNA[i]) / 2;
    }
    
    Bud child = new Bud(p.x, p.y, childDNA);
    child.v = PVector.fromAngle(angle).mult(0.5);
    buds.add(new Bud(p.x, p.y, childDNA));
    
=======
    Bud child = new Bud(b.p.x, b.p.y, buds.size());
    buds.add(child);
    effects.add(new Effect(p.x - 10, p.y - d, "BIRTH"));
    totalbirths++;
    mateCooldown = 10;
    b.mateCooldown = 10;
>>>>>>> 3861b6e8be8743701e95679109369a2d98b4899c
  }

  void eat(Flower f) {
    effects.add(new Effect(p.x - 5, p.y - d, "EAT"));
    lifespan += 5;
    d = d + f.size/10;
    flowers.remove(f);
    feedCooldown = 5;
  }

  float evaluateMate(Bud b) {
    float difR = abs(red(b.c)-red(c))/255 + 0.5;
    float difG = abs(green(b.c)-green(c))/255 + 0.5;
    float difB = abs(blue(b.c)-blue(c))/255 + 0.5;
    float difColor = difR*difG*difB;
    //println(1 - difColor);
    return 1 - difColor;
  }

  Bud getClosestBud() {

    ArrayList<Bud> budsInView = getBudsInView();

    Bud closestBud = null;

    if (!budsInView.isEmpty()) {

      float closestDistance = PVector.dist(p, budsInView.get(0).p);
      closestBud = budsInView.get(0);

      for (Bud b : budsInView) {
        float distance = PVector.dist(p, b.p);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestBud = b;
        }
      }
    }

    return closestBud;
  }

  Flower getClosestFlower() {

    ArrayList<Flower> flowersInView = getFlowersInView();

    Flower closestFlower = null;

    if (!flowersInView.isEmpty()) {

      float closestDistance = PVector.dist(p, flowersInView.get(0).p);
      closestFlower = flowersInView.get(0);

      for (Flower f : flowersInView) {
        float distance = PVector.dist(p, f.p);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestFlower = f;
        }
      }
    }

    return closestFlower;
  }

  ArrayList<Bud> getBudsInView() {

    ArrayList<Bud> budsInView = new ArrayList<Bud>();

    for (Bud b : buds) {
      if (this != b) {
        float distance = PVector.dist(p, b.p);
        if (distance <= 50) {
          budsInView.add(b);
        }
      }
    }

    return budsInView;
  }

  ArrayList<Flower> getFlowersInView() {

    ArrayList<Flower> flowersInView = new ArrayList<Flower>();

    for (Flower f : flowers) {
      float distance = PVector.dist(p, f.p);
      if (distance <= 50) {
        flowersInView.add(f);
      }
    }

    return flowersInView;
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
    
    decide();
    fatigue();

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
    
    angle = map(noise(angleNoiseSeed, age*0.1),0,1,-2*PI,2*PI);
    
    if (mateCooldown > 0) {
      mateCooldown = mateCooldown - 1.0/60;
    }
    
    if (feedCooldown > 0) {
      feedCooldown = feedCooldown - 1.0/60;
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
    
    //eye
    fill(0);
    noStroke();
    ellipse(0, d-7.5, 5, 5);

    popMatrix();

    noStroke();
    //text(nf(v.mag(),0,3), d/2, 0);

    text(puberty, d/2, 0);

    popMatrix();
  }
}