
void oscSend(){
 
  for (int i = 1; i < networkSize-0; i++) { 
    //    print (" upVelocity "); print (i); print ("  "); print ( upVelocity[i]);
    //    print (" dataToLive[i] "); println (dataToLive[0]);
   // Pos[0]=0;   
    oldPos[i]=Pos[i];
   
    //MIDDLE POINT == between 61 & 65
    if ((oldPos[i]<= 65 && Pos[i] >=61) ||
        (oldPos[i]>= 61 && Pos[i] <=65)) {

          dataToLive[i]= (networkSize-1)*(i-0);  // because there i beac you can send data with the step you want to separate controller depending oscillator --> here it is 11.
          dataToLive[0]= (networkSize-1)*(i-0);  // you can send data with the step you want to one controler 
      
        upVelocity[i]= 1;   
    }
    
       if ( Pos[i] >65 ||
            Pos[i] <61) {
       dataToLive[i]=0;
      upVelocity[i]= -1;
 
    }    
}

    downVelocity[1]=  upVelocity[2]* upVelocity[3]* upVelocity[4]* upVelocity[5];//* upVelocity[6];
    
               //       upVelocity[7]* upVelocity[8] * upVelocity[9]* upVelocity[10]* upVelocity[11];
                    
     if ( downVelocity[1]>0){ // if one of oscillator is at middle point
    Velocity=1;  
    }
     else  Velocity=-1; 
     
  OscMessage myMessage = new OscMessage("/test");
  OscMessage myMessage1 = new OscMessage("/trigLfo");
  OscMessage myMessage2 = new OscMessage("/Velocity");
  OscMessage myMessage3 = new OscMessage("/cohesion");
  OscMessage myMessage4 = new OscMessage("/upVelocity11");
  OscMessage myMessage5 = new OscMessage("/upVelocity10");
  OscMessage myMessage6 = new OscMessage("/upVelocity9");
  OscMessage myMessage7 = new OscMessage("/upVelocity8");
  OscMessage myMessage8 = new OscMessage("/upVelocity7");
  OscMessage myMessage9 = new OscMessage("/upVelocity6");
  OscMessage myMessage10= new OscMessage("/upVelocity5");
  OscMessage myMessage11= new OscMessage("/upVelocity4");
  OscMessage myMessage12= new OscMessage("/upVelocity3");
  OscMessage myMessage13= new OscMessage("/upVelocity2");
  
  OscMessage myMessage14= new OscMessage("/averageDeltaPhase");
  OscMessage myMessage15= new OscMessage("/startStop");
  OscMessage myMessage16= new OscMessage("/addPhase");
  OscMessage myMessage17= new OscMessage("/addPhaseAllMode");
  OscMessage myMessage18= new OscMessage("/mouseX"); // oscillator 
  OscMessage myMessage19= new OscMessage("/mouseY"); // oscillator behind

 
    float j= LevelCohesionToSend*1.0;
  myMessage.add((map ((j), 0, 1, 1, 127))); /* add an int to the osc message */
  myMessage1.add( trigLfo);
  float data10= DataToDueCircularVirtualPosition[networkSize-1]*1.0;   
  myMessage2.add(Velocity);
  myMessage3.add(LevelCohesionToSend);
  /*
  myMessage4.add(upVelocity[11]);
  myMessage5.add(upVelocity[10]);
  myMessage6.add(upVelocity[9]);
  myMessage7.add(upVelocity[8]);
  myMessage8.add(upVelocity[7]);
  myMessage9.add(upVelocity[6]);
*/
  myMessage10.add(upVelocity[5]);
  myMessage11.add(upVelocity[4]);
  myMessage12.add(upVelocity[3]);
  myMessage13.add(upVelocity[2]);
  
  myMessage14.add(averageDeltaPhase);
  myMessage15.add(startStop);
  myMessage16.add((map (addPhase, -1, 1, 0, 127)));
  myMessage17.add((map (addPhaseAllMode, -1, 1, 0, 127)));  
  myMessage18.add((float) map (mouseX, 0, 800, 0, 127));
  myMessage19.add((float) map (mouseY, 0, 800, 0, 127));

 

  OscMessage myMessage60= new OscMessage("/encodeur0"); // oscillator SEND ACCELERATION
  OscMessage myMessage61= new OscMessage("/encodeur1"); // oscillator 
  OscMessage myMessage62= new OscMessage("/encodeur2"); // oscillator 
  OscMessage myMessage63= new OscMessage("/encodeur3"); // oscillator 
  OscMessage myMessage64= new OscMessage("/encodeur4"); // oscillator 
  OscMessage myMessage65= new OscMessage("/encodeur5"); // oscillato

  myMessage60.add(encodeur[0]);  // send encodeur
  myMessage61.add(encodeur[1]);
  myMessage62.add(encodeur[2]);
  myMessage63.add(encodeur[3]);
  myMessage64.add(encodeur[4]);
  myMessage65.add(encodeur[5]);

  text  ( " enc " +  encodeur[0], 300, 300);

  


  JoDebug  ="<" // BPM9   
   // + (DataToDueCircularVirtualPosition[11])+","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
   // + DataToDueCircularVirtualPosition[6]+","
    +( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","
    + ">";
    
 
  OscMessage myMessage20= new OscMessage("/position11"); // oscillator front
  OscMessage myMessage21= new OscMessage("/position10"); // oscillator 
  OscMessage myMessage22= new OscMessage("/position9"); // oscillator 
  OscMessage myMessage23= new OscMessage("/position8"); // oscillator 
  OscMessage myMessage24= new OscMessage("/position7"); // oscillator 
  OscMessage myMessage25= new OscMessage("/position6"); // oscillato
  OscMessage myMessage26= new OscMessage("/position5"); // oscillator 
  OscMessage myMessage27= new OscMessage("/position4"); // oscillator 
  OscMessage myMessage28= new OscMessage("/position3"); // oscillator 
  OscMessage myMessage29= new OscMessage("/position2"); // oscillator behind
   
  OscMessage myMessage30= new OscMessage("/decompte11"); // oscillator SEND TRIG NOTE IN MAX4LIVE
  OscMessage myMessage31= new OscMessage("/decompte10"); // oscillator 
  OscMessage myMessage32= new OscMessage("/decompte9"); // oscillator 
  OscMessage myMessage33= new OscMessage("/decompte8"); // oscillator 
  OscMessage myMessage34= new OscMessage("/decompte7"); // oscillator 
  OscMessage myMessage35= new OscMessage("/decompte6"); // oscillato
  OscMessage myMessage36= new OscMessage("/decompte5"); // oscillator 
  OscMessage myMessage37= new OscMessage("/decompte4"); // oscillator 
  OscMessage myMessage38= new OscMessage("/decompte3"); // oscillator 
  OscMessage myMessage39= new OscMessage("/decompte2"); // oscillator behind
  
  OscMessage myMessage40= new OscMessage("/dataToLive11"); // oscillator SEND TRIG NOTE IN MAX4LIVE
  OscMessage myMessage41= new OscMessage("/dataToLive10"); // oscillator 
  OscMessage myMessage42= new OscMessage("/dataToLive9"); // oscillator 
  OscMessage myMessage43= new OscMessage("/dataToLive8"); // oscillator 
  OscMessage myMessage44= new OscMessage("/dataToLive7"); // oscillator 
  OscMessage myMessage45= new OscMessage("/dataToLive6"); // oscillato
  OscMessage myMessage46= new OscMessage("/dataToLive5"); // oscillator 
  OscMessage myMessage47= new OscMessage("/dataToLive4"); // oscillator 
  OscMessage myMessage48= new OscMessage("/dataToLive3"); // oscillator 
  OscMessage myMessage49= new OscMessage("/dataToLive2"); // oscillator behind
 
  OscMessage myMessage50= new OscMessage("/acceleration11"); // oscillator SEND ACCELERATION
  OscMessage myMessage51= new OscMessage("/acceleration10"); // oscillator 
  OscMessage myMessage52= new OscMessage("/acceleration9"); // oscillator 
  OscMessage myMessage53= new OscMessage("/acceleration8"); // oscillator 
  OscMessage myMessage54= new OscMessage("/acceleration7"); // oscillator 
  OscMessage myMessage55= new OscMessage("/acceleration6"); // oscillato
  OscMessage myMessage56= new OscMessage("/acceleration5"); // oscillator 
  OscMessage myMessage57= new OscMessage("/acceleration4"); // oscillator 
  OscMessage myMessage58= new OscMessage("/acceleration3"); // oscillator 
  OscMessage myMessage59= new OscMessage("/acceleration2"); // oscillator behind
 // OscMessage myMessage60= new OscMessage("/acceleration1"); // oscillator behind




 
 /*
  myMessage20.add(Pos[9]);
  myMessage21.add(Pos[8]);
  myMessage22.add(Pos[7]);
  myMessage23.add(Pos[6]);
  myMessage24.add(Pos[5]);
  myMessage25.add(Pos[4]);
  myMessage26.add(Pos[3]);
  myMessage27.add(Pos[2]);
  myMessage28.add(Pos[1]);
  myMessage29.add(Pos[0]);
*/  
//  print ("Pos11");   println (Pos[11]); println (Pos[11]); println (Pos[11]); println (Pos[11]); 
/*
  myMessage20.add(Pos[11]);
  myMessage21.add(Pos[10]);
  myMessage22.add(Pos[9]);
  myMessage23.add(Pos[8]);
  myMessage24.add(Pos[7]);
  myMessage25.add(Pos[6]);
*/
  myMessage26.add(Pos[5]);
  myMessage27.add(Pos[4]);
  myMessage28.add(Pos[3]);
  myMessage29.add(Pos[2]);
/*  
  myMessage30.add(Pos[9]);
  myMessage31.add(Pos[8]);
  myMessage32.add(Pos[7]);
  myMessage33.add(Pos[6]);
  myMessage34.add(Pos[5]);
  myMessage35.add(Pos[4]);
  myMessage36.add(Pos[3]);
  myMessage37.add(Pos[2]);
  myMessage38.add(Pos[1]);
  myMessage39.add(Pos[0]);
 */
 
 if (formerKeyMetro == '$'  ) { 
  /*
  myMessage30.add(revolution[11]);  //  Trig on the left bug when playing sample in negative way. problem with net_oldphase? or and countrevs
  myMessage31.add(revolution[10]);
  myMessage32.add(revolution[9]);
  myMessage33.add(revolution[8]);
  myMessage34.add(revolution[7]);
  myMessage35.add(revolution[6]);
  */
  myMessage36.add(revolution[5]);
  myMessage37.add(revolution[4]);
  myMessage38.add(revolution[3]);
  myMessage39.add(revolution[2]);
 } 
  
  
 /*
  myMessage30.add(decompte[11]);
  myMessage31.add(decompte[10]);
  myMessage32.add(decompte[9]);
  myMessage33.add(decompte[8]);
  myMessage34.add(decompte[7]);
  myMessage35.add(decompte[6]);
  myMessage36.add(decompte[5]);
  myMessage37.add(decompte[4]);
  myMessage38.add(decompte[3]);
  myMessage39.add(decompte[2]);
  */
  
//  osctrignote

  if (formerKeyMetro == '£'  || formerKeyMetro == '*' || formerKeyMetro == 'J' || formerKeyMetro == 's' || formerKeyMetro == '@' || formerKeyMetro == 'c' ) { // trig note if TrigmodPos[i]=0
    showArray(TrigmodPos);
  // These tests used a copy of the original array so that we can perform multiple
  // test using the same working array
//  println("Convert multiple 0s to 1s (good)");
  result = multiMatchData(0, 1, TrigmodPos.clone());
  TrigmodPos=result;
  showArray(result);
  
 if ( keyMode ==  " followSignalLfo "){
    print (" trigNoteOnlyOnceFollowSignalLfo "); 
    showArray(trigFollowSignalLfo);   
  result = multiMatchData(0, 1, trigFollowSignalLfo.clone());
//  TrigmodPos=result;
  showArray(result); 
   } 
  /*
  myMessage30.add(TrigmodPos[11]);  // Trig on the right but there are bugs in pendular way
  myMessage31.add(TrigmodPos[10]);
  myMessage32.add(TrigmodPos[9]);
  myMessage33.add(TrigmodPos[8]);
  myMessage34.add(TrigmodPos[7]);
  myMessage35.add(TrigmodPos[6]);
  */
  myMessage36.add(TrigmodPos[5]);
  myMessage37.add(TrigmodPos[4]);
  myMessage38.add(TrigmodPos[3]);
  myMessage39.add(TrigmodPos[2]);
  println (" NOTE TRIGGED FROM OSCSEND ");
} 
  /*
  myMessage40.add(dataToLive[11]);  // Trig on the right but there are bugs in pendular way
  myMessage41.add(dataToLive[10]);
  myMessage42.add(dataToLive[9]);
  myMessage43.add(dataToLive[8]);
  myMessage44.add(dataToLive[7]);
  myMessage45.add(dataToLive[6]);
  */

  myMessage46.add(dataToLive[5]);
  myMessage47.add(dataToLive[4]);
  myMessage48.add(dataToLive[3]);
  myMessage49.add(dataToLive[2]);
//  myMessage50.add(dataToLive[0]);
/*
  myMessage50.add(mapAcceleration[11]);  // Trig on the right but there are bugs in pendular way
  myMessage51.add(mapAcceleration[10]);
  myMessage52.add(mapAcceleration[9]);
  myMessage53.add(mapAcceleration[8]);
  myMessage54.add(mapAcceleration[7]);
  myMessage55.add(mapAcceleration[6]);
  */
  myMessage56.add(mapAcceleration[5]);
  myMessage57.add(mapAcceleration[4]);
  myMessage58.add(mapAcceleration[3]);
  myMessage59.add(mapAcceleration[2]);
 // myMessage60.add(mapAcceleration[1]);
    
 
  
  //  UNCOMMENT to BEGIN TO USE good useful OSC
  // /* myRemoteLocation to port 8000

  oscP5.send(myMessage,  myRemoteLocation); 
  oscP5.send(myMessage1, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation); 
  oscP5.send(myMessage3, myRemoteLocation); 

  oscP5.send(myMessage4, myRemoteLocation); 
  oscP5.send(myMessage5, myRemoteLocation); 
  oscP5.send(myMessage6, myRemoteLocation); 
  oscP5.send(myMessage7, myRemoteLocation); 
  oscP5.send(myMessage8, myRemoteLocation); 
  oscP5.send(myMessage9, myRemoteLocation); 
  oscP5.send(myMessage10, myRemoteLocation); 
  oscP5.send(myMessage11, myRemoteLocation); 
  oscP5.send(myMessage12, myRemoteLocation); 
  oscP5.send(myMessage13, myRemoteLocation); 
  

  oscP5.send(myMessage14, myRemoteLocation);
  oscP5.send(myMessage15, myRemoteLocation); 
  oscP5.send(myMessage16, myRemoteLocation); 
  oscP5.send(myMessage17, myRemoteLocation); 

  oscP5.send(myMessage18, myRemoteLocation); 
  oscP5.send(myMessage19, myRemoteLocation); 



  // myRemoteLocationII port 8001
  
  oscP5.send(myMessage20, myRemoteLocationII);
  oscP5.send(myMessage21, myRemoteLocationII);
  oscP5.send(myMessage22, myRemoteLocationII);
  oscP5.send(myMessage23, myRemoteLocationII);
  oscP5.send(myMessage24, myRemoteLocationII);
  oscP5.send(myMessage25, myRemoteLocationII);
  oscP5.send(myMessage26, myRemoteLocationII);
  oscP5.send(myMessage27, myRemoteLocationII);
  oscP5.send(myMessage28, myRemoteLocationII);
  oscP5.send(myMessage29, myRemoteLocationII);
   //  END TO USE, NOT BELOW, END OF UNCOMMENT
  
  //*** /*
  oscP5.send(myMessage30, myRemoteLocation);
  oscP5.send(myMessage31, myRemoteLocation);
  oscP5.send(myMessage32, myRemoteLocation);
  oscP5.send(myMessage33, myRemoteLocation);
  oscP5.send(myMessage34, myRemoteLocation);
  oscP5.send(myMessage35, myRemoteLocation);
  oscP5.send(myMessage36, myRemoteLocation);
  oscP5.send(myMessage37, myRemoteLocation);
  oscP5.send(myMessage38, myRemoteLocation);
  oscP5.send(myMessage39, myRemoteLocation);
  //*** */
  
  // myRemoteLocation port 8000  data to live
  oscP5.send(myMessage40, myRemoteLocation);
  oscP5.send(myMessage41, myRemoteLocation);
  oscP5.send(myMessage42, myRemoteLocation);
  oscP5.send(myMessage43, myRemoteLocation);
  oscP5.send(myMessage44, myRemoteLocation);
  oscP5.send(myMessage45, myRemoteLocation);
  oscP5.send(myMessage46, myRemoteLocation);
  oscP5.send(myMessage47, myRemoteLocation);
  oscP5.send(myMessage48, myRemoteLocation);
  oscP5.send(myMessage49, myRemoteLocation);
  oscP5.send(myMessage50, myRemoteLocation);

 // encodeur
  oscP5.send(myMessage60, myRemoteLocation);
  oscP5.send(myMessage61, myRemoteLocation);
  oscP5.send(myMessage62, myRemoteLocation);
  oscP5.send(myMessage63, myRemoteLocation);
  oscP5.send(myMessage64, myRemoteLocation);
  oscP5.send(myMessage65, myRemoteLocation);

  text ( " osc encodeur 0 "  + myMessage60 + " " + myRemoteLocation, 400, -800 );
  text ( " osc mouseX "  + myMessage18 + " " + myRemoteLocation, 400, -900 );
  text ( " osc mouseY"  + myMessage19 + " " + myRemoteLocation, 400, -1000 );
 


   // myRemoteLocationII port 8002
  
  // acceleration
  /*
  oscP5.send(myMessage50, myRemoteLocation3);
  oscP5.send(myMessage51, myRemoteLocation3);
  oscP5.send(myMessage52, myRemoteLocation3);
  oscP5.send(myMessage53, myRemoteLocation3);
  oscP5.send(myMessage54, myRemoteLocation3);
  oscP5.send(myMessage55, myRemoteLocation3);
  oscP5.send(myMessage56, myRemoteLocation3);
  oscP5.send(myMessage57, myRemoteLocation3);
  oscP5.send(myMessage58, myRemoteLocation3);
  oscP5.send(myMessage59, myRemoteLocation3);
  
   // myRemoteLocation port 8000
   
    oscP5.send(myMessage50, myRemoteLocation);
  oscP5.send(myMessage51, myRemoteLocation);
  oscP5.send(myMessage52, myRemoteLocation);
  oscP5.send(myMessage53, myRemoteLocation);
  oscP5.send(myMessage54, myRemoteLocation);
  oscP5.send(myMessage55, myRemoteLocation);
  oscP5.send(myMessage56, myRemoteLocation);
  oscP5.send(myMessage57, myRemoteLocation);
  oscP5.send(myMessage58, myRemoteLocation);
  oscP5.send(myMessage59, myRemoteLocation);
*/
 
 
}
