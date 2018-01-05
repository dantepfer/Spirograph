void drawVertices(int theDrawMode){
      float e = t*a;
      float k = g*a;
      float ad = a+d;
  switch(theDrawMode){
    case 0: //original legit spirograph, with the e twist
      vertex( r*cos(a), 
              r*sin(a));
      vertex( r*cos(ad+e),
              r*sin(ad+e));
      break;

    case 1: //a new one from jan 4 2018
      vertex( r*cos(a), 
              r*sin(a*t));
      vertex( r*sin(ad+e),
              r*tan(ad));
      break;
      
    case 2: // original 1999 "v2" equation
      vertex( r*tan(e), 
              r*sin(e));
      vertex( r*tan(ad),
              r*tan(ad));
      break;
      
    case 3: //from "cool formulas" 
      vertex( r*atan(ad), 
              r*tan(ad));
      vertex( r*tan(a+e),
              r*atan(a+k));
    break;
      
    case 4: //from "cool formulas"
      vertex( r*tan(e), 
              r*sin(e));
      vertex( r*tan(ad),
              r*atan(ad));
    break;
    
    case 5: //from "cool formulas"
      vertex( r*cos(t)*2, 
              r*sin(e));
      vertex( r*sin(t)*2,
              r*cos(k));
    break;
    
    case 6: //from "cool formulas"
      vertex( r*cos(k), 
              r*cos(k));
      vertex( r*cos(e),
              r*sin(e));
    break;
    
    case 7: //from "cool formulas"
      vertex( r*cos(r+k), 
              r*sin(e));
      vertex( r*cos(e),
              r*sin(r+g));
    break;
    
    case 8: //from "spirograph B&W"
      vertex( r*cos(a+k), 
              r*sin(a+k));
      vertex( r*cos(e),
              r*sin(e));
    break;
       
    case 9: //from "weird spiros"
      vertex( r*cos(a+k), 
              r*sin(a+k));
      vertex( r*cos(e),
              r*sin(g));
    break;
    
    case 10: //from "weird spiros"
      vertex( r*cos(e), 
              r*sin(k));
      vertex( r*sin(e),
              r*cos(k));
    break;
    
    case 11: //from "weird spiros"
      vertex( r*cos(k), 
              r*sin(e));
      vertex( r*cos(e),
              r*sin(k));
    break;
          
           
  }
}