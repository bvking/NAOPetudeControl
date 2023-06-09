 
//import PNetwork.java.*; 
// MANAGE NETWORK of OSCILLATOR
// import java.util.Arrays;
import sync.*;
PNetwork net;
import java.util.Arrays;

int networkSize = 6;
int nbBalls=networkSize;

int v0, v1, v2, v3, v4, v5;
int incrementeX;


int [] encodeur = new int [networkSize];
float [] newPosFollowed= new float [networkSize]; // followOppositeWay


int oldOscillatorChangePropagation, oscillatorChangePropagation; // splitIncoming
boolean oscillatorChangingPropagation; // splitIncoming

 
// INTERPOLATION
int actualSec,lastSec, lastLastSec, measure;  // trig internal clock each seconde as a measure  (period of 1 seconde)

int currTime;
boolean bRecording = true;
boolean mouseRecorded = true;
float movementInterpolatedContinue;

int Movement;

float oldMovementInterpolated, movementInterpolated;
float formerInterpolatedY;
float interpolatedX, interpolatedY;

//END INTERPOLaTION

// MANAGE ARDUINO && TENNSY
import processing.serial.*;
Serial encoderReceiveUSBport101; // The native serial port of the DUE fibish with 101
Serial teensyport;

String dataTransformed ;
String dataFromMode ;

boolean startZ=false; // to trig opposite way of propaagtion in addSignalOneAndTwoQuater

float signalToSplit, oldSignalToSplit ;  // signal oscillant entre 0 et 1 ou entre - TWO_PI et TWO_PI. oldSignalTosplit est la valeur du signal a la frame precedente. 

float timeLfo; // met à l'echelle le "signalToSplit" afin qu'il soit limité entre 0 et 1000

float splitTime, oldSplitTime ; // // renvoie la valeur discontine du time. Quand le temps s'ecoule de maniere cconstante et lineaire

float splitTimeLfo, oldSplitTimeLfo; // renvoie la valeur discontine du timeLFO. Quand timeLFO va de 0 à 1000, splitTimeLfo renvoie la valeur restante du timeLfo

int propagationSpeed=20;; // " vitesse " à laquelle on change d'oscillateur

int oscillatorChanging; // next or last changing oscillator
//******************         followSignalLfo
 
 char  modeStartKey;
 String modeStartKeyToFollow;
 
 float [] oscillator = new float [networkSize];
 int [] countFollowSignalLfo = new int [networkSize];
 int [] oldOldPositionToMotor = new int [networkSize];
 int [] trigFollowSignalLfo = new int [networkSize];

// ALIGNEMENT Trig 0
int[] result;


int[] multiMatchData(int matchValue, int newValue, int [] theArray) {
  IntList list = new IntList();
  for (int i = 0; i <  theArray.length; i++)
    if (theArray[i] == matchValue) list.append(i);
  if (list.size() > 1)
  list.forEach(element -> { theArray[element] = newValue; } );
  return theArray;
}

void showArray(int[] array) {
  for (int i = 0; i < array.length; i++)
    print(array[i] + "   ");
    println();
}

//

float []  velocityBis =  new float[networkSize]; //;
float []  oldVelocityBis =  new float[networkSize]; //;
float []  accelerationBis =  new float[networkSize]; //;
//float []  oldaccelerationBis =  new float[networkSize]; //;

float [] phaseAcceleration =  new float[networkSize]; //;
float [] oldPhaseAcceleration =  new float[networkSize]; //;


//******************         FollowMovement addSignalOneAndTwo and addSignalOneAndTwoBis

char letter;
boolean doA,doQ,doZ;

int oldOscillatorChange, oscillatorChange;
boolean oscillatorChanged;




int [] recordLastDataOfMotorPosition = new int[networkSize];  // not used

//float [] phaseShiftingFollowLFO = new float[12];


int frameCountRed;
String keyModeRed;
String mappingMode; 
int   controlTrigLfoPattern;
float phaseShiftingFollowLFO;

int decayTimeLfo;
int formerDecayTimeLfo;


 //int [] j = new int[networkSize];// number of the last changed oscillator
float [] phaseKeptAtChange =  new float[networkSize]; //;
float [] phasePatternFollow =  new float[networkSize]; //;

float [] newPosXaddSignal =  new float[networkSize]; //;
float [] newPosX =  new float[networkSize]; //;
float [] oldPosX =  new float[networkSize]; //;


int decayTimeBis;
int formerDecayTimeBis;

//******************         FollowMovement   

float oldYsampled,  ySampled;
int formerDecayTime, decayTime;
int frameCountBis = 0;
int decayshiftFollowMov = 0;


float [] ableton = new float[networkSize]; //;
float [] signal = new float[networkSize]; //;
float [] phaseAbleton =  new float[networkSize]; //;
float [] oldPhaseAbleton =  new float[networkSize]; //;

float [] oldPhaseLfo = new float[networkSize]; //;
float [] newPhaseLfo = new float[networkSize]; //;

float [] newPosY = new float[networkSize]; //;
float [] LFO = new float[networkSize]; //;

float [] phaseFollowLFO= new float[networkSize]; // 
float [] oldPosF= new float[networkSize]; // 
float [] newPosF= new float[networkSize]; //
float [] oldLfoPhase=  new float[networkSize]; //
float [] lfoPhase=  new float[networkSize]; //
int[] dataMappedForMotor =  new int[networkSize]; //
int[] positionToMotor =  new int[networkSize];
int[] oldPositionToMotor =  new int[networkSize];
int[] revLfo =  new int[networkSize];

// for mode keyMetro < in fonction PatternFollowLfo()
int[] dataToChange =  new int[networkSize]; //
float [] oldMotorToVisualPhase = new float[networkSize];
float [] motorToVisualPhase = new float[networkSize ];
//float [] phaseShiftingFollowLFO = new float[12];




  
//int frameRatio = 20;
//int nbBall = 9;
//int nbMaxDelais = 2000;




//******************       INTERPOLATION AND  SamplingMovement
int phase11;
float addPhase;
float addPhaseAllMode;
float trigLfo; // send only to float to osc
float oldMov;
float movementRecording; 

// IMPORTANT TO COMPARE
// to interpolate angle
float mlerp(float x0, float x1, float t, float M ){
   float dx = (x1 - x0 + 1.5*M) % M - 0.5*M;
   return (x0 + t * dx + M) % M;
}



int formerBeatPrecised, beatPrecised, formerMeasure, formerBeatOnMeasure; // autmationWithMeasureAndNote
int lastMeasureRecordStart, measureRecordStart, beginSample, endSample;
boolean beatPrecisedTrigged;
int timeFrameOffsetFollowing;


// RECORD MOTOR 0 and SAMPLING MOVEMENT and PLAIY IT in LOOP

int frameSampling; 
int z;

int  counterV1;
int  oldv1;
//Record and repeat movement

boolean trigFollowSampling=true;
boolean trigRatio;
int  delayTimeFollowPhase11=0;
float phaseShiftingFollowPhase11=0;
int num = 40; // you need normally 45 frameSamplings/s but actually with a 3D setting you  need only 40 frameSamplings
int numberSec = 5;

float mx[] = new float[num*numberSec]; // memorised frameSampling played 
float my[] = new float[num*numberSec]; // 

float rx[] = new float[num*numberSec]; // recorded frameSampling
float ry[] = new float[num*numberSec]; 

int beginTime,endTime,TimeMiddleElapsed,LastTimeMiddleElapsed,LastTimeElapsed;
int restartTimer;
float Timer,Timer2;

// END RECORD MOTOR 0 and SAMPLING MOVEMENT and PLAIY IT in LOOP


// fonction FOLLOW phase Jo
String debug ="";
String dataToControlMotor;

int nbBall = 12;
int nbMaxDelais = 2000;

// Variable pour suivre un mouvement avec un decalage en frame et phase. DANS les FONCTIONS commencant par follow
boolean firstFollowingLast = true;
float deltaFollow = PI/180;
boolean firstFollowingStarted = false;

float [][] phases = new float[nbBall][nbMaxDelais];
int[] phaseToMotor;
float [] phaseMapped;
float [] phaseMappedFollow;

float b, a;
// fin fonction JO

color bg = rcolor();
color rcolor() {
  return ( color( random(255), random(255), random(255) ) );
}
// Variable pour fonction avec starter et inteerphase

float [] interFrequency =  new float[networkSize];
float [] interPhase  =  new float[networkSize];
float [] interPhaseCircular  =  new float[networkSize];
int oldOldOldMemoryi, oldOldMemoryi;
int lastTimeTrigged;
int TimeTrigged;
float [] TrigRightTemp  =  new float[networkSize];
float [] interPosition = new float[networkSize];
int [] upstairVpos = new int[networkSize];
int [] upstairOldVpos = new int[networkSize];
int [] LasttimeTrigged = new int[networkSize];
int [] timeTrigged = new int[networkSize];
int lastTimeUpstair;
boolean [] upstairShifting;
boolean [] clockWay;
boolean [] oldClockWay;
int [] ClockWay = new int[networkSize];
int [] FactorWay = new int[networkSize];
//boolean upstairShifting; 

int upstairTime=0;
int TimeUpstair=0;
float [] PhaseDecay;
int oldMemoryi;
int oscillatorMoving;
int OldoscillatorMoving;
boolean [] oldOscillatorMoving; 
boolean [] OscillatorMoving; 
int millisRatio;
String JoDebug;
int incrementSpeed; // the speed of periodic wave
int[] formerEvent = new int[networkSize];
int[] TimeEllapsedBall = new int[networkSize];

float [] automationLFO;
int numberOfStep=6400;
int speedDelta=18; // ratio of speed and acceleration in Arduino
float averageDeltaPhase;
boolean twoTree=false;
boolean treeFour=false;
boolean fourFive=false;
boolean fiveSix=false;
boolean sixSeven=false;
boolean sevenEight=false;
boolean eightNine=false;
boolean nineTen=false;
boolean tenEleven=false;
boolean elevenTwo=false;
boolean [] followNumber;
int currentTime;
float [] pseudoTimer;
float [] timer;
float [] phaseReturned;
float k=0; // factor of phiShift in fonction formerkeyo
int d=0; // factor of timeOffset before trigging phaseshifting in fonction formerkeyo
boolean [] factorWay; // factor of phiShift according the oscillator moving in upstairx in cw or ccw
int timeOffset=1;
float phiShift=-PI/4;
float mapShiftPendular; // map the scale of K * phiShift
float mapShiftCircular;
float LFOX;
float LFOY;

//import the necessary libraries to use send, receive and understand OSC data
import oscP5.*;
import netP5.*;

// OSC loading stuff
OscP5 o;//Receive Piano/ Only track 1 from live 
OscP5 oII;//Receive Data/ Automation from Live
OscP5 oscP5;//send data
OscP5 oscP5bis;//send data
NetAddress myRemoteLocation; // send data  to Live
NetAddress myRemoteLocationII; // send data  to Live

float[] dataToLive; 
int[] upVelocity = new int[networkSize]; 
int[] downVelocity = new int[networkSize]; 
float Velocity;
int autmationWithMeasureAndNote;
int beatOnMeasure;
int actualMeasure;

int formerFrameBeat;
float formerAutomation ;
int LastBeat=0;
boolean beatTrigged;

// potar position scaled 0 to 1
float formerAutomation1;
float automation1, automation2, automation3, automation4, automation5, automation6, automation7, automation8, automation9  = 0; 


// midi note data
B_String string1, string2, string3, string4, string5, string6, string7, string8;
int velocity1, velocity2, velocity3, velocity4, velocity5, velocity6, velocity7, velocity8 = 0;
float ver_move1, ver_move2, ver_move3, ver_move4, ver_move5, ver_move6, ver_move7, ver_move8;
float duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8;
int note1, note2, note3, note4, note5, note6, note7, note8  = 0;

// END OF OSC DATAS

int oscillatorBlocked;

int pendular;  //actualise datas. 
boolean circularMov; //switch datas of positions in a pendular way
boolean trigTest; // Trig data when oscillator is on the left

// variable to manage graphics 
PNetwork netG;
int numRows = 12;
int numCols = 12;
int networkSizeGraphic = numRows * numCols;
int gridSize = 16;  

float Coupling;
float sigma; 
float Freq; 
// end of variable to manage graphics 

int orderframe;
int stoploop ;
int memoryi;
float f=0.05; // FOLLOW MODE to incremente phase with  formerkey =='f'
float fmemory;

boolean F11 = true;  
//MANAGE START STOP into LIVE

int startStop;

int nextScene=0; // Do not trig nextScene
int cohesionTrig;

//Manage when oscillator 11 trig his position=0
boolean ready = false;
float pulsation; // nnot used
int pause_start_time, sketch_pause_interval = 0;
int prev_time;

// MANAGE Time according the frame.
float TimeFrame;
int lastMillis = 0;
int sec; 

float timeFrame;
boolean running = true;

int pair=0; // to manage wether I control oscillator odd or even.




// variable of the setting of oscillator network

float x, y;
float side;  
float displacement;
float NaturalF;
//float coupling;
float noiseScale= 1;
float radius;
float orderParameter;
float coupling;
float formerCoupling;
float averagePhase;
float averageFrequency;

float stepSize;
int[] rev; //(counter of revolution of each oscillator);

// MANAGE data TO SEND POSITION or SPEED to ARDUINO
int[] oldVirtualPosition =new int[networkSize];
int[] VirtualPosition  = new int[networkSize];
int[] pos= new int[networkSize];
int[] oldPos = new int[networkSize];
int[] Pos = new int[networkSize]; // to convert data of position always positively
int[] modPos = new int[networkSize]; // ta have special position  quarter or half round
int[] modOldPos = new int[networkSize]; //to have former
int[] modOldOldPos = new int[networkSize]; //to have former
int[] TrigmodPos = new int[networkSize]; // to trig accordinag modPos;

int[] counter= new int[networkSize];


float[] metroPhase; 
float[] metroOldPhase; // convert circular to pendular
float[] abstractPhase; // to compute abstract phase
float[] OldFrequency;
float[] divideFrequency;

int[] PendularVirtualPosition = new int[networkSize];
int[] CircularVirtualPosition  = new int[networkSize];;
int[] DataToDueCircularVirtualPosition  = new int[networkSize];;
int[] ActualVirtualPosition  = new int[networkSize];;
int[] ActualVirtualPositionFromOtherMode  = new int[networkSize];;
int[] oldActualVirtualPosition  = new int[networkSize];;
int[] PendularOldVirtualPosition  = new int[networkSize];;
int[] CircularOldVirtualPosition  = new int[networkSize];;
int[] PendularLeftVirtualPosition  = new int[networkSize];;
int[] PendularOldLeftVirtualPosition  = new int[networkSize];;
int[] PendularOldOldLeftVirtualPosition  = new int[networkSize];;
int[] PendularOldOldOldLeftVirtualPosition  = new int[networkSize];;

int[] revolution;
int[] pseudoRevolutionTodeblock;
// WHAT TO CHOSSE?????  200*4 ou 200*8=?????
int[] decompte; // decremente a number when a revolution is trigged
int[] mapAcceleration;
int[] mapAccelerationinversed;


int [] j; // to reduce the number of revolution to their number even or odd  

//MANAGE VARIABLE TO MODULATE MOVEMENT with different CASES AUTOMATICALY
int caseNumber;
char caseLetter;

// MANAGE COUNTER of COHESION to manage sound
// Trig counter when cohesion is >=0.99
int orderCohesion;
int cohesionCounterHigh;
int cohesionCounterLow;

// Trig counter when cohesion is <=0.01
int orderCohesionLow;
int cohesionCounterHighLow;
float LevelCohesionToSend;

// MANAGE PERSPECTIVE
import peasy.*;
PeasyCam cam;

// change these for screen size
float fov = 45;  // degrees
float w = 1000;
float h = 800;

// don't change these
float cameraZ, zNear, zFar;
float w2 = w / 2;
float h2 = h / 2;

int frameRatio;

// SPECIFIED DATAS TO MAX MSP
float bPM9;
int BPM9;
int constrainedBPM; 
int onOFF;

//********** to RECORD and  playback data in the skecth folder
int formerKey; 
int formerSartKey; 
int formerKeyCode;
int formerFormerKey; 
int formerKeyCodeAzerty;
int formerFrame;
int formerKeyMetro;

int Key;
int KeyCode;

int couplingRed;
float couplingRecorded;

String[] lines;
int index = 0, nextFrame = 0; // these stay the same
// To outpout data recorded as sequences of case on Keypressed
PrintWriter output;

//********************* Data mapped to send To MAX 4 LIVE
int  orderToexpMappedOpposedLive; 
int  acc0ToexpMappedBisLive, acc9ToexpMappedBisLive; 

//BPM
float [] bpmFrequency;
float bpmToSend= 0.0;

//frame where to stop
//int framecount=10040;//4440 //5040  0à°)-_
int framecount=30040;//4440 //5040  0à°)-_

void frameStop() { 
  if (frameCount%framecount ==  0 ) { /// choose the in the   frame where you want to stop
    stoploop = 10; // incrmente the step to the next frame
    framecount = framecount  + stoploop ;
    noLoop();
    //       print (" last or : ");   println (orderframe );
    orderframe  = framecount;
    //       print ("a:ctual order : ");   println (orderframe );
  }
}     
void setup() {
  sampler = new Sampler();

  LastTimeMiddleElapsed=1980;
  LastTimeElapsed=4000-20;
  //  noStroke();
  fill(255, 0, 0, 50); 
  println("Start Drawing!");
  //  frameRate(45);
  v1=counterV1=height/2;

  // end sampling

  int midiNoteAndOtherData  = 300;
  int networkSize = 6;
 
  formerEvent= new int[300];
  formerSartKey='#';
  autmationWithMeasureAndNote=1;
  oscillatorBlocked = 2;

 
  automationLFO = new float [networkSize];
  followNumber= new boolean [networkSize];
  pseudoTimer = new float [networkSize];
  timer =  new float [networkSize];
  phaseReturned =  new float [networkSize];
  
  k=0; // set phase offset to 0
  d=0; // set time offset to 0

  TimeEllapsedBall= new int[networkSize];
  timeTrigged = new int[networkSize];
  TrigRightTemp = new float[networkSize];
  upstairVpos = new int[networkSize];
  upstairOldVpos = new int[networkSize];
  LasttimeTrigged = new int[networkSize];
  interPosition = new float[networkSize];
  PhaseDecay = new float[networkSize];
  interPhase = new float[networkSize];
  interFrequency = new float[networkSize];
  interPhaseCircular = new float[networkSize];
  factorWay = new boolean[networkSize];


  float noiseLevel = 0 ; // Usefull only with case Q?

  // Osc midi potar
  automation1= automation2= automation3= automation4= automation5= automation6= automation7 = 0.5;
  o = new OscP5(this, 2346);//receive data from a port number - it has to be same as in your Max for Live device // careful to oveflow
  oII = new OscP5(this, 2350);//receive data piano partitionII

  oscP5 = new OscP5(this, 7999);//receive data to himself
  //  oscP5bis = new OscP5(this, 8002);//receive data to himself

  // myRemoteLocation = new OscP5(this, 8000); // rsend data to live. define address ove which the communication takes place. Requires host address (127.0.0.1 for localhost and the port number previously defined.)
  // myRemoteLocationII = new OscP5bis(this, 8001); // receive data fto live. define address ove which the communication takes place. Requires host address (127.0.0.1 for localhost and the port number previously defined.)

  myRemoteLocation = new NetAddress("127.0.0.1", 8000); // rsend data to live. define address ove which the communication takes place. Requires host address (127.0.0.1 for localhost and the port number previously defined.)
  myRemoteLocationII = new NetAddress("127.0.0.1", 8001); // receive data fto live. define address ove which the communication takes place. Requires host address (127.0.0.1 for localhost and the port number previously defined.)

  dataToLive= new float[networkSize];
  upVelocity= new int[networkSize];
  downVelocity= new int[networkSize];
  //OSC midi note data

  string1=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.2, 250);
  string2=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.3, 50);
  string3=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.4, 150);
  string4=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.5, 100);
  string5=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.6, 200);
  string6=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.7, 0);
  string7=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.8, 133);
  string8=new B_String (width*0.1, width*0.3, width*0.7, width*0.9, height*0.9, 278);

 

  startStop = 0; // data used in Live
  frameRatio = 30;///30/5=> 108/5 BPM 21.6  or 114/5 = 22.8
  frameRate(frameRatio); //57 frame pour 1 tour. // joure avec G et g et cf le p

  stepSize = 10; // no effect //  net.stepSize = 1; // no effect  
  // Creat text with cases, in order to have a sequence according cases
  //================ record data to the skecth folder
  output = createWriter("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis5FINAL39.txt");// 
  output.println("0:0:0:0:0: addSignalOneAndTwo ");   
  //================ donwload data from the skecth folder

  //********************  
  // lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEcontinueBisElague.txt");//retire o garde pendulaire 5366:36:56:42
  //lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis2.txt");// // to play to trig LIVE
  //lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis5FINAL6.txt");// drole d'effet vers frame 16000 
  //lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis5FINAL13.txt");//
  //lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis5FINAL16.txt");//
  
  //lines = loadStrings("OVERCOOL/viergelentAlongRecBisVitesse8FRAMEFaireVVraimentBis5FINAL33.txt");//  // 33 fonctione


  //********************  fichier vierge
 //  lines = loadStrings("vierge.txt");
   lines = loadStrings("viergechar.txt");
  // lines = loadStrings("madrushstart.txt");
  //**** readOneLine(); // play case frame by frame. Uncomment if you want play in live
  textSize(200);

  //********Sending and Receiving data with two different serialport
  String[] ports = Serial.list();
  printArray(Serial.list());
  //*************** WITH TEENSY connected
 //  teensyport = new Serial(this, ports[0], 115200);// si port non connecte Venturey
// teensyport = new Serial(this, ports[1], 115200);// si port non connecte Catalina ou connecté Venturey
    teensyport = new Serial(this,ports[1],115200); //  si port connecté
  //*************** WITHOUT ENODEER connected
 //   encoderReceiveUSBport101 = new Serial(this, Serial.list()[2], 1000000);
    encoderReceiveUSBport101 =  new Serial(this,ports[2], 1000000);

  // Read bytes into a buffer until you get a linefeed (ASCII 10):
    encoderReceiveUSBport101.bufferUntil('\n');

  //********************************************************* BEGIN GRAPHIC CHIMERA STATE SETUP
  float[][] Coupling = new float[networkSizeGraphic][networkSizeGraphic];
  float sigma = 0.25; // play with this? How can I do?
  initializeCoupling(Coupling, sigma);
  float[] phase = new float[networkSizeGraphic];
  initializePhase(phase);
  float[] naturalFrequency = new float[networkSizeGraphic];
  Freq = PI / 8; // play with this PI/8
  initializeNaturalFrequency(naturalFrequency, Freq);
  netG = new PNetwork(this, phase, naturalFrequency, Coupling);

  colorMode(HSB, TWO_PI, 100, 100);
  noStroke();

  //********************************************************* END GRAPHIC CHIMERA STATE SETUP
  rev = new int[networkSize]; // counter of rev
  j= new int[networkSize]; // reduce  the number of rev  to the number even or odd with 0 or 1 /

  oldVirtualPosition= new int[networkSize];
  VirtualPosition= new int[networkSize];
  pos= new int[networkSize];
  oldPos= new int[networkSize];
  Pos= new int[networkSize];
  modPos= new int[networkSize];
  modOldPos= new int[networkSize]; 
  modOldOldPos=new int[networkSize]; 

  metroPhase= new float[networkSize]; 

  metroOldPhase= new float[networkSize]; 
  abstractPhase = new float[networkSize]; 
 
  OldFrequency = new float[networkSize]; 
  PendularVirtualPosition = new int[networkSize]; 
  CircularVirtualPosition = new int[networkSize]; 
  DataToDueCircularVirtualPosition =new int[networkSize]; 
  ActualVirtualPosition = new int[networkSize];
  ActualVirtualPositionFromOtherMode = new int[networkSize];
  oldActualVirtualPosition = new int[networkSize];

  PendularOldVirtualPosition = new int[networkSize]; 
  CircularOldVirtualPosition = new int[networkSize]; 
  PendularLeftVirtualPosition = new int[networkSize];
  PendularOldLeftVirtualPosition = new int[networkSize];
  PendularOldOldLeftVirtualPosition = new int[networkSize];
  PendularOldOldOldLeftVirtualPosition = new int[networkSize];
  TrigmodPos = new int[networkSize]; 
  revolution= new int[networkSize];
  pseudoRevolutionTodeblock= new int[networkSize];
  decompte=  new int[networkSize];
  mapAcceleration=new int[networkSize];
  mapAccelerationinversed=new int[networkSize];
  divideFrequency= new float[networkSize];

  coupling = 0; 

  net = new PNetwork(this, networkSize, coupling, noiseLevel);
  side = height*0.15*1/networkSize;
  displacement = width/2;

  minim   = new Minim(this);

  // this opens the file and puts it in the "play" state.                           
  filePlayer = new FilePlayer( minim.loadFileStream(fileName) );
  // and then we'll tell the recording to loop indefinitely
  // filePlayer.loop();

  // this creates a TickRate UGen with the default playback speed of 1.
  // ie, it will sound as if the file is patched directly to the output
  rateControl = new TickRate(1.f);

  // get a line out from Minim. It's important that the file is the same audio format 
  // as our output (i.e. same sample rate, number of channels, etc).
  out = minim.getLineOut();

  // patch the file player through the TickRate to the output.
  filePlayer.patch(rateControl).patch(out);
  //**************************
  // to play synthesis with minim. Not used anymore

  phazi=  new float[networkSize];
  speedi= new float[networkSize];
  freqi=  new float[networkSize];
  volumei= new float[networkSize];
  bpmFrequency= new float[networkSize];
  //**************************
   
  
  
  /*  to manage later reflection on sphere
   colorMode(RGB, 1);
   //  fill(0.4);
   */
 
  //***************************************** SET minim library to discriminate 3 differents frequencies in a mp3 

  //  minim = new Minim(this);
  //** song = minim.loadFile("09-The Secret Agent Ending.mp3", 1024);
  //**song.play();

  //  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  //  beat.setSensitivity(400);//300 ou 100? 

  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  //***************************************** set position and coupling of oscillators
  mouseX= width/2;
  // in order to have coupling=0;
  formerKeyMetro = '$'; // to begin setting of phase with pendular phase in the menu $ ; 
  circularMov=false;
  for (int i = 0; i < networkSize; i++) {
    //   net.phase[i] = (i*PI/2);// position 0 at the top
    net.phase[i] = PI/2;// position 0 at the top
    //   net.phase[i]=-PI+0.5*PI+PI/12; // position 0+PI/12
  }
  
 
  upstairShifting = new boolean [networkSize];
  clockWay = new boolean [networkSize];
  oldClockWay = new boolean [networkSize];
 // ClockWay = new int [networkSize];
  FactorWay = new int [networkSize];
  oldOscillatorMoving = new boolean [networkSize];
  OscillatorMoving = new boolean [networkSize];

  for (int i = 0; i < networkSize; i++) {

    oldOscillatorMoving[i]=false;
    OscillatorMoving[i]=false;

  }

  for (int i = 0; i < networkSize; i++) {
    //   ActualVirtualPosition[i]=80*i;
    // DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i]+800;
    DataToDueCircularVirtualPosition[i]= (int) map ( DataToDueCircularVirtualPosition[i], -800, 800, 1600, 4800)+ ActualVirtualPosition[i];  // mapped for 6400 step/round +800
 //  dataToLive[i]=(float)  map(DataToDueCircularVirtualPosition[i], 1600, 4800, 0f, 1f);
  }
  for (int i = 0; i < 300; i++) {
    // which+1 is the smallest (the oldest in the array)
    //  formerEvent[i]=0; //Time elapsed before trigging event
  }
  for (int i = 0; i <  networkSize; i++) {
    phaseToMotor= new int [networkSize];
    phaseMapped= new float [nbBall];
    phaseMappedFollow= new float [nbBall];
    ActualVirtualPosition[i]= 0;

    for (int j = 2; j < nbMaxDelais; j++)
      phases[i][j] = -PI;
      
  }
  
  
  
  
  
    //***************************************** SET 3D CAM 
  cam = new PeasyCam(this, 2000);
  cameraZ = (h / 2.0) / tan(radians(fov) / 2.0);
  zNear = cameraZ / 10.0;
  zFar = cameraZ * 10.0;
  println("CamZ: " + cameraZ);
  rectMode(CENTER);
  //***************************************** END 3D CAM  
  
  
//keyMode = " addSignalOneAndTwoBis ";  
keyMode = " phasePattern ";                                                                                                                                                                                                                 
formerKeyMetro = '@';
translate(0, -800,3000);
 
}
// END SETUP
void mouseXY () {  // MODULATION OF SIGMA and FREQ into GRAPHIC chimera state. No effect
  sigma =  (  map ((float (mouseX)/width*1), 0, 1, 0.0, 1.0 ));
  print ("Sigma"); 
  println (sigma);
  Freq  =  (  map ((float (mouseY)/width*1), 0, 1, 0.0, 0.05 ));
}
public void settings() {
  size(600, 600, P3D);
//  windowRatio(600, 600);
} 
void goZero () {
  for (int i = 0; i < 12; i++) {
    //  net.phase[i]=-PI+0.5*PI+PI/12;
    net.phase[i]= -PI/2;
  }
}

int numFrame = 900;
float LFOmemory[] = new float[numFrame];
float Automation1[] = new float[numFrame];
int formerAuto;


String keyMode;
boolean[] moveKeys = new boolean[99];

void setMovement(int k, boolean b) {//azeqsdwxcrty
  switch (k) {
  case 'a':
    moveKeys[0] = b;
    break;
  case 'z':
    moveKeys[1] = b;
    break;
  case 'e':
    moveKeys[2] = b;
    break;
  case 'q':
    moveKeys[3] = b;
    break;
  case 's':
    moveKeys[4] = b;
    break;
  case 'd':
    moveKeys[5] = b;
    break;
  case 'w':
    moveKeys[6] = b;
    break;
  case 'x':
    moveKeys[7] = b;
    break;
  /*       if (keyCode == CONTROL){ // .. in Keypressed =true, inKeyRelesed == false  // moveKeys[8]=true; }   */
  case 'c':
  moveKeys[9] = b;
  break;
  case 'r':
  moveKeys[10] = b;
  break;
  case 'f':
  moveKeys[11] = b;
  break;
  case 'v':
  moveKeys[12] = b;
  break;
    case 't':
  moveKeys[13] = b;
  break;
   
  }
}

void mousePressed() {  
  mouseRecorded = true;
  measure = 0;
  }
// before draw


void draw() {
 // noLoop();
  println (" v0 " + v0 + " v1 " + v1 + " v2 " + v2 + " v3 " + v3 + " v4 " + v4 +  " v5 " + v5);  
 //println (" v0 " + v0 + " v1 " + v1 + " v2 " + v2 + " v3 " + v3 + " v4 " + v4 +  " v5 " + v5); 
 // printArray(encodeur);
 
 
  
    background(0);
//  printDataOnScreen();
  
 println (" ");
 print ("BEGIN OF MAIN KEYCODE  ");   
 
  print (char(keyCode)); 
  print (" Key ");  
  print (char(key)); 
  print (" formerKey "); 
  print (char(formerKey)); 
  print (" formerFormerKey "); 
  print (char(formerFormerKey)); 
  print (" formerSartKey ");  
  print (char(formerSartKey));
  print (" formerKeyMetro ");  
  print (char(formerKeyMetro));
  print (" keyMode ");  
  print (keyMode);
  print (" beatTrigged ");  
  print (beatTrigged);
  print ( " mouseRec ");  println (  mouseRecorded );
  
    if (moveKeys[0]==true){ // CONTROL && a pressed
 //   mappingMode = " circular " ;
    print (" ***************** ", mappingMode);
   
    }
    
    if (moveKeys[1]== true){ // CONTROL a && z pressed
 //   mappingMode = " pendular " ;
    print (" ***************** ", mappingMode);
   
    }  

  
    if (moveKeys[8]==true && moveKeys[0]==true){ // CONTROL && a pressed
  //  keyMode = " signal " ;
    keyMode = " addSignalOneAndTwoTer " ;
  // formerKeyMetro = '@';
    print (" keyMode ", keyMode );
    }
  
    if (moveKeys[8]==true && moveKeys[1]==true){ // CONTROL && z pressed
    keyMode = " addSignalOneAndTwo " ;
   // formerKeyMetro = '@';
    print (" keyMode ",  keyMode );
    }
    
    if (moveKeys[8]==true && moveKeys[2]==true){ // CONTROL && e pressed
    keyMode = " addSignalOneAndTwoBis "  ;
  //  formerKeyMetro = '*';
    print (" keyMode ",  keyMode );
    }

      if (moveKeys[8]==true && moveKeys[10]==true){ // CONTROL && r pressed
    keyMode = " addSignalOneAndTwoQuater "  ;
  //  formerKeyMetro = '*';
    print (" keyMode ",  keyMode );
    }
    
        
    if (moveKeys[8]==true && moveKeys[3]==true){ // CONTROL && q pressed
    keyMode = " followDirectLfo " ;
    formerKeyMetro = '@';
    print (" keyMode ",  keyMode );
    }
    
    if (moveKeys[8]==true && moveKeys[4]==true){ // CONTROL && s pressed
    keyMode = " followDistribueAddphasePattern " ;
    
    formerKeyMetro = '*';
    print (" keyMode ",  keyMode );
    }
    
    if (moveKeys[8]==true && moveKeys[5]==true){ // ALT && d pressed
    keyMode = " followDistribueAddLfoPattern " ;
    
    formerKeyMetro = '*';
    print (" keyMode ",  keyMode );
    }
    
    if (moveKeys[8]==true && moveKeys[6]==true){ //ALT && w pressed
    keyMode = " samplingMode " ;
    
   // formerKeyMetro = '*';
    print (" keyMode ",  keyMode );
    }
    
    if (moveKeys[8]==true && moveKeys[7]==true){ // ALT && x pressed
    keyMode = " null " ;
    
   //formerKeyMetro = '*';
    print (" keyMode ",  keyMode, " formerKeyMetro ", formerKeyMetro );
    }
    
   if (moveKeys[8]==true && moveKeys[9]==true){ // ALT && c pressed  moveKeys[9]==true  //  r pressed  moveKeys[10]==true
    keyMode = " followDistribueAddLfoPatternControl " ;
   // formerKeyMetro = '*';
     
 //  formerKeyMetro = '#';  // can't add phasee
    print (" keyMode ",  keyMode, " formerKeyMetro ", formerKeyMetro );
    }

   if (moveKeys[8]==true && moveKeys[11]==true){ // ALT & f
    keyMode = " methodAbleton " ;
    formerKeyMetro = '*';
  }

       if (moveKeys[8]==true && moveKeys[12]==true){ // ALT & v
    keyMode = " trigEventWithAbletonSignal " ;
    formerKeyMetro = '*';
  }
    
     if (key == '%' ){ 
    keyMode = " phasePattern " ;
   
    
   formerKeyMetro = '*';
    print (" keyMode ",  keyMode, " formerKeyMetro ", formerKeyMetro );
    }
    
        if (key == 'ù' ){
    keyMode = " abletonPattern " ;
    abletonPattern();
   
    
   formerKeyMetro = '*';
    print (" keyMode ",  keyMode, " formerKeyMetro ", formerKeyMetro );
    }
    
    
    
    
    
    
    
    
    
    
   
   if (keyMode == " followDistribueAddLfoPatternControl " ){ //moveKeys[8]==true && // CONTROL 
   // if (formerFormerKey!='#'){
     /*
     if (Key!='#'){
    controlTrigLfoPattern = millis();
  
     }
       */
 //  keyMode = " followDistribueAddLfoPatternControl " ;
    
  // formerKeyMetro = '';
    }
    
    
    
       
    setMovement(key, false); 
        println (" modeStartKeyToFollow ", modeStartKeyToFollow, " keyModeRed",  keyModeRed,"keyMode",  keyMode, "formerKeyMetro ", formerKeyMetro, " controlTrigLfoPattern ", controlTrigLfoPattern );
    keyModeRed = keyMode; // dont read keyMode in file.txt

     if (  keyMode == " trigEventWithAbletonSignal " || keyModeRed == " trigEventWithAbletonSignal " ) {
    //  formerKeyMetro = '@';       
          //  modeStartKeyToFollow = " trigEventWithAbletonSignal ";
            trigEventWithAbletonSignal();
      text ( keyMode, -width, -height); 
       }
     
      if (keyMode == " addSignalOneAndTwoQuater " || keyModeRed == " addSignalOneAndQuater " ) { //drive ball with lfo
    //   PatternFollowLfo();
     propagationMode();
      text ( keyMode, -width, -height); 
    }
   
    if (keyMode == " addSignalOneAndTwoTer " || keyModeRed == " addSignalOneAndTwoTer " ) { //drive ball with lfo
    //   PatternFollowLfo();
     addSignalOneAndTwoTer();
      text ( keyMode, -width, -height); 
    }
    
    
    if (keyMode == " addSignalOneAndTwoBis " || keyModeRed == " addSignalOneAndTwoBis " ) { //drive ball with lfo
    //   PatternFollowLfo();
     addSignalOneAndTwoBis();
      text ( keyMode, -width, -height); 
    }  

  if (keyMode == " addSignalOneAndTwo " || keyModeRed == " addSignalOneAndTwo " ) { //drive ball with lfo
    //   PatternFollowLfo();
     addSignalOneAndTwo();
      text ( keyMode, -width, -height); 
    }
  
  if (keyMode == " methodAbleton " || keyModeRed == " methodAbleton ") { //drive ball with lfo
     methodAbleton();
     text ( keyMode, -width, -height); 
     
  }
  
  if (keyMode == " followDirectLfo " || keyModeRed == " followDirectLfo ") { //drive ball with lfo
     followDirectLfo();
      text ( keyMode, -width, -height); 
  }
  
  if (keyMode == " followDistribueAddphasePattern " || keyModeRed == " followDistribueAddphasePattern ") { //drive ball with lfo
     followDistribueAddphasePattern();
      text ( keyMode, -width, -height); 
  }
  
  if (keyMode == " followDistribueAddLfoPatternBis " || keyModeRed == " followDistribueAddLfoPatternBis ") { //drive ball with lfo
     followDistribueAddLfoPattern();
      text ( keyMode, -width, -height); 
  }
  
    if (keyMode == " samplingMode " || keyModeRed == " samplingMode ") { //drive ball with lfo
  //   followDistribueAddLfoPattern();
     text ( keyMode, -width, -height);
  }
  
  
  
  if (keyMode ==  " followDistribueAddLfoPatternControl " || keyModeRed == " followDistribueAddLfoPatternControl ") { // drive with CONTROL & r
       if (key!='#'){
    controlTrigLfoPattern = millis();
    }
   //  followDistribueAddLfoPatternControl();
  }
  
  if (keyMode == " null " || keyModeRed == " null ") { //drive ball with lfo
    //  followDistribueAddLfoPattern();
      text (keyMode, (width/2), height/2);  

  }
  
   if (keyMode == " phasePattern " ) { //drive ball with lfo
    //  followDistribueAddLfoPattern();
    // phasePattern();
      text (keyMode, (width/2), height/2); 
    

  }
  
     if (keyMode == " abletonPattern " ) { //drive ball with lfo
    //  followDistribueAddLfoPattern();
      abletonPattern();
      text (keyMode, (width/2), height/2);  

  }

  

  
    if (keyMode == " signal "){ // || formerKeyMetro == 'J'
         text ( keyMode, -width, -height); 
    for (int i = 2; i <  networkSize; i++) {
    net.oldPhase[i] =  net.phase[i]; 
    net.phase[i] =  map (signal[i], 0, 1, 0, TWO_PI);   //  
    println ( " signalTo_net.phase ", (i), net.phase[i] );
    
    if (net.oldPhase[i]>net.phase[i]){
   
     DataToDueCircularVirtualPosition[i]= int (map (net.phase[i], TWO_PI, 0, numberOfStep, 0)); 
     net.oldPhase[i]=net.phase[i];
   
     }
       
     else
    
    DataToDueCircularVirtualPosition[i]= (int) map (net.phase[i], 0, TWO_PI, 0, numberOfStep); 
    net.oldPhase[i]=net.phase[i];
  

     }
     sendToTeensy();
     }
     
     
  
  
//  addPhaseAllMode =net.phase[2] + net.phase[3] + net.phase[4] +net.phase[5]+net.phase[6]+net.phase[7]+net.phase[8]+net.phase[9]+net.phase[10]+net.phase[11];
for (int i = 0; i < networkSize; i++) {
 
 addPhaseAllMode = addPhaseAllMode + net.phase[i];
  }
  print (" all automatik  "); println ( addPhaseAllMode);

  addPhaseAllMode =net.phase[0] + net.phase[1] + net.phase[2] +net.phase[3]+net.phase[4]+net.phase[5];//+net.phase[8]+net.phase[9]+net.phase[10]+net.phase[11];
  print (" all one by one "); println ( addPhaseAllMode);
  addPhaseAllMode= map (addPhaseAllMode,-(networkSize-1)*TWO_PI,(networkSize-1)*TWO_PI,0,1); 
  // addPhaseAllMode = 
  print (" all "); println ( addPhaseAllMode);
  formerBeatPrecised=beatPrecised;
  formerMeasure=measure;
  formerBeatOnMeasure=beatOnMeasure;
  if (modeStartKeyToFollow != " samplingModeInternal " )
   { 
    if (modeStartKeyToFollow != " followSignalSampledOppositeWay(frameRatio) " )
  { 
  measure=(int) map (automation4*10, 0, 7.874016, 1, 1000); // mapping from Ableton measure
  // measure=(int) map (automation4*10, 1,1000 , 1, 1000);
  print ( " measure ");print ( measure);
  print (" AUTOMATION 5= beatPrecised  "); 
  beatPrecised=(int) map (automation5*10, 0, 7.874016, 1, 1000); //  mapping from Ableton step in measure
 //  beatPrecised=(int) map (automation5*10, 1,1000 , 1, 1000);
  println (beatPrecised);
  }
   }  
  recordFrame();
 
  print( " begin main loop " ) ;

    trigBeatWithMeasure();
 //   autmationWithMeasureAndNote();
 //**   printDataOnScreen();
 //   printMidiNoteVelocity();
    

    
  if (keyMode != " phasePattern ")
  {   
   if ( key =='B'||  key =='c' ||  key =='>' ||  key =='<' || key =='d' || key =='e'  ) // 
  {
  //  formerKeyMetro = key;   // press l to change formerKeyMetro Mode
   }
  }
  
  if (keyMode == " null ")
  {   
    if ( key =='a'||  key =='b' ||  key =='c' ||  key =='d' || key =='e' || key =='f' || key =='s' || key =='z' || key =='j'  ) // 
   {
     if ( formerKeyCode == BACKSPACE){
    modeStartKey = key;   // press l to change formerKeyMetro Mode
     }
    }
   
       
    switch( modeStartKey) {
    case 'a': 
    modeStartKeyToFollow = " followSignalSampledLPF ";
    print ( " modeStartKeyToFollow " );
    followSignalSampledLPF(frameRatio);
    break;
    case 'b': 
    modeStartKeyToFollow = " followDistribueAddLfoPatternLPF ";
        print ( " modeStartKeyToFollow " );

    text ( " followDistribueAddLfoPatternLPF ", width/4, -height/4);  
    followDistribueAddLfoPatternLPF();
    break;
   case 'c':  
   formerKeyMetro = '@';       
    modeStartKeyToFollow = " followDistribueAddLfoPatternControl ";
        
   // text ( modeStartKeyToFollow, width/2, -height/4);  
    followDistribueAddLfoPatternControl();  
    //if (formerFormerKey!='#'){
          if (Key!='#'){
   // controlTrigLfoPattern = millis();
   // text (  controlTrigLfoPattern, 200, 300 );
  
    //}
    }
    break;
    case 'f':   
     formerKeyMetro = '@';  
    modeStartKeyToFollow = " followSignalfo ";
        print ( " modeStartKeyToFollow " );

    text ( modeStartKeyToFollow, width/4, -height/4); 
    followSignalLfo(frameRatio, signal[networkSize-1]);
    break;

     case 'd': 
     formerKeyMetro = '@';    
    modeStartKeyToFollow = " followDistribueAddLfoPattern ";
      //  print ( " followDistribueAddLfoPattern in KeyMode null " );

    text ( modeStartKeyToFollow, width/4, -height/4); 
  
    followDistribueAddLfoPattern();
    break;


    case 's':  
     formerKeyMetro = '@';    
    modeStartKeyToFollow = " samplingModeInternal ";
     //   print ( " modeStartKeyToFollow " );

    // keyMode = " samplingModeInternal " ;
     text ( modeStartKeyToFollow, width/4, -height/4); 
    break;

    case 'j': 
     formerKeyMetro = '@';     
    modeStartKeyToFollow = " followSignalSampledOppositeWay(frameRatio) ";
   // formerKeyMetro = 'J';  

    text ( modeStartKeyToFollow + " not good ? " , width/4, -height/4); 
    // keyMode = " modeStartKeyToFollow " ;
     text ( keyMode, width/4, -height/4); 
     followSignalSampledOppositeWay(frameRatio);

    break;

    case 'z':     
 //   modeStartKeyToFollow = " samplingMode ";
 //   text ( modeStartKeyToFollow, width/4, -height/4); 
     keyMode = " addSignalOneAndTwoTer " ;
     text ( keyMode, width/4, -height/4); 
     addSignalOneAndTwoTer();
    break;
   
   
   }
  }
   
    if (beatTrigged==true && formerKeyMetro == 's'){ // formerBeatOnMeasure>=4 && beatOnMeasure<=1 && 
        measureRecordStart=measure;
    //    beginSample=millis();
        print ("*****************************************************************************++++++++++++++++++++++ START SAMPLING  "); 
  
     //  formerKeyMetro = 'S';  // back to normal Mode with formerKeyMetro = '$';
   }
     
     
     
  
   if (formerKeyMetro == 'B' ){
    lfoPattern();
    splitTimeLfo();
  //   splitWithTime();
    addSignal(); 
     
     
 
  } 
  
  if (modeStartKeyToFollow == " samplingMode "     ){ // || formerKeyMetro == 'J'
   println ( " IN SAMPLING ");   println ( " IN SAMPLING ");   println ( " IN SAMPLING ");
    println ( " IN SAMPLING ");   println ( " IN SAMPLING ");   println ( " IN SAMPLING ");
     println ( " IN SAMPLING ");   println ( " IN SAMPLING ");   println ( " IN SAMPLING ");
     beginSample=millis();
    text (keyMode + " samplingMode LFOdecay ", width/4, - height - 100);  
     
 //    mouseY=(int) map (automationLFO[1], 0, 1, 0, 400);  // position from Ableton LFOdecay

    
     //  mouseY=mouseY+10;
       mouseX=mouseX+20;
/*
      oldMov = movementRecording;
      
      movementRecording= mouseY;
      
           
       if (oldMov>=  movementRecording){
      
    movementRecording= map (y, 0, 400, 0 , TWO_PI); 
      }
    else  
    movementRecording= map (y, 400, 0, TWO_PI, 0);
     
 */   
     
    
 
    //****  mouseY=(int) map (automation1, 0, 1, 0, 400);  //POSITION MOTOR
    
      //  mouseY = (int) map (signal[3], 0, 1, 0, 400);   // POSITION from ABLETON
    
        //  mouseY=(int) map (Movement/1000.0, 0, 1, 0, 400);  // to do WHAT?

     // followMovementAll();
     //  displayfollowMovementAll();
      //***** */   activeSamplingMeasure(3);
     //***** */    stopSamplingMeasure(4);
    
   //      activeSamplingInternalClock(7); //do not work
   //      stopSamplingInternalClock(8);  //do not work
      //   samplingMovement(2);
   //***** */     samplingMovementPro(); 
        
  //       print (" v1 ");   print (  v1);  print (" v1 ");   println (  v1); 
         sendToTeensy();
 }
 
     print( " INTERNAL CLOCK lastSec " ) ; print( lastSec ) ; print( " actual " ) ; print( actualSec ) ; print( " measure " ) ; println( measure ) ;
    
     if  (actualSec!=lastSec){
         lastSec=actualSec;
      if (modeStartKeyToFollow == " samplingModeInternal "  || modeStartKeyToFollow ==  " followSignalSampledOppositeWay(frameRatio) "  ){    
          measure ++;
       }
      }  
         actualSec =(int) (millis()*0.001); 
         
   //*************    ENDINTERNALCLOCK  
  
  
   if (modeStartKeyToFollow == " samplingModeInternal "     ){ // || formerKeyMetro == 'J'
     println ( " samplingModeInternal  ");
    
     beginSample=millis();
     text ( modeStartKeyToFollow + " mouseY " +  mouseY  + " mouseX " +  mouseX  +  measure , -width/4, - height + 100);  
   //      text ( measure + " mouseY ", width/4, -height-400);  

    //  mouseY=(float) map (mouseY, 0, 400, 0, TWO_PI);  // position from Ableton LFOdecay
     
    //  mouseY=(int) map (automationLFO[1], 0, 1, 0, 400);  // position from Ableton LFOdecay

     //****  newPosF[networkSize-1]=  map (mouseY, 0, height/2, 0, TWO_PI);

      // mouseX=mouseX+27;
      incrementeX=incrementeX+9;
      incrementeX=incrementeX%800;
      

       /*
      if (incrementeX>=400 && incrementeX<=800){ 
       mouseX =(int) map  (incrementeX, 400, 800, 400, 0);
     //  newPosF[networkSize-1]=  map (mouseX, 400, 0, PI, TWO_PI);
       }
      if (incrementeX<400 ){ 
       mouseX =(int) map  (incrementeX, 0, 400, 0, 400);
     //  newPosF[networkSize-1]=  map (mouseX, 0, 400, 0, PI);
       }
*/
       
/*
        mouseY=(int) map (v0, 0, 800, 0, 800)%800;

      if (mouseY>=400 && mouseY<=800){ 
       mouseY =(int) map  (mouseY, 400, 800, 400, 0)*-1;
       newPosF[networkSize-1]=  map (mouseY, 400, 0, PI, TWO_PI);
       }

          if (mouseY <400 ){ 
       mouseY  =(int) map  (mouseY , 0, 400, 0, 400)*-1;
       newPosF[networkSize-1]=  map (mouseY, 0, 400, 0, PI);
       }
*/

       newPosF[networkSize-1]=  map (v0, 0, 800, 0, TWO_PI);
      float rayon=displacement;
      float polarToCartesionX= displacement*cos(newPosF[networkSize-1]);
      float polarToCartesionY= displacement*sin(newPosF[networkSize-1]);

      mouseX= (int) polarToCartesionX;
      mouseY= (int) polarToCartesionY;



      println ( " polarToCartesionX " + polarToCartesionX + " polarToCartesionY " + polarToCartesionY + " newPosF[networkSize-1] " + newPosF[networkSize-1] );



       // mouseX=mouseY;
       

    //  mouseX=mouseX%400;
     
     // mouseY=(int) map (v0, 0, 400, 0, 400)%400;
    
 
    //****  mouseY=(int) map (automation1, 0, 1, 0, 400);  //POSITION MOTOR
    
      //  mouseY = (int) map (signal[3], 0, 1, 0, 400);   // POSITION from ABLETON
    
        //  mouseY=(int) map (Movement/1000.0, 0, 1, 0, 400);  // to do WHAT?

     // followMovementAll();
    //   displayfollowMovementAll();
     //   activeSamplingMeasure(2);
     //  stopSamplingMeasure(3);
    
         activeSamplingInternalClock(1); //do not work
         stopSamplingInternalClock(3);  //do not work
         samplingMovementPro(); 

       //  samplingMovement(2); 
        
  //       print (" v1 ");   print (  v1);  print (" v1 ");   println (  v1); 
    //     sendToTeensy();
 }
 
 
 //**************   END MODE SETTING   *************************


  //  followSignal();

  formerAuto= frameCount-1;
  // see storeinput example to create sample


  // midi note data

  string1.display(ver_move1);
  string2.display(ver_move2);
  string3.display(ver_move3);
  string4.display(ver_move4);
  string5.display(ver_move5);
  string6.display(ver_move6);
  string7.display(ver_move7);
  string8.display(ver_move8);

  if (ver_move1>0) {
    ver_move1 = ver_move1 -duration1;
  }
  if (ver_move2>0) {
    ver_move2 = ver_move2 -duration2;
  }
  if (ver_move3>0) {
    ver_move3 = ver_move3 -duration3;
  }
  if (ver_move4>0) {
    ver_move4 = ver_move4 -duration4;
  }
  if (ver_move5>0) {
    ver_move5 = ver_move5 -duration5;
  }
  if (ver_move6>0) {
    ver_move6 = ver_move6 -duration6;
  }
  if (ver_move7>0) {
    ver_move7 = ver_move7 -duration7;
  }
  if (ver_move8>0) {
    ver_move8 = ver_move8 -duration8;
  }

  ver_move1 = - ver_move1;
  ver_move2 = - ver_move2;
  ver_move3 = - ver_move3;
  ver_move4 = - ver_move4;
  ver_move5 = - ver_move5;
  ver_move6 = - ver_move6;
  ver_move7 = - ver_move7;
  ver_move8 = - ver_move8;

  //potar data move the circle

  // translate(width/2, height/2);
  //OSC RECEIVE
  print(" automation3 followMadTrack  "); 
  print (automation3);
  incrementSpeed+=10;
  incrementSpeed=incrementSpeed%width;

  float ver_move = (float) incrementSpeed;
  float triangularLFO = map(automation2, 0, 1, -300, 300); //FollowLFO   .. used to autmationWithMeasureAndNote()
  float hor_move = map(automation3, 0, 1, -300, 300);  // //followMad

  float RColour = map(automation7, 0, 1, 0, 255);
  // float GColour = map(automation4, 0, 1, 0, 255);
  float LFO1= map(automation6, 0, 1, 0, 255);
  float LFO2= map(automation7, 0, 1, 0, 255);


  // println (map (automation4*10, 0, 7.874016, 0, 1000));



  float BColour = map(automation3, 0, 1, 0, 255);
  //  float XSize = map(automation6, 0, 1, 10, 80);
  float XSize = map(automation1, 0, 1, 10, 80);
  float YSize = map(automation3, 0, 1, 0, 320);
  
   float LFOphase1 = map(automation6, 0, 1, -300, 300);
   float LFOphase2 = map(automation7, 0, 1, -300, 300);
  //  fill(RColour, GColour, BColour);
  ellipse(ver_move, hor_move, 50, 50);
  ellipse(ver_move, triangularLFO, XSize, YSize);
//  ellipse(ver_move, LFOphase1, XSize, YSize); // seeAutomationAreverbershaper
//  ellipse(ver_move, LFOphase2, XSize, YSize); // seeAutomationAreverbershaper
  
  stroke (255,255,0);
  
    ellipse(ver_move, LFO1, XSize, YSize); // seeAutomationAreverbershaper
    
    ellipse(ver_move, LFO2, XSize, YSize); // seeAutomationAreverbershaper
  
  noStroke();
  //  ellipse(400, 400, GColour, GColour);



  // END midi note data 

  //  print (char(key)); println (char(formerKey));
  if (running == false) return;

  int m = millis();
  timeFrame += float(m - lastMillis) * 0.001;
  lastMillis = m;
  // background (0);
  //*********** to read on screen CASES from each frame count 

//**  printDataOnScreen();

  //* ************************ manage strobe with light()
  //  spotLight(102, 153, 100, mouseX, mouseY,cameraZ, 0, 0, -1, PI/2, 1000); 
  //  pointLight(51, 102, 126, mouseX, mouseY, cameraZ);
  if (1000/pulsation*60>=50 && 1000/pulsation*60<=200) { // pulsation of oscillator 11, at the front of the screen; transformed in BPM
    lights();
    if (frameCount%6==0) {
      noLights();
    }
  }
  //************************* end of manage light

  //   doNothing ();// to not repeat case with key
  //==============================TAKE ON BELOW TO RECORD COUPLING

  if (mousePressed != true) {
    coupling = map ((float (mouseX)/width*1), 0, 1, -10, 10 ); //SET COUPLING
    //   key= '#'; keyReleased();
    // keyCode =CONTROL; keyReleased();
    //   net.setCoupling(coupling);
  }


  text(couplingRed, -400, height - 20); 
  //  *********** TAKE ON BELOW TO HAVE THE COUPLING RECORDED RED. AND TAKE OFF ABOVE 
  /*
    couplingRecorded= float (couplingRed)/1000;
   coupling= couplingRecorded;
   net.setCoupling(coupling);
   
   text(couplingRecorded, 400, height - 20);
   */
  //******************************** 

  //======================== TAKE OFF BELOW TO RECORD DATA //======================== TAKE OFF TO RECORD DATA
  if (frameCount == nextFrame) {
    readOneLine();  
    keyReleased(); 
    keyPressed();
  }
  //****************************
  // BEAT_DETECT ();
  //****************************
  print ("FRAMERATIO "); 
  print ((1*frameRatio)); // utilise map (de 1 à 60);
    print ("  ******   FRAMERATIO "); 

  // Calculate the overall order (cohesion) in the network
  PVector order = net.getOrderVector();

  // DATA of cohesion and acceleration of the first and last oscillator
  orderParameter = net.getOrderParameter();

  // averagePhase = order.heading();
 // averagePhase= (net.phase[11]+net.phase[10]+net.phase[9]+net.phase[8]+net.phase[7]+net.phase[6]+net.phase[5]+
 //   net.phase[4]+net.phase[3]+net.phase[2])/(networkSize-2);
  print ("AVERGE PHASE "); 
  print (averagePhase);

 // averageFrequency= (net.naturalFrequency[11]+net.naturalFrequency[10]+net.naturalFrequency[9]+net.naturalFrequency[8]+net.naturalFrequency[7]+net.naturalFrequency[6]+net.naturalFrequency[5]+
 //   net.naturalFrequency[4]+net.naturalFrequency[3]+net.naturalFrequency[2])/(networkSize-2);


  print ("                                   AVERGE FREQUENCY ");  
  print (averageFrequency);

  float deltaPhase = map ((float (mouseY)/width*1), 0, 1, 0, QUARTER_PI ); // option not used
   
//**   averageDeltaPhase=  TWO_PI/ ((net.phase[11]+net.phase[10]+net.phase[9]+net.phase[8]+net.phase[7]+net.phase[6]+net.phase[5]+
// **  net.phase[4]+net.phase[3]+net.phase[2])/ (networkSize-2))*360;
   
  //   averageDeltaPhase=                    (abs((net.phase[11]+net.phase[10])))/TWO_PI*360;
 // averageDeltaPhase=                    (((abs (metroPhase[11])+ abs(metroPhase[10]))))/TWO_PI*360;
//  averageDeltaPhase= map (averageDeltaPhase, 0, TWO_PI, 0, 180);
  print ("                                    averageDeltaPhase ");  
  println (averageDeltaPhase);

  // SHOW_DATA ();
  //****************************
  translate(width/2, -height/2, -1000);// To set the center of the perspective
  rotate(-HALF_PI ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI 

  // Draw  spheres corresponding to the phase of each oscillator
  colorMode(RGB, 255, 255, 255);
  //  stroke(75, 190, 70); // do not show the "perspective sphere"
//  print ("formerKeyMetro "); 

  
  if (actualSec==lastSec) {  // trigged on internal clock
      trigRatio = true;
    //  background(127, 40, 60);
   }
   
   else trigRatio = false;
   
   
    if (beatTrigged== true) {  // trigged with measure
      trigRatio = true;
    //  background(127, 40, 60);
   }
  
  else trigRatio = false;
   
  if (formerKeyMetro == 'J' ) { //drive ball with lfo ONCE //  && trigRatio == true
  trigFollowSampling=true;
  }
  
   if (formerKeyMetro != 'J' ) {
//   if (formerKeyMetro == 's' ||  formerKeyMetro ==  '@' || formerKeyMetro ==  'B' ) { //you can't distribuate data to others balls  //formerKeyMetro == '*' || formerKeyMetro == '$' ||
  trigFollowSampling=false;
  }
      
      
  if (trigFollowSampling == true ) {
      print (" trigFollowSampling ");   println (trigFollowSampling); 
  
    //  followMadTrack1bis(); ..  folloLFO with my technique
    //    followSignal();
  //****  delayTimeFollowPhase11=60;  // to control time phase offseet with a lot of delay time. You can wait one seconde before the next ball follow the previous ball
    
    
  //  followSignalSampled(frameRatio);
    samplingMovementPro();
  //  noStroke();
  //  fill( 255, 40, 40 );
  // circle ( 100* cos (movement)+400, 100*sin (movement)+400, 20);
  //   followSignalSampled(frameRatio); //no WORK with frame
     followSignalSampledOppositeWay(frameRatio);// with millis()
  //  phasePattern();
   // pendularPatternNoJoe(); // without transformation of position's datas in the Arduino.
    
    rotate(PI/2);
    printDataOnScreen();
    stroke(255);
    

    rect( (currTime % 2) / 2 * width, 10, 2, 8 );
  
//  println (currTime % 2);
    rect( (currTime % 4) / 4 * width, 20, 2, 8 );
    rect( (currTime % 8) / 8 * width, 30, 2, 8 );
    
    rotate(-PI/2);
    countRevs();
   }
   
   modePendulaireModeCirculaire();
   

  
  // ================================= 


  // countRevs();   
  println(frameCount + ": " + Arrays.toString(rev));
  // ================== fonction not used
  // devant_derriere();
  // manageCoupling();
  // mouseMovedPrinted ();
  // SoundmouseMoved(); // to automatise sound with speed. In the setup uncomment the out1, out2 ...

  print ("KEY");    
  print (char(key)); 
  print ("formerKey: "); 
  print (char(formerKey));  
  print ("formerStartKey: ");  
  println (char(formerSartKey));
  if (formerKey== '!') {
    formerSartKey = formerKey;
  }

  if (key=='j') {// send a trig to start record in Ableton live 
    background(255);
    startStop= 3;//
    key='='; 
    keyPressed();
    print ("startStop from the beginning: "); 
    println (startStop);
    key='#'; // reset key to a key doing nothing
  } else {
    startStop= 2;
  } 

  // option to control sound in Live when the animation is stopped then started again and when oscillator 11 touches the left  
  if (formerSartKey == '!' &&  TrigmodPos[networkSize]>=0 && TrigmodPos[networkSize]<1) { 
    println ("TRIG LIVE WITH oscillator 11 on LEFT" ); //
    startStop= 1;  
    print ("MOVEMENT AND TIMER is already started, now START LIVE: "); 
    println (startStop );
/*
    String dataMarkedToDue  ="<" 
    
      + mapAcceleration[11]+","+  int  (1000/avgTimer.average()*60*1000)  +","+cohesionCounterHigh+","
      //+ onOFF+"," +nextScene+","
      //     + mapAcceleration[11]+","+ mapAcceleration[11]+","+mapAcceleration[11]+","+ mapAcceleration[11]+","+mapAcceleration[11]+"," 

      +VirtualPosition[11] +","+VirtualPosition[10] +"," +(VirtualPosition[9]) +","+VirtualPosition[8] +","+VirtualPosition[7] +","
      +VirtualPosition[6] +","+VirtualPosition[5] +","+VirtualPosition[4] +","+VirtualPosition[3] +","+VirtualPosition[2] +","

      +TrigmodPos[11]+","+TrigmodPos[10]+","+TrigmodPos[9]+","+TrigmodPos[8]+","+TrigmodPos[7]+","+TrigmodPos[6]+","+TrigmodPos[5]+","+TrigmodPos[4]+","+TrigmodPos[3]+","+TrigmodPos[2]+","+TrigmodPos[1]+","+TrigmodPos[0]+ "," // to manage 12 note

      +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+ ","+ startStop + ">"; // (2= neither start, neither stop)   cohesionCounterHigh // +orderCohesion+ ">";LevelCohesionToSend ","+ int (map ( LowLevelCohesionToSend, 0, 1, 0, 100))+ 

    print ("dataStart: "); 
    println(frameCount + ": " +  " " + ( dataMarkedToDue ));
*/
    formerKey = '#'; //reset formerkey to not trigging LIVE
    formerSartKey = formerKey;
  }
  print ("KEY ");    
  print (char(key)); 
  print ("FORMERKEY "); 
  print (char(formerKey)); 
  print ("FORMERSTARTKEY ");  
  println (char(formerSartKey));
  // bpmAsfrequencyfunction ();

  textSize (100);


  if ( key=='*' ) {// || key==',' || key==';' || key==':'
    circularMov = true;
  }

  if ( key=='$') {//
    circularMov = false;
  }

  cohesionTrig = int (map (LevelCohesionToSend, 0, 1, 0, 100));
  println (cohesionTrig);


  // ***** automatise Oscillator Moving with a former Key
   arduinoPos(); // // carefull with arduinoPos and function after arduinopos
    if (formerKeyMetro != 'J' ) { //countRevolutions when it is not the mode J
   countRevs();
       }
       
   //**********************************************************************    
   // STARTERCASE with formerKey
 if ( keyMode != " null "  ) {  
    if ( keyMode == " phasePattern "  ) { 
 //       pendularPatternLFO();
      text ( " phase offset " + k + " delay " + d, - width-400, - height+400);
       
  if (formerKey=='o' || key=='ç'|| keyCode==SHIFT || key=='*' || key=='ç' || key==',' || key==';' || key=='A'
    || key=='n' || key=='N'   ) { //  || key=='ç'|| keyCode==SHIFT || key=='*' || key=='ç' || key==',' || key==';'
    //  formerKeyo();
    //  formerKeyoJo();
  }

  if (formerKey=='L') { // like V and shift two frequencies and phases at the same time
    formerSartKey='L';  // do note automatise movement of balls with note 
    // formerKeyL();
  } 
  if (formerSartKey=='L') { // like V and shift two frequencies and phases at the same time
    formerKeyL();
  }
  // oscillator moving
  // upstairauto

  // STARTERV Ar
  if (formerSartKey =='v' && (formerKey=='e' || formerKey=='z' || formerKey=='d' || formerKey=='r' || formerKey=='v')) { //  formerstartKey =='v' && || formerKey=='x'
    if (circularMov==false  ) {//|| circularMov==false
      for (int i = 2; i < (networkSize-0); i++) {
        PendularOldOldOldLeftVirtualPosition[i]=PendularOldOldLeftVirtualPosition[i];
        PendularOldOldLeftVirtualPosition[i]=PendularOldLeftVirtualPosition[i];
        PendularOldLeftVirtualPosition[i]=PendularLeftVirtualPosition[i];
        //    PendularLeftVirtualPosition[i]=CircularVirtualPosition[i];
        //   PendularOldLeftVirtualPosition[i]=CircularOldVirtualPosition[i];
      } 
      print ("STARTERvBIS PendularLeftVirtualPosition "); 
      print (memoryi); 
      print (" ");   
      print (PendularLeftVirtualPosition[memoryi]); 
      print ("STARTERvBIS PendularLeftVirtualPosition%"); 
      print (oldMemoryi); 
      print (" "); 
      println (PendularOldLeftVirtualPosition[oldMemoryi]); 

      if  ( 1>=1
        //        (PendularLeftVirtualPosition[memoryi]%6400 <= 100 &&  (PendularOldOldLeftVirtualPosition[oldMemoryi]%6400 <=  PendularOldLeftVirtualPosition[oldMemoryi]%6400 ) && // you turn on cw
        //        (PendularLeftVirtualPosition[oldMemoryi]%6400 <= PendularOldOldOldLeftVirtualPosition[oldMemoryi]%6400)) ||
        ) { //good with the ordination of the upstairc
        //  background (50,50,50);
        println ("HEREVBIS");   
        println ("HEREVBIS"); 
        print ("PendularLeftVirtualPosition"); 
        print (memoryi); 
        print(" "); 
        print (PendularLeftVirtualPosition[memoryi]);
        print ("PendularLeftVirtualPosition"); 
        print (oldMemoryi); 
        print(" "); 
        println (PendularOldLeftVirtualPosition[oldMemoryi]);            
        if  (millis()>TimeUpstair+d) {
          //  TimeUpstair=millis();
          TimeUpstair=millis();
          key='v'; 
          keyReleased();  
          println (" v  circular Pressed? ");
          //   formerKey='+';
          formerSartKey='v';
        }
      }
    }
  }
  // ***** automatise Oscillator Moving with a former Key

  // triggerv
  if (formerKey=='v') {
    formerKeyv(memoryi, oldMemoryi, k);
    formerSartKey ='v';
  }

 //*** arduinoPos();

  // triggerc

  if (formerSartKey =='c' && (formerKey=='&' || formerKey=='+')) { //  formerstartKey =='v' &&
    if (circularMov==true ) {
      for (int i = 0; i < (networkSize-0); i++) {
        PendularLeftVirtualPosition[i]=CircularVirtualPosition[i];
        PendularOldLeftVirtualPosition[i]=CircularOldVirtualPosition[i];
      } 
      print ("STARTER PendularLeftVirtualPosition "); 
      print (memoryi); 
      print (" ");   
      print (PendularLeftVirtualPosition[memoryi]); 
      print ("STARTER PendularLeftVirtualPosition "); 
      print (oldMemoryi); 
      print (" "); 
      print (PendularOldLeftVirtualPosition[oldMemoryi]); 

      if (millis()>TimeUpstair+d) {
        if  ((PendularLeftVirtualPosition[memoryi]%6400 >=  PendularLeftVirtualPosition[oldMemoryi]%6400 )) { //good with the ordination of the upstairc
          print ("PendularLeftVirtualPosition"); 
          print (memoryi); 
          print(" "); 
          print (PendularLeftVirtualPosition[memoryi]);
          print ("PendularLeftVirtualPosition"); 
          print (oldMemoryi); 
          print(" "); 
          print (PendularOldLeftVirtualPosition[oldMemoryi]);


          key='c'; 
          keyReleased();  
          println (" c circular Pressed? ");
        }
        TimeUpstair=millis();
      }
    }
    if (circularMov==false ) {
      if (millis()>=TimeUpstair+d) {
        if  (PendularLeftVirtualPosition[memoryi]> 400 ||  PendularLeftVirtualPosition[memoryi]<-400 ) { //&&  oldOscillatorMoving[i]== true
          print ("PendularLeftVirtualPosition"); 
          print (memoryi); 
          print(" "); 
          print (PendularLeftVirtualPosition[memoryi]);      
          key='c'; 
          keyReleased();  
          println (" c circular Pressed? ");
        }  
        TimeUpstair=millis();
      }
    }
  }
  
  if (formerKey=='c' ) {
  //  formerKeyc(memoryi, oldMemoryi);
    println (" FORMER formerKeyc ");
    String debug;
    debug = " FORMER formerKeyc string ";
    println (debug); 
    
    formerSartKey ='c';
  } 
  
  //************************************************************ //************************************************************   
  //************************************************************ //************************************************************ 
  //   begin of upstairAuto function 
  //    trigw = trigx
  if (formerKey=='w') {
    print (" formerKeyx? "); 
    print (formerKey );
 //   formerKeyCopposite(memoryi, oldMemoryi, k);
    formerSartKey ='w';
  }  
  //    trigX
  if (formerKey=='X') {
    print (" formerKeyx? "); 
    print (formerKey );
    formerKeyC(memoryi, oldMemoryi, k);
    formerSartKey ='X';
  }  
  // trigx
  if (formerKey=='x') {
    //   interPhase[memoryi]= metroPhase[memoryi];
    print (" formerKeyw? "); 
    print (formerKey );
    formerKeyCu$(memoryi, oldMemoryi, k);
    //  formerKeyCoriginal(memoryi, oldMemoryi, k);
    formerSartKey ='x';
  } 
  //   starterx
  if (formerSartKey =='x' && (formerKey=='e'  )  ) { //  formerstartKey =='v' && || formerKey=='X' || KeyCode== SHIFT
    if (circularMov==true || circularMov==false ) {//|| circularMov==false

      println ("STARTERxBIS DataToDueCircular ");
    

      if  ( 1>=1  ) { 
        if  (millis()>TimeUpstair+d) {
          //  TimeUpstair=millis();
          TimeUpstair=millis();
          key='x'; 
          keyReleased();  
          println ("  x circular Pressed automa? ");
          //   formerKey='+';
          formerSartKey='x';
        }
      }
    }
  }
  }
  
  // END STARTERCASE with formerKey
  //   starterX
  if (formerSartKey =='X' && (formerKey=='e'  )  ) { //  formerstartKey =='v' && || formerKey=='x' || KeyCode== SHIFT
    if (circularMov==true || circularMov==false ) {//|| circularMov==false

      println ("STARTERXBIS DataToDueCircular ");
      //     print (" DataToDueCircularVirtualPosition[oldMemoryi-1] " ) ;  println (DataToDueCircularVirtualPosition[oldMemoryi-1]); BUG x is ased on u$
      print (" DataToDueCircularVirtualPosition[oldMemoryi] " ) ;  
      println (DataToDueCircularVirtualPosition[oldMemoryi]);
      print (" 6400-DataToDueCircularVirtualPosition[oldMemoryi] " ) ;  
      println (6400 - DataToDueCircularVirtualPosition[oldMemoryi]);

      if  ( 1>=1  ) { 
        if  (millis()>TimeUpstair+d) {
          //  TimeUpstair=millis();
          TimeUpstair=millis();
          key='X'; 
          keyReleased();  
          println (" x  circular Pressed? ");
          //   formerKey='+';
          formerSartKey='X';
        }
      }
    }
  } //end starterX 
  //   starterw
  if (formerSartKey =='w'   )  { //  formerstartKey =='v' && || formerKey=='x' || KeyCode== SHIFT
    if (circularMov==true || circularMov==false ) {//|| circularMov==false
//  printDataOnScreen();
 //     pendularPatternLFO();

   
     //   if  (millis()>TimeUpstair+d) {
              if  (millis()>TimeUpstair) {
          //  TimeUpstair=millis();
          TimeUpstair=millis();
         key='w'; 
          keyReleased();  
           formerKeyCopposite(memoryi, oldMemoryi, k);
          println (" w  circular Pressed? ");
     
          formerSartKey='w';
        
      }
    }
  } //end starterX 



  // *****END of automatise Oscillator Moving with a former Key

  // arduinoPos();
  //metroEND
  if (circularMov==true || circularMov==false ) {
    //     print (" END ");          
    for (int i = 2; i < (12); i++) {// pendular from -800 to 800
      /*
              print (" itPhaseE "); print (i); print (" "); print (interPhase[i]); 
       print (" itPhaCiE "); print (i); print (" "); print (interPhaseCircular[i]);
       
       print (" metrPhaE "); print (i); print (" "); print (metroPhase[i]); 
       print (" meOlPhaE "); print (i); print (" "); print (metroOldPhase[i]);
       
       print (" ne.phasE "); print (i); print (" "); print (net.phase[i]); 
       print (" neOphasE "); print (i); print (" "); println (net.oldPhase[i]);
       */
    }
  } 
  //: noLoop();

  //   end of STARTERX function DELETED

  if (formerKey=='I') {
    formerKeyI();
  }  
  /*
    if (formerKey=='x') { // follow mode. What is w?
   formerx();
   //  key ='#';
   } 
   */
  if (formerKey=='V') { // like V and shift two frequencies and phases at the same time
    formerKeyV();
    //  key ='#';
     }
   }
  //************ arduinoPos(); // to control Pos of motor and Trigging note and computing pulsation
  // countPendularTrig ();
  //frameStop(); 
  formerFormerKey= formerKey;

  if ( key!=':' ) {// formerKey!=':' ||  || key=='ç'
     if (  key<65535) { // if there is no SHIFT but the other key
 //   if (formerKeyMetro != 'J') { // if there is no SHIFT but the other key
      formerKey= key;   
      //     formerKeyCodeAzerty = keyCode;
      //       formerKeyCode = keyCode;
    //  }
    }
  }
  if ( keyCode != 0) {// formerKey!=':' ||  || key=='ç'
    //      formerKey= key;   
    formerKeyCodeAzerty = keyCode;
    formerKeyCode = keyCode;
  }
  print (" KEY  ");    
  print  (key); 
  print (" FORMERKEY "); 
  print (formerKey); 
  print (" formerFormerKey "); 
  print (formerFormerKey); 
  print (" FORMERSTARTKEY ");  
  print (formerSartKey);

  print (" KEY  ");    
  print (char(key)); 
  print (" FORMERKEY "); 
  print (char(formerKey)); 
  print (" formerFormerKey "); 
  print (char(formerFormerKey)); 
  print (" FORMERSTARTKEY ");  
  print (char(formerSartKey));
  print (" formerKeyMetro ");  
  println (char(formerKeyMetro));

  print (" KEYCODE  ");    
  print  (keyCode);   
  print (" char KEYCODE  ");    
  print  (char (keyCode));
  print (" former KEYCODE  ");    
  print  (formerKeyCode);   
  print ("char formerKeyCode  ");    
  println  (char (formerKeyCode)); 
  print (" former KEYCODEAZERTY  ");    
  print  (formerKeyCodeAzerty);   
  print ("char formerKeyCodeAZERTY  ");    
  println  (char (formerKeyCodeAzerty)); 

  if ( key==',') {
    //    formerKey= formerKey;
    //    formerFormerKey= formerFormerKey;
    //    formerKeyCodeAzerty =formerKeyCodeAzerty;
  }
  
  if ( formerKeyMetro == 'J') {
      
    //    formerKey= formerKey;
    //    formerFormerKey= formerFormerKey;
        formerKeyCodeAzerty =formerKeyMetro;
  }

  
  for (int i = 2; i < networkSize; i++) {
    phaseReturned[i]=net.phase[i];
  }
  // =============== =============== =============== =============== =============== =============== =============== END OF MAIN LOOP   
  // =============== =============== =============== =============== =============== =============== =============== END OF MAIN LOOP   
  // =============== =============== =============== =============== =============== =============== =============== END OF MAIN LOOP
  // =============== =============== =============== =============== =============== =============== =============== END OF MAIN LOOP
}

//trigRightTemp[i] = int [] TrigModPos { 
//if former





void BEAT_DETECT () {
  // end beatdetect
}

void manageCoupling() {
 
  if (orderParameter<=0.01  ) { //  net.velocity[0]<0 && net.velocity[0]>-1.46c
    coupling= (-coupling);
    //  coupling = exp(abs(coupling));
    net.setCoupling(coupling);
  } else  if (orderParameter>=0.1  ) {
    coupling = map ((float (mouseX)/width*1), 0, 1, -10, 10 );
    net.setCoupling(coupling);
  } 
  print ("coupling_Managed");    
  println ( coupling);
} 

void  doSEVEN() {

  //  if (frequencyEnergy(k)>1.7 ) {
  if ((K>199 && H <200)&& S>150) {
    //   if ((H>199 && H <200)&& S>150){

    print (" doSEVEN()doSEVEN()doSEVEN()doSEVEN()doSEVEN()doSEVEN()doSEVEN()doSEVEN()doSEVEN()");

    //   key='M'; keyPressed();
    key='4'; 
    keyReleased(); // '6';
    // find something actualising or doing case 7 automatical when kick is upper than 1.7
  }
}
void devant_derriere() {
  //    if ( (net.phase[networkSize] && rev[networkSize])  > (net.phase[0] && rev[0])){//     (net.phase[0] >  (j[i]==0 && rev[i]<0))  { 

  if ( (net.phase[9]  > net.phase[0]) &&  ( rev[9]  > rev[0]+2)) {//     (net.phase[0] >  (j[i]==0 && rev[i]<0))  { 

    print (" net.phase[9] "); 
    print ( net.phase[9] );  
    print (" net.phase[0 "); 
    print ( net.phase[0] ); 
    key = '3'; 
    keyReleased();
  }

  if ( (net.phase[0]  > net.phase[9]) &&  ( rev[0]  > rev[9]+2)) {//     (net.phase[0] >  (j[i]==0 && rev[i]<0))  { 

    print (" net.phase[9] "); 
    print ( net.phase[9] );  
    print (" net.phase[0 "); 
    print ( net.phase[0] ); 
    //       key = 'O'; keyPressed ();   
    key = '4'; 
    keyReleased();
  }
}


void countRevs() { // ============================================= Ter NE PAS TOUCHER LE COMPTEUR ou Reduire l'espace avant et apres 0 pour eviter bug à grande vitesse

  onOFF=0;

  for (int i = 0; i < networkSize; i++) { 
//**    print (net.oldPhase[i]); print ("count rev ");   println (net.phase[i]); 
    // decrement caused by negative angular velocity
    // both positive angles || both negative angles || positive-to-negative angle
    //   if (//(net.oldPhase[i] < 0.25 * PI && net.phase[i] > 1.75 * PI) ||//
    if (
      ((net.oldPhase[i] < 0.25 *PI && net.oldPhase[i]>0)  && (net.phase[i] > -0.25* PI && net.phase[i] <0))  || 
      (net.oldPhase[i] < -1.75 * PI && net.phase[i] > -0.25 * PI)// ||
      // (net.oldPhase[i] < 0.25 * PI && net.phase[i] > -0.25 * PI)
      ) {
      onOFF = 1;
      //    TrigmodPos[i]=0;
      rev[i]--;
      //      print (" revultion negative  "); println (revolution[i]=i+1);
      //   revolution[i]=i+1;
      revolution[i]=0; // trig 0 to sent 0 in Max4Live
  //**    memoryi=i;


      decompte[i] = -1; // // RESET COUNTER AT 0 (i know it's strange, otherwise with 0 it begin at 1, not 0)
    } else { // if you do twice there is a funny bug
      //    decompte[i]  ++; 
      //   revolution[i]=0;
    }


    // increment caused by positive angular velocity
    // both positive angles || both negative angles || negative-to-positive angle

    if (
      ((net.oldPhase[i] > -0.25 *PI && net.oldPhase[i]<0)  && (net.phase[i] < 0.25* PI && net.phase[i] >0))  || 
      (net.oldPhase[i] > 1.75 * PI && net.phase[i] < 0.25*PI)
      ) {
      onOFF = 1;
      //   TrigmodPos[i]=0;
      rev[i]++;
      //   revolution[i]=i+1;
      revolution[i]=0;   // trig 0 to sent 0 in Max4Live
  //**    memoryi=i;
      decompte[i] = 0;  // RESET COUNTER AT 0
    } else {

      decompte[i]  ++; //START COUNTER when a REVOLUTION START OR FINISH

      revolution[i]=1;
    }
     if (  revolution[i]<1) {
  print (" revolution[i] "); print ( memoryi); print ("  "); println (revolution[memoryi]);
    }
  }
  
  /*
  if (

    (net.oldPhase[memoryi] < -1.75 * PI && net.phase[memoryi] >= -0.25*TWO_PI) || ( net.phase[memoryi]<=-TWO_PI+0.23  && net.phase[memoryi] >= -0.25*TWO_PI ) 
    ) {
    onOFF = 1;
    //   background (27,59,78);
    //    TrigmodPos[i]=0;
    rev[memoryi]--;

    // memoryi=i;


    decompte[memoryi] = -1; // // RESET COUNTER AT 0 (i know it's strange, otherwise with 0 it begin at 1, not 0)
  }
 */
} 

void printSummary(int i) {
  /*
    print("oldphase "); print(i); print(" ");
   print(net.oldPhase[i]); print(" ");
   print("phase "); print(i); print(" ");
   print(net.phase[i]); print(" ");
   print("velocity"); print(i); print(" ");
   print(net.velocity[i]); print(" ");  
   print("frequency "); print(i); print(" "); 
   print(net.naturalFrequency[i]);
   print("OldFrequency "); print(i); print(" "); 
   println(OldFrequency[i]);
   */
}

void arduinoPos() { 
  
  
  

  if (formerKeyMetro == '>') {  // formerKeyMetro == '<' || 
    for (int i = 0; i < networkSize; i++) {
      // rev[i]=rev[0];


      //*******************************  ASSIGN MOTOR WITH POSITION

      if (rev[i]!=0  && (newPosF[i] >  0) ) { // number of revolution is even and rotation is clock wise   
        pos[i]= int (map (newPosF[i], 0, TWO_PI, 0, numberOfStep))+ (rev[i]*numberOfStep);
      }

      if (rev[i]!=0  && (newPosF[i] <  0)) { // number of revolution is even and rotation is Counter clock wise          // pos[i]= int (map (newPosF[i], 0, -TWO_PI, 0,  numberOfStep))+ (rev[i]*numberOfStep);

        pos[i]= int (map (newPosF[i], 0, -TWO_PI, numberOfStep, 0)) +(rev[i]*numberOfStep);       //   print ("pos "); print (i); print (" ");println (pos[i]);
      }

      if (rev[i]==0 && (newPosF[i] < 0) ) { //  number of revolution is 0 and rotation is counter clock wise 
        pos[i]= int (map (newPosF[i], 0, -TWO_PI, numberOfStep, 0));        
      }         
      if  (rev[i]==0 && (newPosF[i] > 0) ) {  //  number of revolution is 0 and rotation is clock wise     
        pos[i]= int (map (newPosF[i], 0, TWO_PI, 0, numberOfStep));                //      print ("pos "); print (i); print (" CW rev=0 ");println (pos[i]);
      }
    }
  }

  //  else if (formerFormerKey=='Q') {
  for (int i = 0; i < networkSize; i++) {

    //rev[i]=rev[0];

    //*******************************  ASSIGN MOTOR WITH POSITION
    //   pos[i]= pos[i]-numberOfStep/4; // The positions 0 of my motors in real are shifted of - half_PI  

    if (rev[i]!=0  && (net.phase[i] >  0) ) { // number of revolution is even and rotation is clock wise   
      Pos[i]= int (map (net.phase[i], 0, TWO_PI, 0, numberOfStep));
    }

    //   if (rev[i]!=0  && (net.phase[i] <  0)) { // number of revolution is even and rotation is Counter clock wise   
    if (rev[i]!=0  && (net.phase[i] <  0)) { // number of revolution is even and rotation is Counter clock wise   

      Pos[i]= int (map (net.phase[i], 0, -TWO_PI, numberOfStep, 0));
    }

    if (rev[i]==0 && (net.phase[i] < 0) ) { //  number of revolution is 0 and rotation is counter clock wise 
      Pos[i]= int (map (net.phase[i], 0, -TWO_PI, numberOfStep, 0));        
      //    print ("pos "); print (i); print (" CCW rev=0");println (pos[i]);
    }         
    if  (rev[i]==0 && (net.phase[i] > 0) ) {  //  number of revolution is 0 and rotation is clock wise     
      Pos[i]= int (map (net.phase[i], 0, TWO_PI, 0, numberOfStep));         
    }
  }
  
  
  
  //  }  

  //=======================================================================

  // ATTENTION A ENVOYER LE MEME NOMBRE DE VAARIABLE QUE PEUT EN RECEVOIR l'ARDUINO. Here is 30 datas+1 data of COHESION 

  // TRIGGING 1 when THE COHESION is very Low   

  //  if (orderParameter>=0.999 ) {  //&& decompte[9]<=5// && revolution[9]==10 the first oscillator (in front the secreen) pass trough 0
  if (orderParameter<=0.001) { 
    cohesionCounterLow++;

    if (cohesionCounterLow==1) { 
      //   background (50);
    } 

    if ( (cohesionCounterLow>=1 && cohesionCounterLow<=1) || (!(cohesionCounterLow>=2 && cohesionCounterLow<=2))|| (!(cohesionCounterLow>=1 && cohesionCounterLow<=4)))
    {
      orderCohesionLow= 1;  // Trig sound and back ground
      //    background (255);
    }
  } else if  ( orderParameter>0.001 ) { 
    cohesionCounterLow=0 ; // Reset cohesionCounterLow at 0

    orderCohesionLow= -1;
  } 

  if (orderParameter<=0.0011 ) { // && orderParameter>=0.099
    cohesionCounterHigh=0 ;
    orderCohesion= 0;
  } 

  if (orderParameter>=0.999 ) {  //&& decompte[9]<=5// && revolution[9]==10 the first oscillator (in front the secreen) pass trough 0
    cohesionCounterHigh++;
    if (cohesionCounterHigh==1) { 
      //   background (75);
    } 

    if ( (cohesionCounterHigh>=1 && cohesionCounterHigh<=1) || (!(cohesionCounterHigh>=2 && cohesionCounterHigh<=2)) || (!(cohesionCounterHigh>=1 && cohesionCounterHigh<=4)))
    {
      orderCohesion= 1;
    }
  } else if  ( orderParameter>=0.0011  && orderParameter<=0.999) { 
    cohesionCounterHigh=0 ; // RESET COUNTER AT 0
    orderCohesion= -1;
  } 

  LevelCohesionToSend= orderParameter;

  // ATTENTION A ENVOYER LE MEME NOMBRE DE VARAIABLE 
  //***********METTRE TOUT SUR LA MEME LIGNE
  String counterNoMarked = rev[5]+","+rev[4]+","+rev[3]+","+rev[2]+","+rev[1]+","+rev[0]+","; // rev[9]+","+rev[8]+","+rev[7]+","+rev[6]+","+
  // you have the number of revolution made by each oscillator
  String revolutionNoMarked = revolution[5]+","+revolution[4]+","+revolution[3]+","+revolution[2]+","+revolution[1]+","+revolution[0]+","; //revolution[9]+","+revolution[8]+","+revolution[7]+","+revolution[6]+","+

  // =============== MAP ACCORDING LFO, CIRCULAR, PENDULAR PHASE To ADAPT IT TO the stepper motor
  // ===============* CIRCULAR MODE TO TRIG DATA ACCORDING POSITION *
  if (formerKeyMetro == '£'  || formerKeyMetro == '*' || formerKeyMetro == 'J' || formerKeyMetro == 's' || formerKeyMetro == '@'  ) { //interPosition   || formerKeyMetro == 'c'
     if (   keyMode == " ableton " ) {
     for (int i = 0; i < networkSize; i++) { 
            net.phase[i] = newPosF[i];
    }
   }
     if (  keyMode == " addSignalOneAndTwo " ) {
     for (int i = 0; i < networkSize; i++) {  
        //    net.phase[i] = newPosF[i];
       //    net.phase[i] = newPosXaddSignal[i];
     }
    } 
    
       if (  keyMode == " null " ) {
     for (int i = 0; i < networkSize; i++) {  
        //    net.phase[i] = newPosF[i];
        //   net.phase[i] = newPosXaddSignal[i];
    }
   }
   
  if (formerKeyMetro == 's' && millis()<10000 ) { //put netphase 11 to phase 
  //j  net.phase[11]= PI+0.1; // do not forget 
  }
  if (formerKeyMetro == 's' && millis()>10000 ) { //put netphase 11 to phase
  
 //   key= 'j'; keyPressed (); // to start Live 
 
  }
    for (int i = 0; i < networkSize; i++) {
        VirtualPosition[i]= ActualVirtualPosition[i];   // when you change mode of movement, you add last position  DataToDueCircularVirtualPosition[i] +
      // =============== MAP PHASE To ADAPT IT TO the stepper motor    // =============== TRIG 0 when oscillator pass THROUG 0:  No effect on positions datas given to teensyport

      if (net.phase[i] >  0 ) {  
        CircularOldVirtualPosition[i]=CircularVirtualPosition[i]; 
        CircularVirtualPosition[i]= int (map (net.phase[i], 0, TWO_PI, 0, numberOfStep));
        Pos[i]= int (map (net.phase[i], 0, TWO_PI, 0, 127)); // to Oscsend
        
        

     if ((CircularVirtualPosition[i]>3199 && CircularOldVirtualPosition[i]<3200 && CircularOldVirtualPosition[i]>201  )
          || (CircularVirtualPosition[i]<3201 && CircularOldVirtualPosition[i]>3200 && CircularVirtualPosition[i]>201  )  ) {

       TrigmodPos[i]=0;     
       print (i); 
       print(" CIRCULAR PASS CLOCKWISE THROUG 0: ");
       println (  TrigmodPos[i]=0); 
       print (" virt ");  println (  VirtualPosition[i]); print (" Cirvirt "); print(  CircularVirtualPosition[i]); print (" CirOldvirt "); println (  CircularOldVirtualPosition[i]);
        } else  TrigmodPos[i]=1;
      } else {
        CircularOldVirtualPosition[i]=CircularVirtualPosition[i]; 
        CircularVirtualPosition[i]= int (map (net.phase[i], 0, -TWO_PI, numberOfStep, 0));  
        Pos[i]= int (map (net.phase[i], 0, -TWO_PI, 127, 0));  // to Oscsend  

    if ((CircularVirtualPosition[i]<3201 && CircularOldVirtualPosition[i]>3200 )   ) {
       TrigmodPos[i]=0;     
       print (i); 
       print(" CIRCULAR PASS CLOCKWISE THROUG 0: ");
       println (  TrigmodPos[i]=0); 
       print (" virt ");  println (  VirtualPosition[i]); print (" Cirvirt "); print(  CircularVirtualPosition[i]); print (" CirOldvirt "); println (  CircularOldVirtualPosition[i]);

        } else  TrigmodPos[i]=1;
      } 
      DataToDueCircularVirtualPosition[i]=CircularVirtualPosition[i];
      VirtualPosition[i]= CircularVirtualPosition[i]+ActualVirtualPosition[i]; 
      ActualVirtualPositionFromOtherMode[i]=VirtualPosition[i];
    }
    for (int i = 2; i < networkSize; i++) {   
      print(" Pos "); 
      print (i); 
      print(" "); 
      print (Pos[i]);
    }
     println(" "); 
  }

  //*************************************TRIG and  MAP PENDULAR PHASE  for TEENSY and !ç (to manage sound)

  if (formerKeyMetro == '$'|| formerKeyMetro == 'à') {

    for (int i = 0; i < networkSize; i++) {
      // VirtualPosition[i]= (int) map ( VirtualPosition[i], 1600, 4800, -800, 800); // mapped at the scale in Max 4 live
      PendularOldOldOldLeftVirtualPosition[i]=PendularOldOldLeftVirtualPosition[i];  
      PendularOldOldLeftVirtualPosition[i]=PendularOldLeftVirtualPosition[i];  
      PendularOldLeftVirtualPosition[i]=PendularLeftVirtualPosition[i];  
      modOldOldPos[i]=modOldPos[i]; 
      modOldPos[i]=modPos[i];    
      PendularOldVirtualPosition[i]=PendularVirtualPosition[i];

      PendularVirtualPosition[i]= int (map (metroPhase[i], PI, TWO_PI, 0, numberOfStep/2)); // better : Metronome pass throug position 0


      //   PendularVirtualPosition[i]= int (map (metroPhase[i], -0.5*PI, 1.5*TWO_PI, 0, numberOfStep/2)); // movement with more amplitude?
      PendularVirtualPosition[i]= (int) map ( PendularVirtualPosition[i], -4800, -1600, -800, 800); // mapped at the scale in Max 4 live
      Pos[i]= int (map (PendularVirtualPosition[i], -800, 800, 0, 127)); // to Oscsend 

      VirtualPosition[i]= PendularVirtualPosition[i]+ActualVirtualPosition[i]; 
      //  DataToDueCircularVirtualPosition[i]=VirtualPosition[i];
      DataToDueCircularVirtualPosition[i]=PendularVirtualPosition[i];//+VirtualPosition[i]
      //  dataToLive[i]=  map(DataToDueCircularVirtualPosition[i], 0, 6400, 0, 1);

      float rate = map(DataToDueCircularVirtualPosition[i], -800, 800, 0.80f, 1.20f);
      //  rate = 1; //rateSong
      rateControl.value.setLastValue(rate);

      //SET PRECISION OF MODULO
      // PendularLeftVirtualPosition[i]=int(1*(VirtualPosition[i])+800+1)/2%80;
      //***PendularLeftVirtualPosition[i]=VirtualPosition[i];

      //   modPos[i]=int((1*(VirtualPosition[i])+800+0)/2)%80; // si 0 à 80
      modPos[i]=int((1*(VirtualPosition[i])+800+0)/2)%800; // si 0 à 800
      //    print (i); print(" PENDULAR ");print (modOldOldPos[i]);  print(" PENDULAR "); print (modOldPos[i]);print(" PENDULAR "); println (  modPos[i]);
      //print (" modOldOldPos "); print ( modOldOldPos[i]); print (" modOldPos "); print ( modOldPos[i]); print (" modPos "); println( modPos[i]); 
      if   ((modOldOldPos[i]>modOldPos[i] && modOldPos[i] >modPos[i] && modOldOldPos[i]>modOldPos[i]) ) {
        trigTest=true;
        //  print ("trigTest "); print (i);  println (trigTest);
      } else {
        trigTest=false;
        // print ("trigTest "); print (i);  println (trigTest);
      }

      if (  trigTest==false //((modOldOldPos[i]>modOldPos[i] && modOldPos[i] >modPos[i] && modOldOldPos[i]>modOldPos[i]))

        && ((PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]>=700  && modOldPos[i]>=modPos[i]  &&  modOldOldPos[i]<=modPos[i] &&  modOldOldPos[i]>=680 &&  modOldOldPos[i]<=800)// && PendularLeftVirtualPosition[i]< PendularOldLeftVirtualPosition[i]  && PendularLeftVirtualPosition[i]<6
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]>=700  && modOldPos[i]>=modPos[i]  &&  modOldOldPos[i]>=modPos[i] &&  modOldOldPos[i]>=680 &&  modOldOldPos[i]<=800 )
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]<=modOldPos[i] &&  modOldOldPos[i]<=modPos[i] &&  modOldOldPos[i]>=500 &&  modOldOldPos[i]<=800)  // discrimination speed 8
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]<=modOldPos[i] &&  modOldOldPos[i]>=modPos[i] &&  modOldOldPos[i]>=600 &&  modOldOldPos[i]<=800)  // discrimination speed 8
        )) {

        println ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); 
        print ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); 
        print ("VirtualPosition: ") ; 
        print (i);  
        print (" =Pendularleft: ");  
        println  (PendularLeftVirtualPosition[i]);
        //   background (int ((i+1)*22), int ((i+1)*22),int ((i+1)*22) );

        print (i); 
        print(" OLDOLD PENDULAR ");
        print (modOldOldPos[i]);  
        print("OLD PENDULAR ");  
        print (modOldPos[i]);
        print(" Actual PENDULAR "); 
        println (  modPos[i]); 
        TrigmodPos[i]=0;
      } else { 
        TrigmodPos[i]=1;
      }
    }
  }
  if (formerKeyMetro == '$' && (formerSartKey == 'X' || formerSartKey == 'x' || formerSartKey == 'W' || formerSartKey == 'w')) {

    for (int i = 0; i < networkSize; i++) {
      // VirtualPosition[i]= (int) map ( VirtualPosition[i], 1600, 4800, -800, 800); // mapped at the scale in Max 4 live
      PendularOldOldOldLeftVirtualPosition[i]=PendularOldOldLeftVirtualPosition[i];  
      PendularOldOldLeftVirtualPosition[i]=PendularOldLeftVirtualPosition[i];  
      PendularOldLeftVirtualPosition[i]=PendularLeftVirtualPosition[i];  
      modOldOldPos[i]=modOldPos[i]; 
      modOldPos[i]=modPos[i];    
      PendularOldVirtualPosition[i]=PendularVirtualPosition[i];

      PendularVirtualPosition[i]= int (map (metroPhase[i], -HALF_PI, HALF_PI, -4800, -1600)); // better : Metronome pass throug position 0


      //   PendularVirtualPosition[i]= int (map (metroPhase[i], -0.5*PI, 1.5*TWO_PI, 0, numberOfStep/2)); // movement with more amplitude?
      PendularVirtualPosition[i]= (int) map ( PendularVirtualPosition[i], -4800, -1600, -800, 800); // mapped at the scale in Max 4 live
      Pos[i]= int (map (PendularVirtualPosition[i], -800, 800, 0, 127)); // to Oscsend 

      VirtualPosition[i]= PendularVirtualPosition[i]+ActualVirtualPosition[i]; 
      //  DataToDueCircularVirtualPosition[i]=VirtualPosition[i];
      DataToDueCircularVirtualPosition[i]=PendularVirtualPosition[i];
      //  dataToLive[i]=  map(DataToDueCircularVirtualPosition[i], 0, 6400, 0, 1);

      float rate = map(DataToDueCircularVirtualPosition[i], -800, 800, 0.80f, 1.20f);
      //  rate = 1; //rateSong
      rateControl.value.setLastValue(rate);

      //SET PRECISION OF MODULO
      // PendularLeftVirtualPosition[i]=int(1*(VirtualPosition[i])+800+1)/2%80;
      PendularLeftVirtualPosition[i]=VirtualPosition[i];

      //   modPos[i]=int((1*(VirtualPosition[i])+800+0)/2)%80; // si 0 à 80
      modPos[i]=int((1*(VirtualPosition[i])+800+0)/2)%800; // si 0 à 800
      //    print (i); print(" PENDULAR ");print (modOldOldPos[i]);  print(" PENDULAR "); print (modOldPos[i]);print(" PENDULAR "); println (  modPos[i]);
      //print (" modOldOldPos "); print ( modOldOldPos[i]); print (" modOldPos "); print ( modOldPos[i]); print (" modPos "); println( modPos[i]); 
      if   ((modOldOldPos[i]>modOldPos[i] && modOldPos[i] >modPos[i] && modOldOldPos[i]>modOldPos[i]) ) {
        trigTest=true;
        //  print ("trigTest "); print (i);  println (trigTest);
      } else {
        trigTest=false;
        // print ("trigTest "); print (i);  println (trigTest);
      }

      if (  trigTest==false //((modOldOldPos[i]>modOldPos[i] && modOldPos[i] >modPos[i] && modOldOldPos[i]>modOldPos[i]))

        && ((PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]>=700  && modOldPos[i]>=modPos[i]  &&  modOldOldPos[i]<=modPos[i] &&  modOldOldPos[i]>=680 &&  modOldOldPos[i]<=800)// && PendularLeftVirtualPosition[i]< PendularOldLeftVirtualPosition[i]  && PendularLeftVirtualPosition[i]<6
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]>=700  && modOldPos[i]>=modPos[i]  &&  modOldOldPos[i]>=modPos[i] &&  modOldOldPos[i]>=680 &&  modOldOldPos[i]<=800 )
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]<=modOldPos[i] &&  modOldOldPos[i]<=modPos[i] &&  modOldOldPos[i]>=500 &&  modOldOldPos[i]<=800)  // discrimination speed 8
        || ( PendularLeftVirtualPosition[i]<PendularOldLeftVirtualPosition[i] && modOldPos[i]>720  && modPos[i]<=modOldPos[i] &&  modOldOldPos[i]>=modPos[i] &&  modOldOldPos[i]>=600 &&  modOldOldPos[i]<=800)  // discrimination speed 8
        )) {

        println ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); 
        print ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); 
        print ("VirtualPosition: ") ; 
        print (i);  
        print (" =Pendularleft: ");  
        println  (PendularLeftVirtualPosition[i]);
        //   background (int ((i+1)*22), int ((i+1)*22),int ((i+1)*22) );

        print (i); 
        print(" OLDOLD PENDULAR ");
        print (modOldOldPos[i]);  
        print("OLD PENDULAR ");  
        print (modOldPos[i]);
        print(" Actual PENDULAR "); 
        println (  modPos[i]); 
        TrigmodPos[i]=0;
      } else { 
        TrigmodPos[i]=1;
      }
    }
  }
    //*********** COMPUTE ACCELERATION
  
           if (  keyMode == " null " || keyMode == " addSignalOneAndTwo " ) {
     for (int i = 0; i < networkSize; i++) {  
       //     net.phase[i] = newPosF[i];  // to compute acceelration
      //**     net.phase[i] = newPosXaddSignal[i];
      oldPhaseAcceleration[i] = phaseAcceleration[i];
      phaseAcceleration[i] = net.phase[i];
   
        oldVelocityBis[i] = velocityBis[i];
     //**   velocityBis[i] = (net.phase[i] - net.oldPhase[i]) / 1;
        velocityBis[i] = (phaseAcceleration[i] - oldPhaseAcceleration[i]) / 1;
   //   VelocityI[i]=velocity[i];
      // Update acceleration
        accelerationBis[i] = (velocityBis[i] - oldVelocityBis[i]) / 1;
        
        mapAcceleration[i]= constrain ((int (map (abs(accelerationBis[i] *100), -100, 100, 0, 127))), 0, 127); 
      
  //      print(" velocityBis "); print (i);  print (" ");  print(velocityBis[i]); print (" "); 
        
 //       print(" acc  "); print (i);  print (" "); print(accelerationBis[i]); print(" "); 
        
 //       print(" mapAcc  "); print (i);  print (" "); print(mapAcceleration[i]); println(" "); 
        
       }
      }  
      
     //*********** END COMPUTE ACCELERATION 
  

//  countRevs();  
  bpmAsPulsationFunction();
  printMidiNoteVelocity();
  //SUBZERO


  if (key=='l') {
    formerSartKey='l'; //trig  automatiseWithNote();
    formerKeyL();
  }
  if (key=='L') { //
    formerSartKey='L'; // trig setbpm automatically to 108
  }  

  if (formerSartKey=='l') {// || formerSartKey=='!'

  }

  String ACCELERATION = mapAcceleration[5]+","
    +mapAcceleration[4]+","+ mapAcceleration[3]+","+mapAcceleration[2]+","+ mapAcceleration[1]+","+mapAcceleration[0]+","; // mapAcceleration[9]+","+ mapAcceleration[8]+","+mapAcceleration[7]+","+ mapAcceleration[6]+","+

 // String SPEED = speedi[5]+","+speedi[4]+","+speedi[3]+","+speedi[2]+","+speedi[1]+","+speedi[0]+","; // speedi[11]+","+speedi[10]+","+speedi[9]+","+ speedi[8]+","+speedi[7]+","+ speedi[6]+","+
  // DECOMPTE: You trig a 0 when oscillator reach to the position 0, and then you have an incrementation at each frame.

  if (rev[networkSize-1]%8==0 && decompte[networkSize-1]>=-0 && decompte[networkSize-1]<1) {// send a trig to change scene in Ableton live (if oscillator 11 makes 8 round an djust when it pass trought its position 0 -->trig next scene in Live)
    nextScene= 1;//
    println ("nextScenenextScenenextScenenextScenenextScene");
    println ("nextScenenextScenenextScenenextScenenextScene");
    println (nextScene);
  } else {
    nextScene= 0;
  }     
  //*******************

  if (formerKeyMetro == '$') {

    for (int i = 0; i < networkSize; i++) {

      // DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i]+800;
      DataToDueCircularVirtualPosition[i]= (int) map ( DataToDueCircularVirtualPosition[i], -800, 800, 1600, 4800)+ ActualVirtualPosition[i];  // mapped for 6400 step/round +800
      //  dataToLive[i]=(float)  map(DataToDueCircularVirtualPosition[i], 1600, 4800, 0f, 1f);
    }

    // DataToDueCircularVirtualPosition[2] =(int) map (DataToDueCircularVirtualPosition[2], 0, 6400, 0, int (6400/1));
  }  
  if (formerKeyMetro == '*') {

    for (int i = 0; i < networkSize-0; i++) {
      DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i];
      //   dataToLive[i]=(float) map(DataToDueCircularVirtualPosition[i], 0, 6400, 0f, 1f);
      DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i]+ ActualVirtualPosition[i];
    } 
    //  DataToDueCircularVirtualPosition[2]=(int) map (DataToDueCircularVirtualPosition[2], 0, 6400, 0, int (6400/1));
  }

  if (formerKeyMetro == 'J') {

    for (int i = 0; i < networkSize-0; i++) {
    //  net.oldPhase[i]=net.phase[i];
      DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i];
      //   dataToLive[i]=(float) map(DataToDueCircularVirtualPosition[i], 0, 6400, 0f, 1f);
      DataToDueCircularVirtualPosition[i]= DataToDueCircularVirtualPosition[i]+ ActualVirtualPosition[i];
    } 
    //  DataToDueCircularVirtualPosition[2]=(int) map (DataToDueCircularVirtualPosition[2], 0, 6400, 0, int (6400/1));
  }
  //24 data Jo solution

  // OSCsend  

  /*
    if (dataToLive[10]*10>5){
   dataToLive[10]=1;
   } 
   else  if (dataToLive[10]*10<=5){
   dataToLive[10]=0;
   }
   */
  oscSend();
 
//  printDataOnScreen();

  int TeensyJo=3; // trig Joe in Teensy
  int erasePosition=-1; //no
  String dataMarkedToTeensyJo  ="<" // BPM9   

  //  +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
   // +   DataToDueCircularVirtualPosition[6]+","+
    
    + DataToDueCircularVirtualPosition[5]+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","
    + DataToDueCircularVirtualPosition[1]+","+DataToDueCircularVirtualPosition[0]+","

    +  (speedDelta) +","+ 3 +","+TeensyJo+","+ erasePosition+"," 
    

    +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">"; //    cohesionCounterHigh // +orderCohesion+ ">";LevelCohesionToSend ","+ int (map ( LowLevelCohesionToSend, 0, 1, 0, 100))+ 

  // Trig a counter from 0 when cohesionCounterLow is Low +","+ Trig 1  when orderCohesion is High +","+ Map cohesion level


  if (rev[networkSize-1]%8==0 && decompte[networkSize-1]>=-0 && decompte[networkSize-1]<1) {// send a trig to change scene in Ableton live (if oscillator 11 makes 8 round an djust when it pass trought its position 0 -->trig next scene in Live)
    nextScene= 1;//
    println ("nextScenenextScenenextScenenextScenenextScene");
    println ("nextScenenextScenenextScenenextScenenextScene");
    println (nextScene);
  } else {
    nextScene= 0;
  }     
  //*******************
  if ((formerKey == 'o'|| formerKey == 'ç' ) && frameCount%1 == 0 ) {//&& circularMov== false

    //  println(frameCount + ": " +  " dataMarkedToTeensyJoSpecial" + ( dataMarkedToTeensyJo ));
    println(frameCount + ": " +  " JoDebug "  + ( JoDebug ));
    // teensyport.write(dataMarkedToTeensyJo); // Send data to Teensy. only the movement

    //  encoderReceiveUSBport101.write(dataMarkedToDueBis ); // Send data to Arduino. 
    //      encoderReceiveUSBport101.write(dataMarkedToDue36data);// teensy simulation
  }

  if ((formerKey != 'o' ) && frameCount%1 == 0 ) {//&& circularMov== false

    //   println(frameCount + ": " +  " dataMarkedToTeensyJo" + ( dataMarkedToTeensyJo ));
    //     teensyport.write(dataMarkedToTeensyJo); // Send data to Teensy. only the movement
  }




  //    print ("pendular      ");   println (pendular);  
  if (formerKeyMetro!='s') {
    if (formerKeyMetro!='J') {
      if (formerKeyMetro!='<') {
           if (formerKeyMetro!='B') {
              if (formerKeyMetro!='>') {
                 if (formerKeyMetro!='@') {
                     if (formerKeyMetro!='c') {
                       if (keyMode!= " addSignalOneAndTwo ") {
                         if (keyMode!= " methodAbleton ") {
                           if (keyMode!= " addSignalOneAndTwoBis ") {
                             if (keyMode!= " addSignalOneAndTwoTer ") {
                            
                                 if (keyMode!= " followDistribueAddLfoPattern ") {
                                   if (keyMode!= " samplingModeInternal ") {
                                    if (keyMode!= " addSignalOneAndTwoQuater ") {


        println(frameCount + ": " +  " dataMarkedToTeensyJoInMainLoop" + ( dataMarkedToTeensyJo ));
        //   encoderReceiveUSBport101.write(dataMarkedToDue36data);// Send data to Arduino.
       // teensyport.write(dataMarkedToTeensyJo); // Send data to Teensy. only the movement
         
         }
          }
           }
        }
        }
        }
         }
        }
         }
      }
     }
    }
   }
  }
  /*
  if (formerKeyMetro=='<') {
    int driverOnOff=3;
    int dataToTeensyNoJo=-3; // trig noJoe in Teensy
    String dataMarkedToTeensyNoJo  ="<" // BPM9   

      +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
      +   DataToDueCircularVirtualPosition[6]+","+( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

      +  (speedDelta) +","+ driverOnOff +","+decompte[9]+","+decompte[8]+","+decompte[7]+","+decompte[6]+","+decompte[5]+","+decompte[4]+","+decompte[3]+","+decompte[2]+"," // to manage 12 note +decompte[1]+","+decompte[0]+ ","

      +  decompte[1]+"," +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">";    

    println(frameCount + ": " +  " dataMarkedToTeensyNoJo" + ( dataMarkedToTeensyNoJo ));
    //   encoderReceiveUSBport101.write(dataMarkedToDue36data);// Send data to Arduino.
    teensyport.write(dataMarkedToTeensyNoJo); // Send data to Teensy. only the movement
  }
  */
}

//****************************************************** 
//******************************************************  
void readOneLine() { // read data from recordBis()

  String[] current = split(lines[index], ':');
  frameCountRed = int (current[1]);
    print ("  frameCountRed ");  println (  frameCountRed);
 
  keyCode =  int (current[2]);
     print ("  keyCode ");  println ( char(keyCode) );
  couplingRed= int(current[3]);
  Movement= int(current[4]);
  keyModeRed= (current[5]);
  print ("  MovementRed ");  println (  Movement );
 // movement=  Movement/1000;
  if (++index == lines.length - 1) {
    exit();
  }
  nextFrame = int(split(lines[index], ':')[0]);
}   
void recordBis() {
  
if (frameCount>=0) { 
  if (formerFrame!=frameCount) {
  //  if (formerKey!=key  || formerKeyCode!=keyCode) {
   
 //       if (formerCoupling!=coupling) {
      //    if (formerAutomation1!=automation1) { 
       //     if (formerKeyMode!=keyMode) { 
            
    output.println(frameCount +  ":" + int (keyCode) + ":" + int (coupling*1000) + ":" + int (automation1*1000) + ":" + keyMode);
    //    } }  } }
   //   }
    }
  }
}

void recordTer() {
  
if (frameCount>=0) { 
  if (formerFrame!=frameCount) {
    if (formerKey!=key) {
      if (formerKeyCode!=keyCode) {
        if (formerCoupling!=coupling) {
          if (formerAutomation1!=automation1) { 
       //     if (formerKeyMode!=keyMode) { 
            
    output.println(frameCount + ":" + (int)key + ":" + (int)keyCode + ":" + int (coupling*1000) + ":" + int (automation1*1000) + ":" + keyMode);
        } }  } //}
      }
    }
  }
}

void bpmAsPulsationFunctionOscillator11 () {

  if (formerKeyMetro == '$' || formerKeyMetro == 'à') { 

    if (decompte[11]>=0 && decompte[11]<1 && isLooping()) {    
      println ("TEST OK");   // if oscillator 11 is at his position 0
      //    if (TrigmodPos[11]>=0 && TrigmodPos[11]<1 && isLooping()){    println ("TEST OK");   // if oscillator 11 is at his position 0
      if (!ready) {
        ready = true;
        prev_time = millis();
      } else {
        int curr_time = millis();

        avgTimer.nextValue(curr_time - prev_time - sketch_pause_interval);

        sketch_pause_interval = 0;

        println("'a' key pressed at " + curr_time);

        prev_time = curr_time;
      }
    }
  }

  if (formerKeyMetro == '£' || formerKeyMetro == '*') { 

    if (decompte[11]>=0 && decompte[11]<1 && isLooping()) {    
      println ("TEST OK");   // if oscillator 11 is at his position 0
      //  if (TrigmodPos[11]>=0 && TrigmodPos[11]<1 && isLooping()){    println ("TEST OK");   // if oscillator 11 is at his position 0

      if (!ready) {
        ready = true;
        prev_time = millis();
      } else {
        int curr_time = millis();

        avgTimer.nextValue(curr_time - prev_time - sketch_pause_interval);

        sketch_pause_interval = 0;

        println("'a' key pressed at " + curr_time);

        prev_time = curr_time;
      }
    }
  }
}

MovingAverage avgTimer = new MovingAverage(2);



/**
 
 * Use  a circular array to store generation step impl. times
 
 * and calculate a moving average.
 
 * 
 
 * Specify the number of values to include in the moving average when
 
 * using the constructor. 
 
 * 
 
 * The implementation time is O(1) i.e. the same whatever the number 
 
 * of values used it takes the same amount of time to calculate the
 
 * moving average.
 
 * 
 
 * @author Peter Lager 2021
 
 */

private class MovingAverage {

  private float[] data;

  private float total = 0, average = 0;

  private int idx = 0, n = 0;



  /**
   
   * For a moving average we must have at least remember the last 
   
   * two values.
   
   * @param size the size of the underlying array
   
   */

  public MovingAverage(int size) {

    data = new float[Math.max(2, size)];
  }



  // Include the next value in the moving average

  public float nextValue(float value) {

    total -= data[idx];

    data[idx] = value;

    total += value;

    idx = ++idx % data.length;

    if (n < data.length) n++;

    average = total / (float)n;

    return average;
  }



  public void reset() {

    for (int i = 0; i < data.length; i++)

      data[i] = 0;

    total = n = 0;
  }


  public float average() {

    return average;
  }
}
void frameratio() { 
  //**************************FRAME RATE    ***********CONTROL FRAME RATIO SPEED

  if ((key == ',')) {
    if (frameRatio>4 ) {// frameRatio !=0 || 
      frameRatio=frameRatio-5;  
      frameRate(frameRatio);
      text((frameRatio), -width/2, -height );
    } else {
      println ("CAREFULLLLLLLLLLLLLLLLLLLLLLLLLLL");
      frameRatio =0; 
      frameRate(frameRatio);
      text((frameRatio), -width/2, -height );
    }
  }

  if ((key == ';')) {

    //int frameRation

    frameRatio +=5;
    if ( frameRatio >=180) {
      frameRatio=60;
    }
    frameRate(frameRatio);
    text((frameRatio), -width/2, -height );
  }
  /*
   if (key == ':') {
   //  frameRatio=30;frameRate(frameRatio); // 30/5 = 6 frameRate ==> 124/5 = 24.8 BPM record. 124/3
   text((frameRatio), -width/2, -height ); 
   if (key == '='){
   frameRatio=30;frameRate(frameRatio);
   text((frameRatio), -width/2, -height ); 
   } 
   
   }
   */
  if (key == '=') {
    //  frameRatio=45;
    frameRatio=30;
    frameRate(frameRatio);
    text((frameRatio), -width/2, -height ); 
    //processingnodata
  } 



  //***********CONTROL FRAME RATIO SPEED
  if (key == '+') {
    frameRatio=120;
    frameRate(frameRatio);
    println ("MAXIMMMMMMMMMMUMMMMMMM");
    text((frameRatio), -width/2, -height );
  }
} 
void keyPressed() {
  
  setMovement(key, true);
  
 if (keyCode == ALT){ // .. in Keypressed
    moveKeys[8]=true;
   }
  
 
  if (key == '@'|| keyCode == ESC) {
    startStop=3;
    OscMessage myMessage15= new OscMessage("/startStop");
    myMessage15.add(startStop);
    oscP5.send(myMessage15, myRemoteLocation);
  }   

  frameratio();

  if ((key == '!'  ) ) {  
    text ("STOP MOVEMENT AND TIMER: and BPM ;) when restart slowly", 400, -400); //     // Toggle between sketch paused - running
    formerKey = '!'; // to prepare the next start. With the touch A you can trig play in live

    startStop= 3; 
    println ( startStop ); // = STOP
    //stopboolean= true;

    String dataMarkedToDue  ="<" 
     // + mapAcceleration[11]+","+ int  (bpmToSend)  +","+cohesionCounterHigh+","+ onOFF+","+nextScene+","
      + mapAcceleration[4]+","+ mapAcceleration[3]+","+mapAcceleration[2]+","+ mapAcceleration[1]+","+mapAcceleration[0]+"," 

     // +(VirtualPosition[11]) +","+VirtualPosition[2] +","+VirtualPosition[11] +","+VirtualPosition[0] +","+VirtualPosition[11] +","
    //  +int (phazi[11])+","+int (phazi[0])+","+int (phazi[11])+","+int (phazi[0])+","+int (phazi[11])+","

    //  +modPos[11]+","+modPos[10]+","+modPos[9]+","+modPos[8]+","+modPos[7]+","+modPos[6]+","+modPos[5]+","+modPos[4]+","+modPos[3]+","+modPos[2]+","+modPos[1]+","+modPos[0]+ "," // to manage 12 note

      +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+ ","+ startStop + ">"; 

    print ("dataStop: ");  
    println(frameCount + ": " +  " dataMarkedToDue" + ( dataMarkedToDue ));

    //      encoderReceiveUSBport101.write(dataMarkedToDue ); 

    running = false;


    if (isLooping()) {

      pause_start_time = millis();

      noLoop();
    }
  } 
 // else if (keyCode == BACKSPACE) {
   else if (key == '!')  {
    /*
      running = true; // TRIG the TIMER
     int m = millis();
     lastMillis = m;
     
     sketch_pause_interval = millis() - pause_start_time;
     
     println("Paused at " + millis() + " for " + sketch_pause_interval + "ms");
     */
    noLoop();
    lastMillis=0;// restart period  oscillation number 11 to 0 ms 
    timeFrame=1;
    frameCount=1; // restart the begining of the program
  } 
  if (key == ':'||key == '=') {
    if (key == ':') {
      //    frameRatio=30;
      //    frameRate(frameRatio);
    }
    if (key == '=') {
      //    frameRatio=frameRatio+30;;
      //   frameRate(frameRatio);
    }

    running = true; // TRIG the TIMER
    int m = millis();
    lastMillis = m;

    sketch_pause_interval = millis() - pause_start_time;

    println("Paused at " + millis() + " for " + sketch_pause_interval + "ms");

    loop();
  }


  if (key == '-'  ) //&& song.isPlaying()
  {
  //  song.pause();
  }
  if (key == '_')
  {
    // simply call loop again to resume playing from where it was paused
    //  song.rewind();
  }
} 

void recordFrame() { 

  if (key == '@' || keyCode == ESC) {

    keyMode = " phasePattern ";
    key = '9'; // aligne les ballee
     for (int i = 0; i < networkSize; i++)  {
  // DataToDueCircularVirtualPosition[i]=0;
  
  }

    send24DatasToTeensy6motors (10,3,-3,1); // 1 means erase data in Teensy
    //  key='j'; keyReleased();
    output.println("1999999:0:0:0:0");
    output.println("2000000:0:0:0:0");
    output.flush();
    output.close();
    // startStop= 3;
    exit();
  }

  // if (frameCount !=formerFrame && (key != '!' && key != ':')  ){// do not record ! && :   // (frameCount !=formerFrame && key != '!' && key != ':') do not record ! only
  //if (frameCount !=formerFrame || key != key || key != '!' || key != ':' || key != ',' || key != ';'|| key != '=') {// do not record ! && :   // (frameCount !=formerFrame && key != '!' && key != ':') do not record ! only
  if (2>=1 ) { // frameCount !=formerFrame  && ( key != '!' || key != ':' || key != ',' || key != ';'|| key != '=')
    recordBis();
    formerFrame= frameCount;
  }
 if ( keyMode == " null " ) {
  
     text (" delayTimeFollowPhase11  ",  200,-1200);
     text ( delayTimeFollowPhase11  ,  200,-1100);
    
    text (" phaseShiftingFollowPhase11  ",  200,-1000);
    text ( phaseShiftingFollowPhase11  ,  200,-900);
    }
}

void keyReleased() {
    if (keyCode == ALT){
    moveKeys[8]=false;
   }

  
   recordFrame();
   
    if (formerKeyMetro == 'B')  {

      if (keyCode == CONTROL) {
         oscillatorChange++;
         oscillatorChange=oscillatorChange%12;
      if (oscillatorChange<=0) {
         oscillatorChange=2;
     }
         keyCode =SHIFT; // to trig once keyPressedLFO
  }

     if (keyCode == LEFT) {  
    println( " LEFT INCREASE decay offseft shiftFollowMov ")  ; 
 //   decayshiftFollowMov=decayshiftFollowMov+50;
    decayshiftFollowMov+=1;
    decayshiftFollowMov=decayshiftFollowMov%200;
  
    println ("d= timeOffsetRatio: "); 
    println ( decayshiftFollowMov);
    textSize (100);


    keyCode=SHIFT; // to trig once keyPressedLFO
  }

     if (keyCode == RIGHT) { 

    println( " right INCREASE decay offseft shiftFollowMov")  ; 
     decayshiftFollowMov=decayshiftFollowMov-1;  
      println ("d= timeOffsetRatio: "); 
    println ( decayshiftFollowMov);
    textSize (100);
    text (" decayshiftFollowMov  ",  200,200);
    text ( decayshiftFollowMov,  200,300);
   keyCode=SHIFT; // to trig once keyPressedLFO
  }
  
   if (keyCode == UP) {
     println(" lfoPhase phase shifting"); 
        println(" lfoPhase INCREASE phase shifting"); 
           println(" lfoPhase INCREASE phase shifting"); //
    phaseShiftingFollowPhase11= phaseShiftingFollowPhase11+QUARTER_PI/8;
    phaseShiftingFollowPhase11=phaseShiftingFollowPhase11%PI;
    phaseShiftingFollowLFO= phaseShiftingFollowLFO+QUARTER_PI/8;  
    phaseShiftingFollowLFO= phaseShiftingFollowLFO%PI;
    
 /*       
  if (phaseShiftingFollowPhase11>=8*QUARTER_PI/2) { 
      phaseShiftingFollowPhase11=-phaseShiftingFollowPhase11;
    } 
    */
   
    print ("phaseShiftingFollowPhase11 Ratio ");
    println (degrees (phaseShiftingFollowLFO));
    key= '#';
  }
  
    if (keyCode == DOWN) {
     println(" lfoPhase DECREASE phase shifting"); //
      println(" lfoPhase DECREASE phase shifting"); //
       println(" lfoPhase DECREASE phase shifting"); //
     phaseShiftingFollowLFO= 0;   
     phaseShiftingFollowPhase11= phaseShiftingFollowPhase11-QUARTER_PI/8;
 //   phaseShiftingFollowPhase11= phaseShiftingFollowPhase11%(8*QUARTER_PI/2);   
   /*     
  if (phaseShiftingFollowPhase11<=-8*QUARTER_PI/2) { 
      phaseShiftingFollowPhase11=-phaseShiftingFollowPhase11;
    }   
    print ("phaseShiftingFollowPhase11 Ratio ");
    println (degrees (phaseShiftingFollowPhase11));
    */
    keyCode = SHIFT;
  }
  
   
  
 } 
 
 

  if (formerKeyMetro == 'J' || keyMode == " null ")  {
    
  
    if (keyCode == LEFT) {
      
  //   float timeReleased= (millis()/5)%1000;
    println(" followSignal right INCREASE timeOffset ")  ; // Incremente together without changing phases
    delayTimeFollowPhase11=delayTimeFollowPhase11+1;
    delayTimeFollowPhase11=delayTimeFollowPhase11%65;  
    print ("delayTimeFollowPhase11: ");
    println (delayTimeFollowPhase11);
    if ( delayTimeFollowPhase11<=0 && delayTimeFollowPhase11>=0){
      trigLfo=0;
       }
     else if (delayTimeFollowPhase11>0){   trigLfo=1;   }
      keyCode = SHIFT;
  }
  
  if (keyCode == RIGHT) {
    println(" right INCREASE timeOffset ")  ; // Incremente together without changing phases
    delayTimeFollowPhase11=delayTimeFollowPhase11-1;
    if (delayTimeFollowPhase11<0) {
      delayTimeFollowPhase11=60;
       }
 //   delayTimeFollowPhase11=delayTimeFollowPhase11%61;
    print ("delayTimeFollowPhase11: ");
    println (delayTimeFollowPhase11);
      if ( delayTimeFollowPhase11<=0 && delayTimeFollowPhase11>=0){
      trigLfo=0;
       }
     else if (delayTimeFollowPhase11>0){ trigLfo=1;  }    // 
    keyCode = SHIFT;
  }

  if (keyCode == UP) {
     println(" left INCREASE phase shifting"); //
    phaseShiftingFollowPhase11= phaseShiftingFollowPhase11+QUARTER_PI/8;
    phaseShiftingFollowPhase11= phaseShiftingFollowPhase11%(8*QUARTER_PI/2);   
        
  if (phaseShiftingFollowPhase11>=8*QUARTER_PI/2) { 
      phaseShiftingFollowPhase11=-phaseShiftingFollowPhase11;
    }   
    print ("phaseShiftingFollowPhase11 Ratio ");
    println (degrees (phaseShiftingFollowPhase11));
    keyCode = SHIFT;
  }
  
    if (keyCode == DOWN) {
     println(" left INCREASE phase shifting"); //
    phaseShiftingFollowPhase11= phaseShiftingFollowPhase11-QUARTER_PI/8;
    phaseShiftingFollowPhase11= phaseShiftingFollowPhase11%(8*QUARTER_PI/2);   
        
  if (phaseShiftingFollowPhase11<=-8*QUARTER_PI/2) { 
      phaseShiftingFollowPhase11=-phaseShiftingFollowPhase11;
    }   
    print ("phaseShiftingFollowPhase11 Ratio ");
    println (degrees (phaseShiftingFollowPhase11));
    keyCode = SHIFT;
  }
  
  
  
  } 
  // Choose TimeSpace of Sampling with Sculdy Sampling Method


  // ADJUST DATA TO CONTROL MOTOR with TEENSYJO

  if (key == '?'&& millis()>=millisRatio+1000  ) { //&& frameCount%10==0
    speedDelta-= 1;
    if ( speedDelta<=2) {
      speedDelta=1;
    }
    print(speedDelta);  
    println ("slow down acceleration in Teensy Duino == PCTer0");
    millisRatio=millis();
  }

  if (key == '.' && millis()>=millisRatio+1000 ) { //&& frameCount%10==0 && frameCount <=3999

    speedDelta+= 1;  // decompte is always positive, here it is the signal to control acceleration in Teensy Duino
    if ( speedDelta>=20) {
      speedDelta=16;
    }
    print(speedDelta);  
    println ("up acceleration in Teensy Duino == PCTer0");
    millisRatio=millis();
  }
  
  if (key == ')') {
    // song.play();
    /*
    float rate = map(mouseX, 0, width, 0.5f, 1f);
     rate = 1; //rateSong
     rateControl.value.setLastValue(rate);
     */
    filePlayer.loop();
  }

  if ( (key == '°') )
  {
    filePlayer.pause();
  }       
  if (key == 'J') { 
    formerKeyMetro = key;
    print ("KEY LFO MODE "); 
    print ("FormerkeyMetro"); 
    print (char(formerKeyMetro));
    print ("key"); 
    println (char(key));
  }

/*
  if (key == '<') { 
    formerKeyMetro = key;
    print ("KEY CIRCULAR FOLLOW MODE "); 
    print ("FormerkeyMetro"); 
    print (char(formerKeyMetro));
    print ("key"); 
    println (char(key));
  }
*/
  if (key == '£' || key == '*') {//|| key == '£') {
    for (int i = 0; i < networkSize; i++) {
      rev[i]=0;// set revolution of all oscillator to 0  at the beginning if circular way

      formerKeyMetro = key;
      print ("KEY  CICULAR "); 
      print ("FormerkeyMetro: "); 
      print (char(formerKeyMetro));
      print ("Actualkey"); 
      println (char(key));
    }
  }  
  // ***********************************************************************************************  
  // ***********************************************************************************************  
  //********************* TRY PENDULAR PATTERN
  if (key == 'à' ) {//|| key == '£') {
    //   formerKeyMetro = key;
    print ("KEY PENDULAR OTHER PATTERN "); 
    print ("FormerkeyMetro"); 
    print (char(formerKeyMetro));
    print ("key"); 
    println (char(key));
    //      pendularOtherPattern ();
  }
  if (key == '$' ) {//|| key == '£') {
    formerKeyMetro = key;
    print ("KEY PENDULAR "); 
    print ("FormerkeyMetro"); 
    print (char(formerKeyMetro));
    print ("key"); 
    println (char(key));
  }

  if (formerKeyMetro == 'à') {  
    println ("Frequencie adatped to PENDULAR way WITH OTHER PATTERN trigged with à");
    //  pendularOtherPattern ();
  }
  if (formerKeyMetro == '$') {  
    println ("Frequencies adatped to PENDULAR way trigged with $");
    phasePattern();
  } 

  //*********************************************CIRCULAR

  if (formerKeyMetro == '£' ) {    
    println ("Frequencies adatped to circular way");

    circularWay();
    // MAKE A SORT OF FOLLOW MODE
  } 
  if ( formerKeyMetro == '*' || formerKeyMetro == '<') {   // formerKeyMetro == 'J'  
    println ("Frequencies adatped to ÒTHER circular way");

    //  circularOTHERWay();
    //  circularPENDULARWay();
    phasePattern(); //same as $
    // MAKE A SORT OF FOLLOW MODE
  }
}

void bpmAsPulsationFunction () {
  // MIDDLE if ((PendularOldLeftVirtualPosition[i]+800 <= 800 && PendularLeftVirtualPosition[i]+800 >=800) ||
  //     (PendularOldLeftVirtualPosition[i]+800 >= 800 && PendularLeftVirtualPosition[i]+800 <=800)) {

     if ( revolution[networkSize-1]>=0 && revolution[networkSize-1]<1){    println ("TEST OK");   //revolution[11]>=0 && revolution[11]<1 &&// in pendular way, revolution trig 0 on the right and rev trig 0 on left side
 // if (TrigmodPos[0]>=0 && TrigmodPos[0]<1 ||  revolution[0]>=0 && revolution[0]<1) {    
    println ("TEST OK");   // if oscillator 11 is at his position 0. 0 mean on the right
    if (!ready) {
      ready = true;
      prev_time = millis();
    } else if (TrigmodPos[0]>0 ||  revolution[0]>0 ) {
      int curr_time = millis();
      pulsation = avgTimer.nextValue(curr_time - prev_time);
      prev_time = curr_time;
      println("Average time between two pulsation = " + pulsation + "ms");
    }
  }
}

void bpmAsfrequencyfunction () { 
  for (int i = 0; i < networkSize; i++) {
    //  bpmFrequency[i]= net.naturalFrequency[i]*60/4.608*4; // frequencey=1 ==> 1 round in 4.68 sec // *4 is to give an good beat scale
    bpmFrequency[i]= net.naturalFrequency[i]*54.54;
  }          
  if (abs (bpmFrequency[networkSize-1])>= abs (bpmFrequency[0])) {
    bpmToSend= abs(bpmFrequency[networkSize-1]);
  } else  bpmToSend= abs(bpmFrequency[0]);

  print (" bpmToSend");    
  print (" "); 
  print (bpmToSend); 
  println (" ");
}

void SoundmouseMoved()
{

  //      rez= constrain( map( orderParameter, 0, 1, -1, 1), 0, 1 );  
  //       rez= abs (constrain( map( orderParameter, 0, 1, -1, 1), -1, 1 ));

  //   volumei[0]= abs (speedi[0])*vol; // when vol = -1 && speed (0, 10)--> vol decrease.

  //    volumei[0]= abs (-speedi[0])*vol; // when vol = -1 && speed (0, 10)--> vol decrease.

  // volume to go from -50 to 0


  for (int i = 0; i < networkSize; i++) {

    speedi[i]=  (map ((net.velocity[i]*10000), -1000, 1000, -1, 1));
    //         print ("speedi[i "); print (i); print (" "); print  ( speedi[i]); // with this map until case 4 we go from -60 to 60
    //   speedi[i]= map ( (phazi[i]), 0, 14000, -1, 1); // Chnager d'echelle
    //     print ("velocity9 "); print (i);  print (" "); print ( net.velocity[i]); print (" ");  
    print ("speedi "); 
    print (i);  
    print (" "); 
    print ( speedi[i]);         


    volumei[i]= map ((speedi[i]), -1, 35, -50, 6); // 35 is the speed max.
    //       print ("volumei "); print (i); print (" "); print ( volumei[i]);  
    //**************************************************************   SET     VOLUME   WITH SPEED     
    /*
           out0.setGain(volumei[0]);
     out1.setGain(volumei[1]);
     out2.setGain(volumei[2]);
     out3.setGain(volumei[3]);
     out4.setGain(volumei[4]);
     out5.setGain(volumei[5]);
     out6.setGain(volumei[6]);
     out7.setGain(volumei[7]);
     out8.setGain(volumei[8]);
     out9.setGain(volumei[9]);
     
     */
  }

  float RealVelocity9 =   net.velocity[9]/20*2.4; // round*s-1
  float RealVelocity0 =   net.velocity[0]/20*2.4; // round*s-1

  float   bPM_Boundary9 = map (  RealVelocity9, 0, 0.5, 0, 120);// Half a round is the tempo.
  float   bPM_Boundary0 = map (  RealVelocity0, 0, 0.5, 0, 120);// Half a round is the tempo.

  if (bPM_Boundary9 >= bPM_Boundary0) { 
    bPM9= abs(bPM_Boundary9);
  } else  bPM9= abs(bPM_Boundary0);

  print ("velocityReel9 ");    
  print (" "); 
  print ( RealVelocity9); 
  println (" ");  

  print ("BPM9  ");    
  print (" "); 
  print ( bPM9); 
  println (" ");  

  //     constrainedBPM = int (map (bPM9, 0, 400, 20, 200));

  constrainedBPM = int (bPM9);

  print ("constrainedBPM");    
  print (" "); 
  print ( constrainedBPM); 
  println (" ");  




  for (int i = 0; i < networkSize; i++) {

    volumei[i]=-50;
  }
  println ();
}

void devant_derriereAutre() {
  if ( (net.phase[9]  > net.phase[0]) &&  ( rev[9]  > rev[0]+1)) {//     (net.phase[0] >  (j[i]==0 && rev[i]<0))  { 

    print (" net.phase[9] "); 
    print ( net.phase[9] );  
    print (" net.phase[0 "); 
    print ( net.phase[0] ); 
    key = 'O'; 
    keyPressed ();
  }

  if ( (net.phase[0]  > net.phase[9]) &&  ( rev[0]  > rev[9]+1)) {//     (net.phase[0] >  (j[i]==0 && rev[i]<0))  { 

    print (" net.phase[9] "); 
    print ( net.phase[9] );  
    print (" net.phase[0 "); 
    print ( net.phase[0] ); 
    key = '3'; 
    keyReleased ();
  }
}

void SHOW_DATA () {

  // float orderParameter = net.getOrderParameter();
  orderParameter = net.getOrderParameter();

  stroke(100);
  fill(100);


  // float ordometer=  net.orderParameter;  //float ordometer=  orderParameter;
  String ordometer = String.format("Order: %.2f", orderParameter);
  text(ordometer, -width*1.5, 0);

  String couplingFormat = String.format("Coupling: %.2f", coupling);
  text(couplingFormat, -width*-1, 0);


  float ordoMapped= map (orderParameter, 0, 1, 1, 0);



  float orderToexpOpp= 1- exp(-ordoMapped); // ( 0 to 0.632)
  text (orderToexpOpp, -width*1.5, -100);

  //******* THIS ONE (opposed and exponentionalised)?
  float orderToexpOppNormalised = map ( orderToexpOpp, (1-exp(-1)), 0, 1, 0); //( 0 to 1)
  text ( orderToexpOppNormalised, -width*1.5, -200);

  int orderToexpOppNormalisedLive = int (map ( orderToexpOpp, (1-exp(-1)), 0, 127, 0)); //( 0 to 1)
  text ( orderToexpOppNormalisedLive, -width*1.5, -300);



  float orderToexp= 1- exp(-orderParameter); //(0 to 0.632***
  text (orderToexp, -width*1.5, 100);


  float orderToexpMapped = map (orderToexp, 0, (1-exp(-1)), 0, 1);
  text (orderToexpMapped, -width*1.5, 200);

  //******* THIS SECOND ONE    
  float orderToexpMappedBis = map (orderToexp, 0, (1-exp(-1)), 1, 0); // map order from "orderexponnentionnalised scale 0 to 0.640" to linear 1 to 0 
  text (orderToexpMappedBis, -width*1.5, 300);  

  orderToexpMappedOpposedLive =int  (map (orderToexpMappedBis, 0, 1, 0, 127)); // map "order exp and linearised from 0 to 127 to use it in Ableton
  text (orderToexpMappedOpposedLive, -width*1, -300); // BEST MAPPING

  int  orderParameterLiveSimple  =int  (map (orderParameter, 0, 1, 127, 0));
  text (orderParameterLiveSimple, -width*0.5, -300);


  // ********************    
  //    mapAcceleration[i]= constrain ((int (map (abs(net.acceleration[i] *100), 0, 1000, 0, 255))), 0, 255); 

  text (map (mapAcceleration[0], 0, 255, 0, 127), -width*2, -1000); 
  text (map (mapAcceleration[9], 0, 255, 0, 127), -width*0, -1000); 


  float normalizeAcc0 = map ( mapAcceleration[0], 0, 255, 0, 1); 

  float acc0Toexp= 1- exp(-normalizeAcc0);
  text (acc0Toexp, -width*1.5, -700); 

  float acc0ToexpMappedBis = map (acc0Toexp, 0, (1-exp(-1)), 0, 1); // map acceleration0 from "orderexponnentionnalised scale 0 to 0.640" to linear 1 to 0 
  text (acc0ToexpMappedBis, -width*1, -700);  

  acc0ToexpMappedBisLive =int (map ( acc0ToexpMappedBis, 0, 1, 0, 127));
  text (acc0ToexpMappedBisLive, -width*1, -1000); // BEST MAPPING

  float normalizeAcc9 = map ( mapAcceleration[9], 0, 255, 0, 1);
  float acc9Toexp= 1- exp(-normalizeAcc9);

  float acc9ToexpMappedBis = map (acc9Toexp, 0, (1-exp(-1)), 0, 1);
  text (acc9ToexpMappedBis, -width*-0.5, -700);  

  acc9ToexpMappedBisLive=int (map (acc9ToexpMappedBis, 0, 1, 0, 127)); // it stay no too long between 0 and 60, more 60 to 127
  text (acc9ToexpMappedBisLive, -width*-1, -1000); // BEST MAPPING

  print ("acc0 & acc9 exp "); 
  print (acc9ToexpMappedBisLive); 
  print (" ");  
  println (acc9ToexpMappedBisLive);

  /* 
   float orderToexpOpposed= 1- exp(-ordoMapped);
   text (orderToexpOpposed,  -width*1.5, 200);
   */
}

void record() {

  // to STOP record touch @

  if (key == '@') {
    output.flush();
    output.close();
    exit();
  }// else { 
  //   else if (((formerCoupling != coupling) && frameCount %2==0 )|| ((formerCoupling == coupling) && frameCount %2==1)) { // tester l'ancien couple 
  // 
  //      else if (frameCount !=formerFrame){

  if (((((coupling <0 && formerCoupling <0) && coupling < formerCoupling-0.1) || ((coupling >0 && formerCoupling>0) && coupling>formerCoupling+0.1 )) || 
    (((coupling >0 && formerCoupling >0) && coupling < formerCoupling-0.1) || ((coupling <0 && formerCoupling<0) && coupling>formerCoupling+0.1 ))) 

    //  
    //&& (frameCount !=formerFrame )

    // ||  ((formerKey < Key))

    //||(formerKeyCode == int (keyCode)))))


    )
  {

    output.println(frameCount + ":" + (int)key + ":" + (int)keyCode + ":" + int (coupling*1000));
  }
}

void pendularPatternLFO(){ // trigged with J
    println( "pendularPatternLFO right DECREASE phase shifting  witch formerStartKey ")  ; // Incremente together without changing phases   

       
 //   if ((formerSartKey == 'X' || formerSartKey == 'x' || formerSartKey == 'W' || formerSartKey == 'w' || formerKeyMetro  == 'J')) {
       if (keyCode == RIGHT) { 
        k=k-QUARTER_PI/8;
     
   /*  
     if (k<=-8*QUARTER_PI/2) { 
         k = 8*QUARTER_PI;
      }
   */   
  
    }
//  }
  if (keyCode == LEFT) { 
//    println(" pendularPatternLFO left INCREASE phase shifting"); // Incremente together without changing phases  
    if ((formerSartKey == 'X' || formerSartKey == 'x' || formerSartKey == 'W' || formerSartKey == 'w' || formerKeyMetro == 'J')) {
      k= k+QUARTER_PI/8;
      k= k%(8*QUARTER_PI/8);
    }
    if (k>=9*QUARTER_PI/8) { 
   //   k=-k;
    }    
   
  } 

  if (keyCode == DOWN) { 
    println("pendularPatternLFO UP by 2 and change way of LFO2 "); //   TAB -
    for (int i = 2; i < 3; i++) { 
      LFO[i]= map (LFO[i], 0, 1, 0, TWO_PI);
      /*
         if (LFO[i]>=0 && LFO[i]<=1 ) {  
       LFO[i]= map (LFO[i], 0, 1, 0, TWO_PI);
       }
       if (LFO[i]<=1 && LFO[i]>=0) {  
       LFO[i]= map (LFO[i], 1, 1, 0, -TWO_PI);     
       }
       */
    } 
    d=d-25;
    d=d%525;
    keyCode =SHIFT; // to trig only once
  } 
  if (keyCode == UP) { 
    d=d+25;
    d=d%525;
    println("pendularPatternLFO UP by 2 and change way of LFO2 "); //   TAB -
    for (int i = 2; i < 3; i++) { 
      //   LFO[i]= automation3;
      LFO[i]= map (LFO[i], 0, 1, 0, PI);
      printSummary(i);
    }
     keyCode =SHIFT; // to trig only once
  }

  if (keyCode == CONTROL) { 
    println("pendularPatternLFO INCREASE phases with special modulo   "); //P$ 
    //else if (key == 'π') { println("INCREASE phases with special modulo   "); //P$ 
    //  LFO[2]= automation3;
    for (int i = 0; i < networkSize; i++) {

      LFO[i]+= (HALF_PI/(networkSize-2))*(1*(networkSize-1-i)); //
      LFO[i] = LFO[i]%(TWO_PI/1);

      net.phase[i]=  LFO[i]%(TWO_PI/1);

      interPhase[i]= LFO[i]%(TWO_PI/1);
      printSummary(i);  
      keyCode =SHIFT; // to trig only once
    }
  }
  
   keyCode = SHIFT; // to trig only once
   print ("k= shiftingPhaseRatio ");println (k);
   
      text ( " k "+ (k*360) + " delay " + d, -width+800, - height+400);

}

void abletonPattern()
{
    for (int i = 0; i < (networkSize); i++) { 
    {
     oscillator[i]= map (oscillator[i], 0,1, 0, TWO_PI);  //************************************ SET LAST FREQUENCIES as OLD FREQUENCIES
     net.phase[i]= oscillator[i];
    }
  }
  
  /*
 if (formerKey == 'A') { //A$  Shift frequencies one by one. 
    float speeed    = map ((float (mouseY)/width*1.0), 0, 1, -1, 1); 
    speeed=1;
    for (int i = 0; i < networkSize; i++) {
      net.naturalFrequency[i]=OldFrequency[i]; 
      printSummary(i);
    }
    memoryi=11;
//    net.naturalFrequency[memoryi]= speeed;//4.68/2; // 124 bpm
    net.phase[memoryi]= speeed*oscillator[11];//4.68/2; // 124 bpm
  }

  if (formerKey == 'a') { //A$  Shift frequencies one by one. 
    float speeed    = map ((float (mouseY)/width*1.0), 0, 1, -1, 1); 
    for (int i = 0; i < networkSize; i++) {    
      net.naturalFrequency[i]=OldFrequency[i]; 
      printSummary(i);
    }
    memoryi=2;
   net.phase[memoryi]= speeed*oscillator[memoryi];    //4.68/2; // 124 bpm
  }
*/

 }

void circularWay () {
  //************************************ DONT TOUCH  //************************************ RESET OLD FREQUENCIES 
  
  ///******************************============================================================SHIFT SEVERAL OSCILLATOR AT THE SAME TIME

  if (key == 'i') { 
    print("  Shift frequencies one by one, or 5 by five ");
    // net.shiftPhases(5);   
    net.shiftPhases(1);
  }

  if (key == 'u') { //ucircular  Shift frequencies one by one. 
    //  net.shiftPhases(2); 
    net.shiftPhases(-1);
  } 

  if (key == 'I') { //  Shift frequencies one by one, or 5 by five
    // net.shiftPhases(5);   
    net.shiftPhases(1);
  }

  if (key == 'U') { //  Shift frequencies one by one. 
    //  net.shiftPhases(2); 
    net.shiftPhases(-1);
  } 


  // key ='#';  
} 

void circularOTHERWay() { 
  print ("circularOTHERWay based ");
  //  pendularPattern ();
 
} 

void circularPENDULARWay() { 
  print ("circularPENDULARWay based ");
  phasePattern();
  //    pendularOtherPattern ();
}  



void formerx () {
  float k = 0.25;
  print ("char formerFormerKey x?  ");  
  println (char (formerFormerKey));
  print ("circularMov  ");  
  println (circularMov);
  if (circularMov==true ) {
    for (int i = 0; i < (networkSize-1); i++) {  
      PendularLeftVirtualPosition[i]= CircularVirtualPosition[i];
      PendularOldLeftVirtualPosition[i]= CircularOldVirtualPosition[i];
      PendularLeftVirtualPosition[i+1]= CircularVirtualPosition[i+1];
      PendularOldLeftVirtualPosition[i+1]= CircularOldVirtualPosition[i+1];
      print ("PendularLeftVirtualPosition "); 
      print (i); 
      print (" ");   
      print (PendularLeftVirtualPosition[i]); 
      print ("CircularVirtualPosition "); 
      print (i); 
      print (" ");   
      print (CircularVirtualPosition[i]);
    }
  } 
  for (int i = 0; i < networkSize-1; i++) {
    //  net.phase[i]=net.phase[11];

    print ("f: "); 
    println (f);

    net.phase[i]=(net.phase[11]+abstractPhase[i])%(TWO_PI/1);
    // net.phase[i] += (i+1)*0.05;
    net.phase[i]=  net.phase[i]%(TWO_PI);

    //    printSummary(i);


    print ("fmemory: "); 
    println (fmemory);

    //  key='#';
  }
  if (fmemory==k) {

    fmemory=0;
  }
} 

// Mexican-Hat spatial coupling
void initializeCoupling(float[][] Coupling, float sigma) {
  float[][] distance = distanceMatrix();
  for (int i = 0; i < networkSizeGraphic; i++) {
    for (int j = 0; j < networkSizeGraphic; j++) {
      float d = pow(distance[i][j] / sigma, 2);
      float c = (1 / (PI * pow(sigma, 4))) * (1 - 0.5 * d) * exp(-0.5 * d);
      Coupling[i][j] = c;
    }
  }
}

// Calculate the distance between oscillators
float[][] distanceMatrix() {
  float[][] distance = new float[networkSizeGraphic][networkSizeGraphic];
  for (int i = 0; i < networkSizeGraphic; i++) {
    int i1 = i % numCols;
    int j1 = int(floor(i / numCols));
    for (int j = 0; j < networkSizeGraphic; j++) {
      int i2 = j % numCols;
      int j2 = int(floor(j / numCols));
      distance[i][j] = dist(i1, j1, i2, j2);
    }
  }

  return distance;
}

// Set initial phases randomly
void initializePhase(float[] phase) {
  for (int i = 0; i < numRows; i++) {
    for (int j = 0; j < numCols; j++) {
      int index = i * numCols + j;
      phase[index] =  (QUARTER_PI*i);//FREQ ;//
    }
  }
}

// Set natural frequencies to the same random value
void initializeNaturalFrequency(float[] naturalFrequency, float freq) {
  for (int i = 0; i < numRows; i++) {
    for (int j = 0; j < numCols; j++) {
      int index = i * numCols + j;
      naturalFrequency[index] = freq;
    }
  }
} 

void printDataOnScreen() { 
   noStroke();
//**   /*
  text(formerFormerKey, -300, height +300); 
  text(formerKeyCodeAzerty, -100, height + 300);
  text(char (key), 100, height + 300);
  text(char (keyCode), 200, height +300)  ; 
  
    for (int i = 0; i < networkSize; i++) {
      
        text ("trig", -1200, height-500 - 75*i);
        text (TrigmodPos[i], -1000, height-500 - 75*i);
    
    }
  
  text ("mem", -800, height +300+100);
  text (memoryi, -600, height +300+100);
  if (TrigmodPos[networkSize-1]==0) {
   // counter11++;
    counter[networkSize-1]++;
  }  
  if (TrigmodPos[0]==0) {
    counter[0]++;
  } 
  text ( counter[networkSize-1], -600, height +300); 
  text ( counter[networkSize-1], -800, height +300); 
  text ("old", -1200, height +300+100);
  text (oldMemoryi, -1000, height +300+100);
  text ("mem", -800, height +300+100);
  text (memoryi, -600, height +300+100);
  text ("Ratio", -400, height +300+100);
  text (speedDelta, -200, height +300+100);
  text ("block", 0, height +300+100);
  text (oscillatorBlocked, 200, height +300+100);
  String Kratio = nf (k, 0, 1);
  text ("K phi", 0, height +300+200);
  text (Kratio, 200, height +300+200);
  text ("Fratio", 400, height +300+100);
  text (frameRatio, 600, height +300+100);
  text ("D btw case", 600, height +300+200);
  text (d, 1000, height +300+200);
//** */ 
  text ("FrameOffsetPhase11", -1000, height +400+200);
  text (delayTimeFollowPhase11, -200, height +400+200);
  text ("SpacephaseOffset11", 400,  height +400+200);
  text (degrees (phaseShiftingFollowPhase11), 1200, height +400+200);
  text ("measure ", -1000, height +800+200);
//  text (measure , -200, height +800+200);

  text ("Rec ", 800, height +300+0);
  text (measureRecordStart, 1000, height +300+0);
  
  text ("Llast ", 1200, height +300+0);
  text (lastLastSec, 1400, height +300+0);
  text ("last ", 1600, height +300+0);
  text (lastSec, 1800, height +300+0);
  text ("act ", 2000, height +300+0);
  text (actualSec, 2200, height +300+0);
  
  

  /// text (formerFrame, 700, height +300+100);
  text (frameCount, 1000, height +300+100);

  text(coupling, 400, height +300);
  text (frameCount, width/8, -height-200);
  String ONE_DEC = nf (timeFrame, 0, 1); 
  text(ONE_DEC, width/2+100, -height-200);
  String PULSATION = nf (pulsation, 0, 2); 
  text ("W", -width-800, -height -200);
  text (PULSATION, -width-550, -height -200);


  String BPM_PULSATION = nf (1000/pulsation*60, 0, 0); // transform time elapsed betwween two pulsation in BPM
  text ("BPM-W", -width-200, -height );
  text (BPM_PULSATION, -width+200, -height );

  String BPM = nf (bpmToSend, 0, 2); 
  text ("BPM", -width-200, -height -200);
  text (BPM, -width+100, -height-200);
 
  //********
  textSize (50);
  
    text ("BOTT F0", -width-900, height -100);
   text ("XXXX F9", -width-900, height -820);
   text ("FRON F11", -width-900, height -964);
   
  textSize (75);

  for (int i = 0; i < networkSize; i++) {
    if ( factorWay[i]==false) {
      FactorWay[i]=-1;
    } else  FactorWay[i]=1; 
    String FW= nf (FactorWay[i], 0, 0);
    text(FW, -width-800, height -20 - (i+1)*80);
  }

  textSize (75);

  for (int i = 0; i < networkSize; i++) {
    if ( clockWay[i]==false) {
      ClockWay[i]=-1;
    } else  ClockWay[i]=1;     
    String CW = nf (ClockWay[i], 0, 0); 
    text((CW), -width-700, height -20 - (i+1)*80);
  }
/*
  if ( oldClockWay[memoryi]==false) {
    oldC = -1;
  } else 

  oldC = 1;

  String oldClock = nf (oldC, 0, 3); 
  int k = 12;

  text((oldClock), -width-700, height -20 - (k+1)*80);
*/
  /* 
   textSize (50);
   for (int i = 0; i < networkSize; i++) {
   
   String REV = nf (rev[i], 0, 0); 
   //  text(  (net.naturalFrequency[i]), -width-200, height -20 - (i+1)*80); 
   text((REV), -width-700, height -20 - (i+1)*80);
   }
   */
   
 //************** REMETRRE
 
  textSize (50);
  for (int i = 0; i < networkSize; i++) {
    String TWO_DEC = nf (net.naturalFrequency[i], 0, 2); 
    //  text(  (net.naturalFrequency[i]), -width-200, height -20 - (i+1)*80); 
    text((TWO_DEC), -width-400, height -20 - (i+1)*80);
  }  
  textSize (50);

  for (int i = 0; i < 1; i++) {  // metroPhaseOnScreen

    String om = nf (metroPhase[oldMemoryi]-  metroPhase[memoryi], 0, 3); 
    //  text(  (net.naturalFrequency[i]), -width-200, height -20 - (i+1)*80); 
    text(("om " ), -width-300, height -20 - (i+1)*80);
    text((om), -width-200, height -20 - (i+1)*80);
  }

  for (int i = 1; i < 2; i++) {  // metroPhaseOnScreen

    String om = nf (metroPhase[networkSize-1]-  metroPhase[networkSize-1-1], 0, 3); 
    text(("10 "), -width-300, height -20 - (i+1)*80);
    text((om), -width-200, height -20 - (i+1)*80);
  }

  String inter = nf (interPhase[memoryi], 0, 3); 
  int j = networkSize;
  text(("i" ), -width-300, height -20 - (j+1)*80);
  text((inter), -width-200, height -20 - (j+1)*80);

  for (int i = 2; i < networkSize; i++) {  // metroPhaseOnScreen

    String m = nf (metroPhase[i], 0, 3); 
    text(("m" ), -width-300, height -20 - (i+1)*80);
    text((m), -width-200, height -20 - (i+1)*80);
  }

  textSize (50);

  String interCircular = nf (interPhaseCircular[memoryi], 0, 3); 
  int l = networkSize;
  text(("iC" ), -width-100, height -20 - (j+1)*80);
  text((interCircular), -width-0, height -20 - (j+1)*80);

  for (int i = 0; i < networkSize; i++) {  // netPhaseOnScreen

    String n = nf (net.phase[i], 0, 3); 
    text(("n" ), -width-100, height -20 - (i+1)*80);
    text((n), -width-0, height -20 - (i+1)*80);
  }

  for (int i = 2; i < networkSize; i++) {  // metroPhaseOnScreen

    String interPhaseM = nf (interFrequency[i], 0, 3); 
    text(("iF" ), -width+100, height -20 - (i+1)*80);
    text((interPhaseM), -width+200, height -20 - (i+1)*80);
  }
  
}


void formerW() {
   print  (" ACTUAL POSITION ");  print  (" ACTUAL POSITION ");  print  (" ACTUAL POSITION ");
    print  (" ACTUAL POSITION ");
    
  println  ("wwwwwwwwwwwwwwww");
  for (int i = 0; i < networkSize; i++) {    
    ActualVirtualPosition[i]+=0;  
    /*
        ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
     ActualVirtualPosition[i]=ActualVirtualPosition[i]%numberOfStep;
     ActualVirtualPosition[i]+=ActualVirtualPosition[i];
     */
    //*****

    //***  ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;// less conventional than numberOfStep/6*i
    //**   ActualVirtualPosition[i]+=ActualVirtualPosition[i]%numberOfStep;
    //**  ActualVirtualPosition[i]=ActualVirtualPosition[i]%numberOfStep*5;

    //    ActualVirtualPosition[i]=+3200;
    ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
    //VirtualPosition[i]= VirtualPosition[i]+(1600); 

    key='#';
    //formerKey='#';
  }
}
//********  OSCRECEIVE
//RECEIVE OSC AUTOMATION with port 2346 or 2349 and 2350 and analyse OSC messages
void oscEvent(OscMessage theMsg) {
  if (theMsg.checkAddrPattern("/LFO1")==true) {
    automationLFO[0] = theMsg.get(0).floatValue();
  }

  if (theMsg.checkAddrPattern("/LFOdecay")==true) {
    automationLFO[1] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/LFO2")==true) {
    automationLFO[2] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/LFO3")==true) {
    automationLFO[3] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/LFO4")==true) {
    automationLFO[4] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/LFO5")==true) {
    automationLFO[5] = theMsg.get(0).floatValue();
  }  
/*
  if (theMsg.checkAddrPattern("/LFO6")==true) {
    automationLFO[6] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/LFO7")==true) {
    automationLFO[7] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/LFO8")==true) {
    automationLFO[8] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/LFO9")==true) {
    automationLFO[9] = theMsg.get(0).floatValue();
  }
  
*/  
  


  if (theMsg.checkAddrPattern("/oscillator2")==true) {
    oscillator[2] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/oscillator3")==true) {
    oscillator[3] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/oscillator4")==true) {
    oscillator[4] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/oscillator5")==true) {
    oscillator[5] = theMsg.get(0).floatValue();
  }  
/*
  if (theMsg.checkAddrPattern("/oscillator6")==true) {
    oscillator[6] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/oscillator7")==true) {
    oscillator[7] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/oscillator8")==true) {
    oscillator[8] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/oscillator9")==true) {
    oscillator[9] = theMsg.get(0).floatValue();
  }
  
      if (theMsg.checkAddrPattern("/oscillator10")==true) {
    oscillator[10] = theMsg.get(0).floatValue();
  }

  if (theMsg.checkAddrPattern("/oscillator11")==true) {
    oscillator[11] = theMsg.get(0).floatValue();
  } 
  
  */
  


  if (theMsg.checkAddrPattern("/madTempoShaper")==true) {
    formerAutomation1=automation1;
    automation1 = theMsg.get(0).floatValue();
    for (int i = 0; i < networkSize; i++) {   
      //   net.phase[i]= map (automation2, 0, 1, -PI, PI );
    }
  }
  if (theMsg.checkAddrPattern("/speedTempo")==true) {
    automation2 = theMsg.get(0).floatValue();
    //  LFOX=automation2;
  }
  if (theMsg.checkAddrPattern("/followMadTrack1bis")==true) {
    automation3 = theMsg.get(0).floatValue();
    //  LFOY=automation3;
  }  

  if (theMsg.checkAddrPattern("/measureGood")==true) {
    automation4 = theMsg.get(0).floatValue();

  }  

  if (theMsg.checkAddrPattern("/beatPrecised")==true) {
    automation5 = theMsg.get(0).floatValue();
  
  }  

  if (theMsg.checkAddrPattern("/lfo1")==true) {
    automation6 = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/lfo2")==true) {
    automation7 = theMsg.get(0).floatValue();
  } 
  
    if (theMsg.checkAddrPattern("/lfo3")==true) {
    automation8 = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/LPF")==true) {
    automation9 = theMsg.get(0).floatValue();
  } 
  
   //***** ableton[i]
  

  if (theMsg.checkAddrPattern("/ableton0")==true) {
    ableton[0] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/ableton1")==true) {
    ableton[1] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/ableton2")==true) {
    ableton[2] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/ableton3")==true) {
    ableton[3] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/ableton4")==true) {
    ableton[4] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/ableton5")==true) {
    ableton[5] = theMsg.get(0).floatValue();
  } 
/*
  if (theMsg.checkAddrPattern("/ableton6")==true) {
    ableton[6] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/ableton7")==true) {
    ableton[7] = theMsg.get(0).floatValue();
  }
  
  if (theMsg.checkAddrPattern("/ableton8")==true) {
    ableton[8] = theMsg.get(0).floatValue();
  }

  if (theMsg.checkAddrPattern("/ableton9")==true) {
    ableton[9] = theMsg.get(0).floatValue();
  } 
  */
  
  

  if (theMsg.checkAddrPattern("/signal0")==true) {
    signal[0] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/signal1")==true) {
    signal[1] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/signal2")==true) {
    signal[2] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/signal3")==true) {
    signal[3] = theMsg.get(0).floatValue();
  }  

  if (theMsg.checkAddrPattern("/signal4")==true) {
    signal[4] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/signal5")==true) {
    signal[5] = theMsg.get(0).floatValue();
  } 
/*
  if (theMsg.checkAddrPattern("/signal6")==true) {
    signal[6] = theMsg.get(0).floatValue();
  } 

  if (theMsg.checkAddrPattern("/signal7")==true) {
    signal[7] = theMsg.get(0).floatValue();
  }
  
    if (theMsg.checkAddrPattern("/signal8")==true) {
    signal[8] = theMsg.get(0).floatValue();
  }

  if (theMsg.checkAddrPattern("/signal9")==true) {
    signal[9] = theMsg.get(0).floatValue();
  } 
  */

  //***  MIDI NOTE

  if (theMsg.checkAddrPattern("/Velocity1")==true) {
    velocity1 = theMsg.get(0).intValue();
    ver_move1 = map(velocity1, 0, 127, 0, 60);
  }

  if (theMsg.checkAddrPattern("/Velocity2")==true) {
    velocity2 = theMsg.get(0).intValue();
    ver_move2 = map(velocity2, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Velocity3")==true) {
    velocity3 = theMsg.get(0).intValue();
    ver_move3 = map(velocity3, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Velocity4")==true) {
    velocity4 = theMsg.get(0).intValue();
    ver_move4 = map(velocity4, 0, 127, 0, 60);
  }

  if (theMsg.checkAddrPattern("/Velocity5")==true) {
    velocity5 = theMsg.get(0).intValue();
    ver_move5 = map(velocity5, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Velocity6")==true) {
    velocity6 = theMsg.get(0).intValue();
    ver_move6 = map(velocity6, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Velocity7")==true) {
    velocity7 = theMsg.get(0).intValue();
    ver_move7 = map(velocity7, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Velocity8")==true) {
    velocity8 = theMsg.get(0).intValue();
    ver_move8 = map(velocity8, 0, 127, 0, 60);
  }  

  if (theMsg.checkAddrPattern("/Note1")==true) {
    note1 = theMsg.get(0).intValue();
    duration1 = map(sq(note1), 1, sq(127), 0.05, 0.5);
  }

  if (theMsg.checkAddrPattern("/Note2")==true) {
    note2 = theMsg.get(0).intValue();
    duration2 = map(sq(note2), 1, sq(127), 0.05, 0.5);
  } 

  if (theMsg.checkAddrPattern("/Note3")==true) {
    note3 = theMsg.get(0).intValue();
    duration3 = map(sq(note3), 1, sq(127), 0.05, 0.5);
  }

  if (theMsg.checkAddrPattern("/Note4")==true) {
    note4 = theMsg.get(0).intValue();
    duration4 = map(sq(note4), 1, sq(127), 0.05, 0.5);
  } 

  if (theMsg.checkAddrPattern("/Note5")==true) {
    note5 = theMsg.get(0).intValue();
    duration5 = map(sq(note5), 1, sq(127), 0.05, 0.5);
  }

  if (theMsg.checkAddrPattern("/Note6")==true) {
    note6 = theMsg.get(0).intValue();
    duration6 = map(sq(note6), 1, sq(127), 0.05, 0.5);
  } 

  if (theMsg.checkAddrPattern("/Note7")==true) {
    note7 = theMsg.get(0).intValue();
    duration7 = map(sq(note7), 1, sq(127), 0.05, 0.5);
  }

  if (theMsg.checkAddrPattern("/Note8")==true) {
    note8 = theMsg.get(0).intValue();
    duration8 = map(sq(note8), 1, sq(127), 0.05, 0.5);
  }
}




/*float log10 (int x) {
 return (log(x) / log(10));
 }*/

class B_String {
  float osc_points, p11, p21, p31, p41, shade;

  B_String(float a1, float b1, float c1, float d1, float i, int colour) {
    noFill();
    //fill(250, 0, 0, 55);
    stroke(200, colour, 0);
    bezier(a1, i, b1, i, c1, i, d1, i);
    osc_points = i;
    p11 = a1;
    p21 = b1;
    p31 = c1;
    p41 = d1;
    shade = colour;
    //fill(0, 0, 0);
  }

  void display(float velocity) { 
    noFill();
    stroke(200, shade, 0);
    /*
    bezier(p11, osc_points, p21, osc_points+velocity, p31, osc_points+velocity, p41, osc_points);
    bezier(p11, osc_points, p21, osc_points+0.8*velocity, p31, osc_points+0.8*velocity, p41, osc_points);
    bezier(p11, osc_points, p21, osc_points+0.6*velocity, p31, osc_points+0.6*velocity, p41, osc_points);
    bezier(p11, osc_points, p21, osc_points+0.4*velocity, p31, osc_points+0.4*velocity, p41, osc_points);
    bezier(p11, osc_points, p21, osc_points+0.2*velocity, p31, osc_points+0.2*velocity, p41, osc_points);
    bezier(p11, osc_points, p21, osc_points, p31, osc_points, p41, osc_points);
    */
  }
} 

void printMidiNoteVelocity() {

  if  (note1>0) {

    print ("note "); 
    print (1); 
    print (" "); 
    print (note1);
    print ("note "); 
    print (2); 
    print (" "); 
    print (note2);
    print ("note "); 
    print (3); 
    print (" "); 
    print (note3);
    print ("note "); 
    print (4); 
    print (" "); 
    print (note4);
    print ("note "); 
    print (5); 
    print (" "); 
    print (note5);
    print ("note "); 
    print (6); 
    print (" "); 
    print (note6);
    print ("note "); 
    print (7); 
    print (" "); 
    println (note7);
  } else {
    //   println (" ");
  }

  if  (velocity1>0) {

    print ("velo "); 
    print (1); 
    print (" "); 
    print (velocity1);
    print ("velo "); 
    print (2); 
    print (" "); 
    print (velocity2);
    print ("velo "); 
    print (3); 
    print (" "); 
    print (velocity3);
    print ("velo "); 
    print (4); 
    print (" "); 
    print (velocity4);
    print ("velo"); 
    print (5); 
    print (" "); 
    println (velocity5);
    print ("velo"); 
    print (6); 
    print (" "); 
    print (velocity6);
    print ("velo"); 
    print (7); 
    print (" "); 
    println (velocity7);
  }

  //  print ("measure "); println (measure);

  //  if  (1!=0) {
  if  (velocity1>0) {
    rotate (PI/2);
    //  String NOTE1= nf (note1, 0, 0); // transform time elapsed betwween two pulsation in BPM
    text (measure, (-width+1350), -height );  
    text ("1", (-width-150), -height );
    text (note1, -width-50+50, -height );
    text ("2", (-width+50+50), -height );
    text (note2, -width+150+50, -height );   
    text ("3", (-width+250+50), -height );
    text (note3, -width+350+50, -height );
    text ("4", (-width+450+50), -height);
    text (note4, -width+550+50, -height );
    text ("5", (-width+650+50), -height);
    text (note5, -width+750+50, -height );
    text ("6", (-width+850+50), -height);
    text (note6, -width+950+50, -height );
    text ("7", (-width+1050+50), -height);
    text (note7, -width+1150+50, -height );

    text (velocity1, -width-50+50, -height+100 );
    text (velocity2, -width+150+50, -height+100 );   
    text (velocity3, -width+350+50, -height+100 );
    text (velocity4, -width+550+50, -height+100 );
    text (velocity5, -width+750+50, -height+100 );
    text (velocity6, -width+950+50, -height+100 );   
    text (velocity7, -width+1150+50, -height+100 );
  } else {
    rotate (PI/2);
    note1=note2=note3=note4=note5=note6=note7=note8=0;
    velocity1=velocity2=velocity3=velocity4=velocity5=velocity6=velocity7=velocity8=0;

    text (measure, (-width+1350), -height );  
    text ("1", (-width-150), -height );
    text (note1, -width-50+50, -height );
    text ("2", (-width+50+50), -height );
    text (note2, -width+150+50, -height );   
    text ("3", (-width+250+50), -height );
    text (note3, -width+350+50, -height );
    text ("4", (-width+450+50), -height);
    text (note4, -width+550+50, -height );
    text ("5", (-width+650+50), -height);
    text (note5, -width+750+50, -height );
    text ("6", (-width+850+50), -height);
    text (note6, -width+950+50, -height );
    text ("7", (-width+1050+50), -height);
    text (note7, -width+1150+50, -height );

    text (velocity1, -width-50+50, -height+100 );
    text (velocity2, -width+150+50, -height+100 );   
    text (velocity3, -width+350+50, -height+100 );
    text (velocity4, -width+550+50, -height+100 );
    text (velocity5, -width+750+50, -height+100 );
    text (velocity6, -width+950+50, -height+100 );   
    text (velocity7, -width+1150+50, -height+100 );
    //println (" ");
  }
}

void trigBeatWithMeasure()
 {
 //   beatTrigged=false;
 //   beatPrecisedTrigged=false; 
   if (formerMeasure!=measure) {
    //   background (127, 50, 50);
    beatTrigged=true;
    
    
    

    //    autmationWithMeasureAndNote++;

    beatOnMeasure=(measure%4)+1;
    print("  ******** "); 
    print("  ******** "); 
    print("  ******** "); 
    print("  ******** "); 
    print("  ******** "); 
    println(measure);
    formerFrameBeat=frameCount;
    //    if (formerBeatPrecised
 }
 
 else beatTrigged=false;
 
      if (formerBeatPrecised!=beatPrecised) {   
    //     background (127, 50, 50);
    beatPrecisedTrigged=true;
    print("  ******** "); 
    print("  ******** "); 
    print(" automation1*100 ");  println( automation1*100 );
    print("  ******** "); 
    print("  ******** "); 
    print("  beatPrecised "); 
    println(beatPrecisedTrigged);
  }
  
  else  beatPrecisedTrigged=false; 

  
  
   
} 

void autmationWithMeasureAndNote() {
 // if (formerSartKey!=L){
  autoNote1VelInf64();
 //  }

  if (measure<5 ) {
    //  speedDelta=15;
    speedDelta=4; 
    autoNote2();
  } 
  if (measure>=5 && measure<=5 && beatTrigged==true) {
    speedDelta=4 ;
    //   autoNote2();
  } 
  if ( measure<=2 ) {

    key='$';
    keyReleased();
  }
  if ( measure<=5 ) {
    // d=0;
    oscillatorBlocked=6;
//    d=100;
  }
  if ( measure>=6 && measure<=7 ) {
    d=200;
  }

  if ( measure<8 && beatTrigged==true) {
    //   key='?'; // slow acceleration
    //     keyReleased();
  } 


  if  (measure>=24 && measure<=38 ) {// measure>=41 && measure<=42
    //    autoNote2(); mis dans la vers FIVE
    //     key='Y';keyReleased();
    //     key='Y';keyReleased();
  }

  if  (measure>=61 && measure<=61 && beatTrigged==true  ) {

    key='o';
    keyReleased();
  }
  if  (measure>=66 && measure<67 ) {

    //   key='e';keyReleased();// shift phase mod   PI/3
  }
  if  (measure>=71 && measure<78 ) {

    autoNote2();
  }

  if  (measure>=40 && measure<41 && beatTrigged==true ) {//77  //&& beatTrigged==true
    //    key='o';
    //    keyReleased();
    key=9;
    keyReleased();
    key=CONTROL;
    keyReleased();
    oscillatorBlocked=10;
    speedDelta=4;
  }
  if  (measure>=43 && measure<44 && beatPrecised>=4 && beatPrecisedTrigged==true ) {//77  //&& beatTrigged==true
    //    key='9';
    //    keyReleased();
    key='o';
    keyReleased();
  } 
  if  (measure>=45 && measure<46 && beatPrecised>=4 && beatPrecisedTrigged==true ) {//77  //&& beatTrigged==true
    //    key='9';
    //    keyReleased();
    key='o';
    keyReleased();
  }   

  if  (measure>=47 && measure<48 && beatPrecised>=4 && beatPrecisedTrigged==true ) {//77  //&& beatTrigged==true

    key='o';
    keyReleased();
  }

  if  (measure>=50 && measure<51 && beatPrecised>=4 && beatPrecisedTrigged==true ) {//77  //&& beatTrigged==true

    key='o';
    keyReleased();
  }

  if ((( measure>40 && measure<58) && (millis()>formerEvent[74]+1000+d)) &&
    ((note1>73 && note1<75 && velocity1>=1 && velocity1<=64)|| (note2>73 && note2<75 && velocity2>=1 && velocity2<=64)|| (note3>73 && note3<75 && velocity3>=1 && velocity3<=64) ||
    (note4>73 && note4<75 && velocity4>=1 && velocity4<=64)|| (note5>73 && note5<75 && velocity5>=1 && velocity5<=64)|| (note6>73 && note6<75 && velocity6>=1 && velocity6<=64)
    )) {
    //  key='u'; //u=117 
    //   key='d'; //u=117 
    //     key='9'; //TROUVE AUTRE CHOSE QUE l'ALIGNEMENT   pas cool à 60
    key='t'; //TROUVE AUTRE CHOSE QUE l'ALIGNEMENT   pas cool à 60
    keyReleased();
    formerEvent[74]=millis();
  }

  if  (measure>=53 && measure<54 && beatTrigged==true) {
    //    oscillatorBlocked=10;
    //  key='ç';
    //  keyReleased();
    //      key='2';keyReleased();// frequencies equal
    //  key='l';
    //  keyReleased();
    //  formerSartKey='l'; //automatise movement with note
  }

  if (measure>=76 && measure<77 && beatTrigged==true) {//77  //&& beatTrigged==true
  }


  if  (measure>=77 && measure<78 && beatTrigged==true  ) {//77  //&& beatTrigged==true
  }

  if  (measure>=77 && measure<78 && beatTrigged==true ) { //
  }

  if  (measure>=78 && measure<=78 && beatTrigged==true) {
    key='A'; 
    keyReleased();
    key='o'; 
    keyReleased();

    key='*';
    keyReleased();

    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();

    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();

    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='T';
    keyReleased();
    key='t';
    keyReleased();
    keyCode=CONTROL;
    keyReleased();
    speedDelta=12;

    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();


    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
    key='Y';
    keyReleased();
  //    key='Y';keyReleased();
    //   key='Y';keyReleased();
  }
  if  (measure>=79 && measure<=79 && beatTrigged==true) {
    speedDelta= 11;
//    key='Y';
  //  keyReleased();
  //  key='y';
//    keyReleased();
  }

  if  (measure>=79+1 && measure<=79+1 && beatTrigged==true) {
    speedDelta= 8;
  }  
  if  (measure>=79+1 && measure<=200 ) {//129
    autoNote2();
  }
  if  (measure>=79+2 && measure<=79+2 && beatTrigged==true) {
    speedDelta= 4;
  }
  if  (measure>=79+3 && measure<=79+3 && beatTrigged==true) {
    speedDelta= 4;
  }
  
  if  (measure>=79+4 && measure<=79+4 && beatTrigged==true) {
    speedDelta= 2;
  }

  if  (measure>=84 && measure<=92 && beatTrigged==true) {

    //   key='y';keyReleased();
  }
   if ( measure>=106 && measure<=106 && beatTrigged==true) {
       speedDelta= 2;
  //     key='e'; keyReleased();
    
  } 
  if ( measure>=107 && measure<=107 && beatTrigged==true) {
       speedDelta= 2;
  //     key='e'; keyReleased();
      keyCode =CONTROL; keyReleased();
    
  } 
    if ( measure>=109 && measure<=109 && beatTrigged==true) {
       speedDelta= 2;
     
  } 
    if ( measure>=115 && measure<=115 && beatTrigged==true) {
       speedDelta= 2;
    //   key='e'; keyReleased();
    
  } 
      if ( measure>=116 && measure<=116 && beatTrigged==true) {
       speedDelta= 2;
     
  } 


  if  (measure>=129 && measure<130 && beatTrigged==true) {// measure>=41 && measure<=42
    speedDelta=4;
    key='$';
    keyReleased();
    key='H';
    keyReleased();
    key='H';
    keyReleased();
    key='H';
    keyReleased();
    key='H';
    keyReleased();

    key='H';
    keyReleased();
    key='H';
    keyReleased();
    key='H';
    keyReleased();
    key='H';
    keyReleased();

    //  key='O';
    ///   keyReleased();

    //   key='°';keyReleased(); // speed=0 
    key='0';
    keyReleased(); // speed=0
    key='q';
    keyReleased(); // speed=0
    key='n';
    keyReleased(); // speed=0
  }
  if  (measure>=129 ) {// measure>=41 && measure<=42
    //  autoNote1();
  }


  if  (measure>=133 && measure<=137 && beatTrigged==true) {// measure>=41 && measure<=42

    //  key='o';    keyReleased();
    key='*';    
    keyReleased();
    key='w';    
    keyReleased();
  }
  if  (measure>=137 && measure<=137 && beatTrigged==true) {// measure>=41 && measure<=42

    //  key='o';    keyReleased();
    key='*';    
    keyReleased();
    
  }
   if  (measure>=166 && beatTrigged==true) {// measure>=41 && measure<=42
    key='°';    keyReleased();
    key='o';    keyReleased();
    key='*';    keyReleased();
    
  }
  // autoNote1Original(); // !=0
  // autoNote2();
}

void autoNote1VelInf64() {//1 61 63 64 66 85 

 // keyPressedLFO();


 // if (((formerSartKey!='a')) 
  if (((formerSartKey!='L')) 
    ) 
  {

    if (( measure>=12 && measure<=12 && beatPrecised>=4 && beatPrecisedTrigged==true )
      ) {
      //    key='K';keyReleased();
    }
    if (( measure>=12 && measure<=34 && millis()>formerEvent[76]+1000) &&
      ((note1>75 && note1<77 && velocity1>=1 && velocity1<=127)|| (note2>75 && note2<77 && velocity2>=1 && velocity2<=127)|| (note3>75 && note3<77 && velocity3>=1 && velocity3<=127) ||
      (note4>75 && note4<77 && velocity4>=1 && velocity4<=127)|| (note5>75 && note5<77 && velocity5>=1 && velocity5<=127)|| (note6>75 && note6<77 && velocity6>=1 && velocity6<=127)
      )) {
      key='9';
      keyReleased();

      key='P';
      keyReleased();
      key='P';
      keyReleased();

      formerEvent[76]=millis();
    }
    if (( measure>=24 && measure<=34 && millis()>formerEvent[76]+1000) &&
      ((note1>75 && note1<77 && velocity1>=1 && velocity1<=127)|| (note2>75 && note2<77 && velocity2>=1 && velocity2<=127)|| (note3>75 && note3<77 && velocity3>=1 && velocity3<=127) ||
      (note4>75 && note4<77 && velocity4>=1 && velocity4<=127)|| (note5>75 && note5<77 && velocity5>=1 && velocity5<=127)|| (note6>75 && note6<77 && velocity6>=1 && velocity6<=127)
      )) {
      key='9';
      keyReleased();
      key='P';
      keyReleased();
      key='P';
      keyReleased();
      key='p';
      keyReleased();


      formerEvent[76]=millis();
    }

    if  (measure>=12 && measure<=15  && beatTrigged==true ) {// beatPrecised2=true
      for (int i = 0; i < networkSize; i++) {
      }
    }
    if  (measure>16 && measure<=18  && beatTrigged==true ) {// beatPrecised2=true
      for (int i = 0; i < networkSize; i++) {


        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>=36 && measure<=36  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {
        key='0';
        keyReleased();
        key='q';
        keyReleased();
        key='n';
        keyReleased();
        key='q';
        keyReleased();
        key='n';
        keyReleased();
        key='o';
        keyReleased();

        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>41 && measure<=42  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //    ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
      }
    }
    //%ADMAD
    if (( measure<=40 && millis()>formerEvent[67]+50+d )&&
      (
      (note1>66 && note1<68  && velocity1>=1 && velocity1<=64)|| (note2>66 && note2<68 && velocity2>=1 && velocity2<=64) || (note3>66 && note3<68 && velocity3>=1 && velocity3<=64) || 
      (note4>66 && note4<68  && velocity4>=1 && velocity4<=64)|| (note5>66 && note5<68 && velocity5>=1 && velocity5<=64) || (note6>66 && note6<68 && velocity6>=1 && velocity6<=64)
      )) {
      //   key='E'; 
          key='r'; 
          keyReleased(); //u=117
      formerEvent[67]=millis();
      print ("formerEvent[67] INSIDE"); 
      println (formerEvent[67]);
    }

    if (( measure<=15 && millis()>formerEvent[64]+950+d )&&
      (
      (note1>63 && note1<65  && velocity1>=1 && velocity1<=64)|| (note2>63 && note2<65 && velocity2>=1 && velocity2<=64) || (note3>63 && note3<65 && velocity3>=1 && velocity3<=64) || 
      (note4>63 && note4<65  && velocity4>=1 && velocity4<=64)|| (note5>63 && note5<65 && velocity5>=1 && velocity5<=64) || (note6>63 && note6<65 && velocity6>=1 && velocity6<=64)
      )) {
      //    key='f'; 
      //     keyReleased(); //u=117
      formerEvent[64]=millis();
      print ("formerEvent[64] INSIDE"); 
      println (formerEvent[64]);
    }

    if (( measure<=40  && millis()>formerEvent[69]+900+d )&& // from Track1 and Track 0
      (
      (note1>68 && note1<70  && velocity1>=1 && velocity1<=64)|| (note2>68 && note2<70 && velocity2>=1 && velocity2<=64) || (note3>68 && note3<70 && velocity3>=1 && velocity3<=64) || 
      (note4>68 && note4<70  && velocity4>=1 && velocity4<=64)|| (note5>68 && note5<70 && velocity5>=1 && velocity5<=64) || (note6>68 && note6<70 && velocity6>=1 && velocity6<=64)
      )) {
      //      key='r'; 
      //   keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if (( measure>=123 && millis()>formerEvent[69]+100+d )&&
      (
      (note1>68 && note1<70  && velocity1>=1 && velocity1<=64)|| (note2>68 && note2<70 && velocity2>=1 && velocity2<=64) || (note3>68 && note3<70 && velocity3>=1 && velocity3<=64) || 
      (note4>68 && note4<70  && velocity4>=1 && velocity4<=64)|| (note5>68 && note5<70 && velocity5>=1 && velocity5<=64) || (note6>68 && note6<70 && velocity6>=1 && velocity6<=64)
      )) {
      key='U'; 
      keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if ( measure>=123 && measure<=123 && beatTrigged==true 

      ) {
      //   key='9'; 
      //   keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+4 && measure<=123+4 && beatTrigged==true 

      ) {
      //    key='9'; 
      //    keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='9'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='p'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }


    if (( measure<=11 && millis()>formerEvent[72]+350+d )&& //250 to adjust with 172 (the other hand of mad rush)
      ((note1>71 && note1<73  && velocity1>=1 && velocity1<=64)|| (note2>71 && note2<73 && velocity2>=1 && velocity2<=64) || (note3>71 && note3<73 && velocity3>=1 && velocity3<=64) ||
      (note4>71 && note4<73  && velocity4>=1 && velocity4<=64)|| (note5>71 && note5<73 && velocity5>=1 && velocity5<=64) || (note6>71 && note6<73 && velocity6>=1 && velocity6<=64)
      )) {

      key='U';//i= 105 
      keyReleased(); 
      formerEvent[72]=millis();
      print ("formerEvent[72] INSIDE"); 
      println (formerEvent[72]);
    }

    if (( measure>11 && measure<41 && millis()>formerEvent[72]+350+d-300 )&& //250 to adjust with 172 (the other hand of mad rush)
      ((note1>71 && note1<73  && velocity1>=1 && velocity1<=64)|| (note2>71 && note2<73 && velocity2>=1 && velocity2<=64) || (note3>71 && note3<73 && velocity3>=1 && velocity3<=64) ||
      (note4>71 && note4<73  && velocity4>=1 && velocity4<=64)|| (note5>71 && note5<73 && velocity5>=1 && velocity5<=64) || (note6>71 && note6<73 && velocity6>=1 && velocity6<=64)
      )) {

      key='U';//i= 105 
      keyReleased(); 
      formerEvent[72]=millis();
      print ("formerEvent[72] INSIDE"); 
      println (formerEvent[72]);
    }
    /*
      if (( measure>40 && measure<61 && millis()>formerEvent[72]+25+d) && // RETROUVE joli d. Plus coherent sur 64
     ((note1>71 && note1<73  && velocity1>=1 && velocity1<=64 )|| (note2>71 && note2<73 && velocity2>=1 && velocity2<=64) || (note3>71 && note3<73 && velocity3>=1 && velocity3<=64)||
     (note4>71 && note4<73  && velocity4>=1 && velocity4<=64 )|| (note5>71 && note5<73 && velocity5>=1 && velocity5<=64) || (note6>71 && note6<73 && velocity6>=1 && velocity6<=64)
     )) { 
     key='d'; 
     keyReleased(); 
     key='d'; 
     keyReleased(); 
     key='d';    
     formerEvent[72]=millis();
     }
     */
    if (( measure>25 && measure<35 && millis()>formerEvent[70]+300 )&& // from Track1 and Track 0
      (
      (note1>69 && note1<71  && velocity1>=1 && velocity1<=64)|| (note2>69 && note2<71 && velocity2>=1 && velocity2<=64) || (note3>69 && note3<71 && velocity3>=1 && velocity3<=64) || 
      (note4>69 && note4<71  && velocity4>=1 && velocity4<=64)|| (note5>69 && note5<71 && velocity5>=1 && velocity5<=64) || (note6>69 && note6<71 && velocity6>=1 && velocity6<=64)
      )) {
      // oscillatorBlocked=10;  
      key='R'; 
      keyReleased(); 
      //   key='f'; 
      //   keyReleased(); 

      formerEvent[70]=millis();
      print ("                                                   formerEvent[64] INSIDE> f  "); 
      println (formerEvent[64]);
    }



    if (( measure>40 && measure<61  && millis()>formerEvent[64]+100 )&& // from Track1 and Track 0
      (
      (note1>63 && note1<65  && velocity1>=1 && velocity1<=64)|| (note2>63 && note2<65 && velocity2>=1 && velocity2<=64) || (note3>63 && note3<65 && velocity3>=1 && velocity3<=64) || 
      (note4>63 && note4<65  && velocity4>=1 && velocity4<=64)|| (note5>63 && note5<65 && velocity5>=1 && velocity5<=64) || (note6>63 && note6<65 && velocity6>=1 && velocity6<=64)
      )) {
      oscillatorBlocked=10;  
      key='f'; 
      keyReleased(); 
      //   key='f'; 
      //   keyReleased(); 

      formerEvent[64]=millis();
      print ("                                                   formerEvent[64] INSIDE> f  "); 
      println (formerEvent[64]);
    }




    if (( measure>40 && measure<61  && millis()>formerEvent[69]+100 )&& // from Track1 and Track 0
      (
      (note1>68 && note1<70  && velocity1>=1 && velocity1<=64)|| (note2>68 && note2<70 && velocity2>=1 && velocity2<=64) || (note3>68 && note3<70 && velocity3>=1 && velocity3<=64) || 
      (note4>68 && note4<70  && velocity4>=1 && velocity4<=64)|| (note5>68 && note5<70 && velocity5>=1 && velocity5<=64) || (note6>68 && note6<70 && velocity6>=1 && velocity6<=64)
      )) {
      oscillatorBlocked=1;
      key='d'; 
      keyReleased(); 
      //  key='d'; 
      //  keyReleased(); 


      formerEvent[69]=millis();
      print ("                                                   formerEvent[69] INSIDE> d  "); 
      println (formerEvent[69]);
    }

    if (( measure>40 && measure<61  && millis()>formerEvent[67]+100 )&& // pour equilibrer le trop plein de f
      (
      (note1>66 && note1<68  && velocity1>=1 && velocity1<=64)|| (note2>68 && note2<68 && velocity2>=1 && velocity2<=64) || (note3>68 && note3<68 && velocity3>=1 && velocity3<=64) || 
      (note4>68 && note4<68  && velocity4>=1 && velocity4<=64)|| (note5>68 && note5<68 && velocity5>=1 && velocity5<=64) || (note6>68 && note6<68 && velocity6>=1 && velocity6<=64)
      )) {
      //   oscillatorBlocked=1;
      key='d'; 
      keyReleased(); 
      //  key='d'; 
      //  keyReleased(); 


      formerEvent[67]=millis();
      print ("                                                   formerEvent[67] INSIDE> d  "); 
      println (formerEvent[67]);
    }


    if (( measure>60 && measure<78 && millis()>formerEvent[72]+1000) && //25+d
      ((note1>71 && note1<73  && velocity1>=1 && velocity1<=64 )|| (note2>71 && note2<73 && velocity2>=1 && velocity2<=64) || (note3>71 && note3<73 && velocity3>=1 && velocity3<=64)||
      (note4>71 && note4<73  && velocity4>=1 && velocity4<=64 )|| (note5>71 && note5<73 && velocity5>=1 && velocity5<=64) || (note6>71 && note6<73 && velocity6>=1 && velocity6<=64)
      )) {
      // key='d'; 
      key='i'; // u bloque 
      keyReleased(); //u=117
      formerEvent[72]=millis();
    }

    if  ( measure>60 && measure<78 && (millis()>formerEvent[73]+0+d+150) &&
      ((note1>71+1 && note1<73+1  && velocity1>=1 && velocity1<=64 )|| (note2>71+1 && note2<73+1 && velocity2>=1 && velocity2<=64) || (note3>71+1 && note3<73+1 && velocity3>=1 && velocity3<=64) ||
      (note4>71+1 && note4<73+1  && velocity4>=1 && velocity4<=64 )|| (note5>71+1 && note5<73+1 && velocity5>=1 && velocity5<=64) || (note6>71+1 && note6<73+1 && velocity6>=1 && velocity6<=64)
      )) {
      //  key='d';
      //  key='U';
      //    keyReleased(); //u=117
      formerEvent[73]=millis();
    }



    if ((( measure<41 && measure<41) && (millis()>formerEvent[74]+100)) &&
      ((note1>73 && note1<75 && velocity1>=1 && velocity1<=64)|| (note2>73 && note2<75 && velocity2>=1 && velocity2<=64)|| (note3>73 && note3<75 && velocity3>=1 && velocity3<=64) ||
      (note4>73 && note4<75 && velocity4>=1 && velocity4<=64)|| (note5>73 && note5<75 && velocity5>=1 && velocity5<=64)|| (note6>73 && note6<75 && velocity6>=1 && velocity6<=64)
      )) {
      key='r';
      keyReleased();
      key='r';
      keyReleased();
      formerEvent[74]=millis();
    }
    if (( measure>61 && measure<78 && millis()>formerEvent[74]+200) &&  // wiat 200 ms before consideration of the next event 74. Here is note 74
      ((note1>73 && note1<75 && velocity1>=1 && velocity1<=64)|| (note2>73 && note2<75 && velocity2>=1 && velocity2<=64)|| (note3>73 && note3<75 && velocity3>=1 && velocity3<=64) ||
      (note4>73 && note4<75 && velocity4>=1 && velocity4<=64)|| (note5>73 && note5<75 && velocity5>=1 && velocity5<=64)|| (note6>73 && note6<75 && velocity6>=1 && velocity6<=64)
      )) {

      oscillatorBlocked=6; 
      key='f'; 
      keyReleased();//i= 105
      ///   key='f'; 
      //  keyReleased();//i= 105
      formerEvent[74]=millis();
    }

    if  ( measure<78 && millis()>formerEvent[75]+0+d &&

      ((note1>73+1 && note1<75+1 && velocity1>=1 && velocity1<=64)|| (note2>73+1 && note2<75+1 && velocity2>=1 && velocity2<=64) || (note3>73+1 && note3<75+1 && velocity3>=1 && velocity3<=64) ||
      (note4>73+1 && note4<75+1 && velocity4>=1 && velocity4<=64)|| (note5>73+1 && note5<75+1 && velocity5>=1 && velocity5<=64) || (note6>73+1 && note6<75+1 && velocity6>=1 && velocity6<=64)
      )) {

      //  key='k'; 
      //  keyReleased();//i= 105

      formerEvent[75]=millis();
    }



    if  (note1>65 && note1<67 && velocity1 >79  && velocity1 <81) {

      //     key='J'; keyReleased();
    }
    if  (note1>73 && note1<75 && velocity1 >79  && velocity1 <81) {//
      //   key='f'; keyReleased();
      //      key='K'; keyReleased();



      if  (   (note1>59 && note1<61 && velocity1 >95 && velocity1 <97) || (note2>59 && note2<61 && velocity2 >95 && velocity2 <97)) {
        //       if  (note1<1){
        //  key='p'; keyReleased();
        //    formerFrame=millis();

        //   key='p'; 
        //   keyReleased();//p=112;
        //   formerEvent[60]=millis();

        //    key='d'; keyReleased();
        //     formerKey=key;

        // doNothing();
      }   

      if  (   (note1>75 && note1<77) || (note2>75 && note2<77)  ) {

        //   key='d'; 
        //   keyReleased();//d=100;
        formerEvent[76]=millis();
      }
      if  (note2>82 && note2<84 || note1>82 && note1<84) {

        //   key='f'; 
        //   keyReleased();//f=102
        formerEvent[83]=millis();
        //    key='g'; keyReleased();
        //     key='g'; keyReleased();
        //    doNothing();
      }
    }
  }
}


void  autoNote2() {//1 61 63 64 66 85 
 // keyPressedLFO();

  print (millis()); 
  print (" auto2  formerEvent[167]  "); 
  print (formerEvent[167]);
  print (" auto2  formerEvent[172]  "); 
  println (formerEvent[172]);

  if ((formerSartKey!='L') 
    ) 
  {
    if  (measure>40 && measure<=41 && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //   key='W'; 
        //   keyReleased();
        //  formerW();
      }
    }
    if  (measure>41 && measure<=42  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //    ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
        //     ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
        //    key=';';keyPressed(); print ("rise up frameratio +5 ");
        //    key=';';keyPressed(); print ("rise up frameratio +5 ");
        //    key=';';keyPressed(); print ("rise up frameratio +5 ");
      }
    }
    //%ADMAD
    if (( measure<=40 && millis()>formerEvent[167]+450+d)&&
      ((note1>66 && note1<68  && velocity1>=96 && velocity1<=96)|| (note2>66 && note2<68 && velocity2>=96 && velocity2<=96) || (note3>66 && note3<68 && velocity3>=96 && velocity3<=96))) {
      formerEvent[167]=millis();
      //  key='E'; 
      //  keyReleased(); //u=117


      print ("formerEvent[167] INSIDE ");  
      print ("formerEvent[167] INSIDE ");  
      print ("formerEvent[167] INSIDE ");   
      print ("formerEvent[167] INSIDE "); 
      println (formerEvent[167]);
    }

    if (( measure<=40 && millis()>formerEvent[169]+1000+d)&&
      ((note1>68 && note1<70  && velocity1>=96 && velocity1<=96)|| (note2>68 && note2<70 && velocity2>=96 && velocity2<=96) || (note3>68 && note3<70 && velocity3>=96 && velocity3<=96))) {

      key='E'; //E=69
      keyReleased(); //u=117
      formerEvent[169]=millis(); 

      print ("formerEvent[169] INSIDE ");  
      println (formerEvent[169]);
    } 

    if (( measure>40 && measure<75 && millis()>formerEvent[169]+450+d)&&
      ((note1>68 && note1<70  && velocity1>=96 && velocity1<=96)|| (note2>68 && note2<70 && velocity2>=96 && velocity2<=96) || (note3>68 && note3<70 && velocity3>=96 && velocity3<=96))) {

      key='P'; //P=80
      keyReleased(); //u=117


      print ("formerEvent[169] INSIDE ");  
      println (formerEvent[169]);
      formerEvent[169]=millis();
    } 

    if (( measure>78 && measure<=129 && millis()>formerEvent[169]+2950 )  && //1400 with P
      ((note1>68 && note1<70  && velocity1>=96 && velocity1<=96)|| (note2>68 && note2<70 && velocity2>=96 && velocity2<=96) || (note3>68 && note3<70 && velocity3>=96 && velocity3<=96))) {

   //   key='R'; //P=80    R when frequency are negative
      key='p';
      keyReleased(); //u=117
      key='#'; //P=80    R when frequency are negative
      //  keyReleased(); //u=117

      formerEvent[169]=millis();
      print ("formerEvent[269] INSIDE ");  
      println (formerEvent[169]);
    } 
    
     if (( measure>=80 && measure<=80 && beatPrecised>=1 && beatPrecised<=1 && beatPrecisedTrigged==true )
      ) {
      //    key='p';keyReleased();
    //      keyCode=CONTROL;keyReleased();
          key='#';
    }
    
         if (( measure>=83 && measure<=83 && beatPrecised>=1 && beatPrecised<=1 && beatPrecisedTrigged==true )
      ) {
        //  key='p';keyReleased();
      //    keyCode=CONTROL;keyReleased();
          key='#';
    }



    if (( measure<=5 && millis()>formerEvent[172]+300+d)&&
      ((note1>71 && note1<73  && velocity1>=96 && velocity1<=96 )|| (note2>71 && note2<73 && velocity2>=96 && velocity2<=96) || (note3>71 && note3<73 && velocity3>=96 && velocity3<=96))) {

      //   key='i';//i= 105 
      oscillatorBlocked=6;
      //     key='d';
      //   key='f'; //f=102;
      //  keyReleased();
      formerEvent[172]=millis();
      print ("formerEvent[172] INSIDE ");  
      print ("formerEvent[172] INSIDE ");  
      print ("formerEvent[172] INSIDE ");  
      print ("formerEvent[172] INSIDE "); 
      println (formerEvent[172]);
    }
    if ((( measure>40 && measure<61) && (millis()>formerEvent[172]+100+d) && //200
      ((note1>71 && note1<73  && velocity1>=96 && velocity1<=96 )|| (note2>71 && note2<73 && velocity2>=96 && velocity2<=96) || (note3>71 && note3<73 && velocity3>=96 && velocity3<=96)))) {
      //   key='t'; keyReleased();//i= 105   
      //     key='d';//   to much case d with autonote1
      //     keyReleased(); 
      //     key='d'; 
      //     keyReleased(); 
      formerEvent[172]=millis();
    }
    if (( measure>60 && (millis()>formerEvent[172]+200+d) &&
      ((note1>71 && note1<73  && velocity1>=96 && velocity1<=96 )|| (note2>71 && note2<73 && velocity2>=96 && velocity2<=96) || (note3>71 && note3<73 && velocity3>=96 && velocity3<=96)))) {
      // key='d'; 
      //  key='u'; 
      //   keyReleased(); //u=117
      formerEvent[172]=millis();
    }

    if  ( (millis()>formerEvent[173]+1000+d) &&
      ((note1>71+1 && note1<73+1  && velocity1>=96 && velocity1<=96 )|| (note2>71+1 && note2<73+1 && velocity2>=96 && velocity2<=96) || (note3>71+1 && note3<73+1 && velocity3>=96 && velocity3<=96))) {
      //  key='d';
      //    key='i';
      //   keyReleased(); //u=117
      formerEvent[173]=millis();
    }
    if ((( measure<41 && measure<41) && (millis()>formerEvent[174]+200+d)) &&
      ((note1>73 && note1<75 && velocity1>=96 && velocity1<=96)|| (note2>73 && note2<75 && velocity2>=96 && velocity2<=96)|| (note3>73 && note3<75 && velocity3>=96 && velocity3<=96))) {
      //   key='u'; //u=117 
      //   key='d'; //u=117 
      //   keyReleased();
      formerEvent[174]=millis();
    }
    if ((( measure>41 && measure<78) && (millis()>formerEvent[174]+200+d) &&
      ((note1>73 && note1<75 && velocity1>=96 && velocity1<=96)|| (note2>73 && note2<75 && velocity2>=96 && velocity2<=96)))) {

      //      key='t'; keyReleased();//i= 105 
  //***    key='d'; 
      keyReleased();//i= 105
      //  key='d'; 
      //  keyReleased();//i= 105
      formerEvent[174]=millis();
    }

    if  ( millis()>formerEvent[175]+300 &&

      ((note1>73+1 && note1<75+1 && velocity1>=96 && velocity1<=96)|| (note2>73+1 && note2<75+1 && velocity2>=96 && velocity2<=96))) {


   //   key='f';  
    //  keyReleased();//i= 105
    
      /*
        keyReleased();//i= 105
       key='f'; 
       keyReleased();//i= 105
       key='f'; 
       keyReleased();//i= 105
       key='f'; 
       keyReleased();//i= 105
       */
      formerEvent[175]=millis();
    }



    if  (note1>65 && note1<67 && velocity1 >79  && velocity1 <81) {
      //       if  (note1<1){
      //  key='p'; keyReleased();

      //   key='d'; keyReleased();
      //     key='J'; keyReleased();

      //       formerFrame=millis();
      // doNothing();
    }
    if  (note1>73 && note1<75 && velocity1 >79  && velocity1 <81) {//
      //   key='f'; keyReleased();
      //      key='K'; keyReleased();

      //       formerFrame=millis();

      //     key='f'; keyReleased();
      //   doNothing();
    }
    /////TRACK 0 BEAT from MADRUSH 

    //   if  ((note1>0 && note1<6  && velocity1 >79 ) || (note2>0 && note2<6  && velocity2 >79 ) || (note3>0 && note3<6  && velocity3 >79 ) 
    //     || (note4>0 && note4<6  && velocity4 >79 ) || (note5>0 && note5<6  && velocity5 >79 ) || (note6>0 && note6<6  && velocity6 >79 ) 
    //   ){
    ///      if  ((note1>84 && note1<86  && velocity1 >78 && velocity1 <201) || (note2>84 && note2<86  && velocity2 >78  && velocity2 <201)
    //     ||   (note3>84 && note3<86  && velocity3 >78 && velocity3 <201)){  

    if  (   (note1>59 && note1<61 && velocity1 >95 && velocity1 <97) || (note2>59 && note2<61 && velocity2 >95 && velocity2 <97)) {
      //       if  (note1<1){
      //  key='p'; keyReleased();
      //    formerFrame=millis();

      //    key='p'; 
      keyReleased();//p=112;
      formerEvent[160]=millis();

      //    key='d'; keyReleased();
      //     formerKey=key;

      // doNothing();
    }   

    if  (   (note1>75 && note1<77) || (note2>75 && note2<77)) {
      //       if  (note1<1){
      //  key='p'; keyReleased();
      //    formerFrame=frameCount;

      //  key='d'; 
      keyReleased();//d=100;
      formerEvent[176]=millis();
      //    key='d'; keyReleased();
      //    formerKey=key;

      // doNothing();
    }
    if  (note2>82 && note2<84 || note1>82 && note1<84) {

  //***    key='d'; 
  //**    keyReleased();//f=102
      formerEvent[183]=millis();
      //    key='g'; keyReleased();
      //     key='g'; keyReleased();
      //    doNothing();
    }
  }
} 

void autoNote1Original() {//1 61 63 64 66 85 
  keyPressedLFO();


//  if (((formerSartKey!='a')) 
   if (((formerSartKey!='L')) 
    ) 
  {
    if  (measure>40 && measure<=41  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>41 && measure<=42  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //    ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
      }
    }
    //%ADMAD
    if (( measure<=40 && millis()>formerEvent[67]+50+d )&&
      (
      (note1>66 && note1<68  && velocity1!=0)|| (note2>66 && note2<68 && velocity2!=0) || (note3>66 && note3<68 && velocity3!=0) || 
      (note4>66 && note4<68  && velocity4!=0)|| (note5>66 && note5<68 && velocity5!=0) || (note6>66 && note6<68 && velocity6!=0)
      )) {
      key='E'; 
      keyReleased(); //u=117
      formerEvent[67]=millis();
      print ("formerEvent[67] INSIDE"); 
      println (formerEvent[67]);
    }

    if (( measure<=40 && millis()>formerEvent[64]+50+d )&&
      (
      (note1>63 && note1<65  && velocity1!=0)|| (note2>63 && note2<65 && velocity2!=0) || (note3>63 && note3<65 && velocity3!=0) || 
      (note4>63 && note4<65  && velocity4!=0)|| (note5>63 && note5<65 && velocity5!=0) || (note6>63 && note6<65 && velocity6!=0)
      )) {
      key='f'; 
      //     keyReleased(); //u=117
      formerEvent[64]=millis();
      print ("formerEvent[64] INSIDE"); 
      println (formerEvent[64]);
    }

    if (( measure<=40  && millis()>formerEvent[69]+50+d )&& // from Track1
      (
      (note1>68 && note1<70  && velocity1!=0)|| (note2>68 && note2<70 && velocity2!=0) || (note3>68 && note3<70 && velocity3!=0) || 
      (note4>68 && note4<70  && velocity4!=0)|| (note5>68 && note5<70 && velocity5!=0) || (note6>68 && note6<70 && velocity6!=0)
      )) {
      key='r'; 
      keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if (( measure>=123 && millis()>formerEvent[69]+100+d )&&
      (
      (note1>68 && note1<70  && velocity1!=0)|| (note2>68 && note2<70 && velocity2!=0) || (note3>68 && note3<70 && velocity3!=0) || 
      (note4>68 && note4<70  && velocity4!=0)|| (note5>68 && note5<70 && velocity5!=0) || (note6>68 && note6<70 && velocity6!=0)
      )) {
      key='U'; 
      keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if ( measure>=123 && measure<=123 && beatTrigged==true 

      ) {
 //     key='9'; 
 //     keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+4 && measure<=123+4 && beatTrigged==true 

      ) {
  //    key='9'; 
  //    keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='9'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='p'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }


    if (( measure<=40 && millis()>formerEvent[72]+100+d )&& // to adjust with 172 (the other hand of mad rush)
      ((note1>71 && note1<73  && velocity1!=0)|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0) ||
      (note4>71 && note4<73  && velocity4!=0)|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {

      key='U';//i= 105 
      //    key='f';
      keyReleased(); 
      formerEvent[72]=millis();
      print ("formerEvent[72] INSIDE"); 
      println (formerEvent[72]);
    }

    if (( measure>40 && measure<61 && millis()>formerEvent[72]+0+d) && // RETROUVE joli d
      ((note1>71 && note1<73  && velocity1!=0 )|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0)||
      (note4>71 && note4<73  && velocity4!=0 )|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {
      //   key='t'; keyReleased();//i= 105   
      key='d'; 
      keyReleased(); 
      key='d'; 
      keyReleased(); 

      formerEvent[72]=millis();
    }

    if (( measure>60 && measure<78 && millis()>formerEvent[72]+150+d) &&
      ((note1>71 && note1<73  && velocity1!=0 )|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0)||
      (note4>71 && note4<73  && velocity4!=0 )|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {
      // key='d'; 
      key='u'; 
      keyReleased(); //u=117
      formerEvent[72]=millis();
    }

    if  ( (millis()>formerEvent[73]+0+d+150) &&
      ((note1>71+1 && note1<73+1  && velocity1!=0 )|| (note2>71+1 && note2<73+1 && velocity2!=0) || (note3>71+1 && note3<73+1 && velocity3!=0) ||
      (note4>71+1 && note4<73+1  && velocity4!=0 )|| (note5>71+1 && note5<73+1 && velocity5!=0) || (note6>71+1 && note6<73+1 && velocity6!=0)
      )) {
      //  key='d';
      key='U';
      keyReleased(); //u=117
      formerEvent[73]=millis();
    }
    if ((( measure<41 && measure<41) && (millis()>formerEvent[74]+0+d)) &&
      ((note1>73 && note1<75 && velocity1!=0)|| (note2>73 && note2<75 && velocity2!=0)|| (note3>73 && note3<75 && velocity3!=0) ||
      (note4>73 && note4<75 && velocity4!=0)|| (note5>73 && note5<75 && velocity5!=0)|| (note6>73 && note6<75 && velocity6!=0)
      )) {
      key='u'; //u=117 
      //   key='d'; //u=117 
      keyReleased();
      formerEvent[74]=millis();
    }
    if (( measure>41 && measure<78 && millis()>formerEvent[74]+0+d) &&
      ((note1>73 && note1<75 && velocity1!=0)|| (note2>73 && note2<75 && velocity2!=0)|| (note3>73 && note3<75 && velocity3!=0) ||
      (note4>73 && note4<75 && velocity4!=0)|| (note5>73 && note5<75 && velocity5!=0)|| (note6>73 && note6<75 && velocity6!=0)
      )) {

      //      key='t'; keyReleased();//i= 105 
      key='f'; 
      keyReleased();//i= 105
      ///   key='f'; 
      //  keyReleased();//i= 105
      formerEvent[74]=millis();
    }

    if  ( measure<78 && millis()>formerEvent[75]+0+d &&

      ((note1>73+1 && note1<75+1 && velocity1!=0)|| (note2>73+1 && note2<75+1 && velocity2!=0) || (note3>73+1 && note3<75+1 && velocity2!=0) ||
      (note4>73+1 && note4<75+1 && velocity4!=0)|| (note5>73+1 && note5<75+1 && velocity5!=0) || (note6>73+1 && note6<75+1 && velocity6!=0)
      )) {

      key='k'; 
      keyReleased();//i= 105

      formerEvent[75]=millis();
    }



    if  (note1>65 && note1<67 && velocity1 >79  && velocity1 <81) {

      //     key='J'; keyReleased();
    }
    if  (note1>73 && note1<75 && velocity1 >79  && velocity1 <81) {//
      //   key='f'; keyReleased();
      //      key='K'; keyReleased();



      if  (   (note1>59 && note1<61 && velocity1 >95 && velocity1 <97) || (note2>59 && note2<61 && velocity2 >95 && velocity2 <97)) {
        //       if  (note1<1){
        //  key='p'; keyReleased();
        //    formerFrame=millis();

        key='p'; 
        keyReleased();//p=112;
        formerEvent[60]=millis();

        //    key='d'; keyReleased();
        //     formerKey=key;

        // doNothing();
      }   

      if  (   (note1>75 && note1<77) || (note2>75 && note2<77)  ) {

        //   key='d'; 
        //   keyReleased();//d=100;
        formerEvent[76]=millis();
      }
      if  (note2>82 && note2<84 || note1>82 && note1<84) {

        //   key='f'; 
        //   keyReleased();//f=102
        formerEvent[83]=millis();
        //    key='g'; keyReleased();
        //     key='g'; keyReleased();
        //    doNothing();
      }
    }
  }
} 


void formerKeyL() {
  if ( formerSartKey!='@') {

    float tempo= 1000/pulsation*60;

    print ("tempo ");  
    println (tempo);
    float ratioTempo= (oscillatorBlocked-1)%8.0 ;

    // float tempo108= (27*ratioTempo)+27;// pianophase
    float tempo108= (30*ratioTempo);// madrush
    float tempo109= (27*ratioTempo)%108;
    print ("ratioTempo ");  
    println (ratioTempo);
    print ("tempo108 ");  
    println (tempo108);
    print ("tempo109 ");  
    println (tempo109);

    //   if ( TrigmodPos[9]>=0 && TrigmodPos[9]<1 ||  revolution[9]>=0 && revolution[9]<1) {
    if ( TrigmodPos[0]>=0 && TrigmodPos[0]<1 ||  revolution[0]>=0 && revolution[0]<1) {

      if (tempo>tempo108+1.0) {
        key='h'; 
        keyReleased();
      }
      if (tempo<tempo108-1.0) {
        key='y'; 
        keyReleased();
      }
    }
  }
}
void autoNote1() {//1 61 63 64 66 85 
  keyPressedLFO();


  if (((formerSartKey!='a')) 
    ) 
  {

    if  (measure>13 && measure<=14  && beatTrigged==true ) {// beatPrecised2=true
      for (int i = 0; i < networkSize; i++) {
        key=CONTROL;
        keyReleased();

        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>23 && measure<=24  && beatTrigged==true ) {// beatPrecised2=true
      for (int i = 0; i < networkSize; i++) {
        key=CONTROL;
        keyReleased();

        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>40 && measure<=41  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {
        key='0';
        keyReleased();
        key='q';
        keyReleased();
        key='n';
        keyReleased();
        key='q';
        keyReleased();
        key='n';
        keyReleased();
        key='o';
        keyReleased();

        //   key='W'; 
        //   keyReleased();
      }
    }
    if  (measure>41 && measure<=42  && beatTrigged==true  ) {// measure>=41 && measure<=42
      for (int i = 0; i < networkSize; i++) {

        //    ActualVirtualPosition[i]=ActualVirtualPosition[i]+numberOfStep/3*i;
      }
    }
    //%ADMAD
    if (( measure<=40 && millis()>formerEvent[67]+50+d )&&
      (
      (note1>66 && note1<68  && velocity1!=0)|| (note2>66 && note2<68 && velocity2!=0) || (note3>66 && note3<68 && velocity3!=0) || 
      (note4>66 && note4<68  && velocity4!=0)|| (note5>66 && note5<68 && velocity5!=0) || (note6>66 && note6<68 && velocity6!=0)
      )) {
      //   key='E'; 
      //    key='r'; 
      keyReleased(); //u=117
      formerEvent[67]=millis();
      print ("formerEvent[67] INSIDE"); 
      println (formerEvent[67]);
    }

    if (( measure<=15 && millis()>formerEvent[64]+350+d )&&
      (
      (note1>63 && note1<65  && velocity1!=0)|| (note2>63 && note2<65 && velocity2!=0) || (note3>63 && note3<65 && velocity3!=0) || 
      (note4>63 && note4<65  && velocity4!=0)|| (note5>63 && note5<65 && velocity5!=0) || (note6>63 && note6<65 && velocity6!=0)
      )) {
      key='f'; 
      //     keyReleased(); //u=117
      formerEvent[64]=millis();
      print ("formerEvent[64] INSIDE"); 
      println (formerEvent[64]);
    }

    if (( measure<=40  && millis()>formerEvent[69]+900+d )&& // from Track1 and Track 0
      (
      (note1>68 && note1<70  && velocity1!=0)|| (note2>68 && note2<70 && velocity2!=0) || (note3>68 && note3<70 && velocity3!=0) || 
      (note4>68 && note4<70  && velocity4!=0)|| (note5>68 && note5<70 && velocity5!=0) || (note6>68 && note6<70 && velocity6!=0)
      )) {
      //      key='r'; 
      keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if (( measure>=123 && millis()>formerEvent[69]+100+d )&&
      (
      (note1>68 && note1<70  && velocity1!=0)|| (note2>68 && note2<70 && velocity2!=0) || (note3>68 && note3<70 && velocity3!=0) || 
      (note4>68 && note4<70  && velocity4!=0)|| (note5>68 && note5<70 && velocity5!=0) || (note6>68 && note6<70 && velocity6!=0)
      )) {
      key='U'; 
      keyReleased(); //u=117
      formerEvent[69]=millis();
      print ("formerEvent[69] INSIDE"); 
      println (formerEvent[69]);
    }
    if ( measure>=123 && measure<=123 && beatTrigged==true 

      ) {
      key='9'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+4 && measure<=123+4 && beatTrigged==true 

      ) {
      key='9'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='9'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }
    if ( measure>=123+8 && measure<=123+8 && beatTrigged==true 

      ) {
      key='p'; 
      keyReleased(); //u=117
      //   formerEvent[69]=millis();
    }


    if (( measure<=40 && millis()>formerEvent[72]+100+d )&& // to adjust with 172 (the other hand of mad rush)
      ((note1>71 && note1<73  && velocity1!=0)|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0) ||
      (note4>71 && note4<73  && velocity4!=0)|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {

      key='U';//i= 105 
      //    key='f';
      keyReleased(); 
      formerEvent[72]=millis();
      print ("formerEvent[72] INSIDE"); 
      println (formerEvent[72]);
    }

    if (( measure>40 && measure<61 && millis()>formerEvent[72]+100+d) && // RETROUVE joli d
      ((note1>71 && note1<73  && velocity1!=0 )|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0)||
      (note4>71 && note4<73  && velocity4!=0 )|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {
      //   key='t'; keyReleased();//i= 105   
      key='d'; 
      keyReleased(); 
      key='d'; 
      keyReleased(); 

      formerEvent[72]=millis();
    }

    if (( measure>60 && measure<78 && millis()>formerEvent[72]+150+d) &&
      ((note1>71 && note1<73  && velocity1!=0 )|| (note2>71 && note2<73 && velocity2!=0) || (note3>71 && note3<73 && velocity3!=0)||
      (note4>71 && note4<73  && velocity4!=0 )|| (note5>71 && note5<73 && velocity5!=0) || (note6>71 && note6<73 && velocity6!=0)
      )) {
      // key='d'; 
      key='i'; // u bloque 
      keyReleased(); //u=117
      formerEvent[72]=millis();
    }

    if  ( measure>60 && measure<78 && (millis()>formerEvent[73]+0+d+150) &&
      ((note1>71+1 && note1<73+1  && velocity1!=0 )|| (note2>71+1 && note2<73+1 && velocity2!=0) || (note3>71+1 && note3<73+1 && velocity3!=0) ||
      (note4>71+1 && note4<73+1  && velocity4!=0 )|| (note5>71+1 && note5<73+1 && velocity5!=0) || (note6>71+1 && note6<73+1 && velocity6!=0)
      )) {
      //  key='d';
      //  key='U';
      keyReleased(); //u=117
      formerEvent[73]=millis();
    }
    if ((( measure<41 && measure<41) && (millis()>formerEvent[74]+50+d)) &&
      ((note1>73 && note1<75 && velocity1!=0)|| (note2>73 && note2<75 && velocity2!=0)|| (note3>73 && note3<75 && velocity3!=0) ||
      (note4>73 && note4<75 && velocity4!=0)|| (note5>73 && note5<75 && velocity5!=0)|| (note6>73 && note6<75 && velocity6!=0)
      )) {
      //  key='u'; //u=117 
      //   key='d'; //u=117 
      key='i'; //u=117 
      keyReleased();
      formerEvent[74]=millis();
    }
    if (( measure>41 && measure<78 && millis()>formerEvent[74]+0+d) &&
      ((note1>73 && note1<75 && velocity1!=0)|| (note2>73 && note2<75 && velocity2!=0)|| (note3>73 && note3<75 && velocity3!=0) ||
      (note4>73 && note4<75 && velocity4!=0)|| (note5>73 && note5<75 && velocity5!=0)|| (note6>73 && note6<75 && velocity6!=0)
      )) {

      //      key='t'; keyReleased();//i= 105 
      key='f'; 
      keyReleased();//i= 105
      ///   key='f'; 
      //  keyReleased();//i= 105
      formerEvent[74]=millis();
    }

    if  ( measure<78 && millis()>formerEvent[75]+0+d &&

      ((note1>73+1 && note1<75+1 && velocity1!=0)|| (note2>73+1 && note2<75+1 && velocity2!=0) || (note3>73+1 && note3<75+1 && velocity2!=0) ||
      (note4>73+1 && note4<75+1 && velocity4!=0)|| (note5>73+1 && note5<75+1 && velocity5!=0) || (note6>73+1 && note6<75+1 && velocity6!=0)
      )) {

      key='k'; 
      keyReleased();//i= 105

      formerEvent[75]=millis();
    }



    if  (note1>65 && note1<67 && velocity1 >79  && velocity1 <81) {

      //     key='J'; keyReleased();
    }
    if  (note1>73 && note1<75 && velocity1 >79  && velocity1 <81) {//
      //   key='f'; keyReleased();
      //      key='K'; keyReleased();



      if  (   (note1>59 && note1<61 && velocity1 >95 && velocity1 <97) || (note2>59 && note2<61 && velocity2 >95 && velocity2 <97)) {
        //       if  (note1<1){
        //  key='p'; keyReleased();
        //    formerFrame=millis();

        key='p'; 
        keyReleased();//p=112;
        formerEvent[60]=millis();

        //    key='d'; keyReleased();
        //     formerKey=key;

        // doNothing();
      }   

      if  (   (note1>75 && note1<77) || (note2>75 && note2<77)  ) {

        //   key='d'; 
        //   keyReleased();//d=100;
        formerEvent[76]=millis();
      }
      if  (note2>82 && note2<84 || note1>82 && note1<84) {

        //   key='f'; 
        //   keyReleased();//f=102
        formerEvent[83]=millis();
        //    key='g'; keyReleased();
        //     key='g'; keyReleased();
        //    doNothing();
      }
    }
  }
}
void followMovementAll() {
  shiftFollowMov();
    for (int i =1; i < 2; i+=1) {
          LFO[0]=  map (automation1 , 0, 1, 0, TWO_PI);//net.phase[11];// map (automation1 , 0, 1, 0, TWO_PI);
          LFO[i]= LFO[0];
  if (millis()>formerEvent[200+i]+0*i) {
   
    
      newPosX[i] = displacement* cos(LFO[i]);
      newPosY[i] = displacement* sin(LFO[i]);
      formerEvent[200+i]= millis();
    }
  }

  if (millis()>formerEvent[200+2]+d*2) {
    // delay();
    LFO[2]= LFO[1];
    //***   LFO[2]= map (automationLFO[0],0, 1, -PI, 0); // gauche droite vers le haut
    newPosX[2] = displacement*cos (LFO[2]);
    newPosY[2] = displacement*sin (LFO[2]);
    formerEvent[200+2]= millis();
  }

  if (millis()>formerEvent[200+3]+d*3) {
    LFO[3]= LFO[2];
     newPosX[3] = displacement*cos (LFO[3]);
     newPosY[3] = displacement*sin (LFO[3]);
    formerEvent[200+3]= millis();
  }

}

void displayfollowMovementAll(){
 // keyPressedLFO();
  
  for (int i =0; i < 1; i++) {
    if (millis()>formerEvent[200+i]+0) {
      //   formerPositionLFO[0]=LFO[0];

   //   LFO[0]= map (automation1, 0, 1, 0, 1); // gauche droite vers le haut
     
   //      LFO[0]=  map (automation1 , 0, 1, 0, TWO_PI);//net.phase[11];// map (automation1 , 0, 1, 0, TWO_PI);

  //     LFO[0]= net.phase[11];// map (automation1 , 0, 1, 0, TWO_PI);
 
   //   LFO[0]=net.phase[0];
   //   newPosX[i] = displacement*cos (LFO[0]);
   //   newPosY[i] = displacement*sin (LFO[0]);
      formerEvent[200+0]= millis(); 

      print (" cos LFO  " ); print (cos (LFO[0]) ); print (" automation1 " );  print (automation1); print (" formEvent  " ); print (i); print (formerEvent[200+i]);
      print (" net.phase[11]  " );  println (net.phase[11] );
    }
  } 
// translate( 0, 0, 1000);
  for (int i =0; i < networkSize-2; i++) {

    pushMatrix();  
    

    sphere(side*3); // this sphere serves as a reference
    sphereDetail( 4*5);
    colorMode(HSB, TWO_PI, 100, 100);
    noStroke();

    // Color sphere and Draw them, depending of acceleration or later with "chimera state"
    mapAcceleration[i]= constrain ((int (map (abs(net.acceleration[i] *100), 0, 150, 0, 255))), 0, 255); 
    mapAccelerationinversed[i]= abs (int (map ((net.acceleration[i] *100), -200, 200, 0, 255)));
    //********************************************************* BEGIN GRAPHIC CHIMERA STATE
    //********************************************************* END GRAPHIC CHIMERA STATE
    translate (newPosX[i], newPosY[i], 200+(50*5*i));  //*-1 go in clockwise, *1 go in CCW
    colorMode(RGB, 255, 255, 255);
    fill (255,255,0);
    fill( mapAccelerationinversed[i], 255, 0 ); // Sepheres are all modulated with the same color. depending of acceleration
    sphere(side*3);

    popMatrix();
  }
  //   rotate (-HALF_PI);
}

void followLFO() {
  shiftFollowMov();
  if (millis()>formerEvent[200+3]+d) {
    // delay();
    LFO[9]= LFO[8];
    LFO[8]= LFO[7];
    LFO[7]= LFO[6];
    LFO[6]= LFO[5];
    LFO[5]= LFO[4];
    LFO[4]= LFO[3];
    LFO[3]= LFO[2];
    //***   LFO[2]= map (automationLFO[0],0, 1, -PI, 0); // gauche droite vers le haut
    for (int i =3; i < networkSize; i++) {
      newPosX[i] = displacement*cos (LFO[i]);
      newPosY[i] = displacement*sin (LFO[i]);
      formerEvent[200+3]= millis();
    }
  }

  if (millis()>formerEvent[200+2]+d) {
    // delay();
    LFO[2]= LFO[1];
    //***   LFO[2]= map (automationLFO[0],0, 1, -PI, 0); // gauche droite vers le haut
    newPosX[2] = displacement*cos (LFO[2]);
    newPosY[2] = displacement*sin (LFO[2]);
    formerEvent[200+2]= millis();
  }

  if (millis()>formerEvent[200+1]+d*1) {
    LFO[1]= LFO[0];
    newPosX[1] = displacement*cos (LFO[1]);
    newPosY[1] = displacement*sin (LFO[1]);
    formerEvent[200+1]= millis();
  }


  for (int i =0; i < 1; i++) {
    if (millis()>formerEvent[200+i]+0) {
      //   formerPositionLFO[0]=LFO[0];

      LFO[0]=  map (automation1 , 0, 1, 0, TWO_PI);//net.phase[11];// map (automation1 , 0, 1, 0, TWO_PI);

      newPosX[0] = displacement*cos (LFO[0]);
      newPosY[0] = displacement*sin (LFO[0]);
      formerEvent[200+0]= millis(); 

      print ("LFO  " ); 
      print (i);  
      print (LFO[0] ); 
      print ("automationLFO " ); 
      print (i); 
      print (automationLFO[i]); 
      print ("formEvent " ); 
      print (i); 
      print (formerEvent[200+i]);
    }
  } 
// translate( 0, 0, 1000);
  for (int i =0; i < networkSize-2; i++) {

    pushMatrix();  
    

    sphere(side*3); // this sphere serves as a reference
    sphereDetail( 4*5);
    colorMode(HSB, TWO_PI, 100, 100);
    noStroke();

    // Color sphere and Draw them, depending of acceleration or later with "chimera state"
    mapAcceleration[i]= constrain ((int (map (abs(net.acceleration[i] *100), 0, 150, 0, 255))), 0, 255); 
    mapAccelerationinversed[i]= abs (int (map ((net.acceleration[i] *100), -200, 200, 0, 255)));
    //********************************************************* BEGIN GRAPHIC CHIMERA STATE
    //********************************************************* END GRAPHIC CHIMERA STATE
    translate (newPosX[i], newPosY[i], 200+(50*5*i));  //*-1 go in clockwise, *1 go in CCW
    colorMode(RGB, 255, 255, 255);
    fill( mapAccelerationinversed[i], 255, 0 ); // Sepheres are all modulated with the same color. depending of acceleration
    sphere(side*3);

    popMatrix();
  }
  //   rotate (-HALF_PI);
}



void followLFObis() {
shiftFollowMov();



  // delay();

  //***   LFO[2]= map (automationLFO[0],0, 1, -PI, 0); // gauche droite vers le haut
  for (int i =3; i < networkSize-2; i++) {
    if (millis()>formerEvent[200+i]+0) {
      LFO[i]= LFO[i-1];

      newPosX[i] = displacement*cos (LFO[i]);
      newPosY[i] = displacement*sin (LFO[i]);
      formerEvent[200+i]= millis();
    }
  }


  if (millis()>formerEvent[200+2]+d) {
    // delay();
    LFO[2]= LFO[1];
    //***   LFO[2]= map (automationLFO[0],0, 1, -PI, 0); // gauche droite vers le haut
    newPosX[2] = displacement*cos (LFO[2]);
    newPosY[2] = displacement*sin (LFO[2]);
    formerEvent[200+2]= millis();
  }

  if (millis()>formerEvent[200+0+1]+0*(0+1)) {
    //   formerPositionLFO[0]=LFO[0];

    LFO[1]=LFO[0]; // gauche droite vers le haut
    newPosX[1] = displacement*cos (LFO[1]);
    newPosY[1] = displacement*sin (LFO[1]);
    //  formerEvent[200+0]= millis();
    formerEvent[200+0+1]= millis(); 


    println (" ");
  }


  for (int i =0; i < 1; i++) {
    if (millis()>formerEvent[200+i]+0) {
      //   formerPositionLFO[0]=LFO[0];

      LFO[0]=  map (automation1 , 0, 1, 0, TWO_PI);//net.phase[11];// map (automation1 , 0, 1, 0, TWO_PI);

      newPosX[0] = displacement*cos (LFO[0]);
      newPosY[0] = displacement*sin (LFO[0]);
      formerEvent[200+0]= millis(); 

      print ("LFO  " ); 
      print (i);  
      print (LFO[0] ); 
      print ("automationLFO " ); 
      print (i); 
      print (automationLFO[i]); 
      print ("formEvent " ); 
      print (i); 
      print (formerEvent[200+i]);
    }
  } 


  for (int i =0; i < networkSize-2; i++) {

    pushMatrix();  

    sphere(side*3); // this sphere serves as a reference
    sphereDetail( 4*5);
    colorMode(HSB, TWO_PI, 100, 100);
    noStroke();

    // Color sphere and Draw them, depending of acceleration or later with "chimera state"
    mapAcceleration[i]= constrain ((int (map (abs(net.acceleration[i] *100), 0, 150, 0, 255))), 0, 255); 
    mapAccelerationinversed[i]= abs (int (map ((net.acceleration[i] *100), -200, 200, 0, 255)));
    //********************************************************* BEGIN GRAPHIC CHIMERA STATE


    //********************************************************* END GRAPHIC CHIMERA STATE
    translate (newPosX[i], newPosY[i], 200+(50*5*i));  //*-1 go in clockwise, *1 go in CCW
    colorMode(RGB, 255, 255, 255);
    fill( mapAccelerationinversed[i], 255, 0 ); // Sepheres are all modulated with the same color. depending of acceleration
    sphere(side*3);

    popMatrix();
  }
  //   rotate (-HALF_PI);
}

void shiftFollowMov() {
  
 
  if (keyCode == LEFT) {  
    println( " LEFT INCREASE decay offseft shiftFollowMov ")  ; 
 //   decayshiftFollowMov=decayshiftFollowMov+50;
    decayshiftFollowMov++;
  
    println ("d= timeOffsetRatio: "); 
    println ( decayshiftFollowMov);
    textSize (100);
    text (" decayshiftFollowMov  ", decayshiftFollowMov, 200,200);

    keyCode=SHIFT; // to trig once keyPressedLFO
  }


  if (keyCode == RIGHT) { 

    println( " right INCREASE decay offseft shiftFollowMov")  ; 
     decayshiftFollowMov=decayshiftFollowMov-50;  
    println ("d= timeOffsetRatio: "); 
    println (d);
    keyCode=SHIFT; // to trig once keyPressedLFO
  }

  if (keyCode == UP) { 

    oscillatorBlocked++;
  
    if (oscillatorBlocked > (networkSize-1)) { 
      oscillatorBlocked=1;
    }
   println ( decayshiftFollowMov);
   textSize (100);
   text (" decayshiftFollowMov  ", decayshiftFollowMov, 300,300);
    
    keyCode=SHIFT; // to trig once keyPressedLFO
  }

  if (keyCode == DOWN) { 
/*
    oscillatorBlocked--;
    // keyCode = LEFT; 
    print ("  oscillatorBlocked ");     
    println (oscillatorBlocked); 
    if (oscillatorBlocked < 2) { 
      oscillatorBlocked=11;
    }
*/
    keyCode=SHIFT; // to trig once keyPressedLFO
  }
} 

void keyPressedLFO() {

  float PhaseDecay=d*QUARTER_PI/8;

  if (keyCode == LEFT) {  
    println( " LEFT INCREASE decay offseft in  keyPressedLFO ")  ; // Incremente together without changing phases   
    d+=50;
    d=d%1000;
    println ("d= timeOffsetRatio: "); 
    println (d);

    keyCode=SHIFT; // to trig once keyPressedLFO
  }


  if (keyCode == RIGHT) { 

    println( " right INCREASE timeOffset    from F0 (the behind one  the fastest) F1 very slow =0.021 ")  ; // Incremente together without changing phases   
    d+=50;
    d=d%1000;
    println ("d= timeOffsetRatio: "); 
    println (d);

    keyCode=SHIFT; // to trig once keyPressedLFO
  }

  if (keyCode == UP) { 

    oscillatorBlocked++;
    print (" oscillatorBlocked ");     
    println (oscillatorBlocked); 
    if (oscillatorBlocked > (networkSize-1)) { 
      oscillatorBlocked=1;
    }
    keyCode=SHIFT; // to trig once keyPressedLFO
  }

  if (keyCode == DOWN) { 

    oscillatorBlocked--;
    // keyCode = LEFT; 
    print ("  oscillatorBlocked ");     
    println (oscillatorBlocked); 
    if (oscillatorBlocked < 2) { 
      oscillatorBlocked=11;
    }

    keyCode=SHIFT; // to trig once keyPressedLFO
  }
} 
void followMadTrack1bis() {
  //    pendularPatternLFO();
  //    phasePattern();
  if (millis()>formerEvent[200+3]+d) {
    formerEvent[200+3]= millis();
    //***    if (key!='K' || key!='K'){  
    LFO[11]= (LFO[10]+k)%TWO_PI;
    LFO[10]= (LFO[9]+k)%TWO_PI;
    LFO[9]= (LFO[8]+k)%TWO_PI;
    LFO[8]= (LFO[7]+k)%TWO_PI;
    LFO[7]= (LFO[6]+k)%TWO_PI;
    LFO[6]= (LFO[5]+k)%TWO_PI;
    LFO[5]= (LFO[4]+k)%TWO_PI;
    LFO[4]= (LFO[3]+k)%TWO_PI;
    LFO[3]= (LFO[2]+k)%TWO_PI;


    for (int i =3; i < 12; i++) {
      if (millis()>formerEvent[200+0]+0) {        
        net.phase[i]=LFO[i];
      }
    }
  }
  for (int i =2; i < 3; i++) {
    if (millis()>formerEvent[200+0]+0) {

      LFO[i]= map (automation3, 0, 1, 0, TWO_PI); // gauche droite vers le hau.t CIRCULAR MODE usefull ?
      formerEvent[200+0]= millis(); 
      net.phase[i]=LFO[i];

      print ("automation3 " );  
      print (automation3);
    }
  }       

  pendularPatternLFO();
  if (key=='u' || key=='U') {   
    for (int i =2; i < 12; i++) {
      if (millis()>formerEvent[200+0]+0) {        
        //   net.phase[i]=net.phase[i];
      }
    }
  }
}


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
  OscMessage myMessage60= new OscMessage("/acceleration1"); // oscillator behind
 
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
//  TrigmodPos[]=
  // These tests used a copy of the original array so that we can perform multiple
  // test using the same working array
//  println("Convert multiple 0s to 1s (good)");
  result = multiMatchData(0, 1, TrigmodPos.clone());
  TrigmodPos=result;
  showArray(result);
  
//  if ( formerKeyMetro == 'c' ) { // keyMode == followSignalLfo
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
  myMessage60.add(mapAcceleration[1]);
    
  
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



void drawBall(int n, float phase) {
//  println ( "*************************** drawBall " );
  pushMatrix();
  translate(-w2, -h2, -1000);
  noStroke();
  float side = height*0.15*1/nbBall;
  float rayon = width/2;

  a = rayon*cos(phase); //-300 à 300
  b = rayon*sin(phase);
  
//   print (" phaseinDB" + phase);

  translate (a, b, 200+(50*5*n)); // on voit la vague comme j'aimerais si on fait ce qui est dit ligne 153
  translate (100, 100, 200+(50*5*n));
  colorMode(RGB, 255, 255, 255);
  fill( 0, 255, 0 );
  sphere(side*3);
  popMatrix();
}

float [] phaseReturnedBis(float[] netPhase) { 
  //if former
  for (int i = 2; i < networkSize; i++) {
    //   netPhase[i] = net.phase[i];
    netPhase[i] = netPhase[i];
  }
  return netPhase;  // Returns an array of 3 ints: 20, 40, 60
}

void follow( int target, int follower, int delais, float deltaphase) {
  int step = frameCount % nbMaxDelais;
  int followedStep = (step + nbMaxDelais - delais) % nbMaxDelais;
  phases[follower][step] = diffAngle(phases[target][followedStep] + deltaphase, 0);
}

float diffAngle(float angle1, float angle2) { // return the difference angle1 - angle2 between two angle between -PI PI
  float result = angle1 - angle2;
  while (result > PI) {
    result -= 2 * PI;
  }
  while (result < -PI) {
    result += 2 * PI;
  }
  return result;
}

void drawBallOppositeWay(int n, float phase) {
//  println ( "*************************** drawBallOPPOO " );
  pushMatrix();
  translate(-w2, -h2, -1000);
  noStroke();
  float side = height*0.15*1/nbBall;
  float rayon = width/2;

  a = rayon*cos(phase+PI); //-300 à 300
  b = rayon*sin(phase+PI);

//  translate (a, b, 200+(75*5*n)); // on voit la vague comme j'aimerais si on fait ce qui est dit ligne 153
  translate (a, b, 200+(50*5*n));
  colorMode(RGB, 255, 255, 255);
  fill( 255, 0, 0 );
  sphere(side*3);  // redsphere
  popMatrix();
}

void followOppositeWay( int target, int follower, int delais, float deltaphase) {
  int step = frameCountBis % nbMaxDelais;
  int followedStep = (step + nbMaxDelais - delais) % nbMaxDelais;
  phases[follower][step] = diffAngle(phases[target][followedStep] + deltaphase, 0);
}

float diffAngleOppositeWayOppositeWay(float angle1, float angle2) { // return the difference angle1 - angle2 between two angle between -PI PI
  float result = angle1 - angle2;
  while (result > PI) {
    result -= 2 * PI;
  }
  while (result < -PI) {
    result += 2 * PI;
  }
  return result;
}



void arduinoPosJO() { // envoyer les informations aux moteurs

  for (int i = 2; i < nbBall; i++) {

    //  phaseToMotor[i]= (int) map (phaseMapped[i], -PI, PI, 0, 6400);
    phaseToMotor[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, 6400);
  }

  teensyport.write(dataToControlMotor); // Send data to Teensy. only the movement
 // println(frameCount + ": " +  " dataToControlMotor " + ( dataToControlMotor ));
}

void keyReleasedfollowSignal() {
   if (keyCode == RIGHT) {
  phaseShiftingFollowPhase11++;  // ici, le temps que les points attendent pour se suivre est de 5 frames, et il faut un espace entre eux de QUARTER_PI/6
  phaseShiftingFollowPhase11=phaseShiftingFollowPhase11%20;
  key='#';}

    if (keyCode == LEFT) {
  delayTimeFollowPhase11++;  // ici, le temps que les points attendent pour se suivre est de 5 frames, et il faut un espace entre eux de QUARTER_PI/6
  delayTimeFollowPhase11= delayTimeFollowPhase11%20;
  key='#';}
}

void keyReleasedfollowSignalPerfect() {
  if (keyCode == RIGHT) {
    print ("keyReleasedfollowSignalPerfect right INCREASE timeOffset ")  ; // Incremente together without changing phases
  //  d++;
    timeFrameOffsetFollowing++;
//    d=d%20;
    timeFrameOffsetFollowing=timeFrameOffsetFollowing%20;
    print (" keyReleasedfollowSignalPerfect d= timeOffsetRatio: ");
    println (timeFrameOffsetFollowing);
    keyCode = SHIFT;
  }

  if (keyCode == LEFT) {
    print ("keyReleasedfollowSignalPerfect  left INCREASE phase shifting"); //
    k= (k+QUARTER_PI/4);
    k= k%(8*QUARTER_PI/2);   

    if (k>=8*QUARTER_PI/2) { 
      k=-k;
    }   
    print ("k= shiftingPhaseRatio ");
    println (k);
    keyCode = SHIFT;
  }
}
void followSignal() {
  keyReleasedfollowSignalPerfect();

  println(frameCount + ": " + ( debug ));
 // background(0);

  //  rotate(- TWO_PI+ HALF_PI  ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI
  //  translate(width/2-400, -height/2, -1000);// To set the center of the perspective

  if (!firstFollowingStarted) {
    float angle = diffAngle(PI + (frameCount / 4.0) * cos (1000 / 500.0), 0);

    print ("angle ");
    println ( angle );

    LFO[2]= map (automation3, 0, 1, 0, TWO_PI);

    if (angle > 0 )
      phases[0][frameCount % nbMaxDelais]= LFO[2];  // gauche droite vers le hau.t CIRCULAR MODE usefull ?// diffAngle(angle, HALF_PI);//% TWO_PI  // position du point de depart + vitesse * phi constant  ==> ici vitesse du point phases[0] est constante
    else
      phases[0][frameCount % nbMaxDelais]= LFO[2];
      drawBall(0, phases[0][frameCount % nbMaxDelais]); // affiche le point 0. NE PAS AFFICHER SINON IL APPARAIT EN DOUBLE
  }

  float deltaFollow = PI/180;

  for (int i = 1; i < nbBall; i++) {
    debug ="Normal follow ";
    //   follow( i-1, i, 20 * i, 0);  // Modifier les deux derniers paramètres : délais et phase
    follow( i-1, i, d, k);  // ici, le temps que les points attendent pour se suivre est de 5 frames, et il faut un espace entre eux de QUARTER_PI/6

    //*****   drawBall(i, phaseMapped[i] );
    drawBall(i, phases[i][frameCount % nbMaxDelais] );
  }

  /*
     for(int i = 0; i < nbBall; i++) { //Animation brute sans suivi, juste avec une formule
   //drawBall(i, PI + (i * frameCount / 50.0) * cos (frameCount / 500.0) );
   }*/  // A COMPRENDRE

  if (frameCount > nbMaxDelais/10 && firstFollowingLast == true && abs(diffAngle(phases[0][frameCount % nbMaxDelais], phases[nbBall-1][frameCount % nbMaxDelais])) < deltaFollow ) {
    colorMode(RGB, 255, 255, 255);
    fill( 0, 0, 255 );
    println("diffangle" + ": " + diffAngle(phases[0][frameCount % nbMaxDelais], phases[nbBall-1][frameCount % nbMaxDelais]));
    //    firstFollowingStarted = true;
    debug ="First follow last";
    //   firstFollowingLast = false;
    println (debug);
  }

  if (firstFollowingStarted) {
    colorMode(RGB, 255, 255, 255);
    fill( 255, 0, 0 );
    debug ="firstFollowingStarted";
    follow(nbBall-1, 0, d, k);  // Modifier les deux derniers paramètres : délais et phase
    drawBall(0, phases[0][frameCount % nbMaxDelais]);
    //   println ("PHASE MAPPED firstFollowing ");
    //   println("diffangle" + ": " + diffAngle(phases[0][frameCount % nbMaxDelais], phases[nbBall-1][frameCount % nbMaxDelais]));
  }

  arduinoPosJO();
}  



void samplingMovement(float timeSec) {
  
    keyReleasedfollowSignal(); // useless here, but if you sample with a decay of 100ms, each oscillator will have the movement of 11 each new cycle of 11
    frameSampling=frameSampling+1;
    Timer= (millis()%1000*timeSec)*restartTimer;
    Timer2 = (millis()%2000*timeSec)*restartTimer;
     print ("             Timer  "); print (Timer);
     print ("             Timer2  "); print ( Timer2);
     print ("             frameSampling160  "); print ( frameSampling%(num*timeSec)); // each x frameSampling record new datas
    int i = int(frameSampling%(num*timeSec)); // datas record from 0 to 40*number of secondes
    
    if(frameSampling>=0 && frameSampling<=num*timeSec  ) // && lastSec==actualSec
    {
    if(frameSampling<=0) { 
     int timeElapsed= endTime-beginTime; 
     print (" timeElapsed"); println (timeElapsed);
     beginTime=millis();
     background(255);     
    } 
    if(frameSampling>=1 && frameSampling<=num*timeSec )  //&& Timer<=100 && Timer2<=100
    {
//    rx[i] = mouseX;
//    ry[i] = mouseY;
 //**   net.phase[networkSize-1]= (float) map (v1, 0, 400, 0, TWO_PI);
  //  net.phase[networkSize-1]= (float) map (mouseY, 0, 400, 0, TWO_PI);
     newPosF[0]= (float) map (mouseY, 0, 400, 0, TWO_PI);
    rx[i] = z;
 //   ry[i] = v1;
     ry[i]= newPosF[0]+phaseShiftingFollowPhase11;//almost useless
    mx[i] = rx[i];
    my[i] = ry[i];
    fill(255, 0, 0, 50); 
 //     net.phase[networkSize-1]= (float) map (v1, 0, mouseY, 0, TWO_PI);

 //**   net.phase[2]= (float) map (v1, 0, 400, 0, TWO_PI);
    circle(rx[i], ry[i], 10); 
    }    
   }  
   
    int middleTime = millis(); 
    int TimeMiddleElapsed = middleTime -beginTime;
    
    if ( (frameSampling >=num*timeSec+1 && frameSampling <=num*timeSec+1)) { //|| TimeMiddleElapsed >=1970 && TimeMiddleElapsed <=2030 || 
       LastTimeMiddleElapsed=TimeMiddleElapsed;
       print (frameSampling); print ("  TimeMiddleElapsed "); println ( TimeMiddleElapsed);
       } 
     
    if(frameSampling>=num*timeSec+1  ) // begin to replay for 2 sec
    {
      trigFollowSampling=true;
     
 //**   net.phase[networkSize-1]= (float) map (my[i], 0, 400, 0, TWO_PI);
        newPosF[0]= my[i];
 //¨**    net.phase[networkSize-2]= (float) map (my[i], 0, 400, 0, TWO_PI)+k; // you have sampled oscillator2 and repeat it in oscillator 3 with decay
//  
        newPosF[1]= my[i]+delayTimeFollowPhase11; // useless
        newPosF[1]= newPosF[1]%TWO_PI;
    circle(mx[i]+400, my[i], 10); 
  //  print (frameSampling); print (" ry' "); print (i); print ("  "); println (ry[i]);
    print (" frameSampling "); print (frameSampling); print (" ry "); print (i); print ("  "); print (ry[i]);   // frameSampling%160=1 is the first point and  frameSampling%160=0 is the last point recorded
    print (" my "); print (i); print ("  "); println (my[i]);
    } 
  
   // if(frameSampling>=2*20*4+1 && frameSampling<=2*20*4+1  ) //
    if(frameSampling%(2*num*timeSec)<=0  ) //
    {

    endTime=millis();
    int timeElapsed= endTime-beginTime; 
    LastTimeElapsed= timeElapsed;
     print (" LastTimeElapsed"); println (LastTimeElapsed);
 //   Timer=0;
 //   Timer2=0;
 //   frameSampling=80;
    restartTimer=0;//useless for the moment
    background(255);
    }
    if (mousePressed==true){
        mouseRecorded=true;} 
        
    if (mouseRecorded==true  && frameSampling%(2*num*timeSec+0)<=0 
     ) {
       print (" Restart Record ");  print (" Restart Record ");  println (" Restart Record ");
    mouseRecorded=false;
    frameSampling = 0; // Restart main loop
    restartTimer=1;  //useless for the moment
    trigFollowSampling=false;
     }      
}



 

void sendToTeensy() {
  int turnOnDriverNetPhase11=1; //it has to be more than 2 to turn on the driver in the Teensy

  String dataMarkedToTeensyJoGood  ="<" // BPM9   

   // +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
   // +   DataToDueCircularVirtualPosition[6]+","+( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

   // +  (speedDelta) + "," + turnOnDriverNetPhase11 + "," +3+","+decompte[8]+","+decompte[7]+","+decompte[6]+","+decompte[5]+","+decompte[4]+","+decompte[3]+","+decompte[2]+"," // to manage 12 note +decompte[1]+","+decompte[0]+ ","

    +  decompte[1]+"," +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">"; //    cohesionCounterHigh // +orderCohesion+ ">";LevelCohesionToSend ","+ int (map ( LowLevelCohesionToSend, 0, 1, 0, 100))+ 


  if ( abs (speedi[networkSize-1]) > 950 || abs (speedi[0]) > 950) {
    //   key = 'h'; keyReleased();
    textSize (200);
    text("CAREFULL", width/2, height - 20);
  }

  println(frameCount + ": " +  " dataMarkedToTeensyJoGood" + ( dataMarkedToTeensyJoGood ));
  teensyport.write(dataMarkedToTeensyJoGood); // Send data to Teensy. only the movement
}

void sendToTeensyTurnOnDriver() {
  int turnOnDriverNetPhase11=3; //it has to be more than 2 to turn on the driver in the Teensy

  String dataMarkedToTeensyJoGood  ="<" // BPM9   

   // +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
   // +   DataToDueCircularVirtualPosition[6]+","
    
    +( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

    +  (speedDelta) + "," + turnOnDriverNetPhase11 + "," +3+","
    
    //+decompte[8]+","+decompte[7]+","+decompte[6]+","+decompte[5]+","+decompte[4]+","+decompte[3]+","+decompte[2]+"," // to manage 12 note +decompte[1]+","+decompte[0]+ ","

    +  decompte[1]+"," +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">"; //    cohesionCounterHigh // +orderCohesion+ ">";LevelCohesionToSend ","+ int (map ( LowLevelCohesionToSend, 0, 1, 0, 100))+ 



  println(frameCount + ": " +  " dataMarkedToTeensyJoGood" + ( dataMarkedToTeensyJoGood ));
  teensyport.write(dataMarkedToTeensyJoGood); // Send data to Teensy. only the movement
}







void followDistribueAddphasePattern(){
   for (int i = 0; i <  networkSize-0; i+=1) {// networkSize-0
 //    print (net.oldPhase[i]); print (" 12448 ");   println (net.phase[i]); 
 //   net.oldPhase[i]=phaseMapped[i];
    phaseMapped[i]= map (signal[2], 0, 1, 0, TWO_PI); // use varaible phaseMapped (to play movement with time delay or phase delay) to well send it in Teensy
 
    if (phaseMapped[i]<0){
   
    DataToDueCircularVirtualPosition[i]= int (map (phaseMapped[i], 0, -TWO_PI, numberOfStep, 0)); 
    net.oldPhase[i]=net.phase[i];
    net.phase[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
       }
       
   else
    
    DataToDueCircularVirtualPosition[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, numberOfStep);
    net.oldPhase[i]=net.phase[i];
    net.phase[i]= map (DataToDueCircularVirtualPosition[i], 0, numberOfStep, 0, TWO_PI);
  }
  for (int i = 0; i < (networkSize-0); i+=1){
    print (" degrees "); print (i);  print (" "); println (degrees (net.phase[i]));
 }
   
  if (formerFormerKey == '#'  || formerKeyMetro == '*'  || formerKeyMetro == '*' ) { // || formerKeyMetro == '*'
    
      for (int i = 2; i < networkSize-0; i+=1) { 
        
  ////*****  phaseMappedFollow[i] = phaseMapped[i];
 //   phaseMapped[i] = phaseMappedFollow[i]+phaseMapped[i];
   
    if (phaseMapped[i]<0 ){ //&& phaseMappedFollow[i]<0
      
    phaseMapped[i] = phaseMappedFollow[i]-phaseMapped[i];
    DataToDueCircularVirtualPosition[i]= int (map (phaseMapped[i], 0, -TWO_PI, numberOfStep, 0)); 
    net.oldPhase[i]=net.phase[i];
    net.phase[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
  }
       
    if (phaseMapped[i]>0 ){ // && phaseMappedFollow[i]>0
    phaseMapped[i] = phaseMappedFollow[i]+phaseMapped[i];
    DataToDueCircularVirtualPosition[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, numberOfStep);
    net.oldPhase[i]=net.phase[i];
    net.phase[i]= map (DataToDueCircularVirtualPosition[i], 0, numberOfStep, 0, TWO_PI);
  }
 }
   
 
    if (formerFormerKey != '#' ) {
 //   if (formerKeyMetro == '*' ) {
     phasePattern();
     
    for (int i = 0; i < networkSize-0; i+=1) { 
      print ("  BEF phaseMapped[i]  ");    println ( phaseMapped[i]  ); 
    phaseMappedFollow[i]= net.phase[i];
    phaseMapped[i] =  phaseMapped[i]+phaseMappedFollow[i];  // add offset given by pendularPattern
    phaseMapped[i] =  phaseMapped[i]%TWO_PI; 
    print ("  phaseMapped[i]  ");    println ( phaseMapped[i]  ); 
   
    if (phaseMapped[i]<0){
   
     DataToDueCircularVirtualPosition[i]= int (map (phaseMapped[i], 0, -TWO_PI, numberOfStep, 0)); 
   //  net.oldPhase[i]=phaseMapped[i];
    net.oldPhase[i]= net.phase[i];
    net.phase[i]= map (DataToDueCircularVirtualPosition[i], numberOfStep, 0, 0, -TWO_PI);
 //**    net.phase[i]= phaseMapped[i];
       }
       
   else
    
    DataToDueCircularVirtualPosition[i]= (int) map (phaseMapped[i], 0, TWO_PI, 0, numberOfStep); 
    net.oldPhase[i]=net.phase[i];
 //**   net.phase[i]= phaseMapped[i];
       net.phase[i]= map (DataToDueCircularVirtualPosition[i], 0, numberOfStep, 0, TWO_PI);


//   }
  }
 }
 
 
  //sendToTeensyTurnOnDriver();
  }  
    } 

     
void followDirectLfo(){    
  println (" PatternFollowLfo() ");
     
    lfoPattern();
  //  LFO[0]= lfoPhase[2];
 
    splitTimeLfo();
   //  splitWithTime();
                
   if (key=='q' || key=='a') {
     letter = key;
    
     }
  switch(letter) {
    case 'a': 
    doA=true;
    doQ=false;
    println("Alpha");  // Does not execute
    break;
    case 'q': 
    doA=false;
    doQ=true;
    println("qqqqq");  // Does not execute
    break;
     
    }
    
  if (formerFormerKey == '#') { //  && doA==true
     lfoPattern();
      for (int i = 2; i < networkSize-0; i+=1) { 
      print ( " LFO  == '#' "); println (LFO[i]);   
      LFO[i]= lfoPhase[1];
    //  LFO[i]= 0;
   }
   }
   
   if (formerFormerKey == '#') {
     
   if (LFO[oscillatorChange]<0){   // movement drawn by myself      
    LFO[oscillatorChange] = phaseFollowLFO[oscillatorChange]-LFO[oscillatorChange]; 
    
    dataToChange[oscillatorChange]= int (map (LFO[oscillatorChange], 0, -TWO_PI, numberOfStep, 0)); 
    //**    net.oldPhase[i]=net.phase[i];
   // oldPosF[oscillatorChange]=newPosF[oscillatorChange];
   
    //**    net.phase[i]= map (dataToChange[i], numberOfStep, 0, 0, -TWO_PI);
    newPosF[oscillatorChange]= LFO[oscillatorChange]; //map (dataToChange[oscillatorChange], numberOfStep, 0, 0, -TWO_PI);
  }
       
   else
    LFO[oscillatorChange] = phaseFollowLFO[oscillatorChange]+LFO[oscillatorChange];
    LFO[oscillatorChange] = LFO[oscillatorChange]%TWO_PI;
     
    dataToChange[oscillatorChange]= (int) map (LFO[oscillatorChange], 0, TWO_PI, 0, numberOfStep);
    //   net.oldPhase[i]=net.phase[i];
  //  oldPosF[oscillatorChange]=newPosF[oscillatorChange];
   //  net.phase[i]= map (dataToChange[i], 0, numberOfStep, 0, TWO_PI);
    newPosF[oscillatorChange]= LFO[oscillatorChange]; // map (dataToChange[oscillatorChange], 0, numberOfStep, 0, TWO_PI);
  
 }
   
   
   if (formerKey != '#' ) { //  play this command once when you tap on keyboard expect #
    if (doA==true ){ // offset with pendularPattern  || doQ==true
     phasePattern(); // change offset between ball with pendularPattern
     lfoPattern();
   for (int i = 2; i < networkSize-0; i+=1) { 
   
  //  newPosF[i]= net.phase[i];
 //**   newPosF[i]= lfoPhase[1];
  //****  phaseFollowLFO[i]= newPosF[i];

     LFO[i]= lfoPhase[1];
      } 
      
     phaseFollowLFO[oscillatorChange]= lfoPhase[2];
     print ("  case a phaseFollowLFO  ");  print ( oscillatorChange  ); print ( " ");  print ( phaseFollowLFO[oscillatorChange]  ) ; println (   ); 
 //   LFO[i]=0;

//    LFO[oscillatorChange] =  LFO[oscillatorChange]+phaseFollowLFO[oscillatorChange];  // add offset given by pendularPattern
//    LFO[oscillatorChange] =  LFO[oscillatorChange]%TWO_PI; 

    for (int i = 2; i < networkSize-0; i+=1) { 
      
   if (LFO[i]<0){
   
    dataToChange[i]= int (map (LFO[i], 0, -TWO_PI, numberOfStep, 0)); 
  //  oldPosF[i]=newPosF[i];
    newPosF[i]=LFO[i];//dataToChange[i];
 //   DataToDueCircularVirtualPosition[i]= (int) newPosF[i];
       }
       
   else
    
    dataToChange[i]= (int) map (LFO[i], 0, TWO_PI, 0, numberOfStep); 
 //   oldPosF[i]=newPosF[i];
    newPosF[i]=LFO[i];//dataToChange[i];
 //   DataToDueCircularVirtualPosition[i]= (int) newPosF[i];
       } // 
       
      
       
        key='#';// key='a'; // formerFormerKey = '#';
   //    doA=false;
   //    doQ=true;
   }
   
   }
   /*
  for (int i = 2; i < networkSize; i++) { 
    oldDataToChange[i]= dataToChange[i];
    deltaDataToChange[i]= dataToChange[i]-oldDataToChange[i];
    DataToDueCircularVirtualPosition[i]= (int) dataToChange[i];// newPosF[i];
   }  
 */
  
      countRevsContinue();
      
    for (int i = 2; i < networkSize; i++) {
     
     oldPosF[i]=newPosF[i];

      //*******************************  ASSIGN MOTOR WITH POSITION

      if (rev[i]!=0  && (newPosF[i] >  0) ) { // number of revolution is even and rotation is clock wise   
        pos[i]= int (map (newPosF[i], 0, TWO_PI, 0, numberOfStep))+ (rev[i]*numberOfStep);
      }

      if (rev[i]!=0  && (newPosF[i] <  0)) { // number of revolution is even and rotation is Counter clock wise          // pos[i]= int (map (net.phase[i], 0, -TWO_PI, 0,  numberOfStep))+ (rev[i]*numberOfStep);
        pos[i]= int (map (newPosF[i], 0, -TWO_PI, numberOfStep, 0)) +(rev[i]*numberOfStep);       //   print ("pos "); print (i); print (" ");println (pos[i]);
      }

      if (rev[i]==0 && (newPosF[i] < 0) ) { //  number of revolution is 0 and rotation is counter clock wise 
        pos[i]= int (map (newPosF[i], 0, -TWO_PI, numberOfStep, 0));        
      }         
      if (rev[i]==0 && (newPosF[i] > 0) ) {  //  number of revolution is 0 and rotation is clock wise     
        pos[i]= int (map (newPosF[i], 0, TWO_PI, 0, numberOfStep));                //      print ("pos "); print (i); print (" CW rev=0 ");println (pos[i]);
      }
      DataToDueCircularVirtualPosition[i]= (int) pos[i];
            
    }
    
 
  

    int driverOnOff=3;
    int dataToTeensyNoJo=-3; // trig noJoe in Teensy
    String dataMarkedToTeensyNoJo  ="<" // BPM9   

    //  +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
    //  +   DataToDueCircularVirtualPosition[6]+","+( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

   //   +  (speedDelta) +","+ driverOnOff +","+decompte[9]+","+decompte[8]+","+decompte[7]+","+decompte[6]+","+decompte[5]+","+decompte[4]+","+decompte[3]+","+decompte[2]+"," // to manage 12 note +decompte[1]+","+decompte[0]+ ","

      +  decompte[1]+"," +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">";    

    println(frameCount + ": " +  " dataMarkedToTeensyNoJo" + ( dataMarkedToTeensyNoJo ));
   //  encoderReceiveUSBport101.write(dataMarkedToTeensyNoJo );// Send data to Arduino.
    teensyport.write(dataMarkedToTeensyNoJo); // Send data to Teensy. only the movement
 
 } 

 
 void countRevsContinue() { // =========================================== AJOUTE un case dans tableau networkSize+1

  for (int i = 0; i < networkSize; i++) { 
//**    print (net.oldPhase[i]); print ("count rev ");   println (net.phase[i]); 
    // decrement caused by negative angular velocity
    // both positive angles || both negative angles || positive-to-negative angle
    //   if (//(net.oldPhase[i] < 0.25 * PI && net.phase[i] > 1.75 * PI) ||//
    if (
      ((oldPosF[i] < 0.25 *PI && oldPosF[i]>0)  && (newPosF[i] > -0.25* PI && newPosF[i] <0))  || 
       (oldPosF[i] < -1.75 * PI && newPosF[i] > -0.25 * PI)// ||
    
      ) {
    
      //    TrigmodPos[i]=0;
      rev[i]--;
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
      ((oldPosF[i] > -0.25 *PI && oldPosF[i]<0)  && (newPosF[i] < 0.25* PI && newPosF[i] >0))  || 
       (oldPosF[i] > 1.75 * PI && newPosF[i] < 0.25*PI)
      ) {
      onOFF = 1;
      //   TrigmodPos[i]=0;
      rev[i]++;
      //   revolution[i]=i+1;
      revolution[i]=0;   // trig 0 to sent 0 in Max4Live
      memoryi=i;
      decompte[i] = 0;  // RESET COUNTER AT 0
    } else {

      decompte[i]  ++; //START COUNTER when a REVOLUTION START OR FINISH

      revolution[i]=1;
    }
     if (  revolution[i]<1) {
   print (" revolution[i] "); print ( memoryi); print ("  "); print (revolution[memoryi]);
    }
  
  //  print (" rev< "); print ( i); print ("  "); println (rev[i]);
  }
  if (

   
    (newPosF[memoryi] < -1.75 * PI && newPosF[memoryi] >= -0.25*TWO_PI) || ( newPosF[memoryi]<=-TWO_PI+0.23  && newPosF[memoryi] >= -0.25*TWO_PI ) 
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

void addSignal(){
  
    println (" pattern lfoPhase[1] ", lfoPhase[1], "lfoPhase[2] ", lfoPhase[2], "lfoPhase[3] ", lfoPhase[3]); 
   
   if (key=='q' || key=='b') {
     letter = key;   
     }
  switch(letter) {
    case 'q': 
    doQ=true;
    break;
    case 'b': 
    doQ=false;
    break;     
    }
  
   if (formerFormerKey == '#') { //  && doA==true
     print ("  normal " + frameCount + " lfoPhase[1] " + lfoPhase[1] + " lfoPhase[2] " + lfoPhase[2]);    println (   ); 
      for (int i = 2; i <  networkSize+1; i+=1) { 
       LFO[i] = lfoPhase[1]; 
   if (LFO[i]<0){        
       LFO[i] = phaseFollowLFO[i] -  LFO[i];
       dataMappedForMotor[i]= int (map (LFO[i], 0, -TWO_PI, numberOfStep, 0)); 

       newPosX[i]= map (dataMappedForMotor[i], numberOfStep, 0, 0, -TWO_PI);
  }
       
   else
       LFO[i] = phaseFollowLFO[i] +  LFO[i];
       dataMappedForMotor[i]= (int) map (LFO[i], 0, TWO_PI, 0, numberOfStep);

       newPosX[i]= map (dataMappedForMotor[i], 0, numberOfStep, 0, TWO_PI);
 
   }
  
   if (LFO[oscillatorChange]<0){        
       LFO[oscillatorChange] = phaseFollowLFO[oscillatorChange]-LFO[oscillatorChange]; 
       dataMappedForMotor[oscillatorChange]= int (map (LFO[oscillatorChange], 0, -TWO_PI, numberOfStep, 0)); 

       newPosX[oscillatorChange]= map (dataMappedForMotor[oscillatorChange], numberOfStep, 0, 0, -TWO_PI);
  }
       
   else
       LFO[oscillatorChange] = phaseFollowLFO[oscillatorChange]+LFO[oscillatorChange];
       dataMappedForMotor[oscillatorChange]= (int) map (LFO[oscillatorChange], 0, TWO_PI, 0, numberOfStep);

       newPosX[oscillatorChange]= map (dataMappedForMotor[oscillatorChange], 0, numberOfStep, 0, TWO_PI);
  }
 
   if (doQ==true ){
  //   phasePattern(); // offset with lfo oscillator by osillator
    print ("  case q phaseFollowLFO " + oscillatorChange + " "  + phaseFollowLFO[oscillatorChange] + " "); print ("  LFOoscillatorChange  "); print (oscillatorChange); print ("   ") ;  print (LFO[oscillatorChange]  ); 
    print (" newPosX[oscillatorChange] " + newPosX[oscillatorChange]);
    for (int i = 2; i <  networkSize-0; i+=1) { 
   
   //int i = oscillatorChange;
   //  phaseFollowLFO[oscillatorChange]= PI/10*-oscillatorChange; // to understand
     phaseFollowLFO[oscillatorChange]= lfoPhase[2];
     LFO[oscillatorChange]=  LFO[i]+phaseFollowLFO[i];  // add offset given by pendularPattern
     LFO[oscillatorChange]=  LFO[i]; 
  
   
    if (LFO[i]<0){
   
     dataMappedForMotor[i]= int (map (LFO[i], 0, -TWO_PI, numberOfStep, 0)); 

       newPosX[oscillatorChange]= map (dataMappedForMotor[i], numberOfStep, 0, 0, -TWO_PI);
  //   newPosX[i]= LFO[i];
       }
       
   else
    
    dataMappedForMotor[i]= (int) map (LFO[i], 0, TWO_PI, 0, numberOfStep);  
    
    newPosX[oscillatorChange]= map (dataMappedForMotor[i], 0, numberOfStep, 0, TWO_PI);
    
     } //
 
   }
    print ("  LFO+LFOoscillatorChange  "); print (oscillatorChange); print ("   ") ;  println (LFO[oscillatorChange]  ); 
   
  key='#';// 

     for (int i = 2; i <  networkSize+0; i+=1) { // la premiere celle du fond i=2,  la derniere celle du devant i=11
    drawBall(i, newPosX[i] );

   
    print( " oldPositionToMotor[i]" ); print ( oldPositionToMotor[i]);
    positionToMotor[i]= ((int) map (newPosX[i], 0, TWO_PI, 0, numberOfStep)%numberOfStep); //
    
    
    newPosF[i]=positionToMotor[i]%6400;
 //   if (oldPositionToMotor[i]>positionToMotor[i]){
    if ( oldPosF[i]>newPosF[i]){
      revLfo[i]++;
     
    } 
     oldPositionToMotor[i]=  positionToMotor[i];
     oldPosF[i]=newPosF[i];

     print( " newPosF[i] " ); print ( newPosF[i]);
     print( " positionToMotor[i] " ); print ( positionToMotor[i]);
     print (" revolutionLFO "); print ( i); print ("  "); println (revLfo[i]); 
  }
  
   if (formerKeyMetro=='B') {


         for (int i = 0; i < networkSize; i++) {
      // rev[i]=rev[0];


      //*******************************  ASSIGN MOTOR WITH POSITION

      if (revLfo[i]!=0  && (newPosF[i] >  0) ) { // number of revLfoolution is even and rotation is clock wise   
        DataToDueCircularVirtualPosition[i]= int (map (newPosF[i], 0, numberOfStep, 0, numberOfStep))+ (revLfo[i]*numberOfStep);
      }

      if (revLfo[i]!=0  && (newPosF[i] <  0)) { // number of revLfoolution is even and rotation is Counter clock wise          // pos[i]= int (map (newPosF[i], 0, -numberOfStep, 0,  numberOfStep))+ (revLfo[i]*numberOfStep);

        DataToDueCircularVirtualPosition[i]= int (map (newPosF[i], 0, -numberOfStep, numberOfStep, 0)) +(revLfo[i]*numberOfStep);       //   print ("pos "); print (i); print (" ");println (pos[i]);
      }

      if (revLfo[i]==0 && (newPosF[i] < 0) ) { //  number of revLfoolution is 0 and rotation is counter clock wise 
        DataToDueCircularVirtualPosition[i]= int (map (newPosF[i], 0, -numberOfStep, numberOfStep, 0));        
      }         
      if  (revLfo[i]==0 && (newPosF[i] > 0) ) {  //  number of revLfoolution is 0 and rotation is clock wise     
        DataToDueCircularVirtualPosition[i]= int (map (newPosF[i], 0, numberOfStep, 0, numberOfStep));                //      print ("pos "); print (i); print (" CW revLfo=0 ");println (pos[i]);
      }
    }
  } 
     
    int speedLocalDelta=4; 
    int driverOnOff=3;
    int dataToTeensyNoJo=-3; // trig noJoe in Teensy
    String dataMarkedToTeensyNoJo  ="<" // BPM9   

      +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+(DataToDueCircularVirtualPosition[9])+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
      +   DataToDueCircularVirtualPosition[6]+","+( DataToDueCircularVirtualPosition[5])+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

    //  +  (speedDelta) +
     +  speedLocalDelta +
      
      ","+ driverOnOff +","+dataToTeensyNoJo+","+decompte[8]+","+decompte[7]+","+decompte[6]+","+decompte[5]+","+decompte[4]+","+decompte[3]+","+decompte[2]+"," // to manage 12 note +decompte[1]+","+decompte[0]+ ","

      +  decompte[1]+"," +cohesionCounterLow +","+ cohesionCounterHigh +","+ int (map (LevelCohesionToSend, 0, 1, 0, 100))+">";    

    println(frameCount + ": " +  " dataMarkedToTeensyNoJo" + ( dataMarkedToTeensyNoJo ));
    //   encoderReceiveUSBport101.write(dataMarkedToDue36data);// Send data to Arduino.
    teensyport.write(dataMarkedToTeensyNoJo); // Send data to Teensy. only the movement
  }
  /*
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

void countRevsLfoPattern22() { // =========================================== Ter NE PAS TOUCHER LE COMPTEUR ou Reduire l'espace avant et apres 0 pour eviter bug à grande vitesse

  for (int i = 2; i < 3; i++) { 
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
*/
