
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
  ArrayList<Sample> samplesModified;
  int startTime;
  int playbackFrame;
  
  Sampler() {
    samples = new ArrayList<Sample>();
        samplesModified = new ArrayList<Sample>();
    startTime = 0;
  }
  void beginRecording() {   
    samples = new ArrayList<Sample>();
    samplesModified = new ArrayList<Sample>();
    playbackFrame = 0;
  }
  void addSample( int x, int y ) {  // add sample when bRecording
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
    if(samples.size() > 0){
      int deltax = samples.get(0).x - samples.get(samples.size()-1).x;
      int deltay = samples.get(0).y - samples.get(samples.size()-1).y;
      float sumdist = 0;
      
      for(int i = 0; i < samples.size() - 1; i++) {
        sumdist += sqrt((samples.get(i).x - samples.get(i +1 ).x)*(samples.get(i).x - samples.get(i +1 ).x) + (samples.get(i).y - samples.get(i +1 ).y)*(samples.get(i).y - samples.get(i +1 ).y));
      }
      
      samplesModified.add( new Sample(samples.get(0).t, samples.get(0).x , samples.get(0).y ) );
      float dist = 0;
      for(int i = 0; i < samples.size() - 1; i++) {
        dist += sqrt((samples.get(i).x - samples.get(i +1 ).x)*(samples.get(i).x - samples.get(i +1 ).x) + (samples.get(i).y - samples.get(i +1 ).y)*(samples.get(i).y - samples.get(i +1 ).y));
        samplesModified.add( new Sample(samples.get(i+1).t, (int) (samples.get(i +1).x + (dist * deltax) / sumdist), (int) (samples.get(i+1).y +( dist * deltay )/ sumdist)) );
        print(samples.get(i).x);
        print(",");
        print(samples.get(i).y);
        print(",");
        print(samplesModified.get(i).x);
        print(",");
        print(samplesModified.get(i).y);
        println("");      
      }
    }
  }
 
 
  void draw() {
    stroke( 255 );
    
    //**RECORD
    beginShape(LINES);
    for( int i=1; i<samples.size(); i++) {
      vertex( samplesModified.get(i-1).x, samplesModified.get(i-1).y ); // replace vertex with Pvector
      vertex( samplesModified.get(i).x, samplesModified.get(i).y );
    }
    endShape();
    //**ENDRECORD
    
    //**REPEAT
    int now = (millis() - startTime) % fullTime();
    if( now < samplesModified.get( playbackFrame ).t ) playbackFrame = 0;
    while( samplesModified.get( playbackFrame+1).t < now )
      playbackFrame = (playbackFrame+1) % (samples.size()-1);
    Sample s0 = samplesModified.get( playbackFrame );
    Sample s1 = samplesModified.get( playbackFrame+1 );
    float t0 = s0.t;
    float t1 = s1.t;
    float dt = (now - t0) / (t1 - t0);
    float x = lerp( s0.x, s1.x, dt );
    float y = lerp( s0.y, s1.y, dt );
    circle( x, y, 10 );
    println ( "LIMITE y " +int  (y));
    movementInterpolated=map (y, 0, 800, 0, TWO_PI);
  }
 } 
Sampler sampler;

//******************         END INTERPOLATION SamplingMovement