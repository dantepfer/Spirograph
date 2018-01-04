
float r = 370;
float a = 0;
float za = 5*PI/180;
float zza = 0.5*PI/180;
float d = 60;
float zd=1*PI/180;
float t=0;
float zt=PI/1800;
float e;
int iterationsPerFrame = 600;
int totalIterations = 1000;
int iterations = 0;



void setup() {
  
  fullScreen(P2D);
  pixelDensity(displayDensity());
  smooth();
  stroke(0);
  strokeWeight(0.5);
  frameRate(60);
  background(255);
    
}


void draw() {
 
  checkKeys();
  
  beginShape(LINES);
  for (int i=0; i<iterationsPerFrame; i++){
   
    if (iterations++ < totalIterations){
      a = a+za;
      vertex( r*cos(a)+width/2, 
              r*sin(a)+height/2);
      
      vertex( r*cos(a+d+t*a)+width/2,
              r*sin(a+d+t*a)+height/2);
    }
  }
  endShape();
  


}

void checkKeys() {
  if (keyPressed) {
    background(255);
    a=0;
    iterations = 0;
    if (key == 'w') {
      d = d+zd;
    } 
    if (key == 's') {
      d = d-zd;
    } 
    if (key == 'a') {
      za = za-zza;
    } 
    if (key == 'q') {
      za = za+zza;
    } 
    if (key == 'e') {
      t = t+zt;
    } 
    if (key == 'd') {
      t = t-zt;
    } 
  }
}