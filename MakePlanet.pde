// planet contains all the planet in the solar system
class Planet{
  
  int radius;
  int distance;
  float angle;
  float speed;
  PVector vector;
  PShape planet;
  String name;
  float mass;
  PVector velocity = new PVector(0, 0,0);
  Moon moon;
  
  ///////////////
    PVector location;
  float forceAmount;
  
  
  Planet(PVector loc, float frcAmt){
    location = loc;
    forceAmount = frcAmt;
  }
  

  PVector getForce(PVector otherObjectLocation){
    float distance = location.dist(otherObjectLocation);
    
    // work out unit direction force towards other point i.e. the "push" direction
    // and multiply by forceAmt
    PVector unitForce = PVector.sub(otherObjectLocation,location).normalize();
    PVector force = unitForce.mult(forceAmount);
    
    // return this force divided by the distance
    return force.div(distance);
  }
  ///////////////
  
  Planet(int radius, int distance, float angle, float speed, PVector vector, PImage texture, String name, Moon moon){
    this.radius = radius;
    this.distance = distance;
    this.angle = angle;
    this.speed = speed;
    this.vector = vector;
    this.name = name;
    this.moon = moon;
    
    noStroke();
    noFill();
    planet = createShape(SPHERE, radius);
    planet.setTexture(texture);
  }
  
  void orbit(){
    angle += speed;
    if(angle >= 360){
      angle = 0;
    }
    if(moon != null){
      moon.orbit();
    }
  }
  
  void display(){
    pushMatrix();
    rotateX(radians(rotateX));
    rotateY(radians(angle));
    translate(distance * vector.x, vector.y, vector.z);
    shape(planet);
    textAlign(CENTER);
    textSize(16);
    text(name, 0, radius + 30);
    if(moon != null){
      moon.display();
    }
    popMatrix();
  }
  
    boolean planetsCollide(Planet otherMover){
    
    if(otherMover == this) return false; // can't collide with yourself!
    
    float distance = otherMover.location.dist(this.location);
    float minDist = otherMover.radius + this.radius;
    if (distance < minDist)  return true;
    return false;
  }
  
    void collisionResponse(Planet otherMover) {
    // based on 
    // https://en.wikipedia.org/wiki/Elastic_collision
    
     if(otherMover == this) return; // can't collide with yourself!
     
     
    PVector v1 = this.velocity;
    PVector v2 = otherMover.velocity;
    
    PVector cen1 = this.location;
    PVector cen2 = otherMover.location;
    

    float massPart1 = 2*otherMover.mass / (this.mass + otherMover.mass);
    PVector v1subv2 = PVector.sub(v1,v2);
    PVector cen1subCen2 = PVector.sub(cen1,cen2);
    float topBit1 = v1subv2.dot(cen1subCen2);
    float bottomBit1 = cen1subCen2.mag()*cen1subCen2.mag();
    
    float multiplyer1 = massPart1 * (topBit1/bottomBit1);
    PVector changeV1 = PVector.mult(cen1subCen2, multiplyer1);
    
    PVector v1New = PVector.sub(v1,changeV1);
    

    float massPart2 = 2*this.mass/(this.mass + otherMover.mass);
    PVector v2subv1 = PVector.sub(v2,v1);
    PVector cen2subCen1 = PVector.sub(cen2,cen1);
    float topBit2 = v2subv1.dot(cen2subCen1);
    float bottomBit2 = cen2subCen1.mag()*cen2subCen1.mag();
    
    float multiplyer2 = massPart2 * (topBit2/bottomBit2);
    PVector changeV2 = PVector.mult(cen2subCen1, multiplyer2);
    
    PVector v2New = PVector.sub(v2,changeV2);
    
    this.velocity = v1New;
    otherMover.velocity = v2New;
    
  }
}
