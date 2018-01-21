import controlP5.*; //for slider
import processing.pdf.*; //for outputting PDF
import themidibus.*; 

float r = 370;
float a = 0;
float za = 5*PI/180;
float zza = PI/1800;
float d = 60*PI/180;
float zd=1*PI/180;
float t=0;
float zt=PI/1800;
float g=0;
int iterationsPerFrame = 4000; // can set this much lower than totalIterations in order to have an animated effect (e.g. 60)
int totalIterations = 2000;
boolean shouldDrawCompleteFigureEveryFrame = true; //if true iterationsPerFrame is always equal to totalIterations
int iterations = 0;
boolean showIterationSlider = false;
boolean recordPDF = false;
boolean isRecording = false;
boolean needsRedraw = true;
float transX = 0;
float transY = 0;
float ztransX = 10;
float ztransY = 10;
float scaleX = 1;
float scaleY = 1;
float zscale = 1.1;
float rotationZ;
float lineWeight = 0.5;

int drawMode = 0;
int numModes = 12;

boolean[] controls = new boolean[14]; //keep track of what control key is pressed
//0=q,1=a,2=w,3=s,4=e,5=d,6=left,7=up,8=right,9=down,10=/,11=option out,12=r,13=f

PGraphicsPDF pdf;
ControlP5 cp5;
Slider iterationSlider;
MidiBus midiBusLaunchControl;  //Launch Control MIDI Device
int midiControllerFaderNumbers[] = {41, 42, 43, 44, 45, 46, 47, 48}; //midi controller number for the faders 
int midiControllerButtonNumbers[] = {1, 2, 3, 4, 5, 6, 7, 8}; //midi controller number for the buttons 

void setup() {
  
  fullScreen(P2D); //try FX2D
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
  
  MidiBus.list();
  midiBusLaunchControl = new MidiBus(this, "Launch Control", "");  
    
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
    text("za:"+str(za*180/PI)+"  d:"+str(d*180/PI)+"  t:"+str(t*180/PI)+"  g:"+str(g*180/PI)+"  mode:"+str(drawMode),20,20);
  }
  
  if (recordPDF && !isRecording) {
    pdf = (PGraphicsPDF) createGraphics(width*2, height*2, PDF, "spiroPDFS/Spirograph "+str(hour())+str(minute())+str(second())+" za="+str(za)+", d="+str(d)+", t="+str(t)+", g="+str(t)+", mode="+str(drawMode)+".pdf");
    beginRecord(pdf);
    isRecording = true;
    println("began PDF record");
    background(255);
    a=0;
    iterations = 0;
    needsRedraw = false;
  }
  
  pushMatrix();
  scale(scaleX,scaleY);
  translate((width/2)/scaleX+transX,(height/2)/scaleY+transY);
  rotate(rotationZ);
  strokeWeight(lineWeight/((scaleX+scaleY)/2));
  beginShape(LINES);
  for (int i=0; i<iterationsPerFrame; i++){
   
    if (iterations++ < totalIterations){
      a = a+za;
      drawVertices(drawMode);
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
  
  if(!isRecording && showIterationSlider){
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
  if (key == 'r') {controls[12]=true;} 
  if (key == 'f') {controls[13]=true;} 
  if (keyCode == LEFT) {controls[6]=true;} 
  if (keyCode == UP) {controls[7]=true;} 
  if (keyCode == RIGHT) {controls[8]=true;} 
  if (keyCode == DOWN) {controls[9]=true;} 
  if (key == '/') {controls[10]=true;} 
  if (keyCode == ALT) {controls[11]=true;}
  if (key == 'p') {recordPDF = true; }
  if (key == '-') {drawMode=constrain(drawMode-1,0,numModes-1);reset();}
  if (key == '=') {drawMode=constrain(drawMode+1,0,numModes-1);reset();}
}

void keyReleased() {
  if (key == 'q') {controls[0]=false;} 
  if (key == 'a') {controls[1]=false;} 
  if (key == 'w') {controls[2]=false;} 
  if (key == 's') {controls[3]=false;} 
  if (key == 'e') {controls[4]=false;} 
  if (key == 'd') {controls[5]=false;} 
  if (key == 'r') {controls[12]=false;} 
  if (key == 'f') {controls[13]=false;} 
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
  if(controls[6]){transX += ztransX/scaleX;}
  if(controls[8]){transX -= ztransX/scaleX;}
  if(controls[7]){transY += ztransY/scaleY;}
  if(controls[9]){transY -= ztransY/scaleY;}
  if(controls[10]){scaleX *= zscale;}
  if(controls[11]){scaleX /= zscale;}
  if(controls[12]){g += zt;}
  if(controls[13]){g -= zt;}
}

void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(iterationSlider)) {
      if(shouldDrawCompleteFigureEveryFrame){
        iterationsPerFrame = totalIterations;
      }
      needsRedraw = true;
  }
}

void controllerChange(int channel, int number, int value) {
  // Receive a contr  ollerChange
    if (number == midiControllerFaderNumbers[7]) {
      totalIterations = int(10000.0*value/127.0);
      if(shouldDrawCompleteFigureEveryFrame){
        iterationsPerFrame = totalIterations;
      }
    }
    if (number == midiControllerFaderNumbers[0]) {
      zza = PI/180000.0*value/127.0;
    }
    if (number == midiControllerFaderNumbers[1]) {
      zd = PI/180.0*value/127.0;
    }
    if (number == midiControllerFaderNumbers[2]) {
      zt = PI/1800.0*value/127.0;
    }
    if (number == midiControllerFaderNumbers[3]) {
      lineWeight = value/127.0;
    }
    if (number == midiControllerFaderNumbers[6]) {
      if(value == 0){rotationZ=0;}else{rotationZ = (value+1)/128.0*PI;} // so we can get PI/2 on the button
    }
    needsRedraw=true;
}

void mouseDragged(){
   transX+=(mouseX-pmouseX)/scaleX;
   transY+=(mouseY-pmouseY)/scaleY;
   needsRedraw=true;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scaleX *= pow(zscale,-e/2);
  scaleY *= pow(zscale,-e/2);
  needsRedraw=true;
}

void reset(){
  scaleX=1;
  scaleY=1;
  transX=0;
  transY=0;
}