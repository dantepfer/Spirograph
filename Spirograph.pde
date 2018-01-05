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
int iterationsPerFrame = 4000; // can set this much lower than totalIterations in order to have an animated effect (e.g. 60)
int totalIterations = 2000;
boolean shouldDrawCompleteFigureEveryFrame = true; //if true iterationsPerFrame is always equal to totalIterations
int iterations = 0;
boolean recordPDF = false;
boolean isRecording = false;
boolean needsRedraw = true;
float transX = 0;
float transY = 0;
float ztransX = 10;
float ztransY = 10;
float scale = 1;
float zscale = 1.1;

boolean[] controls = new boolean[12];
//0=q,1=a,2=w,3=s,4=e,5=d,6=left,7=up,8=right,9=down,10=zoom in,11=zoom out

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
  
  for (int i = 0; i < controls.length; i++) {
    controls[i] = false;
  }
    
}


void draw() {
  
  applyControls();  
  if ((keyPressed | needsRedraw) && !recordPDF){
    background(255);
    a=0;
    iterations = 0;
    needsRedraw = false;
  }
  
  if(!isRecording && iterations<iterationsPerFrame) { //so as not to print more than once per render
    fill(0);
    text("za:"+str(za*180/PI)+"    d:"+str(d*180/PI)+"    t:"+str(t*180/PI),20,20);
  }
  
  if (recordPDF && !isRecording) {
    pdf = (PGraphicsPDF) createGraphics(width*2, height*2, PDF, "spiroPDFS/Spirograph za="+str(za)+", d="+str(d)+", t="+str(t)+".pdf");
    beginRecord(pdf);
    isRecording = true;
    println("began PDF record");
    background(255);
    a=0;
    iterations = 0;
    needsRedraw = false;
  }
  
  pushMatrix();
  scale(scale);
  translate((width/2)/scale+transX,(height/2)/scale+transY);
  strokeWeight(0.5/scale);
  beginShape(LINES);
  for (int i=0; i<iterationsPerFrame; i++){
   
    if (iterations++ < totalIterations){
      a = a+za;
      vertex( r*tan(a), 
              r*sin(a*t));
      
      vertex( r*tan(a+d+t*a),
              r*cos(a+d+t*a));
    }
    
  }
  endShape();
  popMatrix();
  
  
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

void keyPressed() {
  if (key == 'q') {controls[0]=true;} 
  if (key == 'a') {controls[1]=true;} 
  if (key == 'w') {controls[2]=true;} 
  if (key == 's') {controls[3]=true;} 
  if (key == 'e') {controls[4]=true;} 
  if (key == 'd') {controls[5]=true;} 
  if (keyCode == LEFT) {controls[6]=true;} 
  if (keyCode == UP) {controls[7]=true;} 
  if (keyCode == RIGHT) {controls[8]=true;} 
  if (keyCode == DOWN) {controls[9]=true;} 
  if (key == '/') {controls[10]=true;} 
  if (keyCode == ALT) {controls[11]=true;}
  if (key == 'p') {recordPDF = true; }
}

void keyReleased() {
  if (key == 'q') {controls[0]=false;} 
  if (key == 'a') {controls[1]=false;} 
  if (key == 'w') {controls[2]=false;} 
  if (key == 's') {controls[3]=false;} 
  if (key == 'e') {controls[4]=false;} 
  if (key == 'd') {controls[5]=false;} 
  if (keyCode == LEFT) {controls[6]=false;} 
  if (keyCode == UP) {controls[7]=false;} 
  if (keyCode == RIGHT) {controls[8]=false;} 
  if (keyCode == DOWN) {controls[9]=false;} 
  if (key == '/') {controls[10]=false;} 
  if (keyCode == ALT) {controls[11]=false;}
}

void applyControls() {
  if(controls[0]){za += zza;}
  if(controls[1]){za -= zza;}
  if(controls[2]){d += zd;}
  if(controls[3]){d -= zd;}
  if(controls[4]){t += zt;}
  if(controls[5]){t -= zt;}
  if(controls[6]){transX += ztransX/scale;}
  if(controls[8]){transX -= ztransX/scale;}
  if(controls[7]){transY += ztransY/scale;}
  if(controls[9]){transY -= ztransY/scale;}
  if(controls[10]){scale *= zscale;}
  if(controls[11]){scale /= zscale;}
}

void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(iterationSlider)) {
      if(shouldDrawCompleteFigureEveryFrame){
        iterationsPerFrame = totalIterations;
      }
      needsRedraw = true;
  }
}