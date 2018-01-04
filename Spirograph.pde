import controlP5.*; //for slider
import processing.pdf.*; //for outputting PDF


float r = 370;
float a = 0;
float za = 5*PI/180;
float zza = PI/1800;
float d = 60*PI/180;;
float zd=1*PI/180;
float t=0;
float zt=PI/1800;
float e;
int iterationsPerFrame = 2000; // can set this much lower than totalIterations in order to have an animated effect (e.g. 60)
int totalIterations = 2000;
boolean shouldDrawCompleteFigureEveryFrame = true; //if true iterationsPerFrame is always equal to totalIterations
int iterations = 0;
boolean recordPDF = false;
boolean isRecording = false;
boolean shouldClear = true;

PGraphicsPDF pdf;
ControlP5 cp5;
Slider iterationSlider;

void setup() {
  
  fullScreen(P2D);
  pixelDensity(displayDensity());
  //smooth();
  stroke(0);
  strokeWeight(0.5);
  frameRate(60);
  background(255);
  
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  iterationSlider = cp5.addSlider("totalIterations")
    .setPosition(20,50)
    .setRange(30,10000)
    .setSize(20,300)
    .setColorCaptionLabel(0) 
    .setCaptionLabel("Iter") 
  ;
    
}


void draw() {
  
  if (shouldClear && !recordPDF){
    background(255);
    a=0;
    iterations = 0;
    shouldClear = false;
  }
 
  checkKeys();
  
  if(!isRecording && iterations<iterationsPerFrame) { //so as not to print this twice per render
    fill(0);
    text("za:"+str(za*180/PI)+"    d:"+str(d*180/PI)+"    t:"+str(t*180/PI),20,20);
  }
  
  if (recordPDF && !isRecording) {
    pdf = (PGraphicsPDF) createGraphics(width*2, height*2, PDF, "spiroPDFS/Spirograph za="+str(za)+", d="+str(d)+", t="+str(t)+".pdf");
    beginRecord(pdf);
    strokeWeight(0.5);
    isRecording = true;
    println("began PDF record");
    background(255);
    a=0;
    iterations = 0;
    shouldClear = false;
  }
  
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
  
   if (recordPDF && iterations > totalIterations) {
    endRecord();
    recordPDF = false;
    isRecording = false;
    println("ended PDF record after "+str(iterations)+" iterations");
  }
  
  if(!isRecording){
    cp5.draw(); 
  }


}

void checkKeys() {
  if (keyPressed) {
    shouldClear = true;
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

void keyPressed() {
  if (key == 'p') {
    recordPDF = true;
  }
}

void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(iterationSlider)) {
      if(shouldDrawCompleteFigureEveryFrame){
        iterationsPerFrame = totalIterations;
      }
      shouldClear = true;
  }
}