
int actualSec,lastSec, lastLastSec, measure;  // trig internal clock each seconde as a measure  (period of 1 seconde)

int currTime;
boolean bRecording = true;
boolean mouseRecorded = true;
float movementInterpolated, oldMovementInterpolated;
int Movement;



class Sample {
  int t, x, y;
  Sample( int t, int x, int y ) {
    this.t = t;  this.x = x;  this.y = y;
  }
}
class Sampler {
  ArrayList<Sample> samples;
  int startTime;
  int playbackFrame;
  Sampler() {
    samples = new ArrayList<Sample>();
    startTime = 0;
  }
  void beginRecording() {
    samples = new ArrayList<Sample>();
    playbackFrame = 0;
  }
  void addSample( int x, int y ) {
    int now = millis();
    if( samples.size() == 0 ) startTime = now;
    samples.add( new Sample( now - startTime, x, y ) );
  }
  int fullTime() {
    return ( samples.size() > 1 ) ? 
      samples.get( samples.size()-1 ).t : 0;
  }
  void beginPlaying() {
    startTime = millis();
    playbackFrame = 0;
    println( samples.size(), "samples over", fullTime(), "milliseconds" );
  }
  void draw() {
    stroke( 255 );
    beginShape(LINES);
    for( int i=1; i<samples.size(); i++) {
      vertex( samples.get(i-1).x, samples.get(i-1).y );
      vertex( samples.get(i).x, samples.get(i).y );
    }
    endShape();
    int now = (millis() - startTime) % fullTime();
    if( now < samples.get( playbackFrame ).t ) playbackFrame = 0;
    while( samples.get( playbackFrame+1).t < now )
      playbackFrame = (playbackFrame+1) % (samples.size()-1);
    Sample s0 = samples.get( playbackFrame );
    Sample s1 = samples.get( playbackFrame+1 );
    float t0 = s0.t;
    float t1 = s1.t;
    float dt = (now - t0) / (t1 - t0);
    
    float x = mlerp( s0.x, s1.x, dt, 400 ); // interpolation with 'cylical datas'
    float y = mlerp( s0.y, s1.y, dt, 400 ); // interpolation with 'cylical datas'
       
    oldYsampled=ySampled;
    ySampled=y;   
    println (" ySampled ", ySampled , " oldYSampled ", oldYsampled, "  movementInterpolated ", movementInterpolated,
             " oldmovementInterpolated ", oldMovementInterpolated );
    oldMovementInterpolated = movementInterpolated;

    if (oldYsampled>=  ySampled){ // go down

  //    if (oldMovementInterpolated>=   movementInterpolated){
     
      
    movementInterpolated= map (y, 0, 400, TWO_PI , 0); 
      }
    else { 
    movementInterpolated= map (y, 0, 400, 0, TWO_PI);
     }
   
    noStroke();
    fill( 255, 40, 40 );
    rotate (HALF_PI);
    
    float time= (millis()/5)%1000;
//    circle ( time+400, 100*sin (movement)+400, 20);
    circle ( time+400, 100*sin (movementInterpolated) +net.phase[2] + net.phase[3] + net.phase[4] + net.phase[5], 20) ;//+ net.phase[6]+ net.phase[7]+ net.phase[8]+ net.phase[9]+ net.phase[10]+400, 20);
    addPhase =sin (movementInterpolated) + net.phase[2] + net.phase[3] + net.phase[4] + net.phase[5];//+ net.phase[6]+ net.phase[7]+ net.phase[8]+ net.phase[9]+ net.phase[10];
    addPhase= map (addPhase, -(networkSize-1)*TWO_PI, (networkSize-1)*TWO_PI, -TWO_PI, TWO_PI);
    print ( "addPhase "); println (addPhase); 
    fill( 2500 , 40, 255 );
    circle ( time, 100 * addPhase, 20); //
 //   circle ( time, 200*(sin (net.phase[2])+ sin (net.phase[3])+ sin (net.phase[4])), 20); //+net.phase[5]+net.phase[6]+net.phase[7]+net.phase[8]+net.phase[9]+net.phase[10]+net.phase[11]
    rotate (-HALF_PI);
}
}
Sampler sampler;

//******************         END INTERPOLATION SamplingMovement
