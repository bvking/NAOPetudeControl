//followSignalSampledOppositeWay.pde
float [] newPosFollowed= new float [networkSize];

void followSignalSampledOppositeWay(int ratioTimeFrame){

  
if (formerDecayTime>decayTime){
  frameCountBis=frameCountBis+1;
  } 
  formerDecayTime = decayTime;
  decayTime = millis()%100;// incremente frameCountBis+1 each 100 millisecondes
 
  int delayRatio=ratioTimeFrame;

 //**   samplingMovement(2);
 //**    phases[0][frameCountBis % nbMaxDelais]= newPosF[0];
     
  //  keyReleasedfollowSignal(); useless  phseShifting is controlled in keyRelesead
      float deltaFollow = TWO_PI; // not used
     //here in a previous function we could change the ball followed if the space of phase between phases[0] and phase 9 is more than 360° for example

    samplingMovementPro();
    println ( "  movementInterpolated in FOLLOW opposite WAY", movementInterpolated,
               " oldmovementInterpolated ", oldMovementInterpolated );
   // if (oldMovementInterpolated>movementInterpolated){
   //   movementInterpolated= map (movementInterpolated, 0, TWO_PI, TWO_PI, 0);
   //    }
      for (int i = 0; i < 1; i+=1) {  // number of sample is 55
   println ( "  samplesModified.get(i).y " + i +  " " + positionInterpolatedY);
     }
    phases[0][frameCountBis % nbMaxDelais]=movementInterpolatedContinue;
    //MAP movementInterpolated
    
    if (phases[0][frameCountBis % nbMaxDelais]<0){
   
     DataToDueCircularVirtualPosition[0]= int (map (phases[0][frameCountBis % nbMaxDelais], 0, -TWO_PI, numberOfStep, 0)); 
 
     phases[0][frameCountBis % nbMaxDelais]= map (DataToDueCircularVirtualPosition[0], numberOfStep, 0, 0, -TWO_PI);
   //   newPosF[i]= phaseMapped[i];

       }
       
   else {
    
    DataToDueCircularVirtualPosition[0]= (int) map (phases[0][frameCountBis % nbMaxDelais], 0, TWO_PI, 0, numberOfStep); 

      phases[0][frameCountBis % nbMaxDelais]= map (DataToDueCircularVirtualPosition[0], numberOfStep, 0, 0, -TWO_PI);
   
  }
   drawBallOppositeWay(  0, phases[0][frameCountBis % nbMaxDelais] );  
  //   newPosFollowed[i]

      newPosFollowed[0]= phases[0][frameCountBis % nbMaxDelais]%TWO_PI;



    //  drawBallOppositeWay(0, phases[0][frameCountBis % nbMaxDelais]); //networkSize-5 affiche le point 0. NE PAS AFFICHER SINON IL APPARAIT EN DOUBLE
 
    for (int i = 1; i < networkSize; i+=1) { // 1 follow phase 0
       
  //   follow( i-1, i, 20 * i, 0);  // Modifier les deux derniers paramètres : délais et phase
     followOppositeWay( i-1, i+0, delayTimeFollowPhase11*1*frameRatio/ratioTimeFrame, (phaseShiftingFollowPhase11));  // ici, le temps que les points attendent pour se suivre est de 5 frames, et il faut un espace entre eux de QUARTER_PI/6

  //*** phaseMapped[i]=phases[i-0][frameCountBis % nbMaxDelais]; // use varaible phaseMapped (to play movement with time delay or phase delay) to well send it in Teensy
  // newPosFollowed[i]=phaseMapped[i]; // display data and use them to control motor

   
 
    drawBallOppositeWay( i, phases[i-0][frameCountBis % nbMaxDelais] );
   
   // net.phase[i]=phaseMapped[i]; // display data and use them to control motor  
 
   // drawBallOppositeWay(  i, phases[i+0][frameCountBis % nbMaxDelais] );  
 }
 
 
  if (formerFormerKey == '#' || modeStartKeyToFollow == " followSignalSampledOppositeWay(frameRatio) ") {
    
println ( " modeStartKeyToFollow " + modeStartKeyToFollow);

      for (int i = 0; i < networkSize-0; i+=1) { 
        
       newPosFollowed[i]=phases[i-0][frameCountBis % nbMaxDelais]; // signals to follow
       newPosFollowed[i]=newPosFollowed[i]%TWO_PI;  // signals to follow

       phaseMapped[i] = newPosFollowed[i]+phaseMappedFollow[i]; // new signal is a composition 
   
    if (phaseMapped[i]<0){
   
     DataToDueCircularVirtualPosition[i]= int (map (phaseMapped[i], 0, -TWO_PI, numberOfStep, 0)); 
 
      phaseMapped[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
   //   newPosF[i]= phaseMapped[i];

       }
       
   else {
    
    DataToDueCircularVirtualPosition[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, numberOfStep); 

      phaseMapped[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
    //  newPosF[i]= phaseMapped[i];
    }
  }
  
 }

    if (key != '#' ) {
    if (modeStartKeyToFollow == " followSignalSampledOppositeWay(frameRatio) ") {
     phasePattern();
     
    for (int i = 0; i < networkSize-0; i+=1) { 
    phaseMappedFollow[i]= net.phase[i];// add offset given by pendularPattern   
    phaseMappedFollow[i]= phaseMappedFollow[i]%TWO_PI;  
    }
   }
  }
   if (keyCode == BACKSPACE ) {
    
      for (int i = 0; i < networkSize-0; i+=1) { 
        println (" ALIGN MTF " );

    phaseMapped[i] = phases[i-0][frameCountBis % nbMaxDelais]+0; // to aligin ball with the followed one
   
    if (phaseMapped[i]<0){
   
    DataToDueCircularVirtualPosition[i]= int (map (phaseMapped[i], 0, -TWO_PI, numberOfStep, 0)); 
   //   net.oldPhase[i]=phaseMapped[i];
   //  net.phase[i]= phaseMapped[i];
   phaseMapped[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
       }
        
   else
  
   DataToDueCircularVirtualPosition[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, numberOfStep);
   phaseMapped[i]= map (DataToDueCircularVirtualPosition[i], 0, numberOfStep, 0, TWO_PI);

  }
 }

 for (int i = 0; i < networkSize-0; i+=1) { 
  newPosF[i]=phaseMapped[i]; // %TWO_PI      display data and use them to control motor
 // net.phase[i]=phaseMapped[i];
 print ( " newPosF[i] " + newPosF[i]);
  }

 send24DatasToTeensy6motors(10, 3, -3, -1);  // avant dernier >-1 alors compute data
 // mapDataToMotor(); // do not work
  
}

void countRevsLfoPattern11() { // =========================================== Ter NE PAS TOUCHER LE COMPTEUR ou Reduire l'espace avant et apres 0 pour eviter bug à grande vitesse

  for (int i = 1; i < 2; i++) { 
     print (" oldLfoCount[i] "); print (i); print (" ");  println (oldPhaseLfo[i]); print (" newPhaseLfoCount[i] ");; print (i); print (" ");    println (newPhaseLfo[i]); 
//**    print (net.oldPhase[i]); print ("count rev ");   println (net.phase[i]); 
    // decrement caused by negative angular velocity
    // both positive angles || both negative angles || positive-to-negative angle
    //   if (//(net.oldPhase[i] < 0.25 * PI && net.phase[i] > 1.75 * PI) ||//
    if (
      ((oldPhaseLfo[i] < 0.25 *PI && oldPhaseLfo[i]>0)  && (newPhaseLfo[i] > -0.25* PI && newPhaseLfo[i] <0))  || 
       (oldPhaseLfo[i] < -1.75 * PI && newPhaseLfo[i] > -0.25 * PI)// ||
       
    
      ) {
    
      //    TrigmodPos[i]=0;
      revLfo[i]--;
      //      print (" revultion negative  "); println (revolution[i]=i+1); 
      //   revolution[i]=i+1;
     revolution[i]=0; // trig 0 to sent 0 in Max4Live
      memoryi=i;


   //   decompte[i] = -1; // // RESET COUNTER AT 0 (i know it's strange, otherwise with 0 it begin at 1, not 0)
    } else { // if you do twice there is a funny bug
      //    decompte[i]  ++; 
      //   revolution[i]=0;
    }


    // increment caused by positive angular velocity
    // both positive angles || both negative angles || negative-to-positive angle

    if (
      ((oldPhaseLfo[i] > -0.25 *PI && oldPhaseLfo[i]<0)  && (newPhaseLfo[i] < 0.25* PI && newPhaseLfo[i] >0))  || 
       (oldPhaseLfo[i] > 1.75 * PI && newPhaseLfo[i] < 0.25*PI)
      ) {
      onOFF = 1;
      //   TrigmodPos[i]=0;
      revLfo[i]++;
      //   revolution[i]=i+1;
      revolution[i]=0;   // trig 0 to sent 0 in Max4Live
      memoryi=i;
      decompte[i] = 0;  // RESET COUNTER AT 0
    } else {

      decompte[i]  ++; //START COUNTER when a REVOLUTION START OR FINISH

      revolution[i]=1;
    }
     if (  revolution[i]<1) {
   print (" revolutionPattern[i] "); print ( memoryi); print ("  "); print (revolution[memoryi]);
    }
  
    print (" revPattern "); print ( i); print ("  "); println (revLfo[i]);
  }
  if (

   
    (newPhaseLfo[memoryi] < -1.75 * PI && newPhaseLfo[memoryi] >= -0.25*TWO_PI) || ( newPhaseLfo[memoryi]<=-TWO_PI+0.23  && newPhaseLfo[memoryi] >= -0.25*TWO_PI ) 
    ) {
    onOFF = 1;
    //   background (27,59,78);
    //    TrigmodPos[i]=0;
    rev[memoryi]--;
    //      print (" revultion negative  "); println (revolution[i]=i+1);
    //   revolution[i]=i+1;
//**** revolution[memoryi]=0; // trig 0 to sent 0 in Max4Live   brecause it count twice in negative way!!!
    // memoryi=i;


    decompte[memoryi] = -1; // // RESET COUNTER AT 0 (i know it's strange, otherwise with 0 it begin at 1, not 0)
  }
 
}

