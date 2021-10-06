
class Apollo {
  
  Timer timer = new Timer();
  
  // for working out mass
  float radius = 20;
  private float mass = 1;
  
 
  SimObjectManager simObjectManager = new SimObjectManager();
  
  PVector location = new PVector(width/2, height/2);
  PVector velocity = new PVector(0, 0,0);
  PVector acceleration = new PVector(0,0,0);
  
  
  Apollo() {
    
    // initial positioning of the spaceship
    
    this.location.x = 0;
    this.location.y = 1000;
    this.location.z = 9000;
    
    // load the obj file.
    SimModel Apollo = new SimModel();
    Apollo.setWithPShape(loadShape("apollo1.obj"));
    simObjectManager.addSimObject(Apollo,"Apollo");
   Apollo.setPreferredBoundingVolume("sphere"); 
   Apollo.showBoundingVolume(false);
    setMass(1);
  }
  
  void setMass(float m){
    // converts mass into surface area
    mass=m;
    radius = 60 * sqrt( mass/ PI );
    
  }
  
  
    void update() {
    float ellapsedTime = timer.getElapsedTime();
    applyFriction();
    PVector accelerationOverTime = PVector.mult(acceleration, ellapsedTime);
    velocity.add(accelerationOverTime);
    
    this.location.x = this.location.x;
    this.location.y = this.location.y;
    this.location.z = this.location.z;
    
    
    // scale the movement by time elapsed
    PVector distanceMoved = PVector.mult(velocity, ellapsedTime);
    location.add(distanceMoved);
    acceleration = new PVector(0,0,0);
    
    
  }
  
  
  void addForce(PVector f){
   PVector accelerationEffectOfForce = PVector.div(f, mass);
    acceleration.add(accelerationEffectOfForce);
  }
  

  void display(){
    pushMatrix();
    rotateX(radians(rotateX));
    scale(.1);
    translate(this.location.x, this.location.y, this.location.z);
    rotateX(PI);
    simObjectManager.getSimObject("Apollo").drawMe();
    popMatrix();
  }
  

  
  void applyFriction(){

    PVector dampAmount = PVector.mult( velocity, -0.01 );
    addForce(dampAmount);
  }
  
  
  
  
 ////////////////////////////////////////////////////////////////////////
 /////////////////////collision////////////////////////////////////////// 
  boolean ApolloCollision(Apollo otherMover){
    
    if(otherMover == this) return false; // can't collide with yourself!
    
    float distance = otherMover.location.dist(this.location);
    float minDist = otherMover.radius + this.radius;
    if (distance < minDist)  return true;
    return false;
  }
  
  void collisionResponse(Planet otherMover) {

     
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
  
 
 /////////////////////////////////////////////////////////////////////////
 
 
  
  void resetPosition() {
    this.location.x = 0;
    this.location.y = 1500;
    this.location.z = 9000;
  }
}
