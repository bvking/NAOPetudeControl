void samplingMovementPro() {
   // currTime = millis() * 0.001;  // seconds since app started
    float polarToCartesionX= displacement*cos(newPosF[networkSize-1]);
    float polarToCartesionY= displacement*sin(newPosF[networkSize-1]);
   if( bRecording ) {
    circle( polarToCartesionX,polarToCartesionY, 10 );
    sampler.addSample( newPosF[networkSize-1], newPosF[networkSize-1] ); // polar Version
  //  sampler.addSample( polarToCartesionX, polarToCartesionY ); // cartesian version

  print (" 679 SEC  mouse Y REC " );  print (mouseY);  print (" v1 REC " );  print (v1);
  print (" 679 SEC  mouse Y REC " );  print (mouseY);  print (" v1 REC " );  println (v1);
 
  //**   samplers.get(samplers.size()-1).addSample( currTime, mouseX, v1InMainLoop );

 //net.phase[networkSize-1]=  map (mouseY, 0, height/2, 0, TWO_PI);
  //*** */  newPosF[0]=  map (mouseY, 0, height/2, 0, TWO_PI);// uncomment doesn't change anything

  }
 else {
    if( sampler.fullTime() > 0 )
        sampler.draw();
  }
}

void activeSamplingSecond() { 
   if (actualSec<=0 && actualSec!=lastSec && mouseRecorded == true) {
  bRecording = true;
 //*** samplers.add( new Sampler( nextSamplePeriod, currTime, mouseX, mouseY ) );
 // net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
//  newPosF[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
  
  
}
}


void activeSamplingMeasure(int beginMeasure) {    
  if (measure==beginMeasure && beatTrigged == true && mouseRecorded == true){   //  && measure>=beginMeasure
    println (" BEGINTRACK ");      println (" BEGINTRACK ");        println (" BEGINTRACK ");
    // net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
   //*** */    newPosF[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);

  bRecording = true; 
  sampler.beginRecording();
   print (" 12689 MEA  mouse Y rec " );  println (mouseY); 
  }
}
void stopSamplingMeasure(int endMeasure) { 
    
   if (measure<=endMeasure  && beatTrigged == true) { // && measure>=endMeasure
     println (" ENDTRACK ");     println (" ENDTRACK ");       println (" ENDTRACK ");
    //  net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
    //    newPosF[networkSize-0]= (float) map (mouseY, 0, height/2, 0, TWO_PI);

  mouseRecorded = false;
  bRecording = false;
  sampler.beginPlaying();
  }
}
void activeSamplingInternalClock(int beginMeasure) { 
   if (measure<=beginMeasure && measure>=beginMeasure && actualSec!=lastSec && mouseRecorded == true) {

      //  net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
        //  newPosF[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);

  bRecording = true;
  sampler.beginRecording();
  }
}
void stopSamplingInternalClock(int endMeasure) { 
   if (measure<=endMeasure && measure>=endMeasure && actualSec!=lastSec) {

      //  net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
      //    newPosF[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);

  mouseRecorded = false;
  bRecording = false;

  sampler.beginPlaying();
  }
}