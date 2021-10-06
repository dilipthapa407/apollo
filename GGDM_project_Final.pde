
spacestars[] Stars = new spacestars[500];
float speed, ang, angS;
SimCamera myCamera;

PShape menuApollo;
Apollo Apollo;
float speedApollo, cameraX, cameraY, cameraZ,rotateX;

PImage bgImg, sunImg, mercuryImg, venusImg, earthImg, moonImg, marsImg, jupiterImg, saturnImg, neptuneImg,menuBgImg;

Planet mercury, venus, earth, mars, jupiter, saturn, neptune;
Moon moon;
boolean menu, keyupdate, m, n, up, down, left, right, forward, backward,camera;
Sun Sun;





///menu earth
SimSphere earth1;
float earthRad = 120;

//// menu moon
SimSphere moon1;
float MenuMoonRad = 20;

///
SimObjectManager simObjectManager = new SimObjectManager();



void setup() {
  size (1400, 935, P3D);
  
  MakeTheStars();
  
   speedApollo = 20;
  menuApollo = loadShape("apollo1.obj");
  Apollo = new Apollo();
  Apollo.setMass(0.5);
  
   Sun = new Sun(0,0.25,1000);
   Sun.setMass(50);
  ang = 0;
  surface.setTitle("The solar System");
  menu = true;
  
  //// menu moon
  moon1 = new SimSphere(vec(100,0,100), MenuMoonRad);
  earth1 = new SimSphere(vec(100,0,100), earthRad);
  
  // trail for the sun
       //SimSphere oursun = new SimSphere(vec(0,0,0), 100);
    //simObjectManager.addSimObject(oursun,"sun");
   

  bgImg = loadImage("backgrd2.jpg");
  menuBgImg = loadImage("bg1.jpg");
  rotateX = 0.0;
  initSystem();

}

void draw() {
  if (camera) {
    
    
    cameraX = -Apollo.location.x/5;
    cameraY = -Apollo.location.y/5;
    cameraZ = -Apollo.location.z/5;
    
    beginCamera();
   camera();
    translate(cameraX, cameraY+30, cameraZ+1200);
    endCamera();
  
  }else{
    camera();
 }
  lights();
  if (menu){ menu();
  }
  else {
    background(bgImg);
    if(!camera) showHelp();
    translate(width/2, height/2, -550);
    //simObjectManager.getSimObject("sun").drawMe();
       if ( keyPressed ) {
    doKeyPress();
  }
  
   //float d = Apollo.location.dist(Sun.location);
   //float minDist = Apollo.radius + Sun.radius;
   // if (d < minDist){
   // earth.display();}
  
  
    ShowSolarSystem();
    rotateSystem();
   

  }
}

void initSystem() {
  sunImg = loadImage("Sun.jpg");
  mercuryImg = loadImage("Mercury.jpg");
  venusImg = loadImage("Venus.jpg");
  earthImg = loadImage("Earth.jpg");
  moonImg = loadImage("Moon.png");
  marsImg = loadImage("Mars.jpg");
  jupiterImg = loadImage("Jupiter.jpg");
  saturnImg = loadImage("Saturn.jpg");
  neptuneImg = loadImage("Neptune.jpg");
  
  //int radius, float distance, float angle, float speed, PVector vector(x,y,z) , PImage texture, String name
  
  this.moon = new Moon(15, 1.6, 0, 0.02, new PVector(55, 0, 1), moonImg, "Moon");
  this.mercury = new Planet (35, 4, 0,  0.50, new PVector(40, 0, 1), mercuryImg, "Mercury", null);
  this.venus = new Planet (45, 6, 0,  0.45, new PVector(40, 0, 1), venusImg, "Venus", null);
  this.earth = new Planet (55, 10, 0,  0.40, new PVector(40, 0, 1), earthImg, "Earth", moon);
  this.mars = new Planet (35, 13, 0,  0.35, new PVector(40, 0, 1), marsImg, "Mars", null);
  this.jupiter = new Planet (80, 18, 0,  0.30, new PVector(40, 0, 1), jupiterImg, "Jupiter", null);
  this.saturn = new Planet (65, 24, 0,  0.25, new PVector(40, 0, 1), saturnImg, "Saturn", null);
  this.neptune = new Planet (35, 30, 0,  0.20, new PVector(40, 0, 1), neptuneImg, "Neptune", null);
 
}

void ShowSolarSystem() {
  
  mercury.orbit();  mercury.display();
  venus.orbit();  venus.display();
  earth.orbit();  earth.display();
  mars.orbit();  mars.display();
  jupiter.orbit();  jupiter.display();
  saturn.orbit();  saturn.display();
  neptune.orbit();  neptune.display();
  Sun.orbit(); Sun.update(); Sun.display(); 
 Apollo.update(); Apollo.display();
}

void rotateSystem() {
  if (n && rotateX >= -45.0) rotateX -= 0.5;
  if (m && rotateX <= 45.0) rotateX += 0.5;
}



// Initial screen
void menu() {
  background(menuBgImg);
  translate(width/2, height/2);
  ShowStars();
  textSize(50);
  textAlign(CENTER);
  fill(255);
  text("Interstellar Space Station", 0,-250);
  text("Main Menu", 0,-190);
  textSize(25);
  fill(255);
  text("Press ENTER to continue", 0, 350);
  
  drawMenuPlanet();
}

// Display help
void showHelp() {
  textAlign(LEFT);
  text("> Press Q and E keys to rotate the planetary system.", 20,50);
  text("> Press R to reset.", 20, 100);
  text("> Press C for freeview.", 20, 150);
  text("> Press ESC to exit.", 20, 200);
  text(rotateX, 1420, 50);
  text("Apollo controls:", 20, 650);
  text("> Press ↑ to move UP.", 20, 700);
  text("> Press ↓ to move DOWN.", 20, 700);
  text("> Press ← to move LEFT.", 20, 750);
   text("> Press → to move RIGHT.", 20, 750);
  text("> Press W to move forward.", 20,800);
   text("> Press S to move backward.", 20,850);
  textAlign(RIGHT);
  text("Apollo position:", 1350, 650);
  text("X: " + Apollo.location.x, 1350, 700);
  text("Y: " + Apollo.location.y, 1350, 750);
  text("Z: " + Apollo.location.z, 1350, 800);
}


void MakeTheStars(){
  for (int i = 0; i < Stars.length; i++) {
    Stars[i] = new spacestars();
  }
}

// Show starfield
void ShowStars() {
  speed = 5;
  for (int i = 0; i < Stars.length; i++) {
    Stars[i].update();
    Stars[i].show();
  }
}

// Menu Planets
void drawMenuPlanet(){
  noStroke();
  rotateX(radians(-50));
  
   pushMatrix();
  rotateY(radians(ang));
  earth1.setTransformAbs( 1, 0,0,0, vec(-100,100,-150) );
 earth1.drawMe();
  popMatrix(); 
  
  
 
  
  // after a full turn, reset it.
  ang=ang+0.10;
  if (ang>360)
    ang=0;
    
  // 
  pushMatrix();
  rotateY(radians(angS));
  translate(-width*0.10,0,0);
  scale(0.09);
  rotateX(PI);
  rotateY(PI);
  shape(menuApollo);
  popMatrix();
  
  // after a full turn, reset it.
  angS=angS+0.5;
  if (angS>360)
    angS=0;
    
    beginShape();
    pushMatrix();
    rotateY(radians(ang));
    rotateY(radians(angS));
    moon1.drawMe();
    popMatrix();
    endShape();
    
    angS=angS+0.5;
  if (angS>360)
    angS=0;
}

void keyPressed() {
  if (keyCode == ENTER) menu = false;
  if (key == 'C' || key == 'c') camera = !camera;
  if (key == 'R' || key == 'r') {
    Apollo.resetPosition();
    rotateX = 0.0;
  }
  
  keyupdate = true;
  // camera angles
  if (key == 'Q' || key == 'q')n = keyupdate;
  if (key == 'E' || key == 'e') m = keyupdate;
}
void keyReleased() {
  keyupdate = false;
  if (key == 'Q' || key == 'q') n = keyupdate;
  if (key == 'E' || key == 'e') m = keyupdate;
}


void doKeyPress() {
  float forceAmmount = 100;

  if (key == CODED) {
    if (keyCode == LEFT) {
      Apollo.addForce( new PVector(-forceAmmount, 0) );
     
    }
    if (keyCode == RIGHT) {
      Apollo.addForce( new PVector(forceAmmount, 0) );
     
    }
    if (keyCode == UP) {
      Apollo.addForce( new PVector(0, -forceAmmount) );
     
    }
    if (keyCode == DOWN) {
      Apollo.addForce( new PVector(0, forceAmmount) );
      
    }
  }else
    
     if (key == 'W'|| key == 'w') {
      Apollo.addForce( new PVector(0, 0,-forceAmmount) );
      
    }
    
     if (key == 'S'|| key == 's') {
      Apollo.addForce( new PVector(0, 0,forceAmmount) );
      
    }
  
}
