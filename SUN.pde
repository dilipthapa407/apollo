
class Sun {
  
  float angle;
  float speed;
  
  Timer timer = new Timer();
  
  // for working out mass
  float radius;
  private float mass = 1;
  
 
  SimObjectManager simObjectManager = new SimObjectManager();
  
  PVector location = new PVector(width/2, height/2);
  PVector velocity = new PVector(0, 0,0);
  PVector acceleration = new PVector(0,0,0);
  
  
  Sun(float angle, float speed, float radius) {
  
    
    // initial positioning of the Sun
    this.radius = radius;
    this.angle = angle;
    this.speed = speed;
    this.location.x = 0;
    this.location.y = 0;
    this.location.z = 0;
    
    // load the obj file.
     SimSphere oursun = new SimSphere(vec(0,0,0), radius);
    simObjectManager.addSimObject(oursun,"sun");
    
    
    setMass(1);
  }
  
  void orbit(){
    angle += speed;
    if(angle >= 360){
      angle = 0;
    }
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
    rotateY(radians(angle));
    rotateX(PI);
    
    simObjectManager.getSimObject("sun").drawMe();
    popMatrix();
  }
  
  //applying friction to the spaceship
  
  void applyFriction(){

    PVector dampAmount = PVector.mult( velocity, -0.01 );
    addForce(dampAmount);
  }
  
} 
 ////////////////////////////////////////////////////////////////////////
 /////////////////////collision////////////////////////////////////////// 
